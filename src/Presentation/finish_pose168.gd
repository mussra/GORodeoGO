class_name FinishPose168
extends RefCounted
## All existing adult mounted poses, not just the old lateral study.
static func specs()->Array[Dictionary]:
 var out:Array[Dictionary]=[]
 for kind in ["rider","horse"]:
  for view in ["side","down","up","diag_down","diag_up"]:
   out.append({"id":kind+":"+view,"title":("Montura" if kind=="rider" else "Sin jinete")+" · "+view,"count":9,"kind":kind,"view":view})
 for view in ["jump_side","jump_down","jump_up","jump_diag_down","jump_diag_up"]:
  out.append({"id":view,"title":"Salto · "+view.trim_prefix("jump_"),"count":8,"kind":"classic","view":view})
 out.append({"id":"stunned","title":"Golpe","count":1,"kind":"classic","view":"stunned"})
 out.append({"id":"drink","title":"Reposo / beber","count":2,"kind":"drink","view":"side"})
 return out
static func paths(spec:Dictionary,i:int)->Dictionary:
 i=posmod(i,int(spec.count))
 if spec.kind in ["rider","horse"]:
  return {"source":"res://art/experimental/pixellab/%s/%s/frame_%02d.png"%[spec.kind,spec.view,i],"mask":"res://art/experimental/pixellab_masks_review_v5/%s/%s/color_%02d.png"%[spec.kind,spec.view,i],"uv":"res://art/experimental/pixellab_preview_uv/%s/%s/frame_%02d.png"%[spec.kind,spec.view,i]}
 if spec.kind=="drink":return {"source":"res://art/experimental/drink_preview83/pose_%d.png"%i,"mask":"res://art/experimental/drink_preview83/color_%d.png"%i,"uv":"res://art/experimental/drink_preview83/uv_%d.png"%i}
 var name_:String="frame_0" if spec.view=="stunned" else "frame_%02d"%i
 return {"source":"res://art/player/%s/%s.png"%[spec.view,name_],"mask":"res://art/horse_masks/%s/%s.png"%[spec.view,name_],"uv":""}
static var materials:Dictionary={}
static func material(style:String,spec:Dictionary,i:int)->ShaderMaterial:
 var p:=paths(spec,i);var key:String=style+str(p)
 if materials.has(key):return materials[key]
 var uv:Texture2D=load(p.uv) if not str(p.uv).is_empty() else null
 var result:=SpecialFinish145.material(style,load(p.mask),uv)
 materials[key]=result;return result
