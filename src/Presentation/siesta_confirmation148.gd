class_name SiestaConfirmation148
extends Control
signal confirmed
signal cancelled
var destination:String=""
var preview:bool=false
func _ready():
 process_mode=Node.PROCESS_MODE_ALWAYS;set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);z_index=180;MenuInputGuard.install(self)
 var bg:=ColorRect.new();bg.color=Color("10252ded");bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(bg)
 var box:=VBoxContainer.new();box.size=Vector2(720,320);add_child(box)
 var title:=Label.new();title.text=destination;title.add_theme_font_size_override("font_size",30);box.add_child(title)
 var note:=Label.new();note.text="Te echas una siesta mientras tu caballo va a este sitio ya visitado.\nSin coste ni consumo de energía. No completa encargos por el camino."
 if preview:note.text+="\nMaqueta: este viaje no se guarda."
 note.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;note.custom_minimum_size=Vector2(680,130);box.add_child(note)
 var go:=Button.new();go.name="ConfirmSiesta144";go.text="Ir a este sitio";go.custom_minimum_size.y=56;box.add_child(go);go.pressed.connect(func():confirmed.emit())
 var cancel:=Button.new();cancel.text="Cancelar";cancel.custom_minimum_size.y=56;box.add_child(cancel);cancel.pressed.connect(func():cancelled.emit())
 var layout:Callable=func():
  var k:float=minf(size.x/1280.,size.y/720.);box.scale=Vector2.ONE*k;box.position=(size-Vector2(720,320)*k)/2.
 resized.connect(layout);layout.call()
func _unhandled_input(event:InputEvent):
 if event.is_action_pressed("ui_cancel"):cancelled.emit();get_viewport().set_input_as_handled()
