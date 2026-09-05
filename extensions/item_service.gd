extends "res://singletons/item_service.gd"

#类别需要排除的物品
var lotato_weapon_class_only_weapons:Dictionary = {}
var lotato_item_class_only_items:Dictionary = {}
var lotato_item_class_only_weapons:Dictionary = {}

func _lotato_generate_item_class_only_exclusions(item_set:String):
	var items_of_class = {}
	var allowed_tags = []
	var item_class_data = load("res://mods-unpacked/JonathanFox-Lotato/content/item_class/%s_item_class.tres" % [item_set])
	if item_class_data:
		allowed_tags = item_class_data.allowed_tags
		for item in item_class_data.items:
			items_of_class[item.my_id_hash] = true
	else:
		allowed_tags = [item_set]

	for item in items:
		if item.my_id_hash in items_of_class:
			continue
		for tag in item.tags:
			if tag in allowed_tags:
				items_of_class[item.my_id_hash] = true
				break
	lotato_item_class_only_items[item_set] = [ ]
	var exclude_items = lotato_item_class_only_items[item_set]
	for item in items:
		if not item.my_id_hash in items_of_class:
			exclude_items.append([item, 0])
			print(item.my_id)

	lotato_item_class_only_weapons[item_set] = [ ]
	var exclude_weapons = lotato_item_class_only_weapons[item_set]
	for weapon in weapons:
		for set in weapon.sets:
			if set in item_class_data.banned_weapon_sets:
				exclude_weapons.append([weapon, 0])
				print(weapon.my_id)
				break

###扩展###
func _get_rand_item_for_wave(wave: int, player_index: int, type: int, args: GetRandItemForWaveArgs) -> ItemParentData:
	if type == TierData.WEAPONS:
		var weapon_class_only_effect:Array = RunData.get_player_effect(Utils.lotato_weapon_class_only_hash, player_index)
		if not weapon_class_only_effect.empty():
			var set_id:int = weapon_class_only_effect.back()[0]
			if not lotato_weapon_class_only_weapons.has(set_id):
				lotato_weapon_class_only_weapons[set_id] = []
				var exclude_weapons = lotato_weapon_class_only_weapons[set_id]
				for weapon in weapons:
					var exclude = true
					for set in weapon.sets:
						if set.my_id_hash == set_id:
							exclude = false
					if exclude:
						exclude_weapons.push_back([weapon, 0])
			args.excluded_items.append_array(lotato_weapon_class_only_weapons[set_id])
		var item_class_only_effect:Array = RunData.get_player_effect(Utils.lotato_item_class_only_hash, player_index)
		if not item_class_only_effect.empty():
			var item_set = Keys.hash_to_string[item_class_only_effect.back()[0]]
			if not lotato_item_class_only_weapons.has(item_set):
				_lotato_generate_item_class_only_exclusions(item_set)
			args.excluded_items.append_array(lotato_item_class_only_weapons[item_set])
	elif type == TierData.ITEMS:
		var item_class_only_effect:Array = RunData.get_player_effect(Utils.lotato_item_class_only_hash, player_index)
		if not item_class_only_effect.empty():
			var item_set =  Keys.hash_to_string[item_class_only_effect.back()[0]]
			if not lotato_item_class_only_items.has(item_set):
				_lotato_generate_item_class_only_exclusions(item_set)
			args.excluded_items.append_array(lotato_item_class_only_items[item_set])
	return ._get_rand_item_for_wave(wave, player_index, type, args)
