extends Node
var world:Node
func _ready():run.call_deferred()
func shot(id:String):
 for i in 5:await get_tree().process_frame
 await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png('/downloads/visual243-'+id+'.png');print('SHOT ',id)
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale('es');GameState.sound_enabled=false;GameState.brand_intro_played=true
 SaveData.save_path='user://visual242-only.cfg';SaveData.trial_session_active=true;SaveData.debug_mode=false
 SaveData.world_seed=752026;SaveData.world_generator_version=6;SaveData.world_position=Vector2(1300,850);SaveData.world_quests={};SaveData.world_discovered=[];SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 world=load('res://src/Presentation/frontier_world.tscn').instantiate();add_child(world)
 while world._loading_world:await get_tree().process_frame
 world.player.set_physics_process(false);world.set_physics_process(false)
 var camera:Camera2D=get_viewport().get_camera_2d();camera.position_smoothing_enabled=false
 for factor in [1.,.85,.75]:
  world._camera_controls243.set_factor(factor,false)
  await shot('zoom-'+str(factor))
 world._camera_controls243.set_factor(.75,false)
 # Movement + camera UI simultaneously via the same native gesture routing.
 var down:=InputEventScreenTouch.new();down.index=0;down.position=Vector2(210,450);down.pressed=true;Input.parse_input_event(down)
 for i in 3:await get_tree().process_frame
 var drag:=InputEventScreenDrag.new();drag.index=0;drag.position=Vector2(245,435);Input.parse_input_event(drag)
 await shot('zoom-joystick')
 down.pressed=false;Input.parse_input_event(down)
 world._toggle_map();await shot('zoom-map');world._toggle_map()
 get_tree().root.size=Vector2i(640,360);await shot('zoom-small')
 get_tree().root.size=Vector2i(1600,720);await shot('zoom-wide')
 world.free();get_tree().quit()
