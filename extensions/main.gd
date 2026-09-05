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
