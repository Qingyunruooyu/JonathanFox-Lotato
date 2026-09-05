extends "res://entities/units/neutral/neutral.gd"


func _on_Hurtbox_area_entered(hitbox: Area2D) -> void :
	var from = hitbox.from if is_instance_valid(hitbox.from) else null
	var from_player_index = from.player_index if (from != null and "player_index" in from) else RunData.DUMMY_PLAYER_INDEX
	if RunData.get_player_effect_bool(Utils.lotato_ignore_trees_hash, from_player_index):
		return
	._on_Hurtbox_area_entered(hitbox)
