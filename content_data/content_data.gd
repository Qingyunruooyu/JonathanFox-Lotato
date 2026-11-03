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

	if not tracked_items.empty():
		RunData.init_tracked_items.merge(Utils.convert_dictionary_to_hash(tracked_items))

	if not translation_keys_needing_operator.empty():
		Text.keys_needing_operator.merge(translation_keys_needing_operator)

	if  not translation_keys_needing_percent.empty():
		Text.keys_needing_percent.merge(translation_keys_needing_percent)
