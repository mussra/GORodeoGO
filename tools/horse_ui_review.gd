extends SceneTree
func _initialize()->void:call_deferred("run")
func snap(path:String)->void:
 await process_frame;await process_frame
 root.get_texture().get_image().save_png(path)
func run()->void:
 var save=root.get_node("SaveData");save.save_path="user://qa_horse_ui.dat";save.horse_collection=HorseCollection.new();save.horse_collection.seed_trial();save.horse_collection.add_trial_parents()
 AudioServer.set_bus_mute(0,true)
 var panel=load("res://src/Presentation/horse_panel.gd").new();root.add_child(panel)
 await create_timer(.4).timeout
 await snap("/downloads/horse-collection.png")
 await create_timer(1).timeout
 panel.parent_a="trial_a";panel.parent_b="trial_b";panel.choices={"coat":0,"pattern":0,"mane":1};panel.show_page("breed")
 await snap("/downloads/horse-cross.png");await create_timer(1.5).timeout
 var child:Dictionary=save.breed_horses("trial_a","trial_b",panel.choices);panel.focus_id=child.id;panel.show_page("detail")
 await snap("/downloads/horse-detail.png");await create_timer(1.3).timeout
 panel.show_page("family");await snap("/downloads/horse-family.png");await create_timer(1.2).timeout
 panel.show_page("atlas");await snap("/downloads/horse-atlas.png");await create_timer(1.5).timeout
 panel.free();save.select_horse(child.id);root.get_node("GameState").selected_level=1
 var level=load("res://src/Presentation/level_0.tscn").instantiate();root.add_child(level);await physics_frame
 for b in level._active_bulls:b.set_physics_process(false)
 var note:=Label.new();note.position=Vector2(30,70);note.add_theme_font_size_override("font_size",22)
 var layer:=CanvasLayer.new();layer.layer=100;root.add_child(layer);layer.add_child(note)
 note.text="CRÍA: 280 px/s · manejo1250 · arrastre80% · toros congelados para revisar animación"
 var dirs=[["move_right"],["move_right","move_down"],["move_down"],["move_left","move_down"],["move_left"],["move_left","move_up"],["move_up"],["move_right","move_up"]]
 level.player.global_position=Vector2.ZERO
 for actions in dirs:
  for action in ["move_right","move_left","move_up","move_down"]:Input.action_release(action)
  for action in actions:Input.action_press(action)
  await create_timer(.4).timeout
 for action in ["move_right","move_left","move_up","move_down"]:Input.action_release(action)
 DirAccess.remove_absolute("user://qa_horse_ui.dat");quit()
