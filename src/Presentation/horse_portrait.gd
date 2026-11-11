class_name HorsePortrait
extends RefCounted
const ART=preload("res://art/portraits/adult_hd.png")
const MASK=preload("res://art/portraits/adult_hd_mask.png")
const LIGHT_LEGS=preload("res://art/portraits/adult_light_legs_mask.png")
const LOWER_LEGS=preload("res://art/portraits/adult_lower_legs_mask.png")
const EYES=preload("res://art/portraits/adult_eyes.png")
const SHADER=preload("res://art/portraits/portrait.gdshader")
static func material_for(traits:Dictionary,hat:String="original")->ShaderMaterial:
 var m:=ShaderMaterial.new();m.shader=SHADER;m.set_shader_parameter("spot_data",PackedVector4Array(HorseAppearance.spots()));m.set_shader_parameter("spot_count",HorseAppearance.spots().size());m.set_shader_parameter("eye_mask",EYES);m.set_shader_parameter("custom_eyes",traits.has("eyes"));m.set_shader_parameter("eye_color",HorseAppearance.eye_color_at(HorseCollection.eye_index(traits),Vector2(.5,.5)));m.set_shader_parameter("region_mask",MASK);m.set_shader_parameter("light_legs_mask",LIGHT_LEGS);m.set_shader_parameter("lower_legs_mask",LOWER_LEGS);m.set_shader_parameter("custom_legs",HorseCollection.legs_index(traits)>=0);m.set_shader_parameter("legs_color",Color("33302e") if HorseCollection.legs_index(traits)==0 else Color(HorseAppearance.COLORS[maxi(0,HorseCollection.legs_index(traits))]))
 m.set_shader_parameter("eye_style",HorseCollection.eye_index(traits) if HorseCollection.eye_index(traits)>=20 else 0)
 m.set_shader_parameter("galaxy",traits.get("finish","")=="galaxy")
 m.set_shader_parameter("galaxy_intensity",.30)
 m.set_shader_parameter("galaxy_star_density",.12)
 m.set_shader_parameter("galaxy_palette_preview",traits.get("finish","")=="galaxy")
 m.set_shader_parameter("original_horse",traits.get("finish","normal")=="original")
 m.set_shader_parameter("coat_color",Color(HorseAppearance.COLORS[int(traits.get("coat",10))]))
 var mane:int=int(traits.get("mane",1));m.set_shader_parameter("mane_color",Color("33302e") if mane==0 else Color(HorseAppearance.MANES[mini(mane,4)]));m.set_shader_parameter("rainbow",mane==5)
 m.set_shader_parameter("pattern",int(traits.get("pattern",0)));m.set_shader_parameter("cow_map",HorsePatternMap.COW);m.set_shader_parameter("giraffe_map",HorsePatternMap.GIRAFFE);m.set_shader_parameter("zebra_map",HorsePatternMap.ZEBRA);m.set_shader_parameter("spot_color",HorsePatternMap.color(traits) if HorseCollection.spots_index(traits)>=0 or int(traits.get("pattern",0))>=10 else Color(.96,.93,.85))
 m.set_shader_parameter("separate_hat_mask",true);m.set_shader_parameter("hat_mask",preload("res://art/hat_masks_v10/hat-portrait.png"));m.set_shader_parameter("original_hat",hat=="original");m.set_shader_parameter("hat_color",Color("415c81") if hat=="blue" else Color("c8b994"))
 if HorseEmblem.valid(traits.get("emblem")):
  m.set_shader_parameter("emblem_enabled",true);m.set_shader_parameter("emblem_mask",HorseEmblem.portrait_mask(traits.emblem));m.set_shader_parameter("emblem_color",Color(HorseEmblem.COLORS[int(traits.emblem.get("color",0))%HorseEmblem.COLORS.size()]))
 return m
static func apply(view:CanvasItem,traits:Dictionary,hat:String="original")->void:
 view.set("texture",ART);view.material=material_for(traits,hat);view.texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR

## One portrait configuration for foals and adults across all collection screens.
static func apply_horse(view:TextureRect,horse:Dictionary,hat:String="original")->void:
 view.expand_mode=TextureRect.EXPAND_IGNORE_SIZE
 view.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED
 view.texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR
 if horse.get("stage","adult")=="foal":
  view.material=null
  view.texture=HorseAppearance.texture(load("res://art/foal/base.png"),"foal",0,horse.traits)
 else:
  apply(view,horse.traits,hat)
  if horse.traits.get("finish","")=="galaxy":
   view.material.set_shader_parameter("galaxy_star_density",.04+.96*HorseMastery.percent(horse)/100.)
  if HorseMastery.galaxy_master(horse):
   view.material.set_shader_parameter("galaxy_palette_preview",true)
   view.material.set_shader_parameter("mastery_aura",true)
   view.material.set_shader_parameter("mastery_aura_strength",1.8)
   view.material.set_shader_parameter("galaxy_star_density",1.)
   view.material.set_shader_parameter("galaxy_intensity",1.)
   view.material.set_shader_parameter("galaxy_dark",Color("030b20"))
   view.material.set_shader_parameter("galaxy_light",Color("477ce7"))
