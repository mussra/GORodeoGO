extends Node
var race:Node
var auto:bool=false
func shot(id:String):
 for i in 3:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/race190-"+id+".png")
func _ready():run.call_deferred()
func run():
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(960,540)
 SaveData.save_path="user://race190qa.dat";SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();GameState.brand_intro_played=true
 var menu=load("res://src/Presentation/main_menu.tscn").instantiate();add_child(menu);await get_tree().create_timer(.8).timeout;await shot("menu");menu.free()
 race=load("res://src/Presentation/race190.tscn").instantiate();add_child(race)
 await shot("selector");race.selector.hide();await shot("ready")
 race._pause();await shot("pause");get_tree().paused=false;race.pause_panel.hide()
 race.countdown=0.;race.running=true
 Input.action_press("move_right");await get_tree().create_timer(.9).timeout;Input.action_release("move_right")
 await shot("running")
 race.map_view.toggle();await shot("map-expanded");race.map_view.toggle()
 for index in 2:
  var e:=InputEventScreenTouch.new();e.index=index;e.position=Vector2(180+600*index,420);e.pressed=true;Input.parse_input_event(e)
 await shot("controls")
 for index in 2:
  var e:=InputEventScreenTouch.new();e.index=index;e.position=Vector2(180+600*index,420);e.pressed=false;Input.parse_input_event(e)
 # Show the real flight shared by all modes, with live rivals as targets.
 var target=race.riders[1];target.position=race.player.position+Vector2(140,0)
 race.player.lasso.aim_direction=Vector2.RIGHT;race.player.lasso._start_charging();race.player.lasso._charge_distance=140.;race.player.lasso._release_throw()
 await get_tree().create_timer(.14).timeout;await shot("flight")
 await get_tree().create_timer(.4).timeout
 race.player.try_capture(race.player.position);race.player.tether_from=race.riders[2];await shot("slowed")
 race.player.slow_left=0.;race.player.request_dodge(Vector2.RIGHT);await shot("dodge")
 # Complete a real ordered lap with player input, no checkpoint shortcuts.
 auto=true;Engine.time_scale=8.
 var deadline:float=0.
 while race.player.finish_time<0. and deadline<100.:
  await get_tree().physics_frame;deadline+=get_physics_process_delta_time()
 Engine.time_scale=1.;auto=false
 for a in ["move_right","move_left","move_up","move_down"]:Input.action_release(a)
 await shot("finish")
 if not is_instance_valid(race.story_dialog):race._winner_story()
 await shot("story")
 var body=race.story_dialog.get_node("StoryScroll/StoryBody");print("STORY191 size=",body.size," panel=",race.story_dialog.size)
 get_tree().root.size=Vector2i(1600,720);await shot("wide")
 print("RACE190_QA gates=",race.player.next_gate," finish=",race.player.finish_time," elapsed=",race.elapsed)
 race.free();get_tree().quit()
func _physics_process(_delta):
 if not auto or not is_instance_valid(race) or not race.running:return
 var p=race.player;var projection=race.course.project(p.position);var goal=race.course.at(projection.s+130.)+race.course.tangent(projection.s).orthogonal()*race.course.ai_lane(projection.s,-80.,p.can_jump)
 var wish=(goal-p.position).normalized()
 for pair in [["move_right",maxf(wish.x,0.)],["move_left",maxf(-wish.x,0.)],["move_down",maxf(wish.y,0.)],["move_up",maxf(-wish.y,0.)]]:
  if pair[1]>.001:Input.action_press(pair[0],pair[1])
  else:Input.action_release(pair[0])
