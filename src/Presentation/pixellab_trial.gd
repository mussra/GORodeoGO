class_name PixelLabTrial
extends RefCounted
## Reversible five-view art trial. Never changes horse genes, physics or saves.
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
 for view in ["side","down","up","diag_down","diag_up"]:
  var target:String=("walk" if view=="side" else "walk_"+view) if kind=="horse" else "walk_"+view
  if frames.has_animation(target):frames.remove_animation(target)
  frames.add_animation(target);frames.set_animation_speed(target,9.0)
  for i in 9:frames.add_frame(target,load("res://art/experimental/pixellab/%s/%s/frame_%02d.png"%[kind,view,i]))
 # Rest remains deliberate, not an arbitrary running frame.
 if frames.has_animation("idle"):frames.remove_animation("idle")
 frames.add_animation("idle");frames.add_frame("idle",load("res://art/experimental/pixellab/%s/side/frame_00.png"%kind))
