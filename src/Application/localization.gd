extends Node
## Native TranslationServer, offline catalogs bundled with the game.
const SETTINGS_PATH:String="user://language.cfg"
const SUPPORTED:Array[String]=["es","en"]
var choice:String="auto"
var settings_path:String=SETTINGS_PATH
func _ready()->void:load_choice()
static func resolve_language(selected:String,device:String)->String:
 var requested:String=device.get_slice("_",0).get_slice("-",0).to_lower() if selected=="auto" else selected
 return requested if requested in SUPPORTED else "es"
func load_choice()->void:
 var config:=ConfigFile.new();choice="auto"
 if config.load(settings_path)==OK:
  var saved:Variant=config.get_value("language","choice","auto")
  if saved in ["auto","es","en"]:choice=saved
 apply()
func apply()->void:TranslationServer.set_locale(resolve_language(choice,OS.get_locale_language()))
func set_choice(value:String)->bool:
 if value not in ["auto","es","en"]:return false
 var config:=ConfigFile.new();config.set_value("language","choice",value)
 var error:Error=config.save(settings_path+".tmp")
 if error==OK:error=DirAccess.rename_absolute(settings_path+".tmp",settings_path)
 if error!=OK:return false
 choice=value;apply();return true
