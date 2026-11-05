class_name HatPanel
extends Control
var _canvas:Control
var _buttons:Dictionary={}
var _message:Label
func _ready()->void:
 set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 z_index=60
 var bg:=ColorRect.new();bg.color=Color("10252d");bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(bg)
 _canvas=Control.new();_canvas.size=Vector2(1280,720);add_child(_canvas)
 _label("SOMBREROS · PRUEBA DE COLOR",Vector2(40,25),32)
 _label("Mismo sombrero y mismas habilidades. El original siempre está disponible.",Vector2(40,82),23)
 var back:=Button.new();back.text="VOLVER";back.position=Vector2(1030,25);back.size=Vector2(210,48);back.pressed.connect(hide);_canvas.add_child(back)
 var i:int=0
 for id in HatAppearance.OPTIONS:
  var x:float=80+i*410
  _label(HatAppearance.OPTIONS[id],Vector2(x,155),29)
  var sprite:=TextureRect.new();sprite.texture=load(HatAppearance.art_root(id)+"walk_side/frame_00.png");sprite.position=Vector2(x,220);sprite.size=Vector2(290,290);sprite.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;sprite.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;sprite.texture_filter=CanvasItem.TEXTURE_FILTER_NEAREST;_canvas.add_child(sprite)
  var b:=Button.new();b.position=Vector2(x,530);b.size=Vector2(290,55);b.pressed.connect(func():
   if not SaveData.select_hat(id):_message.text="No se pudo guardar el color. Se mantiene el anterior."
   else:_message.text="Color guardado. Se verá al entrar en la partida."
   refresh())
  _canvas.add_child(b);_buttons[id]=b;i+=1
 _message=_label("",Vector2(40,615),23)
 _label("Prueba sin coste en puntos. Precios y desbloqueos estéticos por definir.",Vector2(40,665),21)
 resized.connect(_layout);_layout();refresh()
func _label(text:String,pos:Vector2,font:int)->Label:
 var l:=Label.new();l.text=text;l.position=pos;l.add_theme_font_size_override("font_size",font);_canvas.add_child(l);return l
func _layout()->void:
 if _canvas==null:return
 var k:float=minf(size.x/1280,size.y/720)
 _canvas.scale=Vector2.ONE*k;_canvas.position=(size-Vector2(1280,720)*k)/2
func refresh()->void:
 for id in _buttons:
  var selected:bool=SaveData.hat_color==id
  _buttons[id].text="EQUIPADO" if selected else "EQUIPAR"
  _buttons[id].disabled=selected
