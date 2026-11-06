extends SceneTree
func _initialize()->void:call_deferred("run")
func shot(path:String)->void:
 for i in range(3):await process_frame
 await RenderingServer.frame_post_draw;root.get_texture().get_image().save_png(path)
func run()->void:
 var save:=root.get_node("SaveData");save.save_path="user://menu2_scratch.dat";save.horse_collection=HorseCollection.new();save.horse_collection.seed_trial();save.horse_collection.add_trial_parents();save.horse_collection.add_random_trial_pair()
 var panel:Node=load("res://src/Presentation/horse_panel.gd").new();root.add_child(panel)
 panel.focus_id="trial_a";panel.show_page("detail");await shot("/downloads/horse2-detail.png")
 panel.show_page("breed");await shot("/downloads/horse2-breed.png")
 for node in panel.content.get_children():
  if node is OptionButton:node.show_popup();break
 await shot("/downloads/horse2-picker.png")
 panel.show_page("atlas");await shot("/downloads/horse2-atlas.png")
 panel.atlas_owned_first=false;panel.refresh();await shot("/downloads/horse2-atlas-normal.png")
 print("MENU2_REVIEW_DONE");quit()
