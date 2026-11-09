class_name NavigationSheet
extends Control
signal selected(id:String)
signal closed
var title:String="Menú"
var entries:Array=[]
var canvas:Control
func _ready()->void:
 process_mode=Node.PROCESS_MODE_ALWAYS;MenuInputGuard.install(self)
 set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);z_index=160;theme=RanchTheme.create()
 var bg:=ColorRect.new();bg.color=Color("10252d");bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(bg)
 canvas=Control.new();canvas.size=Vector2(1280,720);add_child(canvas);resized.connect(layout);layout()
 MenuNavigation.header(canvas,title,func():closed.emit();queue_free())
 MenuNavigation.cards(canvas,entries,func(id:String):selected.emit(id);queue_free())
 MenuNavigation.reveal(canvas)
func layout()->void:
 var k:float=minf(size.x/1280,size.y/720);canvas.scale=Vector2.ONE*k;canvas.position=(size-Vector2(1280,720)*k)/2

func _unhandled_input(event:InputEvent)->void:
 if event.is_action_pressed("ui_cancel"):
  closed.emit();queue_free();get_viewport().set_input_as_handled()
