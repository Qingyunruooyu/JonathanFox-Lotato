extends "res://singletons/run_data.gd"

func resume_from_state(state: Dictionary) -> void :
	.resume_from_state(state)
	for data in players_data:
		for weapon in data.weapons:
				weapon.stats.set_meta("weapon_id_hash", weapon.weapon_id_hash)

func update_unique_bonuses(player_index: int) -> void :
	.update_unique_bonuses(player_index)
	var unique_effects = players_data[player_index].unique_effects
	var effects: = get_player_effects(player_index)
	var unique_weapon_ids = get_unique_weapon_ids(player_index)
	for effect in RunData.get_player_effect(Utils.lotato_specific_weapon_effect_hash, player_index):
		if Keys.hash_to_string[effect[2]] in unique_weapon_ids:
			effects[effect[0]] += effect[1]
			unique_effects.push_back([effect[0], effect[1]])
