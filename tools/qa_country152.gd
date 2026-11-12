extends Node
var frontier:Node2D
var session:CountrySession152
func _ready():run.call_deferred()
func shot(id:String):
 await get_tree().process_frame;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/country152-"+id+".png")
func current_session()->CountrySession152:
 for child in get_tree().root.get_children():
  if child is CountrySession152:return child
 return null
func run():
 process_mode=Node.PROCESS_MODE_ALWAYS;get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es");SaveData.save_path="user://country152-qa.dat";SaveData._load_valid=true;SaveData.trial_session_active=false;SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.world_position=WorldNominal98.home();SaveData.world_flora138={};SaveData.world_cousins140={};SaveData.world_roaming139={};SaveData.world_places144={};SaveData.world_discovered=[];SaveData.world_missions={};SaveData.world_quests={};SaveData.world_edits=[];SaveData.country_ledger146={};SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 frontier=load("res://src/Presentation/frontier_world.gd").new();get_tree().root.add_child(frontier);get_tree().current_scene=frontier
 while frontier._loading_world:await get_tree().process_frame
 frontier.player.set_physics_process(false);await get_tree().create_timer(.8,true).timeout;frontier._open_navigation();await get_tree().create_timer(.2,true).timeout;await shot("menu")
 frontier._navigation.canvas.get_node("Navigate_country_saved152").pressed.emit()
 for i in 120:
  session=current_session()
  if session!=null and session.activated:break
  await get_tree().process_frame
 assert(session!=null and session.activated);session.player.set_physics_process(false);await shot("entrada")
 session.player.position=session.data.sites.source;session._process(0.);session.camera.reset_smoothing();assert(session.save_now152());var position_:Vector2=session.player.position;var explored:=session.visited_cells.duplicate(true);await shot("fuente-guardada")
 session.show_map();await shot("mapa");get_tree().root.size=Vector2i(960,540);await get_tree().process_frame;await shot("mapa-960");get_tree().root.size=Vector2i(1280,720);await get_tree().process_frame
 session.suspend_to_menu152();await get_tree().process_frame;await get_tree().process_frame;await get_tree().create_timer(.5,true).timeout;assert(current_session()==null);assert(get_tree().current_scene.has_method("_show_equipment"));await shot("menu-principal")
 get_tree().current_scene._world_button.pressed.emit()
 for i in 800:
  session=current_session()
  if session!=null and session.activated:break
  await get_tree().process_frame
 assert(session!=null and session.activated);session.player.set_physics_process(false);assert(session.player.position==position_);assert(session.visited_cells==explored);await get_tree().create_timer(.7,true).timeout;await shot("reanudado")
 frontier=get_tree().current_scene;await session.request_return();await get_tree().process_frame;frontier.player.set_physics_process(false);assert(frontier.visible);assert(SaveData.country_ledger146.active=="frontier");await shot("regreso");print("COUNTRY152_REAL_MENU_RESUME_OK ",position_," cells=",explored.size());get_tree().quit()
