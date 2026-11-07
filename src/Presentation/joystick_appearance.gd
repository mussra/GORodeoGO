class_name JoystickAppearance
extends RefCounted
const PALETTE=["ec606c","efb85d","e8d874","77c888","6aa9da","9980c8","ec606c"]
static var cache:Dictionary={}
static func color_at(t:float,mane:int)->Color:
 if mane!=5:return Color(HorseAppearance.MANES[mane])
 var u:=clampf(t,0,.999)*6
 return Color(PALETTE[int(u)]).lerp(Color(PALETTE[mini(int(u)+1,6)]),smoothstep(0,1,u-floorf(u)))
static func texture_for(traits:Dictionary,knob:bool)->Texture2D:
 var n:=220;var im:=Image.create(n,n,false,Image.FORMAT_RGBA8)
 for y in n:
  for x in n:
   var p:=Vector2(x+.5,y+.5)/n;var r:=p.distance_to(Vector2(.5,.5))*2
   if r>1:continue
   var border:=smoothstep(.83,.87,r)*(1-smoothstep(.97,1,r))
   var eye:=HorseAppearance.eye_color_at(HorseCollection.eye_index(traits),p)
   var angle:=atan2(p.y-.5,p.x-.5)
   var fibers:=sin(angle*71+r*13)*.045+sin(angle*113-r*9)*.025
   var shade:=.87+.13*sin(r*PI)+fibers
   var coat:=Color(eye.r*shade,eye.g*shade,eye.b*shade,.28 if not knob else .40)
   var hair:=color_at(p.y,traits.mane);hair.a=.94
   var c:=coat.lerp(hair,border);c.a*=1-smoothstep(.985,1,r);im.set_pixel(x,y,c)
 return ImageTexture.create_from_image(im)
static func apply(level:Node)->void:
 var save:Node=level.get_node("/root/SaveData")
 var h:Dictionary=save.horse_collection.find(save.horse_collection.selected)
 var traits:Dictionary=h.get("traits",{"coat":10,"pattern":0,"mane":1})
 var key:String=str(traits)
 if not cache.has(key):cache[key]=[texture_for(traits,false),texture_for(traits,true)]
 for v in [level.get_node("TouchControls/MoveJoystick"),level.aim_joystick]:
  # Native Godot 4.7 VirtualJoystick has no joystick_texture/tip_texture props; assigning
  # them errors (visuals already default). Keep the no-op tint overrides as before.
  for theme_key in ["ring_normal_color","tip_normal_color","ring_pressed_color","tip_pressed_color"]:v.add_theme_color_override(theme_key,Color.WHITE)
