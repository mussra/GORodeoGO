extends SceneTree
func _initialize()->void:call_deferred("run")
func run()->void:
 var save:Node=root.get_node("SaveData");save.begin_trial_session();save.horse_collection.add_trial_parents();save.horse_collection.find("trial_b").traits.finish="galaxy";save.horse_collection.find("trial_b").traits.eyes=21
 var panel:Node=load("res://src/Presentation/horse_panel.gd").new();root.add_child(panel);panel.parent_a="trial_a";panel.parent_b="trial_b";panel.choices["finish"]=1;panel.choices["eyes"]=1;panel.show_page("breed")
 for i in range(6):await process_frame
 await RenderingServer.frame_post_draw;root.get_texture().get_image().save_png("/downloads/candidate-breeding-menu.png");save.end_trial_session();quit()
