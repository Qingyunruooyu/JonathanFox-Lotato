extends "res://singletons/weapon_service.gd"

func _ready():
	call_deferred("lotato_add_weapon_id_hash")

func lotato_add_weapon_id_hash():
	for weapon in ItemService.weapons:
		weapon.stats.set_meta("weapon_id_hash", weapon.weapon_id_hash)

func init_base_stats(from_stats: WeaponStats, player_index: int, args: = WeaponServiceInitStatsArgs.new(), is_structure: = false, is_special_spawn: = false, is_pet: = false) -> WeaponStats:
	var new_stats = .init_base_stats(from_stats, player_index, args, is_structure, is_special_spawn, is_pet)
	for weapon_bonus in RunData.get_player_effect(Utils.lotato_weapon_bonus_hash, player_index):
		var weapon_id_hash = weapon_bonus[0]
		var stat_name = Keys.hash_to_string[weapon_bonus[1]]
		var effect_value = weapon_bonus[2]
		if from_stats.get_meta("weapon_id_hash") == weapon_id_hash:
			new_stats.set(stat_name, effect_value + new_stats.get(stat_name))

	return new_stats

