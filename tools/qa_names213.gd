extends Node
func _ready():run.call_deferred()
func shot(id_:String):
 for i in 3:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/names213-"+id_+".png")
func run():
 TranslationServer.set_locale("es");GameState.brand_intro_played=true;SaveData.save_path="user://names213-qa.cfg";SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 for extent in [Vector2i(960,540),Vector2i(1280,720)]:
  get_tree().root.size=extent
  var menu=load("res://src/Presentation/main_menu.tscn").instantiate();add_child(menu)
  await get_tree().create_timer(1.).timeout
  await shot("menu-%d"%extent.x);menu._show_games213();await get_tree().create_timer(.3).timeout;await shot("juegos-%d"%extent.x);menu._games213.queue_free();menu._games213=null;menu._show_levels();await get_tree().create_timer(.3).timeout;await shot("toros-%d"%extent.x);menu._drawer.hide();menu._show_settings();await get_tree().create_timer(.3).timeout;await shot("ajustes-%d"%extent.x);menu._show_debug213();await get_tree().create_timer(.3).timeout;await shot("debug-%d"%extent.x);menu.free()
  var scene=load("res://src/Presentation/jump_memory207.tscn").instantiate();add_child(scene);await shot("hipica-%d"%extent.x)
  scene._pause();await shot("pausa-%d"%extent.x);scene._resume();scene.free()
 get_tree().quit()
