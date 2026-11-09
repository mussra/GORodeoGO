extends Node
func _ready()->void:call_deferred("run")
func capture(path:String)->void:
 await get_tree().create_timer(.8).timeout
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png(path)
func run()->void:
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(1280,720)
 SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.horse_collection.add_trial_parents();SaveData.horse_collection.find("trial_a").traits={"coat":13,"mane":0,"pattern":10,"legs":0,"finish":"normal"}
 var panel:=HorsePanel.new();panel.theme=RanchTheme.create();get_tree().root.add_child(panel)
 await capture("/downloads/navigation2746-hub.png")
 panel.parent_a="trial_a";panel.parent_b="original";panel.show_page("breed")
 await capture("/downloads/navigation2746-breed.png")
 panel.focus_id="trial_a";panel.show_page("detail")
 await capture("/downloads/navigation2746-detail.png")
 panel.show_page("collection")
 await capture("/downloads/navigation2746-collection.png")
 panel.show_page("atlas")
 await capture("/downloads/navigation2746-atlas.png")
 panel.open_atlas_filters()
 await capture("/downloads/navigation2746-filters.png")
 panel.queue_free();await get_tree().process_frame
 var graph:=GenealogyPanel.new();graph.theme=RanchTheme.create();get_tree().root.add_child(graph)
 await capture("/downloads/navigation2746-genealogy.png")
 graph.open_filters()
 await capture("/downloads/navigation2746-gen-filters.png")
 get_tree().quit()
