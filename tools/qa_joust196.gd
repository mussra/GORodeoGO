extends Node
func _ready():run.call_deferred()
func shot(id:String):
 for i in 4:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/joust196-"+id+".png")
func run():
 TranslationServer.set_locale("es");GameState.brand_intro_played=true;get_tree().root.size=Vector2i(960,540)
 SaveData.save_path="user://joust196qa-no-write.cfg";SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 var menu=load("res://src/Presentation/main_menu.tscn").instantiate();add_child(menu);await get_tree().create_timer(1.).timeout;await shot("menu");menu.free()
 var joust=load("res://src/Presentation/joust196.tscn").instantiate();add_child(joust);await shot("ready")
 joust.countdown=0.;joust.running=true;joust.riders[1].attack_cooldown=99.
 for i in 65:await get_tree().physics_frame
 await shot("approach")
 for rider in joust.riders:rider.set_physics_process(false)
 joust.player.position=Vector2(-100,-40);joust.riders[1].position=Vector2(60,40);joust.player.velocity=Vector2.ZERO
 joust.player.lasso.aim_direction=Vector2(160,80).normalized();joust.player.lasso._start_charging();joust.player.lasso._charge_distance=Vector2(160,80).length();joust.player.lasso._release_throw()
 for i in 5:await get_tree().physics_frame
 await shot("flight")
 for i in 30:await get_tree().physics_frame
 await shot("round")
 joust._next_round();joust.countdown=0.;joust.running=true
 for rider in joust.riders:rider.position.x=rider.forward*480.
 joust._physics_process(.6);await shot("miss")
 joust._next_round();joust._pause();await shot("pause");joust._resume()
 joust.scores.assign([1,0]);joust.countdown=0.;joust.running=true;joust.capture_landed(joust.riders[1]);joust._resolve_round();await shot("finish")
 joust.free();print("JOUST196_QA saved=",FileAccess.file_exists(SaveData.save_path));get_tree().quit()
