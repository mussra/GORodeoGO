class_name HorsePortrait
extends RefCounted
const ART=preload("res://art/portraits/adult_hd.png")
const MASK=preload("res://art/portraits/adult_hd_mask.png")
const LIGHT_LEGS=preload("res://art/portraits/adult_light_legs_mask.png")
const LOWER_LEGS=preload("res://art/portraits/adult_lower_legs_mask.png")
const EYES=preload("res://art/portraits/adult_eyes.png")
const SHADER=preload("res://art/portraits/portrait.gdshader")
static func material_for(traits:Dictionary,hat:String="original")->ShaderMaterial:
 var m:=ShaderMaterial.new();m.shader=SHADER;m.set_shader_parameter("spot_data",PackedVector4Array(HorseAppearance.spots()));m.set_shader_parameter("spot_count",HorseAppearance.spots().size());m.set_shader_parameter("eye_mask",EYES);m.set_shader_parameter("custom_eyes",traits.has("eyes"));m.set_shader_parameter("eye_color",HorseAppearance.eye_color_at(HorseCollection.eye_index(traits),Vector2(.5,.5)));m.set_shader_parameter("region_mask",MASK);m.set_shader_parameter("light_legs_mask",LIGHT_LEGS);m.set_shader_parameter("lower_legs_mask",LOWER_LEGS);m.set_shader_parameter("custom_legs",HorseCollection.legs_index(traits)>=0);m.set_shader_parameter("legs_color",Color(HorseAppearance.COLORS[maxi(0,HorseCollection.legs_index(traits))]))
 m.set_shader_parameter("eye_style",HorseCollection.eye_index(traits) if HorseCollection.eye_index(traits)>=20 else 0)
 m.set_shader_parameter("galaxy",traits.get("finish","")=="galaxy")
 m.set_shader_parameter("original_horse",traits.get("finish","normal")=="original")
 m.set_shader_parameter("coat_color",Color(HorseAppearance.COLORS[int(traits.get("coat",10))]))
 var mane:int=int(traits.get("mane",1));m.set_shader_parameter("mane_color",Color(HorseAppearance.MANES[mini(mane,4)]));m.set_shader_parameter("rainbow",mane==5)
 m.set_shader_parameter("pattern",int(traits.get("pattern",0)));m.set_shader_parameter("cow_map",HorsePatternMap.COW);m.set_shader_parameter("giraffe_map",HorsePatternMap.GIRAFFE);m.set_shader_parameter("zebra_map",HorsePatternMap.ZEBRA);m.set_shader_parameter("spot_color",HorsePatternMap.color(traits) if HorseCollection.spots_index(traits)>=0 or int(traits.get("pattern",0))>=10 else Color(.96,.93,.85))
 m.set_shader_parameter("original_hat",hat=="original");m.set_shader_parameter("hat_color",Color("415c81") if hat=="blue" else Color("c8b994"))
 if HorseEmblem.valid(traits.get("emblem")):
  m.set_shader_parameter("emblem_enabled",true);m.set_shader_parameter("emblem_mask",HorseEmblem.portrait_mask(traits.emblem));m.set_shader_parameter("emblem_color",Color(HorseEmblem.COLORS[int(traits.emblem.get("color",0))%HorseEmblem.COLORS.size()]))
 return m
static func apply(view:CanvasItem,traits:Dictionary,hat:String="original")->void:
 view.set("texture",ART);view.material=material_for(traits,hat);view.texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR
