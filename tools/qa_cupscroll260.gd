extends Node
var reports:Array=[]
func _ready():run.call_deferred()
func touch(p:Vector2,down:bool):
 var e:=InputEventScreenTouch.new();e.position=get_viewport().get_final_transform()*p;e.index=0;e.pressed=down;Input.parse_input_event(e);Input.flush_buffered_events()
func drag(p:Vector2):
 var e:=InputEventScreenDrag.new();e.position=get_viewport().get_final_transform()*p;e.index=0;Input.parse_input_event(e);Input.flush_buffered_events()
func collect(n:Node,out:Array):
 if n is ScrollContainer:out.append(n)
 for c in n.get_children():collect(c,out)
func check(root:Node,label_:String):
 await get_tree().create_timer(.15).timeout
 var views:Array=[];collect(root,views)
 for v in views:
  if not v.is_visible_in_tree():continue
  assert(v.has_meta("shared_scroll260"))
  var content:Control
  for c in v.get_children():
   if c is Control and not c is ScrollBar:content=c;break
  var natural:float=v.get_v_scroll_bar().max_value-v.get_v_scroll_bar().page
  # Tiny/empty real datasets still exercise this screen's real scroll control,
  # with a temporary tall reading fixture. No player state is saved.
  var extra:Control
  if natural<140:
   if content is Container:
    extra=Control.new();extra.custom_minimum_size=Vector2(100,1800);content.add_child(extra)
   elif content!=null:content.custom_minimum_size.y=maxf(content.custom_minimum_size.y,1800)
  await get_tree().create_timer(.1).timeout
  v.scroll_vertical=0
  var p:Vector2=v.get_global_rect().get_center()+Vector2(0,60)
  touch(p,true);await get_tree().process_frame
  for i in 6:drag(p-Vector2(0,20*(i+1)));await get_tree().process_frame
  touch(p-Vector2(0,120),false);await get_tree().create_timer(.08).timeout
  assert(v.scroll_vertical>50);var value:int=v.scroll_vertical
  var manager:SharedScroll260=GameState.get_node("SharedScroll260");manager.velocity=Vector2.ZERO
  var wheel:=InputEventMouseButton.new();wheel.position=get_viewport().get_final_transform()*p;wheel.button_index=MOUSE_BUTTON_WHEEL_DOWN;wheel.pressed=true;Input.parse_input_event(wheel);Input.flush_buffered_events();await get_tree().process_frame
  assert(v.scroll_vertical>value)
  var bar:ScrollBar=v.get_v_scroll_bar();v.scroll_vertical=0;await get_tree().process_frame
  p=bar.get_global_rect().position+Vector2(12,12);touch(p,true);await get_tree().process_frame;drag(p+Vector2(0,120));await get_tree().process_frame;touch(p+Vector2(0,120),false);await get_tree().process_frame
  assert(v.scroll_vertical>50)
  reports.append({"screen":label_,"drag":value,"wheel":true,"bar":true,"fixture_for_short_content":natural<140})
  print("SCROLL260 ",label_," drag=",value," wheel=true bar=true fixture=",natural<140)
  if label_ in ["horse-detail","ranch","settings","collection"]:
   await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png("/downloads/scroll260-"+label_+".png")
  manager.cancel()
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es");GameState.sound_enabled=false;GameState.brand_intro_played=true
 SaveData.save_path="user://qa260.dat";SaveData.horse_collection.seed_trial();SaveData.horse_collection.add_trial_parents();SaveData.rodeo_intro240=true;SaveData.highest_level_completed=40;SaveData.world_generator_version=6;SaveData.world_seed=752026
 for kind in ["cup"]:
  var panel:Node
  match kind:
   "horse-detail","collection":
    panel=HorsePanel.new();add_child(panel);panel.show_page("detail" if kind=="horse-detail" else "collection")
   "ranch":panel=RanchPasturePanel141.new();add_child(panel)
   "equipment":panel=EquipmentPanel.new();add_child(panel)
   "genealogy":panel=GenealogyPanel.new();add_child(panel)
   "filters":
    panel=FilterDrawer.new();add_child(panel)
    for i in 15:panel.add_choice(str(i),"Campo "+str(i),[{"label":"Uno","value":0},{"label":"Dos","value":1}],0,false)
   "notes":panel=MapNotesList162.new();add_child(panel)
   "quests":
    panel=QuestDetails179.new();panel.position=Vector2(200,120);panel.size=Vector2(800,420);add_child(panel)
    for i in 15:panel._card("Encargo "+str(i),"Lectura de objetivo","En curso",0,3)
   "npc-story":
    panel=NpcDialog.new();add_child(panel);panel.setup_story("Granjero","Historia","Una historia larga. ".repeat(300))
   "settings","campaign":
    panel=load("res://src/Presentation/main_menu.tscn").instantiate();add_child(panel);await get_tree().create_timer(.15).timeout
    if kind=="settings":panel._show_settings()
    else:panel._show_levels()
   "cup":
    # Use the actual cup screen without changing the selected scene on a lock.
    SaveData.highest_level_completed=40;SaveData.rodeo_intro240=true;SaveData.victories240={"wins":{"race":2,"duel":1}};SaveData.world_places144={"visited":{"town1":true,"town2":true}};panel=load("res://src/Presentation/race_cup194.gd").new();add_child(panel)
  await check(panel,kind);panel.free();await get_tree().process_frame
 var f:=FileAccess.open("/downloads/scroll260.json",FileAccess.WRITE);f.store_string(JSON.stringify(reports,"  "));f.close()
 get_tree().quit()
