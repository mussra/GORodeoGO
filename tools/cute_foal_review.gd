extends SceneTree
func _initialize()->void:call_deferred("run")
func run()->void:
 var save:Node=root.get_node("SaveData");assert(save.begin_trial_session())
 var h:Dictionary=save.breed_horses("original","trial_a",{"coat":0,"pattern":0,"mane":0})
 var panel:Node=load("res://src/Presentation/horse_panel.gd").new();root.add_child(panel);panel.focus_id=h.id;panel.parent_b="trial_a"
 for mode in ["collection","breed","family","detail"]:
  panel.show_page(mode)
  for i in range(20):await process_frame
  root.get_texture().get_image().save_png("/downloads/cute-foal-"+mode+".png")
 panel.show_page("family")
 for i in range(50):await process_frame
 save.end_trial_session();quit()
