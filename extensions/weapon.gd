extends "res://weapons/weapon.gd"

var lotato_weapon_remove_speed = []
func _ready():
	if RunData.get_player_effect_bool(Utils.lotato_ignore_trees_hash, player_index):
		_range.collision_mask &= ~Utils.NEUTRAL_BIT
	var remove_speed:Dictionary = EntityService.lotato_get_weapon_remove_speed()
	if remove_speed.has(weapon_id_hash):
		lotato_weapon_remove_speed = remove_speed[weapon_id_hash]

func on_weapon_hit_something(_thing_hit: Node, damage_dealt: int, hitbox: Hitbox) -> void :
	.on_weapon_hit_something(_thing_hit, damage_dealt, hitbox)
	if not "enemy_id" in _thing_hit or lotato_weapon_remove_speed.empty():
		return
	_thing_hit.lotato_set_speed_modifier(lotato_weapon_remove_speed)
