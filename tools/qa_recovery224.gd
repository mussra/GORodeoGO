extends Node
var world:Node2D
func _ready():run.call_deferred()
func shot(id:String):
 for i in 4:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/recovery224-"+id+"-960.png")
func touch(p:Vector2,down:bool):
 var e:=InputEventScreenTouch.new();e.position=get_viewport().get_final_transform()*p;e.index=0;e.pressed=down;Input.parse_input_event(e);Input.flush_buffered_events()
func drag(p:Vector2):
 var e:=InputEventScreenDrag.new();e.position=get_viewport().get_final_transform()*p;e.index=0;Input.parse_input_event(e);Input.flush_buffered_events()
func run():
 get_tree().root.size=Vector2i(960,540);TranslationServer.set_locale("es");GameState.brand_intro_played=true
 SaveData.save_path="user://recovery224-visual-only.cfg";SaveData.world_seed=7781;SaveData.world_generator_version=3;SaveData.world_position=Vector2(1800,200)
 SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.world_quests={};NpcQuests.accept(SaveData.world_quests,"farmer_pigs")
 world=load("res://src/Presentation/frontier_world.tscn").instantiate();add_child(world)
 while world._loading_world:await get_tree().process_frame
 await get_tree().create_timer(.8).timeout;world.set_physics_process(false);world.set_process(false)
 touch(Vector2(100,400),true);await get_tree().physics_frame;drag(Vector2(10,420));await get_tree().create_timer(.15).timeout;await shot("moving")
 drag(Vector2(-20,420));await get_tree().create_timer(.5).timeout;await shot("stopped")
 print("RECOVERY224 move=",Input.get_vector("move_left","move_right","move_up","move_down")," speed=",world.player.velocity.length())
 world.player.set_physics_process(false)
 var pig=world._lasso_pigs()[0];var ridge:Dictionary=WorldTerrain103.ridge(7781,0,0);pig.position=Vector2(ridge.boxes[0].end.x+19.,200.);pig.home=pig.position;var start:Vector2=pig.position
 world.player.position=pig.position+Vector2(130,0);get_viewport().get_camera_2d().reset_smoothing();await shot("pig-start")
 for i in 40:world.player.position=pig.position+Vector2(130,0);world._tick_pigs(.025)
 get_viewport().get_camera_2d().reset_smoothing();await shot("pig-escape");print("RECOVERY224 pig_distance=",pig.position.distance_to(start)," blocked=",WorldTerrain103.blocked(7781,pig.position,18.))
 world.player.lasso.resolve_capture(pig.global_position)
 for i in 100:
  if not is_instance_valid(pig) or pig.is_queued_for_deletion():break
  world.player.position=pig.position+Vector2(130,0);world._tick_pigs(.1)
 await get_tree().process_frame;get_viewport().get_camera_2d().reset_smoothing();await shot("pig-captured");print("RECOVERY224 captured=",SaveData.world_pig_captures.size())
 world.free();get_tree().quit()
