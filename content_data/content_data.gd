extends Resource

# ItemService
export (Resource) var update_data
export (Array, Resource) var sets = []
export (Array, Resource) var upgrades = []
export (Array, Resource) var consumables = []
export (Array, Resource) var elites = []
export (Array, Resource) var difficulties = []
export (Array, Resource) var effects = []

# ChallengeService
export (Array, Resource) var challenges = []

# RunData
export (Dictionary) var tracked_items = {}

# Text
export (Dictionary) var translation_keys_needing_operator = {}
export (Dictionary) var translation_keys_needing_percent = {}

func add_resources():
	ProgressData._append_without_duplicates(ItemService.update_data_list, [update_data])
	ItemService.invalidate_characters_cache()
	ItemService.invalidate_items_cache()
	ItemService.invalidate_weapons_cache()
	ProgressData.refresh_active_update_data()
	ProgressData._append_without_duplicates(ItemService.effects, effects)
	ProgressData._append_without_duplicates(RunData.effect_keys_full_serialization, [Utils.lotato_weapon_explode_on_hit_hash])

	# DLC2变异系统注册：mutation_boolean_keys只按key_hash命中（无custom_key的bool词条），
	# 带custom_key的词条必须进mutation_copy_blacklist（该列表同时检查custom_key_hash）
	var dlc_2_data = ItemService.get_dlc_data_by_id("primal_dread")
	if dlc_2_data != null:
		ProgressData._append_without_duplicates(dlc_2_data.mutation_boolean_keys, [
			Utils.lotato_ignore_trees_hash,
			Utils.lotato_level_up_get_crate_hash,
		])
		ProgressData._append_without_duplicates(dlc_2_data.mutation_copy_blacklist, [
			Utils.lotato_weapon_class_only_hash,
			Utils.lotato_item_class_only_hash,
			Utils.lotato_healed_only_by_hash,
			Utils.lotato_stats_near_tree_hash,
			Utils.lotato_enemy_gold_override_hash,
		])

	if not tracked_items.empty():
		RunData.init_tracked_items.merge(Utils.convert_dictionary_to_hash(tracked_items))

	if not translation_keys_needing_operator.empty():
		Text.keys_needing_operator.merge(translation_keys_needing_operator)

	if  not translation_keys_needing_percent.empty():
		Text.keys_needing_percent.merge(translation_keys_needing_percent)
