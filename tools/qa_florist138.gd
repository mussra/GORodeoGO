extends Node
var world:Node2D
var layer:CanvasLayer
var title:Label
func _ready():run.call_deferred()
func shot(file:String,text:String):
 title.text=text
 await get_tree().process_frame;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/florista138-"+file+".png")
func move_to(pos:Vector2):
 world.player.position=pos;world.player.velocity=Vector2.ZERO;world.player.set_physics_process(false)
 world._update_chunks()
 var count:int=0
 while (not world._build_queue.is_empty() or not world._flora_layer138.pending.is_empty()) and count<600:
  world._drain_chunk_builds();await get_tree().process_frame;count+=1
 await get_tree().create_timer(.2).timeout
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es")
 SaveData.save_path="user://qa-florist138.dat";SaveData.trial_session_active=false;SaveData._load_valid=true;SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.world_edits=[];SaveData.world_flora138={};SaveData.world_discovered=[];SaveData.world_missions={};SaveData.world_quests={};SaveData.horse_collection.seed_trial();SaveData.world_position=WorldNominal98.home()
 world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 var count:int=0
 while world._loading_world and count<1000:await get_tree().process_frame;count+=1
 world.player.set_physics_process(false);world._toasts.visible=false
 layer=CanvasLayer.new();layer.layer=200;add_child(layer);var bar=ColorRect.new();bar.color=Color("10252d");bar.size=Vector2(1280,56);layer.add_child(bar);title=Label.new();title.position=Vector2(18,16);title.add_theme_font_size_override("font_size",23);title.add_theme_color_override("font_shadow_color",Color.BLACK);title.add_theme_constant_override("shadow_outline_size",8);layer.add_child(title)
 var state:Dictionary=SaveData.world_flora138
 print("START138 ",state)
 for id in ["florist_blue105","florist_gold105"]:SaveData.world_quests[id]={"status":"done","count":3,"events":["a","b","c"],"thanked":true}
 await move_to(FloristJourney138.home_door(752026)+Vector2(90,90))
 await shot("cultivos","Cultivos cercados junto a la floristería · partida V3 real")
 world._open_npc(world._npcs98()[1]);await shot("encargo","Encargo nuevo · original de flores azules/doradas conservado")
 world._journey_action138("begin","red");await move_to(FloristJourney138.sample_point(state,"red")+Vector2(80,0))
 await shot("amapolas","Campo silvestre de amapolas · renderer integrado, no preview aislada")
 world.player.position=FloristJourney138.sample_point(state,"red");world._tick_flora138();assert(FloristJourney138.stage(SaveData.world_flora138,"red")=="sample")
 await move_to(FloristJourney138.door(state)+Vector2(110,60));world._open_npc(world._npcs98()[2]);await shot("destino","Otra florista real · la muestra recogida sirve igual que pedirla")
 world._close_npc();await move_to(FloristJourney138.home_door(752026)+Vector2(90,90));world._open_npc(world._npcs98()[1]);await shot("entregar","La entrega se confirma al volver a la florista de origen")
 world._journey_action138("deliver","red");assert(SaveData.world_flora138.fields.red)
 await move_to(FloristJourney138.field_rect(state,"red",true,752026).get_center())
 await shot("efecto","Entrega persistente · nuevo cultivo de amapolas al sur de la tienda")
 # The other route: accept violet, obtain directly from destination, return.
 await move_to(FloristJourney138.home_door(752026)+Vector2(90,90));world._journey_action138("begin","violet")
 await move_to(FloristJourney138.door(state)+Vector2(110,60));world._open_npc(world._npcs98()[2]);await shot("muestra-pista","Dos vías válidas: muestra directa o pista para recogerla")
 world._journey_action138("sample","violet")
 await move_to(FloristJourney138.sample_point(state,"violet")+Vector2(80,0));await shot("violetas","Campo silvestre de violetas · denso e irregular, sin nodos por flor")
 await move_to(FloristJourney138.home_door(752026)+Vector2(90,90));world._journey_action138("deliver","violet");world._open_npc(world._npcs98()[1]);await shot("gracias","Entregas terminadas · reconocimiento de los dos cultivos")
 world._close_npc()
 var saved:Dictionary=SaveData.world_flora138.duplicate(true);SaveData.load_progress();assert(SaveData.world_flora138==saved)
 for field in FloristJourney138.descriptors(saved,752026):
  if not field.planted:
   var r:Rect2=field.rect
   for x in range(WorldMap.chunk_at(r.position).x-1,WorldMap.chunk_at(r.end).x+2):
    for y in range(WorldMap.chunk_at(r.position).y-1,WorldMap.chunk_at(r.end).y+2):SaveData.mark_world_discovered(WorldMap.chunk_key(x,y))
 await move_to(FloristJourney138.door(saved))
 world._toggle_map();world._map_overlay._ensure_terrain();await shot("mapa","Campos en el mapa · solo los chunks ya descubiertos")
 print("FINISH138 saved/reloaded ",saved," tile worst_usec=",world._flora_layer138.tile_build_usec," flowers built=",world._flora_layer138.built_flower_count," active tiles=",world._flora_layer138.tiles.size())
 get_tree().quit()
