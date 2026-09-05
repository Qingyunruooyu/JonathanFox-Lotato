extends "res://entities/units/target_behavior/lootworm_target_behavior.gd"


func update_target():
	if not (RunData.get_player_effect_bool(Utils.lotato_ignore_trees_hash, _parent.player_index)):
		.update_target()
		return

	var min_dist_squared: int = Utils.LARGE_NUMBER
	if _parent.current_target != null:
		if _parent.current_target is Gold and _parent.current_target.is_connected("picked_up", self, "on_gold_picked_up_by_player"):
			_parent.current_target.disconnect("picked_up", self, "on_gold_picked_up_by_player")
		elif _parent.current_target is Neutral and _parent.current_target.is_connected("died", self, "on_dead_tree"):
			_parent.current_target.disconnect("died", self, "on_dead_tree")
	_parent.current_target = null

	min_dist_squared = Utils.LARGE_NUMBER
	var active_golds = _main._active_golds

	for gold in active_golds:
		if gold.already_picked_up:
			continue
		var dist_squared = global_position.distance_squared_to(gold.global_position)
		if dist_squared < min_dist_squared:
			min_dist_squared = dist_squared
			_parent.current_target = gold


	if _parent.current_target != null:
		var _error = _parent.current_target.connect("picked_up", self, "on_gold_picked_up_by_player")
		emit_signal("target_found", self)
	else:
		_parent.current_target = self
