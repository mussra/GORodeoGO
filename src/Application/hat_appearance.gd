class_name HatAppearance
extends RefCounted
## First cosmetic trial. Original is always available; no gameplay bonus or price.
const OPTIONS:Dictionary={"original":"Original","blue":"Azul noche","sand":"Arena"}
static func sanitize(value:Variant)->String:
 return value if typeof(value)==TYPE_STRING and OPTIONS.has(value) else "original"
static func art_root(value:Variant)->String:
 var id:String=sanitize(value)
 return "res://art/player/" if id=="original" else "res://art/player_hats/"+id+"/"
