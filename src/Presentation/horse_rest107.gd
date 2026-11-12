class_name HorseRest107
extends RefCounted
## Reuse Ant's existing mounted drink poses; never alter locomotion frames.
const MIN_WAIT:float=5.
const MAX_WAIT:float=10.
const GESTURE_SECONDS:float=3.
static var cache:Dictionary={}
var elapsed:float=0.
var wait:float=randf_range(MIN_WAIT,MAX_WAIT)
func reset()->void:
 elapsed=0.;wait=randf_range(MIN_WAIT,MAX_WAIT)
func step(delta:float,moving:bool)->int:
 if moving:reset();return 0
 elapsed+=delta
 if elapsed<wait:return 0
 var gesture:float=elapsed-wait
 if gesture>=GESTURE_SECONDS:reset();return 0
 return 1 if gesture>.45 and gesture<2.55 else 0
static func texture(pose:int,traits:Dictionary,horse:Dictionary={})->Texture2D:
 var key:String=str([pose,traits,HorseGalaxyLook.state(horse),SaveData.hat_color])
 if cache.has(key):return cache[key]
 if cache.size()>128:cache.clear()
 var source:Texture2D=HorseDrink.texture(pose,traits if not traits.is_empty() else {"coat":10,"pattern":0,"mane":1,"finish":"original"},SaveData.hat_color,horse)
 # Preserve source pixels, align its 112px canvas to the 96px mounted rig.
 var image:Image=Image.create(112,96,false,Image.FORMAT_RGBA8)
 image.blit_rect(source.get_image(),Rect2i(0,0,112,96),Vector2i.ZERO)
 var texture_=ImageTexture.create_from_image(image)
 cache[key]=texture_;return texture_
static func apply(frames:SpriteFrames,traits:Dictionary,horse:Dictionary={})->void:
 for pose in 2:
  var name_:String="idle" if pose==0 else "rest_gesture107"
  if frames.has_animation(name_):frames.remove_animation(name_)
  frames.add_animation(name_);frames.add_frame(name_,texture(pose,traits,horse));frames.set_animation_loop(name_,true)
