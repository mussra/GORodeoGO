class_name LoadingParade
extends Node2D
## Shared loading-only visuals. Local cosmetic RNG, no world seed or save writes.
const GRASS170=preload("res://art/world/modular87/grass-1.png")
var age:float=0.0
var rng=RandomNumberGenerator.new()
var rider:AnimatedSprite2D
var actors:Array=[]
var frontier_people267:Array[Sprite2D]=[]
const DISTANT_FLOOR267:float=418.
const DISTANT_HEIGHT267:float=46.
const FRONTIER_PEOPLE267:Array=[
 ["Granjero","res://art/npc/farmer.png"],
 ["Florista","res://art/npc/florist.png"],
 ["Loco","res://art/npc/loco-normal140.png"],
 ["Juanito","res://art/breeding256/juanito.png"],
 ["Alma","res://art/breeding256/alma.png"],
 ["Músico","res://art/npc/ganjo_musician205.png"]]
var cycle:float=10.8
var ready_age:float=-1.0
var prepared:bool=false
signal preparation_finished
const RUN_SPEED:float=230.0
const FADE:float=.5
const MOUNT_SCALE228:float=WorldActorScale.HORSE*1.5
const FLOOR228:float=490.
func actor(kind:String,sizing:float)->AnimatedSprite2D:
 var frames=SpriteFrames.new();frames.add_animation("side");frames.set_animation_speed("side",9)
 var traits={"coat":rng.randi_range(0,19),"pattern":rng.randi_range(0,11),"mane":rng.randi_range(0,4),"eyes":0,"finish":"normal"}
 var record:Dictionary={}
 if kind=="rider":
  record=SaveData.horse_collection.find(SaveData.horse_collection.selected).duplicate(true)
  if not record.is_empty():traits=record.traits.duplicate(true)
 var start=Time.get_ticks_usec()
 for i in 9:
  var texture:Texture2D
  if kind in ["rider","horse"]:texture=PixelLabTrial.pose_texture(kind,"side",i,traits,record)
  else:texture=load("res://art/experimental/pixellab/%s/side/frame_%02d.png"%[kind,i])
  frames.add_frame("side",texture)
  if Time.get_ticks_usec()-start>8000:
   await get_tree().process_frame;start=Time.get_ticks_usec()
 var sprite=AnimatedSprite2D.new();sprite.sprite_frames=frames;sprite.scale=Vector2.ONE*sizing
 sprite.set_meta("traits228",traits.duplicate(true))
 sprite.play("side");sprite.speed_scale=.52 if kind=="rider" else 1.0;sprite.visible=false
 if kind in ["pig","goat","horse","rider"]:
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
  sprite.offset.y=frames.get_frame_texture("side",0).get_height()*.5-reference
  sprite.frame_changed.connect(func():sprite.offset.y=frames.get_frame_texture("side",sprite.frame).get_height()*.5-float(feet[sprite.frame]))
 sprite.z_index=2;add_child(sprite);return sprite
func _ready():
 prepare.call_deferred()
func prepare():
 rng.randomize()
 rider=await actor("rider",MOUNT_SCALE228)
 var lineup=[["pig",.68],["goat",.74],["horse",MOUNT_SCALE228]]
 for i in range(lineup.size()-1,0,-1):
  var j=rng.randi_range(0,i);var tmp=lineup[i];lineup[i]=lineup[j];lineup[j]=tmp
 var delay=0.0
 for data in lineup:
  var figure:AnimatedSprite2D=await actor(data[0],data[1]);figure.flip_h=true
  actors.append({"sprite":figure,"delay":delay,"kind":data[0]});delay+=rng.randf_range(2.4,3.1)
 for entry in FRONTIER_PEOPLE267:
  var figure:=Sprite2D.new();figure.texture=load(entry[1]);figure.name="Distant"+str(frontier_people267.size());figure.set_meta("frontier_role267",entry[0]);figure.z_index=1
  NpcScale214.apply(figure,figure.texture,DISTANT_HEIGHT267);add_child(figure);frontier_people267.append(figure)
 cycle=delay
 prepared=true;age=0.0;preparation_finished.emit()
func finish():
 if ready_age<0:ready_age=age
static func drift_x(t:float)->float:
 return 920.0-620.0*exp(-t/8.4)
func _draw():
 draw_rect(Rect2(0,0,1280,720),Color("9ddcff"))
 # White clouds are vector shapes, not replacement character/source art.
 for i in 5:
  var x:float=fposmod(i*295.+140.-age*7.,1530.)-125.;var y:float=90.+(i%3)*65.
  draw_circle(Vector2(x,y),31.,Color.WHITE);draw_circle(Vector2(x+34,y-17),41.,Color.WHITE);draw_circle(Vector2(x+73,y),30.,Color.WHITE)
  draw_rect(Rect2(x,y-4,74,31),Color.WHITE)
 draw_rect(Rect2(0,394,1280,326),Color("6d9e3d"))
 for x in range(-1,11):
  for y in range(4):
   var offset:float=fposmod(age*40.,128.)
   draw_texture_rect(GRASS170,Rect2(x*128.-offset,394.+y*128.,128.,128.),false)
 draw_line(Vector2(0,394),Vector2(1280,394),Color("96bb58"),3)
func _process(delta:float):
 if not prepared:return
 rider.visible=true
 age+=delta
 var t=fposmod(age,cycle)
 for i in frontier_people267.size():
  var figure:Sprite2D=frontier_people267[i]
  figure.position=Vector2(fposmod(180.+i*216.-age*14.,1420.)-70.,DISTANT_FLOOR267+float(i%2)*3.)
  figure.rotation=sin(age*.9+float(i))*.008
 rider.position=Vector2(drift_x(age if ready_age<0 else ready_age),FLOOR228)
 for a in actors:
  var local=fposmod(t-a.delay,cycle)
  a.sprite.visible=local<7.8
  if not a.sprite.visible:continue
  a.sprite.position=Vector2(lerpf(1420,-140,local/7.8),FLOOR228)
 if ready_age>=0:
  var exit_time=age-ready_age
  rider.speed_scale=1.05
  rider.position.x=drift_x(ready_age)+RUN_SPEED*exit_time
 queue_redraw()
