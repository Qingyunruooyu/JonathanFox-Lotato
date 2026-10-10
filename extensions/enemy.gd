extends "res://entities/units/enemies/enemy.gd"

# 减速世代计数：respawn时+1，使上一条命遗留的减速恢复定时器全部作废
var _lotato_speed_mod_gen: int = 0

func lotato_set_speed_modifier(speed_remove_effect: Array) -> void :
	if dead:
		return
	var speed_modifier = current_stats.speed * speed_remove_effect[0] / 100
	current_stats.speed += speed_modifier
	var gen := _lotato_speed_mod_gen
	var timer: SceneTreeTimer = get_tree().create_timer(speed_remove_effect[1], false)
	var _e = timer.connect("timeout", self, "_lotato_on_speed_mod_timeout", [speed_modifier, gen])

func _lotato_on_speed_mod_timeout(speed_modifier, gen: int) -> void :
	if dead or gen != _lotato_speed_mod_gen:
		return
	current_stats.speed -= speed_modifier

func respawn() -> void :
	_lotato_speed_mod_gen += 1
	.respawn()
