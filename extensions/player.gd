extends "res://entities/units/player/player.gd"

var _lotato_stats_near_tree_effect: Array
var _lotato_trees_nearby: int = 0
onready var _lotato_stats_near_tree_range:Area2D = null
onready var _lotato_stats_near_tree_collision_shape:CollisionShape2D = null
onready var _lotato_stats_near_tree_circle_shape:CircleShape2D = null
# 拥有伤害免疫(_hit_protection>0)时加成的属性是否已生效
var _lotato_stat_applied_for_hit_protection: bool = false
# 生效时实际添加的[属性key, 数值]（移除时用，避免中途属性变化导致不对称）
var _lotato_applied_stat_amounts: = []
var _lotato_hit_protection_timer: Timer = null
# 近战武器命中爆炸（每玩家一份的计算缓存，属性变化经RunData.stats_updated失效重算）
var lotato_weapon_explode_on_hit_stats = null
var _lotato_explode_on_hit_args: = WeaponServiceExplodeArgs.new()
var _lotato_explode_init_stats_args: = WeaponServiceInitStatsArgs.new()
var _lotato_default_explode_effects: = [ExplodingEffect.new()]

func _ready():
	_lotato_stats_near_tree_ready()
	_lotato_apply_bonus_hit_protection_for_stat()
	_lotato_stat_for_hit_protection_ready()
	var _error = RunData.connect("stats_updated", self, "_lotato_on_stats_updated")

func _lotato_on_stats_updated(updated_player_index: int) -> void :
	if updated_player_index == player_index:
		lotato_weapon_explode_on_hit_stats = null

# 计算并缓存爆炸伤害stats（供所有近战武器共用）
func lotato_get_weapon_explode_on_hit_stats(first_effect) -> WeaponStats:
	if lotato_weapon_explode_on_hit_stats == null:
		_lotato_explode_init_stats_args.effects = _lotato_default_explode_effects
		lotato_weapon_explode_on_hit_stats = WeaponService.init_base_stats(first_effect.stats, player_index, _lotato_explode_init_stats_args)
	return lotato_weapon_explode_on_hit_stats

# 敌袭开始时，每永久持有{0}{1}，可获得一次伤害免疫；条目格式：[属性key, 每X点属性]
# 商为正才生效（per_value与属性同负也兼容），per_value为0跳过
func _lotato_apply_bonus_hit_protection_for_stat() -> void :
	for effect in RunData.get_player_effect(Utils.lotato_bonus_hit_protection_for_stat_hash, player_index):
		var per_value: int = effect[1]
		if per_value == 0:
			continue
		var ratio: float = RunData.get_stat(effect[0], player_index) / per_value
		if ratio > 0:
			_hit_protection += int(ratio)

# 有该效果时开半秒Timer轮询伤害免疫状态（参考linked_stats的半秒更新）
func _lotato_stat_for_hit_protection_ready() -> void :
	if RunData.get_player_effect(Utils.lotato_bonus_stat_for_hit_protection_hash, player_index).empty():
		return
	_lotato_hit_protection_timer = Timer.new()
	_lotato_hit_protection_timer.wait_time = 0.5
	var _error = _lotato_hit_protection_timer.connect("timeout", self, "_lotato_update_stat_for_hit_protection")
	add_child(_lotato_hit_protection_timer)
	_lotato_hit_protection_timer.start()

# 敌袭期间拥有伤害免疫时增加属性，失去时移除（免疫次数中途可能增减，按状态切换处理）
# 条目格式：[属性key, 属性值]，属性值为永久属性的百分比（如200 = +200%该属性）
func _lotato_update_stat_for_hit_protection() -> void :
	var stat_effects = RunData.get_player_effect(Utils.lotato_bonus_stat_for_hit_protection_hash, player_index)
	if stat_effects.empty():
		return

	var has_protection = _hit_protection > 0
	if has_protection == _lotato_stat_applied_for_hit_protection:
		return

	_lotato_stat_applied_for_hit_protection = has_protection
	if has_protection:
		_lotato_applied_stat_amounts.clear()
		for effect in stat_effects:
			var amount: int = int(RunData.get_stat(effect[0], player_index) * effect[1] / 100)
			_lotato_applied_stat_amounts.append([effect[0], amount])
			TempStats.add_stat(effect[0], amount, player_index)
	else:
		for applied in _lotato_applied_stat_amounts:
			TempStats.remove_stat(applied[0], applied[1], player_index)
		_lotato_applied_stat_amounts.clear()

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

func _on_lotato_tree_dies(_target: Node, _args: Entity.DieArgs) -> void :
	_lotato_trees_nearby -= 1
	_lotato_recover_stats_nearby_trees()

func _lotato_recover_stats_nearby_trees():
	if _lotato_trees_nearby == 0:
		remove_outline(ProgressData.settings.color_positive)
		for effect in _lotato_stats_near_tree_effect:
			TempStats.remove_stat(effect[0], effect[1], player_index)

func _is_hp_regen_disabled():
	return not RunData.get_player_effect(Utils.lotato_healed_only_by_hash, player_index).empty()

# 材料掉落改为固定几率时，砖块类武器碎裂不掉落材料
func on_weapon_wanted_to_break(weapon: Weapon, gold_dropped: int) -> void :
	if RunData.get_player_effect(Utils.lotato_enemy_gold_override_hash, player_index) > 0:
		gold_dropped = 0
	.on_weapon_wanted_to_break(weapon, gold_dropped)

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
