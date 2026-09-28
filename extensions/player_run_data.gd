extends "res://singletons/player_run_data.gd"

static func init_lotato_stats() -> Dictionary:
	return {
		}

static func init_stats(all_null_values: bool = false)->Dictionary:
	if (not Utils == null) :
		var vanilla_stats = .init_stats(all_null_values)
		var lotato_stats = init_lotato_stats()
		lotato_stats.merge(vanilla_stats)

		return lotato_stats;
	else:
		return {}

static func init_effects()->Dictionary:
	if (not Utils == null) :
		var vanilla_effects = .init_effects()
		var new_effects: = {
			Utils.lotato_ignore_trees_hash: 0,
			Utils.lotato_stats_near_tree_hash: [], #属性，属性值，与树的距离
			Utils.lotato_weapon_class_only_hash: [], #只出现xx类武器（看最后一个）
			Utils.lotato_healed_only_by_hash: [], #只能通过这个道具恢复生命值（看最后一个）
			Utils.lotato_level_up_get_crate_hash: 0, #升级获得一个宝箱
			Utils.lotato_item_class_only_hash: [], #只出现XX类道具（看最后一个）
			Utils.lotato_weapon_bonus_hash: [], #使用某个武器的属性增益
			Utils.lotato_weapon_remove_speed_hash: [], #武器减少总移速
			Utils.lotato_specific_weapon_effect_hash: [],
			Utils.lotato_enemy_gold_override_hash: 0,
			Utils.lotato_bonus_hit_protection_for_stat_hash: [],
			Utils.lotato_bonus_stat_for_hit_protection_hash: [],
			Utils.lotato_weapon_explode_on_hit_hash: [],
		}
		new_effects.merge(vanilla_effects)
		new_effects.merge(init_lotato_stats())
		return new_effects;
	else:
		return {}

