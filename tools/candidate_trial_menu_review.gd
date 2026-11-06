extends SceneTree
func _initialize()->void:call_deferred("run")
func run()->void:
 root.get_node("SaveData").begin_trial_session()
 root.add_child(load("res://src/Presentation/trial_panel.gd").new())
 for i in range(6):await process_frame
 await RenderingServer.frame_post_draw;root.get_texture().get_image().save_png("/downloads/candidate-trial-menu.png");quit()
