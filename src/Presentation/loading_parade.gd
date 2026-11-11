class_name LoadingParade
extends Node2D
## Shared loading-only visuals. Local cosmetic RNG, no world seed or save writes.
var age:float=0.0
var rng=RandomNumberGenerator.new()
var rider:AnimatedSprite2D
var actors:Array=[]
var cycle:float=10.8
var ready_age:float=-1.0
var prepared:bool=false
signal preparation_finished
const RUN_SPEED:float=230.0
const FADE:float=.5
func actor(kind:String,sizing:float)->AnimatedSprite2D:
 var frames=SpriteFrames.new();frames.add_animation("side");frames.set_animation_speed("side",9)
 var traits={"coat":rng.randi_range(0,19),"pattern":rng.randi_range(0,11),"mane":rng.randi_range(0,4),"eyes":0,"finish":"normal"}
 var start=Time.get_ticks_usec()
 for i in 9:
  var texture:Texture2D
  if kind in ["rider","horse"]:texture=PixelLabTrial.pose_texture(kind,"side",i,traits)
  else:texture=load("res://art/experimental/pixellab/%s/side/frame_%02d.png"%[kind,i])
  frames.add_frame("side",texture)
  if Time.get_ticks_usec()-start>8000:
   await get_tree().process_frame;start=Time.get_ticks_usec()
 var sprite=AnimatedSprite2D.new();sprite.sprite_frames=frames;sprite.scale=Vector2.ONE*sizing
 sprite.play("side");sprite.speed_scale=.52 if kind=="rider" else 1.0;sprite.visible=false
 if kind in ["pig","goat","horse"]:
  var feet:Array=[]
  for i in 9:
   var image=frames.get_frame_texture("side",i).get_image()
   if image.is_compressed():image.decompress()
   var bottom:int=0
   for y in image.get_height():
    for x in image.get_width():
     if image.get_pixel(x,y).a>.15:bottom=maxi(bottom,y)
   feet.append(bottom)
  var reference:float=feet[0]
  sprite.frame_changed.connect(func():sprite.offset.y=reference-float(feet[sprite.frame]))
 add_child(sprite);return sprite
func _ready():
 prepare.call_deferred()
func prepare():
 rng.randomize()
 rider=await actor("rider",1.55)
 var lineup=[["pig",.68],["goat",.74],["farmer",1.0],["horse",1.4]]
 for i in range(3,0,-1):
  var j=rng.randi_range(0,i);var tmp=lineup[i];lineup[i]=lineup[j];lineup[j]=tmp
 var delay=0.0
 for data in lineup:
  var figure:Node2D
  if data[0]=="farmer":
   figure=Sprite2D.new();figure.visible=false;figure.texture=load("res://art/npc/farmer.png");figure.scale=Vector2.ONE*(154.0/1536.0);add_child(figure)
  else:
   figure=await actor(data[0],data[1]);figure.flip_h=true
  actors.append({"sprite":figure,"delay":delay,"kind":data[0]});delay+=rng.randf_range(2.4,3.1)
 cycle=delay
 prepared=true;age=0.0;preparation_finished.emit()
func finish():
 if ready_age<0:ready_age=age
static func drift_x(t:float)->float:
 return 920.0-620.0*exp(-t/8.4)
func _draw():
 draw_rect(Rect2(0,0,1280,720),Color("10252d"))
 draw_rect(Rect2(0,394,1280,326),Color("142c33"))
 draw_line(Vector2(0,394),Vector2(1280,394),Color("385052"),2)
 for i in 24:
  var x=fposmod(i*61.0-age*160.0,1280.0)
  draw_line(Vector2(x,512+i%3*23),Vector2(x+13,512+i%3*23),Color("294146"),2)
func _process(delta:float):
 if not prepared:return
 rider.visible=true
 age+=delta
 var t=fposmod(age,cycle)
 rider.position=Vector2(drift_x(age if ready_age<0 else ready_age),345)
 for a in actors:
  var local=fposmod(t-a.delay,cycle)
  a.sprite.visible=local<7.8
  if not a.sprite.visible:continue
  a.sprite.position=Vector2(lerpf(1420,-140,local/7.8),465 if a.kind=="horse" else 462)
  if a.kind=="farmer":
   a.sprite.position.y=433+sin(local*8.0)*2.0;a.sprite.rotation=sin(local*4.0)*.018
 if ready_age>=0:
  var exit_time=age-ready_age
  rider.speed_scale=1.05
  rider.position.x=drift_x(ready_age)+RUN_SPEED*exit_time
 queue_redraw()
