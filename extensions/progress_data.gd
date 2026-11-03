extends "res://singletons/progress_data.gd"

var lotato_data
const LOTATO_MOD_NAME:="JonathanFox-Lotato"
const LOTATO_MOD_PATH:="res://mods-unpacked/" + LOTATO_MOD_NAME + "/"

# =========================== Extension =========================== #
func _ready() -> void:
	_lotato_ready()

# =========================== Custom =========================== #
func _lotato_ready() -> void:
	DebugService.log_data("%s/content_data/content_data.tres" % [LOTATO_MOD_PATH])
	lotato_data = load("%s/content_data/content_data.tres" % [LOTATO_MOD_PATH])
	lotato_data.add_resources()
	DebugService.log_data("add_resources")

	add_unlocked_by_default()
	RunData.reset()
	set_max_selectable_difficulty()
