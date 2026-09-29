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
	if not "enemy_id" in _thing_hit:
		return
	lotato_process_weapon_explode_on_hit(_thing_hit)
	if lotato_weapon_remove_speed.empty():
		return
	_thing_hit.lotato_set_speed_modifier(lotato_weapon_remove_speed)

# 近战武器命中敌人时爆炸，伤害取自效果自身的stats；数组条目为item_exploding_effect资源
# stats缓存与explode_args都在Player上（每玩家一份），属性变化经RunData.stats_updated失效重算
func lotato_process_weapon_explode_on_hit(thing_hit: Node) -> void :
	if not (self is MeleeWeapon):
		return

	var explode_effects = RunData.get_player_effect(Utils.lotato_weapon_explode_on_hit_hash, player_index)
	if explode_effects.empty():
		return

	var explosion_chance: = 0.0
	for effect in explode_effects:
		explosion_chance += effect.chance
	if not Utils.get_chance_success(explosion_chance):
		return

	var first_effect = explode_effects[0]
	var explode_stats = _parent.lotato_get_weapon_explode_on_hit_stats(first_effect)
	if explode_stats == null:
		return

	var explode_args = _parent._lotato_explode_on_hit_args
	explode_args.pos = thing_hit.global_position
	explode_args.damage = explode_stats.damage
	explode_args.accuracy = explode_stats.accuracy
	explode_args.crit_chance = explode_stats.crit_chance
	explode_args.crit_damage = explode_stats.crit_damage
	explode_args.burning_data = explode_stats.burning_data
	explode_args.scaling_stats = explode_stats.scaling_stats
	explode_args.from_player_index = player_index
	explode_args.ignored_objects = [ ]
	explode_args.damage_tracking_key_hash = first_effect.tracking_key_hash
	explode_args.from = self
	var _inst = WeaponService.explode(first_effect, explode_args)
