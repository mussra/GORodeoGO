class_name PixelLabTrial
extends RefCounted
## Nominal PixelLab movement art. Never changes horse genes, physics or saves.
static var image_cache:Dictionary={}
static var texture_cache:Dictionary={}
static func cache_key(t:Dictionary)->String:
 return str(t)
static func pose_texture(kind:String,view:String,i:int,traits:Dictionary)->Texture2D:
 var base:Texture2D=load("res://art/experimental/pixellab/%s/%s/frame_%02d.png"%[kind,view,i])
 if traits.is_empty():return base
 var key:String=kind+view+str(i)+str(traits)
 if texture_cache.has(key):return texture_cache[key]
 var pose:String=kind+view+str(i)
 if not image_cache.has(pose):
  var mask:Image=load("res://art/experimental/pixellab_masks_review_v5/%s/%s/color_%02d.png"%[kind,view,i]).get_image()
  var uv:Image=load("res://art/experimental/pixellab_preview_uv/%s/%s/frame_%02d.png"%[kind,view,i]).get_image()
  if mask.is_compressed():mask.decompress()
  if uv.is_compressed():uv.decompress()
  image_cache[pose]=[mask,uv]
 var images:Array=image_cache[pose]
 var result:Texture2D=HorseAppearance.texture(base,"walk_"+view,i,traits,images[0],images[1])
 if texture_cache.size()>600:texture_cache.clear()
 texture_cache[key]=result;return result

static func apply(frames:SpriteFrames,kind:String,animation:String,traits:Dictionary={})->void:
 for view in ["side","down","up","diag_down","diag_up"]:
  var target:String=("walk" if view=="side" else "walk_"+view) if kind=="horse" else "walk_"+view
  if frames.has_animation(target):frames.remove_animation(target)
  frames.add_animation(target);frames.set_animation_speed(target,9.0)
  for i in 9:frames.add_frame(target,pose_texture(kind,view,i,traits))
 # Rest remains deliberate, not an arbitrary running frame.
 if frames.has_animation("idle"):frames.remove_animation("idle")
 frames.add_animation("idle");frames.add_frame("idle",pose_texture(kind,"side",0,traits))

static func animal_views(kind:String)->Array:
 var views:Array=[]
 for view in ["side","down","up","diag_down","diag_up"]:
  var complete:bool=true
  for i in 9:
   if not ResourceLoader.exists("res://art/experimental/pixellab/%s/%s/frame_%02d.png"%[kind,view,i]):complete=false;break
  if complete:views.append(view)
 return views
static func apply_animal(frames:SpriteFrames,kind:String)->void:
 for view in animal_views(kind):
  var anim:String="run" if view=="side" else "run_"+view
  if frames.has_animation(anim):frames.remove_animation(anim)
  frames.add_animation(anim);frames.set_animation_speed(anim,9.0)
  for i in 9:frames.add_frame(anim,load("res://art/experimental/pixellab/%s/%s/frame_%02d.png"%[kind,view,i]))
static func apply_pig(frames:SpriteFrames)->void:
 apply_animal(frames,"pig")

static func frame_specs(kind:String)->Array:
 var specs:Array=[]
 for view in ["side","down","up","diag_down","diag_up"]:
  var anim:String=("walk" if view=="side" else "walk_"+view) if kind=="horse" else "walk_"+view
  for i in 9:specs.append([view,i,anim,9.0])
 specs.append(["side",0,"idle",3.0]);return specs
static func append_pose(frames:SpriteFrames,kind:String,step:Array,traits:Dictionary)->void:
 if not frames.has_animation(step[2]):
  frames.add_animation(step[2]);frames.set_animation_speed(step[2],step[3])
 frames.add_frame(step[2],pose_texture(kind,step[0],int(step[1]),traits))
static func unreplaced_rider_animations(names:Array)->Array:
 return names.filter(func(anim):return not str(anim).begins_with("walk"))

static func apply_bull(frames:SpriteFrames)->void:
 for view in animal_views("bull"):
  var anim:String="flee_"+view
  if frames.has_animation(anim):frames.remove_animation(anim)
  frames.add_animation(anim);frames.set_animation_speed(anim,9.0)
  for i in 9:frames.add_frame(anim,load("res://art/experimental/pixellab/bull/%s/frame_%02d.png"%[view,i]))
