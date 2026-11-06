extends SceneTree
func _initialize()->void:call_deferred("run")
func run()->void:
 var save=root.get_node("SaveData");save.save_path="user://qa_menu_gallop.dat";save.horse_collection=HorseCollection.new();save.horse_collection.seed_trial();save.horse_collection.add_trial_parents()
 var panel=load("res://src/Presentation/horse_panel.gd").new();root.add_child(panel);await process_frame
 for id in ["original","trial_a","trial_b"]:
  panel.focus_id=id;panel.show_page("detail");await process_frame
  assert(panel.preview_frames.size()==12)
  var first:Texture2D=panel.preview_texture.texture
  await create_timer(.2).timeout
  assert(panel.preview_texture.texture!=first)
  await create_timer(1.1).timeout
  if id=="trial_b":root.get_texture().get_image().save_png("/downloads/horse-menu-gallop.png")
 var child:Dictionary=save.horse_collection.breed("trial_a","trial_b",{})
 panel.focus_id=child.id;panel.show_page("detail");await process_frame
 assert(panel.preview_frames.is_empty());assert(panel.preview_texture==null)
 await create_timer(1.5).timeout
 print("ADULT_MENU_GALLOP_CHECK_PASSED 3adults animate, foal static")
 DirAccess.remove_absolute("user://qa_menu_gallop.dat");quit()
