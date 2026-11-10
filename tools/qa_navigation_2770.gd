extends Node
func _ready()->void:run.call_deferred()
func snap(path:String)->void:
 for i in 4:await get_tree().process_frame
 await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png(path)
func run()->void:
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es");SaveData.horse_collection.seed_trial();SaveData.horse_collection.add_trial_parents()
 var panel=HorsePanel.new();add_child(panel)
 for i in 4:await get_tree().process_frame
 panel.focus_id=SaveData.horse_collection.horses[1].id;panel.show_page("detail")
 await snap("/downloads/detail2770.png");await get_tree().create_timer(2).timeout
 panel.content.get_node("ItemPager").next.pressed.emit();await get_tree().create_timer(1).timeout
 panel.show_page("atlas");await snap("/downloads/atlas2770.png");await get_tree().create_timer(2).timeout
 panel.content.get_node("ItemPager").next.pressed.emit();await get_tree().create_timer(1).timeout
 panel.queue_free();await get_tree().process_frame
 var training=TrainingPanel.new();add_child(training);await snap("/downloads/training2770.png");await get_tree().create_timer(2).timeout;training.queue_free();await get_tree().process_frame
 var genealogy=GenealogyPanel.new();add_child(genealogy);await get_tree().process_frame;genealogy.select(SaveData.horse_collection.horses[1].id);await snap("/downloads/genealogy2770.png");await get_tree().create_timer(2).timeout;genealogy.queue_free();await get_tree().process_frame
 GameState.brand_intro_played=true
 var menu=load("res://src/Presentation/main_menu.tscn").instantiate();add_child(menu);await get_tree().create_timer(1).timeout;menu._show_settings();await snap("/downloads/settings2770.png");await get_tree().create_timer(2).timeout;get_tree().quit()
