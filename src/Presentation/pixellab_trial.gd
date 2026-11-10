class_name PixelLabTrial
extends RefCounted
## Reversible lateral-only art trial. Never changes horse genes, physics or saves.
static var enabled:bool=true
static var initialized:bool=false
static func active()->bool:
 if not initialized:
  var cfg:=ConfigFile.new()
  if cfg.load("user://pixellab-trial.cfg")==OK:enabled=bool(cfg.get_value("art","enabled",true))
  initialized=true
 return enabled
static func set_active(value:bool)->void:
 enabled=value;initialized=true
 var cfg:=ConfigFile.new();cfg.set_value("art","enabled",value);cfg.save("user://pixellab-trial.cfg")
static func apply(frames:SpriteFrames,kind:String,animation:String)->void:
 if not active():return
 if frames.has_animation(animation):frames.remove_animation(animation)
 frames.add_animation(animation);frames.set_animation_speed(animation,9.0)
 for i in 9:frames.add_frame(animation,load("res://art/experimental/pixellab/%s/frame_%02d.png"%[kind,i]))
 # Keep the deliberate resting pose rather than running while stopped.
 if frames.has_animation("idle"):frames.remove_animation("idle")
 frames.add_animation("idle");frames.add_frame("idle",load("res://art/experimental/pixellab/%s/frame_00.png"%kind))
