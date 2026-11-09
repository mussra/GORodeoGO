extends Node
func _ready()->void:call_deferred("run")
func shot(name:String)->void:
 await get_tree().create_timer(.5).timeout;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/selectors2756-"+name+".png")
func run()->void:
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(1280,720)
 SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.horse_collection.add_trial_parents();SaveData.horse_collection.find("trial_a").name="Azul con parches";SaveData.horse_collection.find("trial_b").name="Violeta liso"
 HorseTraining.configure(SaveData.horse_collection,"trial_a","trial_b","jump")
 var train:=TrainingPanel.new();add_child(train);train.note=tr("TRAIN_AUTO_SAVED");await shot("training");train.queue_free();await get_tree().process_frame
 var panel:=HorsePanel.new();add_child(panel);panel.parent_a="trial_a";panel.parent_b="trial_b";panel.show_page("breed");await shot("parents");panel.queue_free();await get_tree().process_frame
 var trial=load("res://src/Presentation/trial_panel.gd").new();add_child(trial);await shot("debug");get_tree().quit()
