extends Node
var world:Node2D
func _ready():run.call_deferred()
func shot(name_:String):
 await get_tree().process_frame;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/montanas103-"+name_+".png")
func run():
 get_tree().root.size=Vector2i(1598,720)
 TranslationServer.set_locale("es")
 SaveData.save_path="user://qa103-only.dat";SaveData.trial_session_active=true;SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.world_edits=[];SaveData.world_discovered=[];SaveData.world_missions={};SaveData.world_quests={};SaveData.horse_collection.seed_trial();SaveData.world_position=WorldNominal98.home()
 world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 await get_tree().create_timer(.8).timeout
 world.player.set_physics_process(false);world.player.velocity=Vector2.ZERO
 await shot("pueblo")
 var ridge=WorldTerrain103.ridge(SaveData.world_seed,0)
 world.player.position=ridge.port-Vector2(170,0);world._update_chunks()
 for i in 180:
  world._drain_chunk_builds()
  await get_tree().process_frame
 await get_tree().create_timer(.3).timeout
 await shot("puerto")
 var map=world._map_overlay
 map.expanded=true;map.zoom=1.;map.pan=Vector2.ZERO;map._layout();map._ensure_terrain();map.queue_redraw()
 await shot("mapa")
 map.expanded=false;map._layout();map.queue_redraw()
 world.player.position=ridge.port+Vector2(-220,220)
 world.player.set_physics_process(false)
 var before:Vector2=world.player.position
 # Direct CharacterBody motion to the wall, not a teleport.
 for i in 120:
  world.player.velocity=Vector2(400,0);world.player.move_and_slide()
  await get_tree().physics_frame
 world.player.set_physics_process(false)
 print("MOUNTAINS103 rider_wall before=",before," after=",world.player.position," ridge_x=",ridge.x)
 await shot("colision")
 get_tree().quit()
