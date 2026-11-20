class_name TutorialGuide323
extends CanvasLayer
signal completed
var target323:Control
var words323:String
var action323:String="Continuar"
var run323:Callable
var cover323:Control
var message323:Label
var go323:Button
func _ready()->void:
 layer=220;process_mode=Node.PROCESS_MODE_ALWAYS
 cover323=Control.new();cover323.set_meta("ui_modal",true);cover323.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);cover323.mouse_filter=Control.MOUSE_FILTER_STOP;add_child(cover323)
 cover323.draw.connect(_draw323)
 message323=Label.new();message323.text=words323;message323.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;message323.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER;message323.add_theme_font_size_override("font_size",26);message323.add_theme_color_override("font_color",Color("fff2d8"));cover323.add_child(message323)
 go323=Button.new();go323.text=action323;QuestButtonStyle.apply(go323);cover323.add_child(go323);go323.pressed.connect(func():
  if run323.is_valid():run323.call()
  completed.emit();queue_free())
 var skip:=Button.new();skip.text="Cerrar ayuda";skip.position=Vector2(20,20);skip.size=Vector2(180,48);QuestButtonStyle.apply(skip);cover323.add_child(skip);skip.pressed.connect(close323)
func _process(_delta:float)->void:
 if not is_instance_valid(target323):queue_free();return
 var extent:=get_viewport().get_visible_rect().size
 var k:float=minf(extent.x/1280.,extent.y/720.)
 message323.size=Vector2(minf(850.*k,extent.x-40.),135.*k);message323.position=Vector2((extent.x-message323.size.x)*.5,extent.y*(.27 if target323.get_global_rect().get_center().y>extent.y*.5 else .55))
 message323.add_theme_font_size_override("font_size",maxi(18,int(26*k)))
 go323.size=Vector2(350,64)*k;go323.position=Vector2((extent.x-go323.size.x)*.5,extent.y*.80)
 cover323.queue_redraw()
func _draw323()->void:
 if not is_instance_valid(target323):return
 var rect:Rect2=target323.get_global_rect().grow(8.);var extent:=get_viewport().get_visible_rect().size;var shade:=Color(0.015,.06,.07,.88)
 cover323.draw_rect(Rect2(0,0,extent.x,maxf(0.,rect.position.y)),shade)
 cover323.draw_rect(Rect2(0,rect.end.y,extent.x,maxf(0.,extent.y-rect.end.y)),shade)
 cover323.draw_rect(Rect2(0,rect.position.y,maxf(0.,rect.position.x),rect.size.y),shade)
 cover323.draw_rect(Rect2(rect.end.x,rect.position.y,maxf(0.,extent.x-rect.end.x),rect.size.y),shade)
 cover323.draw_rect(rect,Color("f7cf7c"),false,4.)
static func show323(parent:Node,target:Control,words:String,action_:String,run_:Callable)->TutorialGuide323:
 var guide:=TutorialGuide323.new();guide.target323=target;guide.words323=words;guide.action323=action_;guide.run323=run_;parent.add_child(guide);return guide

func close323()->void:
 if is_queued_for_deletion():return
 completed.emit();queue_free()
