extends Node

# MOD配置
const MOD_NAME:="JonathanFox-Lotato"
const MOD_PATH:="res://mods-unpacked/" + MOD_NAME + "/"
const LOTATO_EXTENSION_DIR: = MOD_PATH + "extensions/"
const LOTATO_TRANSLATION_DIR: = MOD_PATH + "translations/"

const EXTENSION_SCRIPTS: =[
	"item_service.gd",
	"player_run_data.gd",
	"player.gd",
	"weapon.gd",
	"neutral.gd",
	"turret.gd",
	"main.gd",
	"weapon_service.gd",
	"run_data.gd",
	"enemy.gd",
	"entity_service.gd",
	"utils.gd",
	"progress_data.gd",
]

func _init():
	ModLoaderLog.info("Init", MOD_NAME)
	for script in EXTENSION_SCRIPTS:
		ModLoaderMod.install_script_extension(LOTATO_EXTENSION_DIR + script)
	ModLoaderMod.add_translation(LOTATO_TRANSLATION_DIR + "lotato_translation.en.translation")
	ModLoaderMod.add_translation(LOTATO_TRANSLATION_DIR + "lotato_translation.zh_Hans_CN.translation")

