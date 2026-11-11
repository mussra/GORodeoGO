extends Control
## Design storyboard only. No save writes, gallery calls, share sheet or network.
var canvas:Control
var stage:int=0
var automatic:bool=false
func _ready():
 canvas=Control.new();add_child(canvas);build()
 if automatic:run.call_deferred()
func label(text:String,pos:Vector2,width:float,font:int=22):
 var node=Label.new();node.text=text;node.position=pos;node.size=Vector2(width,100);node.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;node.add_theme_font_size_override("font_size",font);canvas.add_child(node);return node
func button(text:String,pos:Vector2,size:Vector2,action:Callable):
 var b=Button.new();b.text=text;b.position=pos;b.size=size;canvas.add_child(b);b.pressed.connect(action);return b
func build():
 for child in canvas.get_children():canvas.remove_child(child);child.queue_free()
 var background=ColorRect.new();background.color=Color("10252d");background.size=Vector2(1280,720);canvas.add_child(background)
 label("MIS LUGARES",Vector2(30,18),900,32)
 label("DEMO DE DISEÑO · No guarda marcas ni fotos · No abre galería ni comparte",Vector2(30,65),1220,18).modulate=Color("e8bb67")
 var board=Panel.new();board.position=Vector2(30,112);board.size=Vector2(760,480);board.add_theme_stylebox_override("panel",RanchTheme.box(Color("3b7044"),Color("87aa85"),12));canvas.add_child(board)
 var painter=load("res://src/Presentation/world_draw_node.gd").new();painter.draw_fn=paint_map;canvas.add_child(painter)
 label("Mapa de ejemplo · toca un lugar para marcarlo",Vector2(48,126),700,18)
 var panel=Panel.new();panel.position=Vector2(815,112);panel.size=Vector2(435,480);panel.add_theme_stylebox_override("panel",RanchTheme.box(Color("183740"),Color("587f85"),12));canvas.add_child(panel)
 if stage==0:
  label("Nueva marca",Vector2(838,130),385,27)
  label("Elige un icono",Vector2(838,180),385,20)
  for i in 4:button(["Lugar","Casa","Flor","Animal"][i],Vector2(838+i%2*195,220+i/2*58),Vector2(180,48),func():stage=1;build())
  label("Nota corta (opcional)",Vector2(838,347),385,20)
  var edit=LineEdit.new();edit.text="Flores junto al arroyo";edit.max_length=60;edit.position=Vector2(838,384);edit.size=Vector2(385,48);canvas.add_child(edit)
  button("Guardar marca · demo",Vector2(838,455),Vector2(385,54),func():stage=1;build())
 elif stage==1:
  label("Flores junto al arroyo",Vector2(838,130),385,27)
  label("Icono: Flor · aquí queda mi nota",Vector2(838,180),385,18)
  button("Añadir captura del juego",Vector2(838,250),Vector2(385,60),func():stage=2;build())
  label("Opcional. Copia privada del juego. No se envía a la galería automáticamente.",Vector2(838,342),385,22)
  button("Borrar marca · demo",Vector2(838,490),Vector2(385,48),func():stage=0;build())
 else:
  label("Flores junto al arroyo",Vector2(838,130),385,27)
  label("Icono: Flor · aquí queda mi nota",Vector2(838,180),385,18)
  var photo=TextureRect.new();photo.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;photo.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;photo.position=Vector2(838,220);photo.size=Vector2(385,190);photo.texture=load("res://tools/preview_assets/map-note-example.jpg");canvas.add_child(photo)
  label("Copia privada · exportar es opcional",Vector2(838,415),385,18)
  button("Guardar en galería",Vector2(838,454),Vector2(385,48),func():stage=3;build())
  button("Compartir...",Vector2(838,511),Vector2(385,48),func():stage=3;build())
 if stage==3:
  label("Galería y compartir: solo al pulsar dentro del juego. Nunca automáticamente.\nLa marca usa su copia privada: borrar la galería no la afecta.\nSi falta/corrompe la foto: imagen neutra, sin bloquear nota ni guardado.",Vector2(30,610),1220,23).modulate=Color("e8bb67")
 else:
  label("Las marcas se verían en el mapa y el minimapa.\nPropuesta: nota hasta 60 letras + 1 miniatura por marca, guardado por mundo.",Vector2(30,610),1220,23)
func paint_map(n:Node2D):
 for row in 4:
  for col in 6:
   var box=Rect2(48+col*120,165+row*101,119,100)
   n.draw_rect(box,Color("426f48") if (row+col)%2 else Color("477a50"))
 var points=PackedVector2Array([Vector2(60,420),Vector2(185,360),Vector2(350,400),Vector2(500,340),Vector2(756,280)])
 n.draw_polyline(points,Color("c59f65"),15,true)
 n.draw_polyline(PackedVector2Array([Vector2(290,190),Vector2(330,290),Vector2(350,400),Vector2(390,560)]),Color("c59f65"),13,true)
 n.draw_polyline(PackedVector2Array([Vector2(70,230),Vector2(220,260),Vector2(420,210),Vector2(580,245),Vector2(750,200)]),Color("62bed2"),22,true)
 for p in [Vector2(170,250),Vector2(560,350)]:
  n.draw_circle(p,18,Color("ffd56b"));n.draw_circle(p,6,Color("6f482c"))
 if stage>0:
  var p=Vector2(560,350)
  for i in 5:n.draw_circle(p+Vector2(cos(i*TAU/5),sin(i*TAU/5))*7,5,Color("ec82c1"))
  n.draw_circle(p,4,Color("fff1a4"))
 n.draw_circle(Vector2(350,400),10,Color("fff4cd"));n.draw_circle(Vector2(350,400),4,Color("a94635"))
func run():
 for index in 4:
  stage=index;build();await get_tree().create_timer(.3).timeout;await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png("/downloads/map-notes-%d.png"%index)
  await get_tree().create_timer(2).timeout
 get_tree().quit()
