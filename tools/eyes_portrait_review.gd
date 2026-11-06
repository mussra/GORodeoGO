extends SceneTree
func _initialize()->void:call_deferred("run")
func run()->void:
 var save:Node=root.get_node("SaveData");save.begin_trial_session();save.preview_trial_traits(6,0,5);save.horse_collection.find("preview_temporary").traits.eyes=3
 var panel:Node=load("res://src/Presentation/horse_panel.gd").new();root.add_child(panel)
 panel.focus_id="preview_temporary";panel.page="detail";panel.refresh()
 for i in range(8):await process_frame
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png("/downloads/eyes-portrait-integrated.png")
 quit()
