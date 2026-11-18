extends Node
func _ready():run.call_deferred()
func shot(id:String):
 for i in 10:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png('/downloads/306-'+id+'.png')
func run():
 get_tree().root.size=Vector2i(1600,900);TranslationServer.set_locale('es');GameState.sound_enabled=false
 SaveData.save_path='user://qa306.cfg';SaveData._load_valid=true;SaveData.horse_collection.seed_trial();SaveData.debug_mode=true;SaveData.dual_lasso_intro_shown=true;SaveData.trial_session_active=false;GameState.selected_level=1
 SaveData.horse_collection.add_trial_parents();HorseTraining.configure(SaveData.horse_collection,"trial_a","original","jump");SaveData.horse_collection.selected="original"
 var level=load('res://src/Presentation/level_0.tscn').instantiate();add_child(level);await get_tree().create_timer(.5).timeout
 get_tree().paused=false;SaveData.debug_mode=false;await shot('entrenamiento-juego')
 level._trigger_win();await get_tree().process_frame
 for child in level.get_children():
  if child is HorseVictory251:child.free()
 await shot('entrenamiento-resultado')
 level.free();get_tree().quit()
