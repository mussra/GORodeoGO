extends SceneTree
func _initialize()->void:call_deferred("run")
func shot(path:String)->void:
 for i in range(5):await process_frame
 await RenderingServer.frame_post_draw;root.get_texture().get_image().save_png(path)
func run()->void:
 var save:Node=root.get_node("SaveData");save.begin_trial_session();save.horse_collection.add_trial_parents()
 for locale in ["es","en"]:
  TranslationServer.set_locale(locale)
  for kind in ["equipment_panel","hat_panel","trial_panel"]:
   var panel:Node=load("res://src/Presentation/"+kind+".gd").new();root.add_child(panel);await shot("/downloads/i18n-"+kind+"-"+locale+".png");panel.queue_free();await process_frame
  var hp:Node=load("res://src/Presentation/horse_panel.gd").new();root.add_child(hp);hp.parent_a="trial_a";hp.parent_b="trial_b";hp.focus_id="trial_b"
  for page in ["collection","breed","detail","atlas","family"]:
   hp.show_page(page);await shot("/downloads/i18n-horse-"+page+"-"+locale+".png")
  hp.queue_free();await process_frame
 save.end_trial_session();quit()
