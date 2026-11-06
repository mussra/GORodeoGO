extends SceneTree
func _initialize()->void:call_deferred("run")
func run()->void:
 var state:Node=root.get_node("GameState");state.brand_intro_played=true
 var save:Node=root.get_node("SaveData");save.begin_trial_session()
 for language in ["es","en"]:
  TranslationServer.set_locale(language)
  var menu:Control=load("res://src/Presentation/main_menu.tscn").instantiate();root.add_child(menu)
  await create_timer(1.2).timeout;menu._hero.modulate.a=1
  await RenderingServer.frame_post_draw;root.get_texture().get_image().save_png("/downloads/i18n-menu-"+language+".png")
  menu._show_settings();await process_frame;await RenderingServer.frame_post_draw;root.get_texture().get_image().save_png("/downloads/i18n-settings-"+language+".png")
  menu.queue_free();await process_frame
 save.end_trial_session();quit()
