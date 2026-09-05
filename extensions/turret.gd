extends "res://entities/structures/turret/turret.gd"

onready var _lotato_range = $Range

func _ready():
	call_deferred("lotato_ignore_trees_ready")

func lotato_ignore_trees_ready():
	if RunData.get_player_effect_bool(Utils.lotato_ignore_trees_hash, player_index):
		_lotato_range.collision_mask &= ~Utils.NEUTRAL_BIT
