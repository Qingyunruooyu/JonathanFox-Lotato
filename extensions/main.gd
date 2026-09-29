extends "res://main.gd"


func on_levelled_up(player_index: int) -> void :
	.on_levelled_up(player_index)
	if not RunData.get_player_effect_bool(Utils.lotato_level_up_get_crate_hash, player_index):
		return

	var upgrade = _upgrades_to_process[player_index].pop_back()
	_things_to_process_player_containers[player_index].upgrades.remove_element(upgrade.level)

	var consumable_tier = Tier.UNCOMMON
	if upgrade.level % 5 == 0:
		consumable_tier = Tier.LEGENDARY
	var consumable_to_drop = ItemService.get_consumable_for_tier(consumable_tier)
	var consumable_to_process = UpgradesUI.ConsumableToProcess.new()
	consumable_to_process.consumable_data = consumable_to_drop
	consumable_to_process.player_index = player_index
	_consumables_to_process[player_index].push_back(consumable_to_process)
	_things_to_process_player_containers[player_index].consumables.add_element(consumable_to_drop)

func get_gold_value(entity_type: int, args: Entity.DieArgs, base_value: float, unit: Unit = null) -> float:
	if args.killed_by_player_index >= 0 and args.killed_by_player_index < _players.size():
		var lotato_enemy_gold_override = RunData.get_player_effect(Utils.lotato_enemy_gold_override_hash, args.killed_by_player_index)
		if lotato_enemy_gold_override > 0:
			# 击杀敌人（含BOSS）：固定几率掉落1个材料；击杀的非敌人单位（树木等）：不掉落材料
			if (entity_type == EntityType.ENEMY or entity_type == EntityType.BOSS) and Utils.get_chance_success(lotato_enemy_gold_override / 100.0):
				return 1.0
			return 0.0
	return .get_gold_value(entity_type, args, base_value, unit)
