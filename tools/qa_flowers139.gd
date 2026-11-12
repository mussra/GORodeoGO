extends Node
var world:Node2D
var title:Label
func _ready():run.call_deferred()
func shot(name_:String,text:String):
 title.text=text
 await get_tree().process_frame;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/flores139-"+name_+".png")
func move_to(p:Vector2):
 world.player.position=p;world.player.velocity=Vector2.ZERO;world._update_chunks()
 while not world._build_queue.is_empty():world._drain_chunk_builds();await get_tree().process_frame
 world.player.set_physics_process(false)
 await get_tree().create_timer(.15).timeout
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es")
 SaveData.save_path="user://qa139.dat";SaveData.trial_session_active=false;SaveData._load_valid=true;SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.world_edits=[];SaveData.world_flora138={};SaveData.world_discovered=[];SaveData.world_missions={};SaveData.world_quests={};SaveData.horse_collection.seed_trial();SaveData.world_position=WorldNominal98.home()
 world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 world.set_process(false);world.set_physics_process(false);world.player.set_physics_process(false)
 var layer:=CanvasLayer.new();layer.layer=200;add_child(layer)
 var bar:=ColorRect.new();bar.color=Color("10252d");bar.size=Vector2(1280,56);layer.add_child(bar)
 title=Label.new();title.position=Vector2(18,16);title.add_theme_font_size_override("font_size",23);layer.add_child(title)
 var door:=FloristJourney138.home_door(752026)
 NpcQuests.accept(SaveData.world_quests,"florist_blue105");world._tick_npcs();world._toasts.clear()
 await move_to(door+Vector2(90,90));world._open_npc(world._npcs98()[1]);await shot("tienda","Encargo: flores en la zona salvaje de este pueblo, lejos de la tienda")
 world._close_npc();world.player.set_physics_process(false)
 var positions:=WorldFlowers105.positions(752026,3,door,"florist_blue105")
 for p in positions:print("TARGET139 ",p," distance=",p.distance_to(door))
 await move_to(positions[0]+Vector2(90,0));await shot("salvaje","Flor de misión en terreno salvaje · no en la puerta ni sobre el camino")
 # Simulated exploration only, to make the distribution visible in this QA map.
 for x in range(-1,4):
  for y in range(-2,3):SaveData.mark_world_discovered(WorldMap.chunk_key(x,y))
 await move_to(door+Vector2(90,90));world._toggle_map();world._map_overlay.zoom=.7;world._map_overlay._ensure_terrain();await shot("mapa","Mapa de prueba: tres flores azules repartidas alrededor del pueblo")
 world._toggle_map();world._toasts.clear();world._toasts.set_process(false)
 for p in positions:world.player.position=p;world._tick_npcs()
 assert(world._toasts.active.size()==1 and world._toasts.pending.is_empty())
 assert(world._toasts.active[0].text=="Flores azules · 3/3")
 await move_to(positions[-1]);await shot("aviso","Tres recogidas seguidas: solo queda el contador más reciente, 3/3")
 print("QA139_DONE active=",world._toasts.active[0].text," pending=",world._toasts.pending.size())
 get_tree().quit()
