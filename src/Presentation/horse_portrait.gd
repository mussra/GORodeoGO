class_name HorsePortrait
extends RefCounted
const ART=preload("res://art/portraits/adult_hd.png")
const MASK=preload("res://art/portraits/adult_hd_mask.png")
const SHADER=preload("res://art/portraits/portrait.gdshader")
static func material_for(traits:Dictionary,hat:String="original")->ShaderMaterial:
 var m:=ShaderMaterial.new();m.shader=SHADER;m.set_shader_parameter("region_mask",MASK)
 m.set_shader_parameter("original_horse",traits.get("finish","normal")=="original")
 m.set_shader_parameter("coat_color",Color(HorseAppearance.COLORS[int(traits.get("coat",10))]))
 var mane:int=int(traits.get("mane",1));m.set_shader_parameter("mane_color",Color(HorseAppearance.MANES[mini(mane,4)]));m.set_shader_parameter("rainbow",mane==5)
 m.set_shader_parameter("pattern",int(traits.get("pattern",0)))
 m.set_shader_parameter("original_hat",hat=="original");m.set_shader_parameter("hat_color",Color("415c81") if hat=="blue" else Color("c8b994"))
 return m
static func apply(view:CanvasItem,traits:Dictionary,hat:String="original")->void:
 view.set("texture",ART);view.material=material_for(traits,hat);view.texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR
