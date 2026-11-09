extends Node
func _ready()->void:call_deferred("run")
func shot(name:String)->void:
 await get_tree().create_timer(.4).timeout;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/training2757-"+name+".png")
func run()->void:
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(1280,720)
 SaveData.save_path="user://qa-training57.dat";SaveData.trial_session_active=false;SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.horse_collection.add_trial_parents();SaveData.horse_collection.find("original").learning={"jump":12.0}
 HorseTraining.configure(SaveData.horse_collection,"trial_a","original","jump");SaveData.horse_collection.selected="original";GameState.selected_level=1
 var level=load("res://src/Presentation/level_0.tscn").instantiate();add_child(level)
 await shot("hud");level._trigger_win();await shot("result");get_tree().quit()
