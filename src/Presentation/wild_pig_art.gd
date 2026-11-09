class_name WildPigArt
extends AnimatedSprite2D
## Shared textures and frames, not twenty fresh loads for every pig.
static var frame_cache:Dictionary={}
var variant:String="pink"
func _ready()->void:
 if not frame_cache.has(variant):
  var frames:=SpriteFrames.new()
  for anim in ["idle","run","tired","run_down","run_up"]:
   frames.add_animation(anim);frames.set_animation_speed(anim,12.0 if anim.begins_with("run") else 1.0)
   var indices:Array=range(12) if anim in ["run_down","run_up"] else (range(10) if anim=="run" else [6 if anim=="tired" else 0])
   for i in indices:
    var view:String="/down" if anim=="run_down" else ("/up" if anim=="run_up" else "")
    frames.add_frame(anim,load("res://art/world/pigs/%s%s/frame_%02d.png"%[variant,view,i]))
  frame_cache[variant]=frames
 sprite_frames=frame_cache[variant]
 centered=false;offset=Vector2(-80,-128);scale=Vector2.ONE*.36
 texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR
 play("idle")
func update_state(fleeing:bool,tired:bool,left:bool,movement:Vector2=Vector2.RIGHT)->void:
 flip_h=left
 var next:String="tired" if tired else ("run" if fleeing else "idle")
 if fleeing and not tired and absf(movement.y)>absf(movement.x)*1.2:
  next="run_down" if movement.y>0 else "run_up";flip_h=false
 if animation!=next:play(next)
