extends GutTest
var scene:Node2D
var prior_path:String
func before_each():
 prior_path=SaveData.save_path;SaveData.save_path="user://gesture209.cfg"
func after_each():
 SaveData.save_path=prior_path;DirAccess.remove_absolute("user://gesture209.cfg")
 if is_instance_valid(scene):scene.free()
 get_tree().paused=false;Engine.time_scale=1.
 for a in ["aim_left","aim_right","aim_up","aim_down"]:Input.action_release(a)
 await wait_physics_frames(2)
func ignore_ui(n:Node):
 if n is Control:n.mouse_filter=Control.MOUSE_FILTER_IGNORE
 for c in n.get_children():ignore_ui(c)
func touch(index:int,p:Vector2,pressed:bool):
 var e:=InputEventScreenTouch.new();e.index=index;e.position=p;e.pressed=pressed;Input.parse_input_event(e);Input.flush_buffered_events()
func drag(index:int,p:Vector2):
 var e:=InputEventScreenDrag.new();e.index=index;e.position=p;Input.parse_input_event(e);Input.flush_buffered_events()
func make_race():
 ignore_ui(get_tree().root.get_node("GutRunner"));RaceCourse190.selected=0;RaceCourse190.start_selected=true
 scene=load("res://src/Presentation/race190.tscn").instantiate();add_child(scene);await wait_physics_frames(2)
 scene.countdown=0.;scene.running=true
 scene.set_physics_process(false)
 for rider in scene.riders:
  if rider!=scene.player:rider.set_physics_process(false)
func test_release_aim_over_map_finishes_original_gesture():
 await make_race()
 var origin:=get_viewport().get_visible_rect().size*Vector2(.76,.78)
 var map_point:Vector2=scene.map_view.get_global_rect().get_center()
 touch(4,origin,true);drag(4,origin+Vector2(65,0));await wait_physics_frames(2)
 assert_true(scene.player.lasso._touch_aim_active,"Native stick owns aim gesture")
 drag(4,map_point);touch(4,map_point,false);await wait_physics_frames(2)
 assert_false(scene.player.lasso._touch_aim_active,"Release over map must reach original aim stick")
 assert_false(scene.player.lasso.is_charging(),"No stuck charge")
 assert_true(scene.player.lasso.is_in_flight(),"Normal release still throws")
 assert_false(scene.map_view.expanded,"A drag ending on map is not a tap")
 assert_false(get_tree().paused)
func test_map_owns_only_contacts_begun_on_map():
 await make_race()
 var map_point:Vector2=scene.map_view.get_global_rect().get_center()
 touch(7,map_point,true);touch(7,map_point,false);await wait_physics_frames(2)
 assert_true(scene.map_view.expanded);assert_true(get_tree().paused)
 # End map gesture outside the map. It must still be cleared.
 touch(9,map_point,true);touch(9,Vector2(8,8),false);await wait_physics_frames(2)
 assert_eq(scene.map_view.get("_map_touches209").size(),0)
 var center:Vector2=scene.map_view.get_global_rect().get_center()
 touch(8,center,true);touch(8,center,false);await wait_physics_frames(2)
 assert_false(scene.map_view.expanded);assert_false(get_tree().paused)

func make_mode(mode:String):
 ignore_ui(get_tree().root.get_node("GutRunner"))
 SaveData.country_ledger146={};SaveData.world_generator_version=3;SaveData.world_flora138={};SaveData.world_cousins140={};SaveData.world_roaming139={};SaveData.world_places144={};SaveData.world_edits=[];SaveData.world_discovered=[];SaveData.world_missions={};SaveData.world_quests={};SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 scene=CountryPreview146.new() if mode=="country_preview146" else load("res://src/Presentation/"+mode+".tscn").instantiate();add_child(scene);await wait_physics_frames(4)
 var cover=get_tree().root.get_node_or_null("FrontierTransition")
 if cover!=null:cover.free()
 if mode=="frontier_world":scene.visible=true
 if mode=="jump_memory207":scene.model.sequence.assign([0,1]);scene.model.begin_input();scene._refresh()
 elif mode in ["duel193","joust196"]:scene.countdown=0.;scene.running=true
 scene.set_process(false);scene.set_physics_process(false)
 if scene.get("riders")!=null:
  for rider in scene.riders:
   if rider!=scene.player:rider.set_physics_process(false)
 scene.player.set_physics_process(true)
 await wait_physics_frames(2)
func check_button_drag(mode:String):
 var moving:bool=mode=="jump_memory207"
 var button:=Button.new();button.position=Vector2(170 if moving else 1020,400);button.size=Vector2(130,70)
 var layer:=CanvasLayer.new();layer.layer=40;scene.add_child(layer);layer.add_child(button)
 var clicks:Array=[0];button.pressed.connect(func():clicks[0]+=1)
 await wait_physics_frames(1)
 var origin:Vector2=button.get_global_rect().get_center();var dest:=origin+Vector2(-90,90)
 touch(2,origin,true);await wait_physics_frames(1)
 assert_eq(clicks[0],0,mode+": UI waits for tap completion")
 drag(2,dest);await wait_physics_frames(3)
 if not moving:assert_true(scene.player.lasso._touch_aim_active,mode+": UI-started drag reaches aim stick")
 else:assert_true(Input.is_action_pressed("move_down"),mode+": UI-started drag reaches move stick")
 # Leave button and re-enter: excursion is still a drag, never a click.
 drag(2,origin);touch(2,origin,false);await wait_physics_frames(3)
 assert_eq(clicks[0],0,mode+": drag returning over button is not a click")
 if not moving:
  assert_false(scene.player.lasso._touch_aim_active,mode+": aim released")
  assert_false(scene.player.lasso.is_charging(),mode+": no stuck charging")
 else:assert_false(Input.is_action_pressed("move_down"),mode+": no stuck movement")
 touch(3,origin,true);touch(3,origin,false);await wait_physics_frames(3)
 assert_eq(clicks[0],1,mode+": clean tap still activates UI")
