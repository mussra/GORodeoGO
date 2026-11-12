class_name SpecialFinish145
extends RefCounted
## Visual studies only. Never encoded into traits, saves, rarity or prices.
const IDS:Array[String]=["gold","crystal","ice"]
const NAMES:Array[String]=["Oro brillante","Cristal","Hielo"]
const SHADER=preload("res://art/special_finish145.gdshader")
static func material(style:String,mask:Texture2D,uv:Texture2D=null,portrait:bool=false)->ShaderMaterial:
 var m:=ShaderMaterial.new();m.shader=SHADER;m.set_shader_parameter("style",IDS.find(style)+1);m.set_shader_parameter("region_mask",mask);m.set_shader_parameter("uv_enabled",uv!=null);m.set_shader_parameter("portrait",portrait)
 if uv!=null:m.set_shader_parameter("body_uv",uv)
 return m
static func riderless_frame(i:int)->Texture2D:return load("res://art/experimental/pixellab/horse/side/frame_%02d.png"%posmod(i,9))
static var frame_cache:Dictionary={}
static func frame_material(style:String,i:int)->ShaderMaterial:
 i=posmod(i,9)
 var key:String=style+str(i)
 if frame_cache.has(key):return frame_cache[key]
 var result:ShaderMaterial=material(style,load("res://art/experimental/pixellab_masks_review_v5/horse/side/color_%02d.png"%i),load("res://art/experimental/pixellab_preview_uv/horse/side/frame_%02d.png"%i))
 frame_cache[key]=result;return result
