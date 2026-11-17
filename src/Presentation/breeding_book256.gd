class_name BreedingBook256
extends CanvasLayer
signal closed
var page:int=-1
var tutorial:bool=false
var shell:Control
var content:Control
var canvas:Control
const INK=Color("493327")
const GOLD=Color("d7b56f")
const PAPER=Color("f7e8bf")
func _ready():
 layer=125;process_mode=Node.PROCESS_MODE_ALWAYS
 shell=Control.new();shell.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(shell);MenuInputGuard.install(shell)
 var shade:=ColorRect.new();shade.color=Color("051c24ee");shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);shell.add_child(shade)
 canvas=Control.new();canvas.size=Vector2(1280,720);shell.add_child(canvas)
 get_viewport().size_changed.connect(_fit);_fit();show_page(page)
func _fit():
 var extent:=get_viewport().get_visible_rect().size;var k:float=minf(extent.x/1280.,extent.y/720.)
 canvas.scale=Vector2.ONE*k;canvas.position=(extent-Vector2(1280,720)*k)*.5
func panel(at:Vector2,extent:Vector2,color:Color,border:Color,radius:int=16)->Panel:
 var p:=Panel.new();p.position=at;p.size=extent;p.add_theme_stylebox_override("panel",RanchTheme.box(color,border,radius));content.add_child(p);return p
func label_(text_:String,at:Vector2,extent:Vector2,font:int=24,color:Color=INK)->Label:
 var l:=Label.new();l.text=text_;l.position=at;l.size=extent;l.add_theme_color_override("font_color",color);l.add_theme_font_size_override("font_size",font);l.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;content.add_child(l)
 l.clip_text=true;l.text_overrun_behavior=TextServer.OVERRUN_NO_TRIMMING;l.autowrap_mode=TextServer.AUTOWRAP_OFF
 var wrapped:String="";var line_:String="";var face:Font=l.get_theme_font("font")
 for paragraph in text_.split("\n"):
  line_=""
  for word in paragraph.split(" "):
   if not line_.is_empty() and face.get_string_size(line_+" "+word,HORIZONTAL_ALIGNMENT_LEFT,-1,font).x>extent.x:
    wrapped+=line_+"\n";line_=word
   else:line_+=(" " if not line_.is_empty() else "")+word
  wrapped+=line_+"\n"
 l.text=wrapped.trim_suffix("\n");l.size=extent;return l
func button_(text_:String,at:Vector2,extent:Vector2,action:Callable)->Button:
 var b:=Button.new();b.text=text_;b.position=at;b.size=extent;b.add_theme_font_size_override("font_size",22);QuestButtonStyle.apply(b);content.add_child(b);b.pressed.connect(action);return b
func image_(path_:String,at:Vector2,extent:Vector2):
 var image:=TextureRect.new();image.texture=load(path_);image.position=at;image.size=extent;image.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;image.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;image.mouse_filter=Control.MOUSE_FILTER_IGNORE;content.add_child(image);image.size=extent
