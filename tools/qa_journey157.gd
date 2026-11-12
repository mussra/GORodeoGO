extends Node
var world:Node2D
var caption:Label
var panel:HorsePanel
var ui:Control
var manifest:Array=[]
var start:int
func _ready():run.call_deferred()
func shot(id:String,text:String,kind:String):
 caption.text=text
 for i in 4:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/journey157/"+id+".png")
 manifest.append({"id":id,"caption":text,"mode":kind,"elapsed_s":(Time.get_ticks_msec()-start)/1000.})
func move_to(pos:Vector2):
 world.player.position=pos;world.player.velocity=Vector2.ZERO;world.player.set_physics_process(false);world._update_chunks()
 var count:int=0
 while (not world._build_queue.is_empty() or not world._flora_layer138.pending.is_empty()) and count<600:
  world._drain_chunk_builds();await get_tree().process_frame;count+=1
 await get_tree().create_timer(.3).timeout
func show_horse(id:String):
 if is_instance_valid(panel):panel.free()
 panel=HorsePanel.new();panel.page="detail";panel.focus_id=id;ui.add_child(panel)
func run():
 start=Time.get_ticks_msec();process_mode=Node.PROCESS_MODE_ALWAYS;get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es")
 DirAccess.make_dir_recursive_absolute("/downloads/journey157")
 SaveData.save_path="user://journey157-isolated.cfg";SaveData._load_valid=true;SaveData.trial_session_active=false;SaveData.debug_mode=false;SaveData.highest_level_completed=0;SaveData.equipment_points=0;SaveData.points_legacy_credit_applied=true;SaveData.dual_lasso_intro_shown=true
 SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.world_position=WorldNominal98.home();SaveData.world_edits=[];SaveData.world_discovered=[];SaveData.world_missions={};SaveData.world_quests={};SaveData.world_flora138={};SaveData.world_roaming139={};SaveData.world_cousins140={};SaveData.world_places144={};SaveData.country_ledger146={};SaveData.world_tamed=[];SaveData.world_pig_captures=[];SaveData.world_pigs_sold=0;SaveData.world_goat_captures=[]
 SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.save_progress()
 var menu_layer:=CanvasLayer.new();menu_layer.layer=150;add_child(menu_layer);ui=Control.new();ui.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);menu_layer.add_child(ui)
 var layer:=CanvasLayer.new();layer.layer=220;add_child(layer);var bg:=ColorRect.new();bg.color=Color("10252df0");bg.position=Vector2(0,653);bg.size=Vector2(1280,67);layer.add_child(bg);caption=Label.new();caption.position=Vector2(18,663);caption.size=Vector2(1240,53);caption.add_theme_font_size_override("font_size",20);layer.add_child(caption)
 GameState.selected_level=1;var level=load("res://src/Presentation/level_0.tscn").instantiate();add_child(level);await get_tree().create_timer(.5).timeout;await shot("01-inicio","PARTIDA AISLADA NUEVA · Original y nivel 1\nAuditoría de escritorio. No se toca la partida de Antonio.","fresh")
 level._trigger_win();await shot("02-nivel","SIMULADO · Victoria del nivel 1 activada para revisar recompensa y guardado\nNo se ha jugado el nivel completo.","simulated");get_tree().paused=false;level.free()
 world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 world.set_process(false);world.set_physics_process(false);world.player.set_physics_process(false);world._toasts.clear();world._toasts.visible=false
 await move_to(WorldNominal98.home()+Vector2(0,500))
 var h=world.WildHorseScript.new();h.setup({"pos":world.player.position+Vector2(180,0),"member_id":"audit157#0","member_index":0,"traits":{"coat":3,"mane":1,"pattern":1},"temperament":.2,"stats":{"speed":260}});h.set_meta("c",Vector2i(99,99));world.add_child(h);h.set_physics_process(false);world._herd_horses[h.herd.member_id]=h;h.position=world.player.position+Vector2(180,0)
 await get_tree().create_timer(1.).timeout
 world.player.lasso.can_capture=func():return true
 world.player.lasso.resolve_capture(h.global_position)
 assert(h.roped)
 await shot("03-lazo","CAPTURA PREPARADA · Se resuelve directamente una caída acertada\nSin gesto ni vuelo jugado; después avanza la confianza con sus reglas.","prepared-controller-resolution")
 for tick in 250:
  world._tick_taming(.02)
  if SaveData.horse_collection.find("world_99_99_0").is_empty():await get_tree().create_timer(.02).timeout
  else:break
 assert(not SaveData.horse_collection.find("world_99_99_0").is_empty());show_horse("world_99_99_0");await shot("04-caballo","CAPTURA GUARDADA · El caballo entra de verdad en la colección\nPosición y animal preparados; confianza avanzó con las reglas del juego.","prepared-controller-resolution");panel.free();panel=null
 await move_to(world._npcs98()[0].position);NpcQuests.accept(SaveData.world_quests,"farmer_pigs")
 for i in 3:assert(SaveData.record_pig104("journey157:pig"+str(i)))
 world._refresh_livestock104();world._refresh_quest_hud();world._refresh_missions();world._open_npc(world._npcs98()[0]);await shot("05-cerdos","SIMULADO · Se registran 3 capturas, sin perseguir a los cerdos\nEncargo completado: inventario de 3 y venta disponible, sin pulsar vender.","simulated");world._close_npc();NpcQuests.acknowledge(SaveData.world_quests,"farmer_pigs");NpcQuests.accept(SaveData.world_quests,"farmer_goats")
 for i in 3:assert(SaveData.record_goat104("journey157:goat"+str(i)))
 world._refresh_livestock104();world._refresh_quest_hud();world._refresh_missions();world._open_npc(world._npcs98()[0]);await shot("06-cabras","SIMULADO · Se registran 3 cabras, sin jugar sus embestidas\nEl encargo cambia a completado y el granjero da las gracias.","simulated");world._close_npc()
 NpcQuests.accept(SaveData.world_quests,"florist_blue105")
 for i in 3:NpcQuests.record(SaveData.world_quests,"collect_flower","florist_blue105","auditflower"+str(i))
 await move_to(world._npcs98()[1].position);world._open_npc(world._npcs98()[1]);await shot("07-flores","SIMULADO · Tres eventos de recogida, sin recorrer el campo\nSe revisa la entrega completada de flores azules.","simulated");world._close_npc()
 await move_to(VillageCousins140.point(SaveData.world_cousins140,"home")+Vector2(90,30));world._open_cousin140("home");await shot("08-loco","DIÁLOGO REAL CON EL LOCO · Llegada por atajo\nSe abre su pista y queda anotada en el diario. No se recorrió el camino.","shortcut-dialogue");world._close_npc()
 SaveData.highest_level_completed=20;SaveData.equipment_points=100000
 var galaxy:Dictionary
 for offer in HorseMarket.offers(20):
  if offer.traits.get("finish","")=="galaxy":assert(SaveData.buy_market_horse(offer));galaxy=SaveData.horse_collection.horses[-1];break
 assert(not galaxy.is_empty());show_horse(galaxy.id);await shot("09-galaxy","COMPRA REAL CON PROGRESO Y PUNTOS SIMULADOS · Galaxy del mercado\nEl catálogo de nivel 20 ofrece uno; aquí no se han jugado esos 20 niveles.","simulated-prerequisites");panel.free();panel=null
 var child:=SaveData.breed_horses(galaxy.id,"world_99_99_0",{});assert(not child.is_empty());show_horse(child.id);await shot("10-cria","CRÍA CREADA POR LAS REGLAS REALES · Galaxy + caballo capturado\nLa elección hereda Galaxy. Es potro, no unicornio ni Galaxy puro.","simulated-prerequisites");panel.free();panel=null
 for n in range(1,21):HorseMastery.record(SaveData.horse_collection,galaxy.id,n)
 SaveData.horse_collection.selected=galaxy.id;show_horse(galaxy.id);assert(HorseMastery.galaxy_master(galaxy));await shot("11-maestro","SIMULADO · Se marcan 20 niveles distintos con este Galaxy\nLa ficha llega al 100%. No representa 20 niveles jugados.","simulated");panel.free();panel=null
 world.visible=false
 for child_layer in world.get_children():
  if child_layer is CanvasLayer:child_layer.visible=false
 var country:=CountryPreview146.new();add_child(country);country.player.set_physics_process(false);await shot("12-pais","PAÍS NUEVO · Entrada de prueba real, sin puerta normal ni ritual\nEl desbloqueo narrativo sigue pendiente. La isla sí se puede explorar.","test-entry")
 country.player.position=country.data.sites.source;country.camera.reset_smoothing();country._process(0.);await shot("13-fuente","FUENTE REAL · Llegada por atajo, no recorrido completo\nNO hay ritual de obtención implementado: no se consigue un unicornio.","shortcut-unimplemented-ritual");country.free()
 var atlas:=UnicornAtlasPanel.new();ui.add_child(atlas);await shot("14-unicornio","ESTADO REAL · Atlas de unicornios aún sin descubrir\nNo se fabrica una obtención: Galaxy y unicornio son identidades distintas.","unimplemented");atlas.free()
 SaveData.save_progress();var output:=FileAccess.open("/downloads/journey157/manifest.json",FileAccess.WRITE);output.store_string(JSON.stringify(manifest,"  "));print("JOURNEY157_COMPLETE ",manifest.size()," snapshots elapsed_s=",(Time.get_ticks_msec()-start)/1000.);get_tree().quit()
