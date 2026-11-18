class_name NavigationSheet
extends Control
signal selected(id:String)
signal closed
var title:String="Menú"
var entries:Array=[]
var access_note239:String=""
var canvas:Control
var keep_open250:Array=[]
func _ready()->void:
 set_meta("background300","content")
 process_mode=Node.PROCESS_MODE_ALWAYS;MenuInputGuard.install(self)
 set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);z_index=160;theme=RanchTheme.create()
 var bg:=ColorRect.new();bg.color=Color("10252d");bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(bg)
 canvas=Control.new();canvas.size=Vector2(1280,720);add_child(canvas);resized.connect(layout);layout()
 MenuNavigation.header(canvas,title,func():closed.emit();queue_free())
 MenuNavigation.cards(canvas,entries,func(id:String):
  selected.emit(id)
  if id not in keep_open250:queue_free())
 if not access_note239.is_empty():
  var note:=Label.new();note.name="GameAccess239";note.text=access_note239;note.position=Vector2(40,565);note.mouse_filter=Control.MOUSE_FILTER_IGNORE;canvas.add_child(note);TextFit181.fixed(note,Vector2(1200,110),24,21,3)
 ButtonSkin272.tree(canvas)
 MenuNavigation.reveal(canvas)
func layout()->void:
 var k:float=minf(size.x/1280,size.y/720);canvas.scale=Vector2.ONE*k;canvas.position=(size-Vector2(1280,720)*k)/2

func _unhandled_input(event:InputEvent)->void:
 if event.is_action_pressed("ui_cancel"):
  closed.emit();queue_free();get_viewport().set_input_as_handled()

func show_requirement250(text_:String)->void:
 var note:Label=canvas.get_node("GameAccess239")
 note.text="Para jugar: "+text_
 note.add_theme_color_override("font_color",Color("aab9bd"))
 note.modulate.a=.45
 create_tween().tween_property(note,"modulate:a",1.0,.18)
