extends Node
var report:Dictionary={"environment":"Desktop Linux, Godot 4.7.2, software-rendered window; not Android hardware","modes":[]}
func _ready():run.call_deferred()
func settle(n:int=6):
 for i in n:await get_tree().process_frame
func capture(name_:String):
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/night169-"+name_+".png")
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es");GameState.brand_intro_played=true
 SaveData.save_path="user://qa-night169.cfg";SaveData._load_valid=true;SaveData.debug_mode=false;SaveData.trial_session_active=false;SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.highest_level_completed=0
 var menu=load("res://src/Presentation/main_menu.tscn").instantiate();add_child(menu);await settle(15)
 menu._show_games213();await settle(15);await capture("games")
 menu.free();await settle()
 var cartoon=load("res://src/Presentation/main_menu_cartoon.tscn").instantiate();add_child(cartoon);await settle(20);await capture("cartoon");cartoon.free();await settle()
 for item in [["race","race190"],["duel","duel193"],["joust","joust196"],["memory","jump_memory207"]]:
  RaceCupSession194.active=false;RaceCourse190.start_selected=false
  var begin:int=Time.get_ticks_usec();var scene=load("res://src/Presentation/"+item[1]+".tscn").instantiate();add_child(scene)
  var build_ms:float=(Time.get_ticks_usec()-begin)/1000.;await settle(10)
  if item[0]=="race":await capture("race-selector");scene._choose_course(0)
  await capture(item[0]);var spans:Array[float]=[];var prev:int=Time.get_ticks_usec()
  for i in 90:
   await get_tree().process_frame
   var now_:int=Time.get_ticks_usec();spans.append((now_-prev)/1000.);prev=now_
  spans.sort();report.modes.append({"mode":item[0],"instantiate_ms":build_ms,"frame_p50_ms":spans[45],"frame_p95_ms":spans[85],"frame_max_ms":spans[-1],"static_memory_bytes":Performance.get_monitor(Performance.MEMORY_STATIC),"node_count":Performance.get_monitor(Performance.OBJECT_NODE_COUNT)})
  scene.free();get_tree().paused=false;await settle()
 var f:=FileAccess.open("/downloads/night169-performance.json",FileAccess.WRITE);f.store_string(JSON.stringify(report,"  "));f.close()
 print("NIGHT169_PERFORMANCE ",JSON.stringify(report));get_tree().quit()
