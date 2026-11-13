class_name HorseFinish168
extends RefCounted
## Cosmetic only: separate from genetic finish, ancestry and stats.
const IDS:Array[String]=["","gold","crystal","ice"]
static func style(horse:Dictionary)->String:
 var value:Variant=horse.get("special_finish168","")
 return value if value is String and IDS.has(value) else ""
static func selected_spec(animation:String,kind:String)->Dictionary:
 var id:String=animation
 if animation=="rest_gesture107":id="drink"
 elif animation=="idle":id="drink" if kind=="rider" else "horse:side"
 elif animation=="walk":id="horse:side"
 elif animation.begins_with("walk_"):id=kind+":"+animation.trim_prefix("walk_")
 for spec in FinishPose168.specs():
  if spec.id==id:return spec
 return {}
static func update(sprite:AnimatedSprite2D,horse:Dictionary,kind:String="rider")->void:
 var finish:String=style(horse)
 if finish.is_empty():sprite.material=null;return
 var spec:=selected_spec(str(sprite.animation),kind)
 if spec.is_empty():sprite.material=null;return
 var frame:int=sprite.frame
 if str(sprite.animation)=="rest_gesture107":frame=1
 sprite.material=FinishPose168.material(finish,spec,frame)
static func install(sprite:AnimatedSprite2D,horse:Dictionary,kind:String="rider")->void:
 if style(horse).is_empty():return
 var refresh:Callable=func():update(sprite,horse,kind)
 sprite.frame_changed.connect(refresh);sprite.animation_changed.connect(refresh);refresh.call()