func show_page(index:int):
 page=clampi(index,-1,5)
 if is_instance_valid(content):canvas.remove_child(content);content.queue_free()
 content=Control.new();canvas.add_child(content)
 panel(Vector2(58,42),Vector2(1164,624),Color("704738"),GOLD,24)
 panel(Vector2(76,57),Vector2(557,588),PAPER,Color("caa367"),10)
 panel(Vector2(645,57),Vector2(557,588),Color("f1ddb0"),Color("caa367"),10)
 panel(Vector2(630,59),Vector2(18,584),Color("ae8051"),Color("ae8051"),3)
 button_("Cerrar" if not tutorial else "Ahora no",Vector2(1050,10),Vector2(160,44),finish)
 label_("RANCHO  /  CUADERNO DE ALMA",Vector2(102,81),Vector2(500,32),18,Color("8c633f"))
 label_("Índice",Vector2(102,121),Vector2(470,50),38)
 image_("res://art/breeding256/alma.png",Vector2(503,70),Vector2(94,104))
 var read:=BreedingAdvice256.state()
 for i in 6:
  var b:=button_(("✓  " if read.has(BreedingAdvice256.IDS[i]) else "○  ")+BreedingAdvice256.TITLES[i],Vector2(100,187+i*61),Vector2(498,53),show_page.bind(i))
  b.name="Chapter256_"+str(i)
  b.icon=load("res://art/breeding256/chapter%d.png"%i);b.expand_icon=true;b.add_theme_constant_override("icon_max_width",40)
 label_("Consejos guardados al descubrirlos.\nPuedes volver aquí cuando quieras.",Vector2(104,562),Vector2(480,65),20,Color("8c633f"))
 if page<0:
  label_("El libro\nde tu cuadra",Vector2(693,99),Vector2(458,122),48)
  image_("res://art/breeding256/book-cover.png",Vector2(740,242),Vector2(300,210))
  label_("Criar · Mejorar · Llegar a maestro",Vector2(693,469),Vector2(465,42),24)
  button_("Aprender con Alma",Vector2(690,551),Vector2(460,60),start_tutorial)
 else:
  if not BreedingAdvice256.mark(BreedingAdvice256.IDS[page]):label_("No se pudo recordar la lectura",Vector2(690,620),Vector2(460,24),17)
  label_("ALMA  /  "+("PASO %d DE 6"%(page+1) if tutorial else "CONSEJO %d"%(page+1)),Vector2(690,83),Vector2(450,30),18,Color("8c633f"))
  label_(BreedingAdvice256.TITLES[page],Vector2(690,122),Vector2(465,70),32)
  if page in [0,3,5]:image_("res://art/breeding256/book-open.png",Vector2(789,200),Vector2(260,138))
  else:
   var glyph:=BookGlyph256.new();glyph.position=Vector2(700,211);glyph.size=Vector2(460,126);glyph.kind=page;content.add_child(glyph)
  for i in 3:label_(BreedingAdvice256.TIPS[page][i],Vector2(690,359+i*58),Vector2(461,56),21)
  button_("Anterior",Vector2(688,557),Vector2(188,58),show_page.bind(page-1))
  button_("Siguiente" if page<5 else "Volver a portada",Vector2(889,557),Vector2(270,58),show_page.bind(page+1 if page<5 else -1))
func start_tutorial():tutorial=true;show_page(0)
func finish():closed.emit();queue_free()
func _unhandled_input(event:InputEvent):
 if event.is_action_pressed("ui_cancel"):finish();get_viewport().set_input_as_handled()
class BookGlyph256 extends Control:
 var kind:int=0
 func _draw():
  var gold:=Color("bf8d37");var teal:=Color("2b897b");var ink:=Color("75543a");var cream:=Color("fff6da")
  if kind==6:
   draw_style_box(RanchTheme.box(Color("2d7065"),gold,18),Rect2(55,0,200,180));draw_line(Vector2(78,14),Vector2(78,165),gold,5.)
   horse(Vector2(145,89),gold,1.1);draw_circle(Vector2(155,34),8,cream);return
  if kind==1:
   for i in 3:
    var height:float=[50.,100.,75.][i];draw_rect(Rect2(75+i*145,115-height,70,height),teal if i==2 else gold)
   draw_line(Vector2(160,55),Vector2(337,55),ink,3.);draw_line(Vector2(327,45),Vector2(337,55),ink,3.)
  elif kind==2:
   draw_style_box(RanchTheme.box(cream,ink,10),Rect2(30,36,395,42));draw_rect(Rect2(35,41,385,32),teal);draw_line(Vector2(423,15),Vector2(423,100),gold,7.)
  elif kind==3:
   for i in 5:
    var at:=Vector2(50+i*85,70);var pts:=PackedVector2Array()
    for j in 10:pts.append(at+Vector2(cos(-PI*.5+j*PI/5),sin(-PI*.5+j*PI/5))*(28. if j%2==0 else 12.))
    draw_colored_polygon(pts,gold if i<4 else teal)
  elif kind==5:
   draw_colored_polygon(PackedVector2Array([Vector2(180,10),Vector2(280,10),Vector2(280,78),Vector2(230,120),Vector2(180,78)]),teal);horse(Vector2(224,62),cream,.6)
  else:
   for i in 3:horse(Vector2(65+i*150,72),[gold,teal,ink][i],.7 if kind==0 and i==2 else 1.)
 func horse(at:Vector2,color:Color,k:float):
  draw_style_box(RanchTheme.box(color,color,7),Rect2(at+Vector2(-30,-12)*k,Vector2(62,29)*k));draw_line(at+Vector2(24,-3)*k,at+Vector2(35,-39)*k,color,13*k);draw_circle(at+Vector2(42,-42)*k,12*k,color)
  for x in [-21,-5,18,28]:draw_line(at+Vector2(x,9)*k,at+Vector2(x-4,39)*k,color,6*k)
