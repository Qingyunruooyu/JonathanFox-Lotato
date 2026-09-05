extends "res://entities/units/player/player.gd"

var _lotato_stats_near_tree_effect: Array
var _lotato_trees_nearby: int = 0
onready var _lotato_stats_near_tree_range:Area2D = null
onready var _lotato_stats_near_tree_collision_shape:CollisionShape2D = null
onready var _lotato_stats_near_tree_circle_shape:CircleShape2D = null

func _ready():
	_lotato_stats_near_tree_ready()

func _lotato_stats_near_tree_ready():
	var radius = Utils.LARGE_NUMBER
	_lotato_stats_near_tree_effect = RunData.get_player_effect(Utils.lotato_stats_near_tree_hash, player_index)
	if _lotato_stats_near_tree_effect.empty():
		return
	for effect in _lotato_stats_near_tree_effect:
		radius = clamp(effect[2], 0, radius)

	if not has_node("LotatoRange"):
		_lotato_stats_near_tree_range = Area2D.new()
		_lotato_stats_near_tree_range.name = "LotatoRange"
		_lotato_stats_near_tree_range.collision_layer = 0
		_lotato_stats_near_tree_range.collision_mask = Utils.NEUTRAL_BIT
		_lotato_stats_near_tree_range.monitorable = false
		add_child(_lotato_stats_near_tree_range)

		_lotato_stats_near_tree_circle_shape = CircleShape2D.new()
		_lotato_stats_near_tree_circle_shape.resource_local_to_scene = true
		_lotato_stats_near_tree_circle_shape.radius = radius

		_lotato_stats_near_tree_collision_shape = CollisionShape2D.new()
		_lotato_stats_near_tree_collision_shape.name = "LotatoCollisoinShape"
		_lotato_stats_near_tree_collision_shape.rotation = 1.5708
		_lotato_stats_near_tree_collision_shape.shape = _lotato_stats_near_tree_circle_shape
		_lotato_stats_near_tree_range.add_child(_lotato_stats_near_tree_collision_shape)
	else:
		_lotato_stats_near_tree_range = $LotatoRange
	_lotato_stats_near_tree_range.connect("body_entered", self, "_on_lotato_Range_tree_entered")
	_lotato_stats_near_tree_range.connect("body_exited", self, "_on_lotato_Range_tree_exited")

func _on_lotato_Range_tree_entered(body: Node) -> void :
	_lotato_trees_nearby += 1
	var _error = body.connect("died", self, "_on_lotato_tree_dies")
	if _lotato_trees_nearby == 1:
		for effect in _lotato_stats_near_tree_effect:
			TempStats.add_stat(effect[0], effect[1], player_index)
		add_outline(ProgressData.settings.color_positive)

func _on_lotato_Range_tree_exited(body: Node) -> void :
	_lotato_trees_nearby -= 1
	_lotato_recover_stats_nearby_trees()
	body.disconnect("died", self, "_on_lotato_tree_dies")

func _on_lotato_tree_dies(target: Node, _args: Entity.DieArgs) -> void :
	_lotato_trees_nearby -= 1
	_lotato_recover_stats_nearby_trees()

func _lotato_recover_stats_nearby_trees():
	if _lotato_trees_nearby == 0:
		remove_outline(ProgressData.settings.color_positive)
		for effect in _lotato_stats_near_tree_effect:
			TempStats.remove_stat(effect[0], effect[1], player_index)

func _is_hp_regen_disabled():
	return not RunData.get_player_effect(Utils.lotato_healed_only_by_hash, player_index).empty()

###扩展####
func check_hp_regen() -> void :
	if _is_hp_regen_disabled():
		_health_regen_timer.stop()
		return
	.check_hp_regen()

func set_hp_regen_timer_value() -> void :
	if _is_hp_regen_disabled():
		_health_regen_timer.wait_time = Utils.LARGE_NUMBER
		return
	.set_hp_regen_timer_value()

func on_health_regen(loop_count: int) -> void :
	if _is_hp_regen_disabled():
		return
	.on_health_regen(loop_count)

func on_healing_effect(value: int, tracking_key: int = Keys.empty_hash, from_torture: bool = false) -> int:
	var heal_only_effect:Array = RunData.get_player_effect(Utils.lotato_healed_only_by_hash, player_index)
	if not heal_only_effect.empty():
		var heal_only_by = heal_only_effect.back()[0]
		if heal_only_by != tracking_key:
			return 0
	return .on_healing_effect(value, tracking_key, from_torture)
