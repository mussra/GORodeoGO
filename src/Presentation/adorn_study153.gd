class_name AdornStudy153
extends RefCounted
## Preview-only adapter: no save, inventory, ownership, stats or prices.
const SHADER=preload("res://art/adorn153/adorn.gdshader")
const IDS:Array[String]=["original","gold","silver"]
const NAMES:Array[String]=["Sin adornos","Oro","Plata"]
static var cache:Dictionary={}
static func material(style:String,pose:int=-1)->ShaderMaterial:
 var frame:int=posmod(pose,9) if pose>=0 else -1
 var key:String=style+str(frame)
 if cache.has(key):return cache[key]
 var result:=ShaderMaterial.new();result.shader=SHADER;result.set_shader_parameter("metal",maxi(0,IDS.find(style)))
 result.set_shader_parameter("adorn_mask",load("res://art/adorn153/portrait.png" if frame<0 else "res://art/adorn153/side_%02d.png"%frame));cache[key]=result;return result
static func frame(pose:int)->Texture2D:return load("res://art/experimental/pixellab/rider/side/frame_%02d.png"%posmod(pose,9))
