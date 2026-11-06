extends SceneTree
func _initialize()->void:call_deferred("run")
func run()->void:
 var save:Node=root.get_node("SaveData");save.begin_trial_session();save.horse_collection.selected="trial_a"
 var panel:Node=load("res://src/Presentation/hat_panel.gd").new();root.add_child(panel)
 for i in range(8):await process_frame
 root.get_texture().get_image().save_png("/downloads/hd-hats-wip.png")
 quit()
