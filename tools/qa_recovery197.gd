extends Node
func _ready():run.call_deferred()
func shot(id:String):
 for i in 5:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/recovery197-"+id+".png")
func run():
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(1600,720)
 SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.save_path="user://recovery197qa-never-write.cfg"
 RaceCourse190.selected=0;RaceCourse190.start_selected=true
 var race=load("res://src/Presentation/race190.tscn").instantiate();add_child(race);race.countdown=0.;race.running=true
 for rider in race.riders:
  if rider!=race.player:rider.set_physics_process(false)
 var p=race.player;var s:float=race.course.length*7./16.+70.;var normal:Vector2=race.course.tangent(s).orthogonal()
 p.position=race.course.at(s)+normal*165.;p.previous_position=p.position;p.next_gate=8;race.elapsed=35.
 p.request_dodge_path(PackedVector2Array([Vector2.ZERO,normal*240.]));await get_tree().create_timer(.4).timeout
 print("RECOVERY197QA after_boundary path=",p.dodge.path.size()," remaining=",p.dodge.remaining)
 await shot("boundary-released")
 var inward:Vector2=-normal
 Input.action_press("move_left",maxf(0.,-inward.x));Input.action_press("move_right",maxf(0.,inward.x));Input.action_press("move_up",maxf(0.,-inward.y));Input.action_press("move_down",maxf(0.,inward.y))
 await get_tree().create_timer(.6).timeout
 for action in ["move_left","move_right","move_up","move_down"]:Input.action_release(action)
 p.attack_cooldown=.3;Input.action_press("aim_left",.7);p.lasso._on_aim_pressed();await get_tree().create_timer(.5).timeout
 await shot("held-aim-ready")
 p.lasso._on_aim_released(Vector2.LEFT*.7)
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/recovery197-flight-after-recovery.png")
 Input.action_release("aim_left")
 print("RECOVERY197QA position=",p.position," flight=",p.lasso.is_in_flight()," saved=",FileAccess.file_exists(SaveData.save_path))
 race.free();get_tree().quit()
