class_name ReplacementArt259
extends RefCounted
## Optional artwork intake. No caller is switched until the received sheet is
## inspected. Missing files always return null and preserve the current art.
const ROOT="res://art/replacement259/"
static var cache:Dictionary={}
static func texture(key:String)->Texture2D:
 if not key.is_valid_identifier():return null
 var path:=ROOT+key+".png"
 if not ResourceLoader.exists(path):return null
 if not cache.has(key):cache[key]=load(path)
 return cache[key]
static func reset()->void:cache.clear()
