extends "res://singletons/entity_service.gd"

func lotato_get_weapon_remove_speed() -> Dictionary:
	var cache_key = Utils.lotato_reset_speed_hash
	var factor = factor_cache.get(cache_key)
	if factor == null:
		factor_cache[cache_key] = {}
		var lotato_weapon_remove_speed = factor_cache[cache_key]
		for player_index in range(RunData.get_player_count()):
			for effect in RunData.get_player_effect(Utils.lotato_weapon_remove_speed_hash, player_index):
				if lotato_weapon_remove_speed.has(effect[0]):
					lotato_weapon_remove_speed[effect[0]][0] += effect[1]
					if effect[2] > lotato_weapon_remove_speed[effect[0]][1]:
						lotato_weapon_remove_speed[effect[0]][1] = effect[2]
				else:
					lotato_weapon_remove_speed[effect[0]] = [effect[1], effect[2]]
	return factor_cache[cache_key]
