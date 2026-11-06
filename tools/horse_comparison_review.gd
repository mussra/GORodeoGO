extends SceneTree
var save:Node
var level:Node
var p:Node
var note:Label
var results:Array=[]
func _initialize()->void:call_deferred("run")
func release()->void:
 for a in ["move_left","move_right","move_up","move_down"]:Input.action_release(a)
func sample(frames:int)->void:
 for i in frames:await physics_frame
func scene_for(id:String)->void:
 release()
 if is_instance_valid(level):level.free()
 save.horse_collection.selected=id
 root.get_node("GameState").selected_level=1
 level=load("res://src/Presentation/level_0.tscn").instantiate();root.add_child(level)
 await physics_frame
 p=level.player;p.global_position=Vector2.ZERO;p.velocity=Vector2.ZERO
 while level._active_bulls.size()<2:
  var extra=level._active_bulls[0].duplicate();level.add_child(extra);extra.set_player(p);level._active_bulls.append(extra)
 for b in level._active_bulls:b.set_physics_process(false);b.global_position=Vector2(2000,2000)
func run()->void:
 save=root.get_node("SaveData");save.save_path="user://qa_horse_compare.dat";save.horse_collection=HorseCollection.new();save.horse_collection.seed_trial();save.horse_collection.add_trial_parents()
 var child:Dictionary=save.horse_collection.breed("trial_a","trial_b",{"coat":0,"mane":1})
 save.mature_horse_trial(child.id)
 save.highest_level_completed=5;save.dual_lasso_intro_shown=true;save.equipment_owned.assign(["whip_basic"]);save.equipment_equipped={"whip":"whip_basic"}
 AudioServer.set_bus_mute(0,true)
 var layer:=CanvasLayer.new();layer.layer=100;root.add_child(layer)
 var bg:=ColorRect.new();bg.color=Color(0,0,0,.9);bg.position=Vector2(10,60);bg.size=Vector2(1260,102);layer.add_child(bg)
 note=Label.new();note.position=Vector2(28,70);note.add_theme_font_size_override("font_size",23);layer.add_child(note)
 for id in ["original",child.id]:
  var who:String="ORIGINAL" if id=="original" else "CRÍA A+B"
  await scene_for(id)
  note.text=who+" · ensayo reproducible en pista aislada\nMismas mejoras (+15% velocidad) · toros ajenos congelados"
  await sample(24)
  var start:Vector2=p.global_position
  Input.action_press("move_right");await sample(90)
  var speed:float=p.velocity.length();var distance:float=p.global_position.distance_to(start)
  note.text="%s · velocidad real %.1f px/s · recorrido 1,5s: %.1fpx\nAceleración %.0f px/s² (misma entrada y mejoras)"%[who,speed,distance,p.acceleration]
  assert(is_equal_approx(speed,299.0 if id=="original" else 322.0))
  await sample(45)
  p.global_position=Vector2.ZERO;p.velocity=Vector2(speed,0)
  Input.action_release("move_right");Input.action_press("move_left")
  var frames:int=0
  while p.velocity.x>=0 and frames<100:await physics_frame;frames+=1
  var reverse:float=frames/60.0
  note.text="%s · inversión de derecha a izquierda\nCruza velocidad cero en %.3fs (%.0f px/s²)"%[who,reverse,p.acceleration]
  await sample(60)
  release();p.cancel_input();p.global_position=Vector2.ZERO;p.velocity=Vector2.ZERO
  for i in 2:
   var b:Node=level._active_bulls[i];b.global_position=Vector2(-110-i*90,45*i);b.controller=BullController.new(BullState.State.CONTROLLED);b.controller.state_changed.connect(b._on_state_changed);b._on_state_changed(BullState.State.CONTROLLED);b.set_physics_process(true)
  level._update_nerves_hud();assert(p._active_capture_count==2)
  Input.action_press("move_right");await sample(90)
  var tow:float=p.velocity.length();assert(is_equal_approx(tow,speed*p.dual_capture_speed_multiplier))
  note.text="%s · 2 toros controlados y siguiéndolo\nVelocidad real %.1f px/s = %.0f%% de %.1f · capacidad sigue siendo2"%[who,tow,p.dual_capture_speed_multiplier*100,speed]
  print("MEASURED ",who," speed=",speed," distance1.5=",distance," reversal_s=",reverse," towing=",tow," captures=",p._active_capture_count)
  results.append({"horse":who,"speed":speed,"distance":distance,"reverse":reverse,"towing":tow})
  await sample(75)
 release();level.free()
 var before:int=save.horse_collection.horses.size();save.record_victory(6);var after:int=save.horse_collection.horses.size();assert(after==before+1)
 var panel=load("res://src/Presentation/horse_panel.gd").new();root.add_child(panel)
 note.text="LOGRO DEMO: primera victoria de nivel6 añade1caballo aleatorio\nGuardado real: %d → %d caballos · regla provisional, sin costes ni rarezas"%[before,after]
 await sample(120)
 var f:=FileAccess.open("/downloads/horse-measurements.json",FileAccess.WRITE);f.store_string(JSON.stringify(results,"  "));f.close()
 DirAccess.remove_absolute("user://qa_horse_compare.dat");quit()
