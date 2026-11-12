extends Node2D
const GRASS=preload("res://art/world/derived88/grass-cache91.png")
const FLOWERS=[preload("res://art/world/cartoon/f_red1.png"),preload("res://art/world/cartoon/f_violet.png")]
const FIELDS=[Rect2(0,0,2048,1024),Rect2(3072,0,2048,1024)]
var camera:Camera2D
var horse:AnimatedSprite2D
var ui:CanvasLayer
var title:Label
var map:Control
func _ready():run.call_deferred()
func ground():
 for x in range(-1,7):
  for y in range(-1,3):draw_texture_rect(GRASS,Rect2(x*1024,y*1024,1024,1024),false)
 draw_line(Vector2(-1024,1140),Vector2(6000,1140),Color("bb9460"),75.)
func map_draw():
 var n:Control=map;var origin=Vector2(70,200);var sc:float=.215
 n.draw_rect(Rect2(0,0,1280,720),Color("10252d"));n.draw_rect(Rect2(origin-Vector2(20,20),Vector2(1160,350)),Color("4f844b"))
 for i in 2:
  var r:Rect2=FIELDS[i];n.draw_rect(Rect2(origin+r.position*sc,r.size*sc),Color("d53832") if i==0 else Color("864dc2"))
  var rng=RandomNumberGenerator.new();rng.seed=126+i
  for j in 250:
   var p=origin+(r.position+Vector2(rng.randf()*r.size.x,rng.randf()*r.size.y))*sc
   n.draw_circle(p,1.5,Color("f3704f") if i==0 else Color("b585e0"))
 n.draw_line(origin+Vector2(-20,1140*sc),origin+Vector2(1125,1140*sc),Color("bb9460"),10.)
 for x in range(6):
  n.draw_line(origin+Vector2(x*1024*sc,0),origin+Vector2(x*1024*sc,1024*sc),Color(1,1,1,.28),1.)
 for y in range(2):n.draw_line(origin+Vector2(0,y*1024*sc),origin+Vector2(5120*sc,y*1024*sc),Color(1,1,1,.28),1.)
func text_(value:String,pos:Vector2,size_:int)->Label:
 var l=Label.new();l.text=value;l.position=pos;l.add_theme_font_size_override("font_size",size_);ui.add_child(l);return l
func shot(path:String):
 await get_tree().process_frame;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png(path)
func field(index:int):
 var r:Rect2=FIELDS[index];var rng=RandomNumberGenerator.new();rng.seed=126+index
 var list:Array=[]
 for x in range(int(r.position.x),int(r.end.x),29):
  for y in range(0,1024,29):
   list.append({"pos":Vector2(x+rng.randf_range(-9,9),y+rng.randf_range(-9,9)),"height":rng.randf_range(24,32),"type":"red1" if index==0 else "violet"})
 var back=RegionalFlowerField123.new();back.flowers=list.filter(func(f):return int(f.pos.y)%58<29);back.z_index=0;add_child(back)
 var front=RegionalFlowerField123.new();front.flowers=list.filter(func(f):return int(f.pos.y)%58>=29);front.z_index=0;add_child(front)
 print("FIELD126 ",index," flowers=",list.size()," bounds=",r)
func run():
 get_tree().root.size=Vector2i(1280,720);SaveData.hat_color="blue"
 draw.connect(ground);queue_redraw()
 for i in 2:field(i)
 horse=AnimatedSprite2D.new();horse.sprite_frames=SpriteFrames.new()
 var traits={"coat":12,"pattern":3,"mane":1,"eyes":0,"finish":"normal"}
 PixelLabTrial.apply(horse.sprite_frames,"rider","walk",traits);horse.centered=false;horse.offset=Vector2(-48,-80);horse.scale=Vector2.ONE*1.35;horse.z_index=3;horse.play("walk_side");horse.speed_scale=1.55;add_child(horse)
 camera=Camera2D.new();add_child(camera);camera.make_current()
 ui=CanvasLayer.new();ui.layer=10;add_child(ui)
 var bar=ColorRect.new();bar.color=Color("10252de6");bar.size=Vector2(1280,70);ui.add_child(bar)
 title=text_("Campos extensos · preview aislada",Vector2(24,14),30)
 var footer_bg=ColorRect.new();footer_bg.color=Color("10252de6");footer_bg.position=Vector2(0,666);footer_bg.size=Vector2(1280,54);ui.add_child(footer_bg)
 var footer=text_("Sin partidas · arte existente · 2 chunks por campo · no es APK ni rendimiento Android",Vector2(24,678),20)
 map=Control.new();map.z_index=20;map.draw.connect(map_draw);ui.add_child(map);map.queue_redraw()
 var labels:Array=[]
 labels.append(text_("Mapa de muestra · campos continuos por especie",Vector2(32,50),30))
 labels.append(text_("AMAPOLAS · 2048 × 1024 px",Vector2(90,130),24))
 labels.append(text_("VIOLETAS · 2048 × 1024 px",Vector2(700,130),24))
 labels.append(text_("Cada recuadro: 1024 × 1024 px · dos recuadros contiguos del mismo color",Vector2(70,585),23))
 labels.append(text_("Mapa solo de preview: muestra ambos campos ya descubiertos",Vector2(70,625),22))
 # map layer then labels need above map canvas order
 for label in labels:label.z_index=21
 footer.z_index=21
 await shot("/downloads/campos126-mapa.png")
 map.visible=false
 for label in labels:label.visible=false
 var frames:bool=OS.get_environment("FLOWER126_CLIP")=="1"
 var count:int=0
 for kind in 2:
  title.text="Galopando entre amapolas" if kind==0 else "Galopando entre violetas"
  for frame in 80:
   horse.position=Vector2(FIELDS[kind].position.x+350+frame*15,520)
   camera.position=horse.position+Vector2(150,-70);camera.reset_smoothing()
   horse.frame=int(frame*9.*1.55/20.)%9
   horse.rotation=sin(frame*.8)*.01
   if frame in [20,60]:await shot("/downloads/campos126-%s-%d.png"%["amapolas" if kind==0 else "violetas",frame])
   if frames:await shot("/downloads/flower126-frames/frame_%04d.png"%count)
   count+=1
 await get_tree().process_frame
 get_tree().quit()
