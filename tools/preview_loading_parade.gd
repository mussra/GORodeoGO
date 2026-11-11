extends Node2D
## Isolated visual proposal, no world loading or save writes.
var age:float=0.0
var rng=RandomNumberGenerator.new()
var rider:AnimatedSprite2D
var actors:Array=[]
var cycle:float=10.8
var world:Sprite2D
const READY_AT:float=18.0
const RUN_SPEED:float=230.0
const FADE:float=.5
func actor(kind:String,sizing:float)->AnimatedSprite2D:
 var frames=SpriteFrames.new()
 if kind in ["rider","horse"]:
  PixelLabTrial.apply(frames,kind,"walk_side",{"coat":rng.randi_range(0,19),"pattern":rng.randi_range(0,11),"mane":rng.randi_range(0,4),"eyes":0,"finish":"normal"})
 else:PixelLabTrial.apply_animal(frames,kind)
 var sprite=AnimatedSprite2D.new();sprite.sprite_frames=frames;sprite.scale=Vector2.ONE*sizing
 sprite.play("walk_side" if kind=="rider" else ("walk" if kind=="horse" else "run"));sprite.speed_scale=.52
 add_child(sprite);return sprite
func _ready():
 get_tree().root.size=Vector2i(1280,720)
 rng.randomize()
 if not OS.get_environment("PARADE_SEED").is_empty():rng.seed=int(OS.get_environment("PARADE_SEED"))
 rider=actor("rider",1.55)
 var lineup=[["pig",.68],["goat",.74],["farmer",1.0],["horse",1.4]]
 for i in range(3,0,-1):
  var j=rng.randi_range(0,i);var tmp=lineup[i];lineup[i]=lineup[j];lineup[j]=tmp
 var delay=0.0
 for data in lineup:
  var figure:Node2D
  if data[0]=="farmer":
   figure=Sprite2D.new();figure.texture=load("res://art/npc/farmer.png");figure.scale=Vector2.ONE*(154.0/1536.0);add_child(figure)
  else:
   figure=actor(data[0],data[1]);figure.flip_h=true
  actors.append({"sprite":figure,"delay":delay,"kind":data[0]});delay+=rng.randf_range(2.4,3.1)
 cycle=delay
 world=Sprite2D.new();world.texture=ImageTexture.create_from_image(Image.load_from_file("res://tools/preview_assets/loading-exit-world.jpg"));world.centered=false;world.modulate.a=0;add_child(world)
func drift_x(t:float)->float:
 return 920.0-620.0*exp(-t/8.4)
func _draw():
 draw_rect(Rect2(0,0,1280,720),Color("10252d"))
 draw_rect(Rect2(0,394,1280,326),Color("142c33"))
 draw_line(Vector2(0,394),Vector2(1280,394),Color("385052"),2)
 for i in 24:
  var x=fposmod(i*61.0-age*235.0,1280.0)
  draw_line(Vector2(x,512+i%3*23),Vector2(x+13,512+i%3*23),Color("294146"),2)
func _process(delta:float):
 age+=delta
 var t=fposmod(age,cycle)
 rider.position=Vector2(drift_x(minf(age,READY_AT)),345)
 for a in actors:
  var local=fposmod(t-a.delay,cycle)
  a.sprite.visible=local<5.0
  if not a.sprite.visible:continue
  a.sprite.position=Vector2(lerpf(1420,-140,local/5.0),465 if a.kind=="horse" else 462)
  if a.kind=="farmer":
   a.sprite.position.y=433+sin(local*8.0)*2.0;a.sprite.rotation=sin(local*4.0)*.018
 if age>=READY_AT:
  var exit_time=age-READY_AT
  rider.speed_scale=1.05
  rider.position.x=drift_x(READY_AT)+RUN_SPEED*exit_time
  world.modulate.a=clampf(exit_time/FADE,0,1)
 queue_redraw()
 if age>READY_AT+1.5:get_tree().quit()
