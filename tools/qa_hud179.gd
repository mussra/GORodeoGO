extends Node
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(960,540);TranslationServer.set_locale("es");SaveData.dual_lasso_intro_shown=true;SaveData.trial_session_active=true;SaveData.horse_collection.seed_trial();GameState.selected_level=1
 var scene=load("res://src/Presentation/level_0.tscn").instantiate();add_child(scene)
 await get_tree().create_timer(.8).timeout
 await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png("/downloads/details179-hud-960.png");get_tree().quit()
