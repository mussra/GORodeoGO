class_name HatPanel
extends Control
var _canvas:Control
var _buttons:Dictionary={}
var _message:Label
var _portraits:Dictionary={}
func _ready()->void:
 set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 z_index=60
 var bg:=ColorRect.new();bg.color=Color("10252d");bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(bg)
 _canvas=Control.new();_canvas.size=Vector2(1280,720);add_child(_canvas)
 _label(tr("UI_063"),Vector2(40,25),32)
 _label(tr("UI_064"),Vector2(40,82),23)
 var back:=Button.new();back.text=tr("UI_009");back.position=Vector2(1030,25);back.size=Vector2(210,48);back.pressed.connect(hide);_canvas.add_child(back)
 var i:int=0
 for id in HatAppearance.OPTIONS:
  var x:float=80+i*410
  _label(tr(HatAppearance.OPTIONS[id]),Vector2(x,155),29)
  var sprite:=TextureRect.new();sprite.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;HorsePortrait.apply(sprite,SaveData.horse_collection.find(SaveData.horse_collection.selected).traits,id);_portraits[id]=sprite;sprite.position=Vector2(x,220);sprite.size=Vector2(290,290);sprite.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;sprite.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;sprite.texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR;_canvas.add_child(sprite)
  var b:=Button.new();b.position=Vector2(x,530);b.size=Vector2(290,55);b.pressed.connect(func():
   if not SaveData.select_hat(id):_message.text=tr("UI_065")
   else:_message.text=tr("UI_066")
   refresh())
  _canvas.add_child(b);_buttons[id]=b;i+=1
 _message=_label("",Vector2(40,615),23)
 _label(tr("UI_067"),Vector2(40,665),21)
 resized.connect(_layout);_layout();refresh()
func _label(text:String,pos:Vector2,font:int)->Label:
 var l:=Label.new();l.text=text;l.position=pos;l.add_theme_font_size_override("font_size",font);_canvas.add_child(l);return l
func _layout()->void:
 if _canvas==null:return
 var k:float=minf(size.x/1280,size.y/720)
 _canvas.scale=Vector2.ONE*k;_canvas.position=(size-Vector2(1280,720)*k)/2
func refresh()->void:
 for id in _buttons:
  HorsePortrait.apply(_portraits[id],SaveData.horse_collection.find(SaveData.horse_collection.selected).traits,id)
  var selected:bool=SaveData.hat_color==id
  _buttons[id].text=tr("UI_060") if selected else tr("UI_059")
  _buttons[id].disabled=selected
