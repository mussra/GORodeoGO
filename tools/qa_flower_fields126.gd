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
## Same seeded organic envelope for world flowers and map. Core stays full.
func boundary127(index:int)->PackedVector2Array:
 var r:Rect2=FIELDS[index];var out=PackedVector2Array()
 var rng=RandomNumberGenerator.new();rng.seed=12700+index
 var corners=[r.position,Vector2(r.end.x,r.position.y),r.end,Vector2(r.position.x,r.end.y)]
 for edge in 4:
  var start:Vector2=corners[edge];var end:Vector2=corners[(edge+1)%4]
  var count:int=20 if edge%2==0 else 10
  var tangent:Vector2=(end-start).normalized();var normal=Vector2(tangent.y,-tangent.x)
  for j in count:
   var t:float=float(j)/count
   # Outward scallops protect full interior chunks; rounded joins avoid box corners.
   var wave:float=70.+rng.randf()*75.+sin(j*1.3+edge)*30.
   var p:Vector2=start.lerp(end,t)+normal*wave
   if j==0:p+=(-tangent+normal).normalized()*35.
   out.append(p)
 # Round the seeded lobes without snapping to chunk borders.
 for pass_ in 2:
  var rounded=PackedVector2Array()
  for j in out.size():
   rounded.append(out[j].lerp(out[(j+1)%out.size()],.25))
   rounded.append(out[j].lerp(out[(j+1)%out.size()],.75))
  out=rounded
 return out
func map_draw():
 var n:Control=map;var origin=Vector2(90,225);var sc:float=.205
 n.draw_rect(Rect2(0,0,1280,720),Color("10252d"));n.draw_rect(Rect2(48,175,1165,355),Color("668956"))
 for i in 2:
  var polygon:PackedVector2Array=boundary127(i);var screen=PackedVector2Array()
  for p in polygon:screen.append(origin+p*sc)
  n.draw_colored_polygon(screen,Color("b37a72") if i==0 else Color("7e7b93"))
  var rng=RandomNumberGenerator.new();rng.seed=126+i
  var r:Rect2=FIELDS[i].grow(160.)
  for j in 115:
   var p=r.position+Vector2(rng.randf()*r.size.x,rng.randf()*r.size.y)
   if Geometry2D.is_point_in_polygon(p,polygon):n.draw_circle(origin+p*sc,.85,Color("ce9c91") if i==0 else Color("a49bb9"))
 n.draw_line(origin+Vector2(-20,1205*sc),origin+Vector2(1125,1205*sc),Color("bb9460"),8.)
 for x in range(6):n.draw_line(origin+Vector2(x*1024*sc,-120*sc),origin+Vector2(x*1024*sc,1170*sc),Color(1,1,1,.12),1.)
 for y in range(2):n.draw_line(origin+Vector2(-130*sc,y*1024*sc),origin+Vector2(5270*sc,y*1024*sc),Color(1,1,1,.12),1.)
func text_(value:String,pos:Vector2,size_:int)->Label:
 var l=Label.new();l.text=value;l.position=pos;l.add_theme_font_size_override("font_size",size_);ui.add_child(l);return l
func shot(path:String):
 await get_tree().process_frame;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png(path)
func field(index:int):
 var r:Rect2=FIELDS[index];var rng=RandomNumberGenerator.new();rng.seed=126+index
 var list:Array=[]
 var polygon:PackedVector2Array=boundary127(index)
 for x in range(int(r.position.x)-174,int(r.end.x)+174,29):
  for y in range(-174,1198,29):
   var p:Vector2=Vector2(x+rng.randf_range(-14,14),y+rng.randf_range(-14,14))
   var height_:float=rng.randf_range(24,32)
   if not Geometry2D.is_point_in_polygon(p,polygon):continue
   list.append({"pos":p,"height":height_,"type":"red1" if index==0 else "violet"})
 var back=RegionalFlowerField123.new();back.flowers=list.filter(func(f):return int(f.pos.y)%58<29);back.z_index=0;add_child(back)
 var front=RegionalFlowerField123.new();front.flowers=list.filter(func(f):return int(f.pos.y)%58>=29);front.z_index=0;add_child(front)
 print("FIELD126 ",index," flowers=",list.size()," bounds=",r)
func run():
 get_tree().root.size=Vector2i(1280,720);SaveData.hat_color="blue"
 draw.connect(ground);queue_redraw()
 y_sort_enabled=true
 for i in 2:
  field(i)
  for j in 6:
   var tree=load("res://src/Presentation/world_decor.gd").new()
   var p:Vector2=FIELDS[i].position+Vector2(170+j*315,220 if j%2==0 else 780)
   tree.configure121("tree" if j%3!=0 else "pine",p,.7,127)
   tree.z_index=3;add_child(tree)
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
 labels.append(text_("Mapa · campos suaves y bordes orgánicos",Vector2(32,50),30))
 labels.append(text_("AMAPOLAS · 2048 × 1024 px",Vector2(90,130),24))
 labels.append(text_("VIOLETAS · 2048 × 1024 px",Vector2(700,130),24))
 labels.append(text_("Interior lleno: 2 chunks · borde irregular compartido con el campo real",Vector2(70,585),23))
 labels.append(text_("Mapa solo de preview: muestra ambos campos ya descubiertos",Vector2(70,625),22))
 # map layer then labels need above map canvas order
 for label in labels:label.z_index=21
 footer.z_index=21
 await shot("/downloads/campos127-mapa.png")
 map.visible=false
 for label in labels:label.visible=false
 var frames:bool=OS.get_environment("FLOWER127_CLIP")=="1"
 var count:int=0
 for kind in 2:
  title.text="Galopando entre amapolas" if kind==0 else "Galopando entre violetas"
  for frame in 80:
   horse.position=Vector2(FIELDS[kind].position.x+350+frame*15,520)
   camera.position=horse.position+Vector2(150,-70);camera.reset_smoothing()
   horse.frame=int(frame*9.*1.55/20.)%9
   horse.rotation=sin(frame*.8)*.01
   if frame in [20,60]:await shot("/downloads/campos127-%s-%d.png"%["amapolas" if kind==0 else "violetas",frame])
   if frames:await shot("/downloads/flower127-frames/frame_%04d.png"%count)
   count+=1
 title.text="Borde orgánico · densidad interior conservada"
 horse.position=Vector2(1600,80);camera.position=Vector2(1550,-20);camera.reset_smoothing()
 await shot("/downloads/campos127-borde.png")
 get_tree().quit()
