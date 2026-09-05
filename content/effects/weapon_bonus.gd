class_name LotatoWeaponBonusEffect
extends WeaponTypeBonusEffect

static func get_id() -> String:
	return "lotato_weapon_bonus_effect"


func apply(player_index: int) -> void:
	var effects = RunData.get_player_effects(player_index)
	effects[Utils.lotato_weapon_bonus_hash].push_back([key_hash, stat_hash, value])


func unapply(player_index: int) -> void:
	var effects = RunData.get_player_effects(player_index)
	effects[Utils.lotato_weapon_bonus_hash].erase([key_hash, stat_hash, value])


func get_args(_player_index: int) -> Array:
	return [str(value), tr(stat_displayed_name.to_upper()), tr(key.to_upper())]
