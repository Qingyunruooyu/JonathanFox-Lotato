extends "res://singletons/utils.gd"

# effects
var lotato_ignore_trees_hash: int = Keys.generate_hash("lotato_ignore_trees")
var lotato_stats_near_tree_hash: int = Keys.generate_hash("lotato_stats_near_tree")
var lotato_weapon_class_only_hash: int = Keys.generate_hash("lotato_weapon_class_only")
var lotato_healed_only_by_hash: int = Keys.generate_hash("lotato_healed_only_by")
var lotato_level_up_get_crate_hash: int = Keys.generate_hash("lotato_level_up_get_crate")
var lotato_item_class_only_hash: int = Keys.generate_hash("lotato_item_class_only")
var lotato_weapon_bonus_hash: int = Keys.generate_hash("lotato_weapon_bonus")
var lotato_weapon_remove_speed_hash: int = Keys.generate_hash("lotato_weapon_remove_speed")
var lotato_specific_weapon_effect_hash: int = Keys.generate_hash("lotato_specific_weapon_effect")

# entity service
var lotato_reset_speed_hash = Keys.generate_hash("lotato_reset_speed_hash")
