extends Node
var world:Node
func _ready():run.call_deferred()
func shot(id:String):
 await get_tree().create_timer(.8).timeout;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png('/downloads/osd242-'+id+'.png')
 print('SHOT ',id)
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale('es');GameState.sound_enabled=false
 SaveData.save_path='user://osd242-only.dat';SaveData.trial_session_active=true;SaveData.debug_mode=true
 SaveData.world_seed=752026;SaveData.world_generator_version=6;SaveData.world_position=Vector2(1300,850);SaveData.world_quests={};SaveData.world_discovered=[];SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 for x in range(-4,8):
  for y in range(-4,8):SaveData.world_discovered.append(WorldMap.chunk_key(x,y))
 world=load('res://src/Presentation/frontier_world.tscn').instantiate();add_child(world)
 get_tree().current_scene=self
 while world._loading_world:await get_tree().process_frame
 world.player.set_physics_process(false)
 await shot('frontier')
 world._toggle_map();await shot('map-expanded')
 var map=world._map_overlay
 map._set_zoom(4.);await shot('map-zoom')
 map._begin_drag106(Vector2(350,220));map._drag106(Vector2(440,260));await shot('map-drag');map._end_drag106(Vector2(440,260))
 world._toggle_map();world.player.position=TownEnclosures227.plans(752026).home.gate+Vector2(130,120)
 world.set_process(false);world.set_physics_process(false)
 await shot('sign')
 SaveData.debug_mode=false;world.player.dodge.drawing=true;world.player.dodge.draw_points=PackedVector2Array([Vector2.ZERO,Vector2(100,20),Vector2(200,30)])
 world.player.queue_redraw();await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png('/downloads/osd242-bullet-time.png')
 SaveData.debug_mode=true;get_tree().root.size=Vector2i(640,360);await shot('small')
 world.free();get_tree().quit()
