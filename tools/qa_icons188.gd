extends Node
func shot(id:String):
 for i in 6:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/icons188-"+id+".png")
func _ready():process_mode=Node.PROCESS_MODE_ALWAYS;run.call_deferred()
func run():
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(960,540);SaveData.trial_session_active=true;SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.horse_collection.add_trial_parents()
 var panel:=HorsePanel.new();add_child(panel);panel.page="hub";panel._refresh();await shot("menu");panel.queue_free();await get_tree().process_frame
 SaveData.trial_session_active=false;SaveData.save_path="user://icons188-qa.dat";SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.world_position=WorldNominal98.home();SaveData.country_ledger146={}
 var world:=CountrySession152.new();world.session_state=CountryLedger146.enter(CountryLedger146.fresh(752026,3),SaveData.world_position,752026);add_child(world);await get_tree().physics_frame;world.activate152();world.player.set_physics_process(false);world.set_process(false);world._process(0.)
 world.show_map();world._map_overlay._process(.01);await shot("map");world.free()
 SaveData.world_edits=[];SaveData.world_discovered=[];SaveData.world_missions={};SaveData.world_quests={};SaveData.world_flora138={}
 var frontier=load("res://src/Presentation/frontier_world.gd").new();add_child(frontier)
 while frontier._loading_world:await get_tree().process_frame
 frontier.set_process(false);frontier.set_physics_process(false);frontier.player.set_physics_process(false)
 await get_tree().create_timer(.8).timeout
 SaveData.world_discovered=["0,0"];frontier.player.position+=Vector2(600,0);frontier._toggle_map();frontier._map_overlay._terrain_valid=false;frontier._map_overlay._process(.01);frontier._map_overlay._find_player108();await shot("ranch-map");frontier.free()
 var host:=Control.new();host.theme=RanchTheme.create();host.size=Vector2(1280,720);add_child(host)
 var bg:=ColorRect.new();bg.color=Color("10252d");bg.size=Vector2(1280,720);host.add_child(bg)
 var title:=Label.new();title.text="Misma lógica · nuevos dibujos de Ant";title.position=Vector2(30,20);host.add_child(title)
 for i in 4:
  var at:=Vector2(90+i*150,130)
  var c:=Control.new();c.position=at;host.add_child(c)
  c.draw.connect(func():MapPlayerMarker99.draw(c,Vector2.ZERO,Vector2.from_angle(i*PI/2.)*100.,.5))
 for i in 3:
  var flower:=FlowerQuestGlyph105.new();flower.position=Vector2(30+i*230,250);flower.color=[Color("68cfff"),Color("e8688b"),Color("ffd35c")][i];flower.caption=["Azul","Rosa","Amarilla"][i];host.add_child(flower)
 var loop:=Control.new();loop.position=Vector2(50,390);loop.size=Vector2(100,70);host.add_child(loop)
 loop.draw.connect(func():AntIcons188.draw_fit(loop,7,Rect2(0,0,100,70)))
 for i in 2:
  var lock:=Control.new();lock.position=Vector2(260+i*120,400);host.add_child(lock)
  lock.draw.connect(func():AntIcons188.draw_fit(lock,3+i,Rect2(0,0,50,50)))
 await shot("details");host.free()
 SaveData.dual_lasso_intro_shown=true;GameState.selected_level=18
 var level=load("res://src/Presentation/level_0.tscn").instantiate();add_child(level);await get_tree().physics_frame;await get_tree().physics_frame
 await shot("arena")
 for i in range(2):
  var e:=InputEventScreenTouch.new();e.index=i;e.position=Vector2(180+600*i,420);e.pressed=true;Input.parse_input_event(e)
 await shot("joystick-pressed")
 for i in range(2):
  var e:=InputEventScreenTouch.new();e.index=i;e.position=Vector2(180+600*i,420);e.pressed=false;Input.parse_input_event(e)
 await shot("joystick-released")
 var map:ArenaMinimap
 for layer in level.get_children():
  if layer is CanvasLayer:
   for item in layer.get_children():
    if item is ArenaMinimap:map=item
 level._puzzle_corrals[0].opened=true
 map.set_expanded(true);await shot("arena-map");map.set_expanded(false)
 level.hud.show_dual_lasso_intro();await shot("double-lasso");level.free()
 print("ICONS188_QA_OK");get_tree().quit()
