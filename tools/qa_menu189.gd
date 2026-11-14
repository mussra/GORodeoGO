extends Node
func _ready():run.call_deferred()
func run():
 TranslationServer.set_locale("es");GameState.brand_intro_played=true;SaveData.save_path="user://menu189-qa.dat";SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 for extent in [Vector2i(960,540),Vector2i(1280,720),Vector2i(1600,720)]:
  get_tree().root.size=extent
  var menu=load("res://src/Presentation/main_menu.tscn").instantiate();add_child(menu)
  await get_tree().create_timer(.12).timeout
  await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png("/downloads/menu189-intro-%d.png"%extent.x)
  await get_tree().create_timer(.8).timeout
  await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png("/downloads/menu189-final-%d.png"%extent.x)
  menu.free()
 var hub:=HorsePanel.new();add_child(hub);hub.page="hub";hub._refresh();await get_tree().process_frame;await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png("/downloads/menu189-atlas.png");hub.free()
 print("MENU189_QA_OK");get_tree().quit()
