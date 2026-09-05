extends "res://singletons/progress_data.gd"

var lotato_extension_loaded:=false
var lotato_data
const LOTATO_MOD_NAME:="JonathanFox-Lotato"
const LOTATO_MOD_PATH:="res://mods-unpacked/" + LOTATO_MOD_NAME + "/"
const LOTATO_EXTENSION_DIR: = LOTATO_MOD_PATH + "extensions/"

# =========================== Extension =========================== #
func _ready() -> void:
	_lotato_ready()

func load_dlc_pcks()->void :
	.load_dlc_pcks()
	if not lotato_extension_loaded:
		lotato_install_extensions()
		lotato_extension_loaded = true

# =========================== Custom =========================== #
func _lotato_ready() -> void:
	DebugService.log_data("%s/content_data/content_data.tres" % [LOTATO_MOD_PATH])
	lotato_data = load("%s/content_data/content_data.tres" % [LOTATO_MOD_PATH])
	lotato_data.add_resources()
	DebugService.log_data("add_resources")

	ItemService.init_unlocked_pool()
	RunData.reset()
	load_game_file()
	add_unlocked_by_default()
	set_max_selectable_difficulty()

func lotato_install_extensions() -> void:
	var extensions: Array = [

	]
	for path in extensions:
		DebugService.log_data(path)
		ModLoaderMod.install_script_extension(LOTATO_EXTENSION_DIR + path)
