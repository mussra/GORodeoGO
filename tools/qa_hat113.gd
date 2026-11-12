extends Node
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(896,414);TranslationServer.set_locale("es");SaveData.horse_collection.seed_trial();SaveData.trial_session_active=true
 var panel=HatPanel.new();add_child(panel);panel.size=get_viewport().get_visible_rect().size;panel._layout()
 await get_tree().process_frame
 for pair in [[3,0],[3,13],[4,11],[5,14]]:
  panel._color.select(pair[0]+3);panel._finish.select(panel._finish_ids.find(pair[1]));panel._update_preview()
  await get_tree().process_frame;await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png("/downloads/sombrero113-%d.png"%pair[1])
 get_tree().quit()
