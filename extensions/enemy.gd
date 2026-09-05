extends "res://entities/units/enemies/enemy.gd"

func lotato_set_speed_modifier(speed_remove_effect: Array) -> void :
	if dead:
		return
	var speed_modifier = current_stats.speed * speed_remove_effect[0] / 100
	current_stats.speed += speed_modifier
	var timer: SceneTreeTimer = get_tree().create_timer(speed_remove_effect[1], false)
	var _e = timer.connect("timeout", self, "lotato_reset_speed_modifier", [speed_modifier])

func lotato_reset_speed_modifier(speed_modifier: int) -> void :
	if dead:
		return
	current_stats.speed -= speed_modifier
