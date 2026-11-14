extends Node
var world:Node
func _ready():run.call_deferred()
func shot(name_:String):
 for i in 3:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/garden212-"+name_+".png")
func run():
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(1280,720)
 SaveData.save_path="user://garden212-qa.cfg";SaveData._load_valid=true;SaveData.world_garden212=Garden212.fresh()
 SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.world_flora138={};SaveData.world_cousins140={};SaveData.world_roaming139={};SaveData.world_places144={};SaveData.world_edits=[];SaveData.world_discovered=[];SaveData.world_missions={};SaveData.world_quests={};SaveData.country_ledger146={};SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 world=load("res://src/Presentation/frontier_world.tscn").instantiate();add_child(world)
 await get_tree().create_timer(1.6).timeout
 var cover=get_tree().root.get_node_or_null("FrontierTransition")
 if cover!=null:cover.free()
 world.visible=true;world.set_process(false);world.player.set_physics_process(true)
 var garden:GardenWorld212=world.garden212
 world.player.position=garden.home;get_viewport().get_camera_2d().reset_smoothing()
 world._open_npc(world._npcs98()[1]);await shot("florista");world._close_npc()
 SaveData.garden_action212("introduce");world.player.position=garden.plot;garden.open();await shot("encargo");garden.act("accept");garden.close()
 world.player.position=garden.sample;garden.open();garden.act("sample");garden.close()
 world.player.position=garden.plot+Vector2(-100,85);get_viewport().get_camera_2d().reset_smoothing()
 world._update_chunks()
 while not world._build_queue.is_empty():world._step_chunk_build()
 world._update_chunks()
 for child in world._toasts.get_children():
  if child is CanvasItem:child.visible=false
 garden.open();garden.act("plant");garden.act("water");garden.close()
 await shot("parcela")
 world.player.position=garden.plot+Vector2(0,65)
 SaveData.world_garden212=Garden212.tick(SaveData.world_garden212,900.,0.)
 garden.open();garden.act("harvest");await shot("cosecha");garden.act("feed");await shot("alimento")
 garden.close()
 for map_ in [world._chunk_pending,world._chunk_built]:
  for key in map_:world._discard_builder(map_[key])
 world.free();DirAccess.remove_absolute(SaveData.save_path);get_tree().quit()
