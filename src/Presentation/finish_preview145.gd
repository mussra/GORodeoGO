class_name FinishPreview145
extends Control
var canvas:Control
var clocks:float=0.
var frame_id:int=-1
var runners:Array[TextureRect]=[]
var pose_specs:Array[Dictionary]=FinishPose168.specs()
var pose_index:int=0
func _ready():
 MenuInputGuard.install(self);set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);z_index=65
 var background:=ColorRect.new();background.color=Color("10252d");background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(background)
 canvas=Control.new();canvas.size=Vector2(1280,720);add_child(canvas)
 _text("Acabados · estudio de todas las poses",Vector2(35,20),30)
 _text("Estudio visual: no compra, equipa, cría ni modifica tus caballos.",Vector2(35,66),21)
 var back:=Button.new();back.text="Volver";back.position=Vector2(1060,20);back.size=Vector2(180,52);QuestButtonStyle.apply(back);back.pressed.connect(queue_free);canvas.add_child(back)
 for i in 3:
  var x:float=40.+i*416.
  _text(SpecialFinish145.NAMES[i],Vector2(x+12,110),27)
  var backdrop:=ColorRect.new();backdrop.color=Color("294738") if i==1 else Color("28404a");backdrop.position=Vector2(x,160);backdrop.size=Vector2(374,365);canvas.add_child(backdrop)
  # A visible background grid lets transparency be checked rather than implied.
  for k in 7:
   var line:=ColorRect.new();line.color=Color("ffffff0b");line.position=Vector2(x+k*56.,160);line.size=Vector2(1,365);canvas.add_child(line)
  var portrait:=TextureRect.new();portrait.texture=HorsePortrait.ART;portrait.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;portrait.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;portrait.position=Vector2(x,160);portrait.size=Vector2(374,365);portrait.material=SpecialFinish145.material(SpecialFinish145.IDS[i],HorsePortrait.MASK,null,true);portrait.texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR;canvas.add_child(portrait)
  var runner:=TextureRect.new();runner.position=Vector2(x+91,477);runner.size=Vector2(192,192);runner.texture_filter=CanvasItem.TEXTURE_FILTER_NEAREST;canvas.add_child(runner);runners.append(runner)
 var select:=OptionButton.new();select.name="Pose168";select.position=Vector2(35,633);select.size=Vector2(650,44);select.add_theme_font_size_override("font_size",20);canvas.add_child(select)
 for spec in pose_specs:select.add_item(spec.title)
 select.item_selected.connect(func(index:int):pose_index=index;frame_id=-1;_advance())
 _text("Solo estudio visual · aún sin compra ni equipamiento",Vector2(35,685),20)
 resized.connect(_layout);_layout();_advance()
func _text(text_:String,point:Vector2,size_:int):
 var label:=Label.new();label.text=text_;label.position=point;label.add_theme_font_size_override("font_size",size_);canvas.add_child(label)
func _layout():
 if canvas==null:return
 var k:float=minf(size.x/1280.,size.y/720.);canvas.scale=Vector2.ONE*k;canvas.position=(size-Vector2(1280,720)*k)/2.
func _process(delta:float):
 clocks+=delta
 if int(clocks*9.)%int(pose_specs[pose_index].count)!=frame_id:_advance()
func _advance():
 frame_id=int(clocks*9.)%int(pose_specs[pose_index].count)
 var spec:Dictionary=pose_specs[pose_index];var paths:=FinishPose168.paths(spec,frame_id)
 for i in runners.size():runners[i].texture=load(paths.source);runners[i].material=FinishPose168.material(SpecialFinish145.IDS[i],spec,frame_id)
func _unhandled_input(event:InputEvent):
 if event.is_action_pressed("ui_cancel"):queue_free();get_viewport().set_input_as_handled()
