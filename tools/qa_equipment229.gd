extends Node
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(960,540);TranslationServer.set_locale("es");SaveData.equipment_points=0;SaveData.equipment_owned=[];SaveData.equipment_equipped={}
 var panel:=EquipmentPanel.new();add_child(panel)
 for i in 4:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/equipment229-icons-960.png")
 panel.free();get_tree().quit()
