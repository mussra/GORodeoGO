extends Node
func _ready()->void:call_deferred("run")
func run()->void:
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(1280,720)
 SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.horse_collection.add_trial_parents();SaveData.horse_collection.find("trial_a").name="Negro moteado"
 HorseTraining.configure(SaveData.horse_collection,"trial_a","original","jump");SaveData.horse_collection.selected="original"
 for number in range(3):HorseTraining.complete(SaveData.horse_collection,HorseTraining.session(SaveData.horse_collection))
 var panel:=TrainingPanel.new();panel.note="Prueba: niveles1,2,3 ganados con Original → salto aprendido";add_child(panel)
 await get_tree().create_timer(.5).timeout;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/training2755-levels.png")
 get_tree().quit()
