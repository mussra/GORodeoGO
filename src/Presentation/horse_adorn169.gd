class_name HorseAdorn169
extends RefCounted
## Cosmetics only, separate per adult mount. Purchase unlocks a metal for both slots.
const IDS:Array[String]=["","gold","silver"]
const NAMES:Array[String]=["Sin adorno","Oro","Plata"]
const SLOTS:Array[String]=["legs","boots"]
static var materials:Dictionary={}
static func metal(horse:Dictionary,slot:String)->String:
 if not SLOTS.has(slot):return ""
 var value:Variant=horse.get("leg_adorn169" if slot=="legs" else "boot_adorn169","")
 return value if value is String and IDS.has(value) else ""
static func active(horse:Dictionary)->bool:return not metal(horse,"legs").is_empty() or not metal(horse,"boots").is_empty()
static func mask_path(spec:Dictionary,i:int)->String:
 i=posmod(i,int(spec.count))
 if spec.kind in ["rider","horse"]:return "res://art/adorn169/%s/%s/%02d.png"%[spec.kind,spec.view,i]
 return "res://art/adorn169/%s/%02d.png"%[spec.id,i]
static func configure(material_:ShaderMaterial,horse:Dictionary,mask:Texture2D)->void:
 material_.set_shader_parameter("adorn_mask169",mask)
 material_.set_shader_parameter("leg_metal169",IDS.find(metal(horse,"legs")))
 material_.set_shader_parameter("boot_metal169",IDS.find(metal(horse,"boots")))
static func material(horse:Dictionary,spec:Dictionary,i:int)->ShaderMaterial:
 var style:String=HorseFinish168.style(horse)
 if not active(horse):return FinishPose168.material(style,spec,i) if not style.is_empty() else null
 var path:String=mask_path(spec,i);var key:String=style+metal(horse,"legs")+metal(horse,"boots")+path
 if materials.has(key):return materials[key]
 var p:=FinishPose168.paths(spec,i)
 var result:=SpecialFinish145.material(style,load(p.mask),load(p.uv) if not str(p.uv).is_empty() else null)
 configure(result,horse,load(path));materials[key]=result;return result
