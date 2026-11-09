extends Node
func _ready()->void:call_deferred("run")
func run()->void:
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(1280,720)
 SaveData.horse_collection.seed_trial()
 var learner:Dictionary={"id":"qa_learner","name":"Castaño con corazones","stage":"adult","can_dodge":false,"traits":{"coat":10,"pattern":5,"mane":2,"spots":3,"eyes":10,"finish":"normal"}}
 SaveData.horse_collection.horses.append(learner);HorseTraining.configure(SaveData.horse_collection,"original","qa_learner","dodge")
 var panel:=TrainingPanel.new();panel.mentor="original";panel.learner="qa_learner";panel.skill="dodge";panel.note=tr("TRAIN_SAVED");add_child(panel)
 await get_tree().create_timer(.5).timeout;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/training2754-learner.png")
 get_tree().quit()
