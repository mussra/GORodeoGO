extends SceneTree
func _initialize()->void:call_deferred("run")
func run()->void:
 root.get_node("SaveData").begin_trial_session()
 for locale in ["es","en"]:
  TranslationServer.set_locale(locale)
  var level:Node=load("res://src/Presentation/level_0.tscn").instantiate();root.add_child(level)
  for i in range(12):await process_frame
  await RenderingServer.frame_post_draw;root.get_texture().get_image().save_png("/downloads/i18n-world-"+locale+".png")
  level.queue_free();await process_frame
 root.get_node("SaveData").end_trial_session();quit()
