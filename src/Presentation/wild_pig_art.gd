class_name WildPigArt
extends AnimatedSprite2D
## Shared textures and frames, not twenty fresh loads for every pig.
static var frame_cache:Dictionary={}
var variant:String="pink"
func _ready()->void:
 var key:String=variant
 if not frame_cache.has(key):
  var frames:=SpriteFrames.new()
  for anim in ["idle","tired"]:
   frames.add_animation(anim);frames.set_animation_speed(anim,1.0)
   frames.add_frame(anim,load("res://art/world/pigs/%s/frame_%02d.png"%[variant,6 if anim=="tired" else 0]))
  PixelLabTrial.apply_pig(frames);frame_cache[key]=frames
 sprite_frames=frame_cache[key]
 centered=false;offset=Vector2(-80,-128);scale=Vector2.ONE*.36
 texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR
 play("idle")
func update_state(fleeing:bool,tired:bool,left:bool,movement:Vector2=Vector2.RIGHT)->void:
 flip_h=left
 var next:String="tired" if tired else ("run" if fleeing else "idle")
 if fleeing and not tired:
  var available:Array=["side","down","up"]
  for view in ["diag_down","diag_up"]:
   if sprite_frames.has_animation("run_"+view):available.append(view)
  var view:String=AnimalDirection.available_view(movement,available)
  next="run" if view=="side" else "run_"+view
  flip_h=left and view not in ["up","down"]
 if animation!=next:play(next)
