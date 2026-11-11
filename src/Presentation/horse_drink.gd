class_name HorseDrink
extends RefCounted
## Cosmetic only. No stats, energy, timers of gameplay, capture or save mutation.
const BASE="res://art/experimental/drink_preview83/"
static var cache:Dictionary={}
var actor
var visual:Sprite2D
var idle:float=0
var elapsed:float=0
var active:bool=false
var source:HorseWater
func _init(owner_body):actor=owner_body
static func texture(pose:int,traits:Dictionary,hat:String)->Texture2D:
 var key=str(pose)+str(traits)+hat
 if cache.has(key):return cache[key]
 var original:Texture2D=load(BASE+"pose_%d.png"%pose)
 var mask:Image=load(BASE+"color_%d.png"%pose).get_image()
 var uv:Image=load(BASE+"uv_%d.png"%pose).get_image()
 var eyes:Image=load(BASE+"eyes_%d.png"%pose).get_image()
 var image=HorseAppearance.texture(original,"walk_side",pose,traits,mask,uv).get_image().duplicate()
 var raw=original.get_image()
 for y in image.get_height():
  for x in image.get_width():
   if eyes.get_pixel(x,y).r>.5 and traits.has("eyes"):
    var old=image.get_pixel(x,y);var c=HorseAppearance.eye_color_at(HorseCollection.eye_index(traits),Vector2(x/112.0,y/96.0));image.set_pixel(x,y,Color(c.r,c.g,c.b,old.a))
   if mask.get_pixel(x,y).b>.5:
    var old=raw.get_pixel(x,y)
    if HatAppearance.sanitize(hat)=="original":image.set_pixel(x,y,old)
    else:
     var c=Color("415c81") if hat=="blue" else Color("c8b994");var shade=clampf(maxf(old.r,maxf(old.g,old.b))/.65,.25,1.18);image.set_pixel(x,y,Color(c.r*shade,c.g*shade,c.b*shade,old.a))
 var tex=ImageTexture.create_from_image(image);cache[key]=tex;return tex
func stop()->void:
 active=false;idle=0;elapsed=0;source=null
 if is_instance_valid(visual):visual.visible=false
 if actor._sprite_swap!=null and actor._sprite_swap.has_sprite():actor._sprite_swap._sprite.visible=true
func step(delta:float,wish:Vector2)->bool:
 if actor._sprite_swap==null or not actor._sprite_swap.has_sprite():return false
 if wish.length()>.1 or actor.velocity.length()>6 or actor._jump_time>0 or actor._stun_time_remaining>0 or actor.dodge.drawing or actor.dodge.remaining>0 or actor.dodge.coast_remaining>0 or actor.dodge.path.size()>0 or actor.lasso.is_charging() or actor.lasso._touch_aim_active or Input.is_action_pressed("throw_lasso"):
  stop();return false
 var water:HorseWater=null;var facing:int=0
 for item in actor.get_tree().get_nodes_in_group("horse_water"):
  facing=item.facing_from(actor)
  if facing!=0:water=item;break
 if water==null:stop();return false
 idle+=delta
 if idle<.6:return false
 if not active:
  source=water;active=true;elapsed=0
  if visual==null:
   visual=Sprite2D.new();visual.offset=Vector2(-8,-43);actor.add_child(visual)
  var sprite=actor._sprite_swap._sprite
  visual.scale=sprite.scale;visual.position=Vector2(sprite.position.x,sprite.position.y+(44+sprite.offset.y)*sprite.scale.y)
 actor.velocity=Vector2.ZERO;elapsed+=delta
 var horse=SaveData.horse_collection.find(SaveData.horse_collection.selected)
 visual.texture=texture(0 if elapsed<.45 else 1,horse.get("traits",{}),SaveData.hat_color)
 visual.flip_h=facing<0;visual.visible=true;actor._sprite_swap._sprite.visible=false
 return true
