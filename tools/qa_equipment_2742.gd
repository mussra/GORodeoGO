extends Node
func _ready()->void:call_deferred("run")
func run()->void:
 TranslationServer.set_locale("es");get_tree().root.theme=RanchTheme.create();get_tree().root.size=Vector2i(1600,720)
 SaveData.equipment_points=595;SaveData.equipment_owned.clear();SaveData.equipment_equipped.clear()
 var host:=Control.new();get_tree().root.add_child(host);host.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);MenuInputGuard.install(host)
 var panel:=EquipmentPanel.new();panel.visible=false;host.add_child(panel)
 await get_tree().create_timer(.3).timeout
 panel.refresh();panel.show();await get_tree().create_timer(.3).timeout
 await RenderingServer.frame_post_draw
 var label:String="after"
 for arg in OS.get_cmdline_user_args():label=arg
 get_viewport().get_texture().get_image().save_png("/downloads/equipment2742-"+label+".png")
 get_tree().quit()
