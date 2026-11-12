extends Node
func _ready():run.call_deferred()
func run():
 var small:bool=OS.get_environment("MARKER99_SMALL")=="1"
 get_tree().root.size=Vector2i(896,414) if small else Vector2i(1598,720)
 SaveData.save_path="user://qa99-only.dat";SaveData.trial_session_active=true;SaveData.world_seed=752026;SaveData.world_generator_version=2;SaveData.world_edits=[];SaveData.world_discovered=[];SaveData.world_missions={};SaveData.world_quests={};SaveData.horse_collection.seed_trial();SaveData.world_position=WorldNominal98.home()
 var world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 await get_tree().create_timer(.8).timeout
 world.player.set_physics_process(false);world.set_process(false);world.set_physics_process(false);world.player.velocity=Vector2.ZERO
 var map=world._map_overlay
 map.set_process(false);map._pulse=0
 for data in [{"name":"mini","expanded":false,"zoom":1.},{"name":"grande","expanded":true,"zoom":1.},{"name":"menos","expanded":true,"zoom":.5},{"name":"mas","expanded":true,"zoom":3.}]:
  map.expanded=data.expanded;map.zoom=data.zoom;map.pan=Vector2.ZERO;map._layout();map._close_btn.visible=data.expanded
  for button in map._zoom_btns:button.visible=data.expanded
  map._ensure_terrain();map.queue_redraw()
  await get_tree().process_frame;await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png("/downloads/marcador99-"+("telefono-" if small else "")+data.name+".png")
  var pos:Vector2=map._to_map(world.player.position,map._map_geometry.data.mins,map._map_geometry.cell,map._map_geometry.origin)+map.position
  print("MARKER99 ",data.name," center=",pos," cell=",map._map_geometry.cell," screen-scale=",map.get_viewport().get_stretch_transform().get_scale())
 get_tree().quit()
