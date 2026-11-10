class_name PixelLabTrial
extends RefCounted
## Reversible five-view art trial. Never changes horse genes, physics or saves.
static var enabled:bool=true
static var initialized:bool=false
static var masks_enabled:bool=true
static var pig_enabled:bool=true
static func active()->bool:
 if not initialized:
  var cfg:=ConfigFile.new()
  if cfg.load("user://pixellab-trial.cfg")==OK:
   enabled=bool(cfg.get_value("art","enabled",true))
   masks_enabled=bool(cfg.get_value("art","masks_v5",true))
   pig_enabled=bool(cfg.get_value("art","pig_side",true))
  initialized=true
 return enabled
static func set_active(value:bool)->void:
 enabled=value;initialized=true
 save_config()
static func save_config()->void:
 var cfg:=ConfigFile.new();cfg.set_value("art","enabled",enabled);cfg.set_value("art","masks_v5",masks_enabled);cfg.set_value("art","pig_side",pig_enabled);cfg.save("user://pixellab-trial.cfg")
static func masks_active()->bool:
 active();return masks_enabled
static func set_masks_active(value:bool)->void:
 active();masks_enabled=value;save_config()
static func cache_key(t:Dictionary)->String:
 return str(t)+str(active())+str(masks_active())
static func pose_texture(kind:String,view:String,i:int,traits:Dictionary)->Texture2D:
 var base:Texture2D=load("res://art/experimental/pixellab/%s/%s/frame_%02d.png"%[kind,view,i])
 if not masks_active() or traits.is_empty():return base
 var mask:Image=load("res://art/experimental/pixellab_masks_review_v5/%s/%s/color_%02d.png"%[kind,view,i]).get_image()
 var uv:Image=load("res://art/experimental/pixellab_preview_uv/%s/%s/frame_%02d.png"%[kind,view,i]).get_image()
 if mask.is_compressed():mask.decompress()
 if uv.is_compressed():uv.decompress()
 return HorseAppearance.texture(base,"walk_"+view,i,traits,mask,uv)
static func apply(frames:SpriteFrames,kind:String,animation:String,traits:Dictionary={})->void:
 if not active():return
 for view in ["side","down","up","diag_down","diag_up"]:
  var target:String=("walk" if view=="side" else "walk_"+view) if kind=="horse" else "walk_"+view
  if frames.has_animation(target):frames.remove_animation(target)
  frames.add_animation(target);frames.set_animation_speed(target,9.0)
  for i in 9:frames.add_frame(target,pose_texture(kind,view,i,traits))
 # Rest remains deliberate, not an arbitrary running frame.
 if frames.has_animation("idle"):frames.remove_animation("idle")
 frames.add_animation("idle");frames.add_frame("idle",pose_texture(kind,"side",0,traits))

static func pig_active()->bool:
 active();return pig_enabled
static func set_pig_active(value:bool)->void:
 active();pig_enabled=value;save_config()
static func apply_pig(frames:SpriteFrames)->void:
 if not pig_active():return
 if frames.has_animation("run"):frames.remove_animation("run")
 frames.add_animation("run");frames.set_animation_speed("run",9.0)
 for i in 9:frames.add_frame("run",load("res://art/experimental/pixellab/pig/side/frame_%02d.png"%i))
