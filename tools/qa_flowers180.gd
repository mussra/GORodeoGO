extends Node
var world:Node2D
func _ready():run.call_deferred()
func run():
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(1280,720)
 SaveData.save_path="user://perf138.dat";SaveData.trial_session_active=true;SaveData.world_generator_version=3;SaveData.world_seed=752026;SaveData.world_flora138=FloristJourney138.fresh([]);SaveData.world_discovered=[];SaveData.world_quests={};SaveData.world_missions={};SaveData.world_edits=[];SaveData.horse_collection.seed_trial()
 var field:Rect2=FloristJourney138.field_rect(SaveData.world_flora138,"red");SaveData.world_position=field.get_center()
 world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 world.player.set_physics_process(false)
 var layer:FlowerExpansion138=world._flora_layer138
 assert(layer.visible_ready180())
 var result:Dictionary={"startup_visible_ready":true,"frames":0,"missing_visible_tiles":0,"max_tiles":0,"max_pending":0,"tile_build_max_usec":0,"texture_orientation":"negative Y transform corrects QuadMesh UV vertical inversion"}
 for species in ["red","violet"]:
  field=FloristJourney138.field_rect(SaveData.world_flora138,species)
  world.player.position=field.get_center();world.player.velocity=Vector2.ZERO
  for i in 60:await get_tree().process_frame
  assert(layer.visible_ready180())
  await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png("/downloads/flowers180-"+species+"-1280.png")
  var before:Dictionary=SaveData.world_flora138.duplicate(true)
  world.player.position=Vector2(field.position.x-1600.,field.get_center().y);world.player.velocity=Vector2.ZERO
  for i in 60:await get_tree().process_frame
  world.player.velocity=Vector2(520,0)
  for i in 200:
   world.player.position.x+=520./30.
   await get_tree().process_frame
   for c in layer._field_tiles180(layer._camera_rect180().grow(40.)):
    if not layer.tiles.has(c):result.missing_visible_tiles+=1
   result.frames+=1;result.max_tiles=maxi(result.max_tiles,layer.tiles.size());result.max_pending=maxi(result.max_pending,layer.pending.size())
  world.player.position=field.get_center();world.player.velocity=Vector2.ZERO
  for i in 60:await get_tree().process_frame
  for direction in [Vector2.RIGHT,Vector2.DOWN,Vector2.LEFT,Vector2.UP]:
   world.player.velocity=direction*520.
   for i in 60:
    world.player.position+=direction*(520./30.)
    await get_tree().process_frame
    var visible:Dictionary=layer._field_tiles180(layer._camera_rect180().grow(40.))
    for c in visible:
     if not layer.tiles.has(c):result.missing_visible_tiles+=1
    result.frames+=1;result.max_tiles=maxi(result.max_tiles,layer.tiles.size());result.max_pending=maxi(result.max_pending,layer.pending.size())
  assert(SaveData.world_flora138==before)
 assert(result.missing_visible_tiles==0)
 result.tile_build_max_usec=layer.tile_build_usec
 for tile in layer.tiles.values():
  for batch in tile.get_children():
   if batch.multimesh.instance_count>0:assert(batch.multimesh.get_instance_transform_2d(0).y.y<0.)
 var f:=FileAccess.open("/downloads/flowers180-qa.json",FileAccess.WRITE);f.store_string(JSON.stringify(result,"  "));f.close();print("FLOWER180_PRELOAD_AND_ORIENTATION_OK ",JSON.stringify(result));get_tree().quit()
