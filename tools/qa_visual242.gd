extends Node
var world:Node
func _ready():run.call_deferred()
func shot(id:String):
 for i in 5:await get_tree().process_frame
 await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png('/downloads/visual242-'+id+'.png');print('SHOT ',id)
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale('es');GameState.sound_enabled=false;GameState.brand_intro_played=true
 SaveData.save_path='user://visual242-only.cfg';SaveData.trial_session_active=true;SaveData.debug_mode=false
 SaveData.world_seed=752026;SaveData.world_generator_version=6;SaveData.world_position=Vector2(1300,850);SaveData.world_quests={};SaveData.world_discovered=[];SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 world=load('res://src/Presentation/frontier_world.tscn').instantiate();add_child(world)
 while world._loading_world:await get_tree().process_frame
 world.player.set_physics_process(false);world.set_physics_process(false)
 var camera:Camera2D=get_viewport().get_camera_2d();camera.position_smoothing_enabled=false
 var plan:Dictionary=TownEnclosures227.plans(752026).home
 # Stream actual corner before capturing, rather than standalone illustration.
 for target in [plan.polygon[0],plan.polygon[1],plan.gate+Vector2(130,200),Vector2(1000,470)]:
  world.player.position=target+Vector2(0,140);world._update_chunks()
  while not world._build_queue.is_empty():world._step_chunk_build()
  for key in world._chunk_built.keys():world._activate_built(key)
  world.set_process(false)
  await get_tree().create_timer(.3).timeout
  await shot('world-'+str(target))
  world.set_process(true)
 world.player.position=Vector2(1000,470);world.set_process(false)
 world.player.dodge.drawing=true;world.player.dodge.draw_points=PackedVector2Array([Vector2.ZERO,Vector2(100,30),Vector2(200,40)])
 world.player.queue_redraw();await shot('bullet-time')
 world.player.dodge.drawing=false
 world.player.set_physics_process(true)
 var down:=InputEventScreenTouch.new();down.index=1;down.position=Vector2(210,450);down.pressed=true;Input.parse_input_event(down)
 var drag:=InputEventScreenDrag.new();drag.index=1;drag.position=Vector2(245,435);Input.parse_input_event(drag)
 await shot('joystick')
 down.pressed=false;Input.parse_input_event(down)
 world.player.set_physics_process(false)
 # A real cactus from the shared decor renderer, placed near rider for visual review.
 var cactus=load('res://src/Presentation/world_decor.gd').new();cactus.configure121('cactus',world.player.position+Vector2(160,30),1.,0);world.add_child(cactus)
 await shot('cactus')
 world.free();get_tree().quit()
