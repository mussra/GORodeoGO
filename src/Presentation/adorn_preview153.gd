class_name AdornPreview153
extends Control
var canvas:Control
var clock:float=0.
var frame_id:int=-1
var runners:Array[TextureRect]=[]
var small_runners:Array[TextureRect]=[]
func _ready():
 MenuInputGuard.install(self);set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);z_index=70
 var bg:=ColorRect.new();bg.color=Color("10252d");bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(bg)
 canvas=Control.new();canvas.size=Vector2(1280,720);add_child(canvas)
 _text("Adornos de patas y botas · prueba visual",Vector2(30,16),29)
 _text("Mismo dibujo. Bandas oro/plata, sin comprar, equipar ni cambiar tu partida.",Vector2(30,62),21)
 var back:=Button.new();back.text="Volver";back.position=Vector2(1080,15);back.size=Vector2(170,46);QuestButtonStyle.apply(back);back.pressed.connect(queue_free);canvas.add_child(back)
 for i in 3:
  var x:float=28.+i*418.
  _text(AdornStudy153.NAMES[i],Vector2(x+10,106),26)
  var pad:=ColorRect.new();pad.color=Color("28404a");pad.position=Vector2(x,145);pad.size=Vector2(390,480);canvas.add_child(pad)
  var portrait:=_view(HorsePortrait.ART,Vector2(x+61,146),Vector2(267,280));portrait.material=AdornStudy153.material(AdornStudy153.IDS[i]);portrait.texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR
  var runner:=_view(AdornStudy153.frame(0),Vector2(x+23,414),Vector2(192,192));runners.append(runner)
  var small:=_view(AdornStudy153.frame(0),Vector2(x+266,496),Vector2(96,96));small_runners.append(small)
  _text("×2",Vector2(x+93,592),17);_text("96 px",Vector2(x+285,592),17)
 _text("Solo retrato y galope lateral · faltan otras poses · precio y obtención pendientes",Vector2(30,653),21)
 _text("Sin estadísticas, genética ni cambios de silueta.",Vector2(30,686),19)
 resized.connect(_layout);_layout();_advance()
func _view(texture_:Texture2D,point:Vector2,dimensions:Vector2)->TextureRect:
 var node:=TextureRect.new();node.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;node.texture=texture_;node.position=point;node.size=dimensions;node.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;node.texture_filter=CanvasItem.TEXTURE_FILTER_NEAREST;canvas.add_child(node);return node
func _text(text_:String,point:Vector2,font:int):
 var label:=Label.new();label.text=text_;label.position=point;label.add_theme_font_size_override("font_size",font);canvas.add_child(label)
func _layout():
 if canvas==null:return
 var k:float=minf(size.x/1280.,size.y/720.);canvas.scale=Vector2.ONE*k;canvas.position=(size-Vector2(1280,720)*k)/2.
func _process(delta:float):
 clock+=delta
 if int(clock*9.)%9!=frame_id:_advance()
func _advance():
 frame_id=int(clock*9.)%9
 for i in runners.size():
  for node in [runners[i],small_runners[i]]:node.texture=AdornStudy153.frame(frame_id);node.material=AdornStudy153.material(AdornStudy153.IDS[i],frame_id)
func _unhandled_input(event:InputEvent):
 if event.is_action_pressed("ui_cancel"):queue_free();get_viewport().set_input_as_handled()
