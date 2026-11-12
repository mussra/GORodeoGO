extends Node
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es");var panel:=EquipmentPanel.new();add_child(panel)
 await get_tree().process_frame;await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png("/downloads/adorn153-equipo.png")
 var button:Button
 for child in panel._canvas.get_children():
  if child is Button and child.text=="Adornos · Vista previa":button=child
 assert(button!=null);button.pressed.emit();await get_tree().process_frame;await RenderingServer.frame_post_draw
 var preview:AdornPreview153
 for child in panel.get_children():
  if child is AdornPreview153:preview=child
 assert(preview!=null);await get_tree().create_timer(.4,true).timeout;await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png("/downloads/adorn153-entrada.png")
 var event:=InputEventAction.new();event.action="ui_cancel";event.pressed=true;preview._unhandled_input(event);await get_tree().process_frame;assert(not is_instance_valid(preview));print("ADORN153_EQUIPMENT_ROUTE_OK");get_tree().quit()
