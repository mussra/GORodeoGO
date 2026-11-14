extends Node
var duel:Node2D
func shot(id:String):
 for i in 4:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/duel193-"+id+".png")
func _ready():run.call_deferred()
func run():
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(960,540);SaveData.save_path="user://duel193qa-no-write.dat"
 SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();GameState.brand_intro_played=true
 var menu=load("res://src/Presentation/main_menu.tscn").instantiate();add_child(menu);await shot("menu");menu.free()
 duel=load("res://src/Presentation/duel193.tscn").instantiate();add_child(duel);await shot("ready")
 duel._pause();await shot("pause");duel._resume()
 duel.countdown=0.;duel.running=true
 Input.action_press("move_right");await get_tree().create_timer(1.).timeout;Input.action_release("move_right");await shot("play")
 for rider in duel.riders:rider.set_physics_process(false);rider.velocity=Vector2.ZERO
 duel.player.position=Vector2(-100,0);duel.riders[1].position=Vector2(40,0)
 duel.player.lasso.aim_direction=Vector2.RIGHT;duel.player.lasso._start_charging();duel.player.lasso._charge_distance=140.;duel.player.lasso._release_throw()
 await get_tree().create_timer(.14).timeout;await shot("flight")
 await get_tree().create_timer(.4).timeout;await shot("round")
 duel._next_round();duel.countdown=0.;duel.running=true
 duel.capture_landed(duel.riders[1]);duel._resolve_round();await shot("finish")
 get_tree().root.size=Vector2i(1600,720);await shot("wide")
 print("DUEL193_QA scores=",duel.scores," finished=",duel.finished," saved=",FileAccess.file_exists(SaveData.save_path))
 duel.free();get_tree().quit()
