extends Node
func _ready()->void:call_deferred("run")
func run()->void:
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(1280,720)
 SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.horse_collection.add_trial_parents();SaveData.horse_collection.find("original").traits={"coat":10,"mane":0,"pattern":0,"legs":0,"finish":"normal"}
 var panel:=HorsePanel.new();get_tree().root.add_child(panel);panel.focus_id="original";panel.show_page("detail")
 await get_tree().create_timer(.3).timeout
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/colors2745-detail.png")
 panel.parent_a="original";panel.parent_b="trial_a";panel.show_page("breed")
 await get_tree().create_timer(.3).timeout
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/colors2745-breed.png")
 get_tree().quit()