func test_ui_started_drag_and_tap_in_all_riding_modes():
 for mode in ["duel193","joust196","jump_memory207","level_0","frontier_world","modular_world93","country_preview146"]:
  await make_mode(mode);await check_button_drag(mode)
  scene.free();scene=null;await wait_physics_frames(2)
func test_move_and_aim_ending_over_frontier_minimap():
 await make_mode("frontier_world")
 var target:Vector2=scene._map_overlay.get_global_rect().get_center()
 var origin:=Vector2(1000,530)
 touch(5,origin,true);drag(5,origin+Vector2(70,0));await wait_physics_frames(2)
 assert_true(scene.player.lasso._touch_aim_active)
 drag(5,target);touch(5,target,false);await wait_physics_frames(3)
 assert_false(scene.player.lasso._touch_aim_active);assert_false(scene.player.lasso.is_charging());assert_false(scene._map_overlay.expanded)
 origin=Vector2(200,530)
 touch(6,origin,true);drag(6,origin+Vector2(70,0));await wait_physics_frames(2)
 drag(6,target);touch(6,target,false);await wait_physics_frames(3)
 for a in ["move_left","move_right","move_up","move_down"]:assert_false(Input.is_action_pressed(a),a+" released over minimap")
func test_drag_starting_on_race_minimap_does_not_expand_it():
 await make_race()
 var point:Vector2=scene.map_view.get_global_rect().get_center()
 touch(1,point,true);assert_false(scene.map_view.expanded)
 drag(1,point+Vector2(-120,200));await wait_physics_frames(3)
 assert_true(scene.player.lasso._touch_aim_active,"race map started drag owned, touches="+str(scene.get_node("GameplayGestures209").touches))
 touch(1,point+Vector2(-120,200),false);await wait_physics_frames(3)
 assert_false(scene.player.lasso._touch_aim_active);assert_false(scene.player.lasso.is_charging());assert_false(scene.map_view.expanded);assert_false(get_tree().paused)

func test_two_finger_pause_releases_do_not_stick_after_resume():
 await make_race()
 var left:=Vector2(200,530);var right:=Vector2(980,530)
 touch(0,left,true);drag(0,left+Vector2(80,0));touch(1,right,true);drag(1,right+Vector2(80,0));await wait_physics_frames(3)
 assert_true(scene.player.lasso._touch_aim_active);assert_true(Input.is_action_pressed("move_right"))
 scene._pause();assert_true(get_tree().paused)
 touch(0,left+Vector2(80,0),false);touch(1,scene.map_view.get_global_rect().get_center(),false);await wait_process_frames(3)
 assert_false(scene.player.lasso._touch_aim_active)
 for a in ["move_left","move_right","move_up","move_down","aim_left","aim_right","aim_up","aim_down"]:assert_false(Input.is_action_pressed(a),a+" clears under pause")
 # The actual pause menu must still respond to a clean finger tap.
 var resume:Button
 for node in scene.pause_panel.get_children():
  if node is Button and node.text=="Continuar":resume=node
 assert_not_null(resume)
 var point:Vector2=resume.get_global_rect().get_center()
 touch(4,point,true);touch(4,point,false);await wait_process_frames(3)
 assert_false(get_tree().paused);assert_false(scene.pause_panel.visible)
 # A fresh aim works, rather than the native stick retaining the old index.
 touch(6,right,true);drag(6,right+Vector2(70,0));await wait_physics_frames(2)
 assert_true(scene.player.lasso._touch_aim_active)
 touch(6,right+Vector2(70,0),false);await wait_physics_frames(2)
 assert_false(scene.player.lasso._touch_aim_active)
func test_focus_loss_clears_native_gestures_without_throwing():
 await make_race()
 var right:=Vector2(980,530)
 touch(0,right,true);drag(0,right+Vector2(80,0));await wait_physics_frames(2)
 assert_true(scene.player.lasso._touch_aim_active)
 scene.get_node("GameplayGestures209")._notification(NOTIFICATION_APPLICATION_FOCUS_OUT);await wait_physics_frames(2)
 assert_false(scene.player.lasso._touch_aim_active);assert_false(scene.player.lasso.is_charging());assert_false(scene.player.lasso.is_in_flight())
 touch(1,right,true);drag(1,right+Vector2(70,0));await wait_physics_frames(2)
 assert_true(scene.player.lasso._touch_aim_active)
 touch(1,right+Vector2(70,0),false);await wait_physics_frames(2)
 assert_false(scene.player.lasso._touch_aim_active)
