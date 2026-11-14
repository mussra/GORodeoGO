extends GutTest
var scene:Node
func after_each():
 if is_instance_valid(scene):scene.free()
 get_tree().paused=false
 for a in ["move_right","move_left","move_up","move_down"]:Input.action_release(a)
 get_tree().root.size=Vector2i(1280,720)
 await wait_physics_frames(2)
func ignore_controls(n:Node):
 if n is Control:n.mouse_filter=Control.MOUSE_FILTER_IGNORE
 for c in n.get_children():ignore_controls(c)
func touch(p:Vector2,down:bool):
 var e:=InputEventScreenTouch.new();e.index=2;e.position=get_viewport().get_final_transform()*p;e.pressed=down;Input.parse_input_event(e);Input.flush_buffered_events()
func drag(p:Vector2):
 var e:=InputEventScreenDrag.new();e.index=2;e.position=get_viewport().get_final_transform()*p;Input.parse_input_event(e);Input.flush_buffered_events()
func make_memory():
 ignore_controls(get_tree().root.get_node("GutRunner"))
 scene=load("res://src/Presentation/jump_memory207.tscn").instantiate();add_child(scene);await wait_physics_frames(3)
 scene.model.sequence.assign([0,1]);scene.model.begin_input();scene._refresh();scene.set_physics_process(false)
 # Isolate actual joystick pixels, not a computed proxy for their position.
 for c in scene.get_children():
  if c is CanvasItem:c.visible=false
  elif c is CanvasLayer and c.name!="TouchControls":c.visible=false
 for c in scene.get_node("TouchControls").get_children():
  if c.name!="MoveJoystick" and c is CanvasItem:c.visible=false
 var layer:=CanvasLayer.new();layer.layer=40;scene.add_child(layer)
 var b:=Button.new();b.position=Vector2(0,550);b.size=Vector2(200,100);layer.add_child(b)
 b.modulate.a=0.
 isolate_pixels()
 await wait_physics_frames(2)
func isolate_pixels():
 var bg:=ColorRect.new();bg.color=Color.BLACK;bg.size=Vector2(2000,1200);bg.mouse_filter=Control.MOUSE_FILTER_IGNORE
 var controls=scene.get_node("TouchControls");controls.add_child(bg);controls.move_child(bg,0)
 var runner=get_tree().root.get_node("GutRunner")
 for c in runner.get_children():
  if c is CanvasLayer:c.visible=false
func ring_center(clipped_left:bool=false)->Vector2:
 await RenderingServer.frame_post_draw
 var image:=get_viewport().get_texture().get_image()
 image.save_png("/downloads/joystick211-"+str(scene.get_script().resource_path.get_file())+"-"+str(image.get_width())+".png")
 var lo:=Vector2i(99999,99999);var hi:=Vector2i(-1,-1)
 for y in image.get_height():
  for x in mini(image.get_width(),640):
   var c:=image.get_pixel(x,y)
   if c.r>.45 and c.g>.25 and c.b<.25 and c.r>c.g*1.08 and c.g>c.b*1.4:
    lo=lo.min(Vector2i(x,y));hi=hi.max(Vector2i(x,y))
 assert_gt(hi.x,lo.x,"native gold ring found")
 return Vector2(hi.x-102.0 if clipped_left else (lo.x+hi.x)*.5,(lo.y+hi.y)*.5)
func test_memory_ui_origin_keeps_ring_under_initial_finger():
 await make_memory()
 var origin:=Vector2(55,580)
 touch(origin,true);drag(origin+Vector2(45,0));await wait_physics_frames(3)
 var center:Vector2=await ring_center(true)
 assert_lt(center.distance_to(origin),4.,"Native ring center equals real touch origin, not inset clamp: "+str(center))
 assert_gt(Input.get_action_strength("move_right"),.05);assert_eq(Input.get_action_strength("move_down"),0.)
 touch(origin+Vector2(45,0),false);await wait_physics_frames(2)
 assert_eq(Input.get_vector("move_left","move_right","move_up","move_down"),Vector2.ZERO)

func make_mode(mode:String):
 ignore_controls(get_tree().root.get_node("GutRunner"))
 SaveData.country_ledger146={};SaveData.world_generator_version=3;SaveData.world_flora138={};SaveData.world_cousins140={};SaveData.world_roaming139={};SaveData.world_places144={};SaveData.world_edits=[];SaveData.world_discovered=[];SaveData.world_missions={};SaveData.world_quests={};SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 RaceCourse190.selected=0;RaceCourse190.start_selected=true
 scene=CountryPreview146.new() if mode=="country_preview146" else load("res://src/Presentation/"+mode+".tscn").instantiate();add_child(scene);await wait_physics_frames(4)
 var cover=get_tree().root.get_node_or_null("FrontierTransition")
 if cover!=null:cover.free()
 scene.visible=true
 if mode=="jump_memory207":scene.model.sequence.assign([0,1]);scene.model.begin_input();scene._refresh()
 elif mode in ["duel193","joust196","race190"]:scene.countdown=0.;scene.running=true
 scene.set_process(false);scene.set_physics_process(false);scene.player.set_physics_process(true)
 for c in scene.get_children():
  if c is CanvasItem:c.visible=false
  elif c is CanvasLayer and c.name!="TouchControls":c.visible=false
 for c in scene.get_node("TouchControls").get_children():
  if c.name!="MoveJoystick" and c is CanvasItem:c.visible=false
 isolate_pixels()
 await wait_physics_frames(2)
func test_native_origin_and_direction_match_across_all_modes_and_top_ui():
 for mode in ["jump_memory207","race190","frontier_world","duel193","joust196","level_0","modular_world93","country_preview146"]:
  await make_mode(mode)
  var layer:=CanvasLayer.new();layer.layer=40;scene.add_child(layer)
  var button:=Button.new();button.position=Vector2(110,80);button.size=Vector2(150,100);button.modulate.a=0.;layer.add_child(button)
  await wait_physics_frames(2)
  var origin:=Vector2(180,130)
  touch(origin,true);drag(origin+Vector2(45,0));await wait_physics_frames(3)
  var center:Vector2=await ring_center()
  assert_lt(center.distance_to(origin),4.,mode+": ring uses actual touch origin "+str(center))
  assert_gt(Input.get_action_strength("move_right"),.05,mode+": rightward drag")
  assert_eq(Input.get_action_strength("move_down"),0.,mode+": no vertical skew")
  assert_eq(Input.get_action_strength("move_up"),0.,mode+": no vertical skew")
  touch(origin+Vector2(45,0),false);await wait_physics_frames(2)
  assert_eq(Input.get_vector("move_left","move_right","move_up","move_down"),Vector2.ZERO)
  scene.free();scene=null;await wait_physics_frames(2)
func test_memory_coordinates_at_supported_viewport_widths():
 for extent in [Vector2i(960,540),Vector2i(1280,720),Vector2i(1600,720)]:
  get_tree().root.size=extent;await wait_physics_frames(2)
  await make_mode("jump_memory207")
  var origin:=Vector2(210,330)
  touch(origin,true);drag(origin+Vector2(45,0));await wait_physics_frames(3)
  var center:Vector2=await ring_center()
  print("PIXEL211 ",extent," viewport=",get_viewport().get_visible_rect()," image_transform=",get_viewport().get_final_transform()," origin=",center)
  var expected:Vector2=get_viewport().get_final_transform()*origin
  assert_lt(center.distance_to(expected),3.,str(extent)+": screen/viewport transform exact")
  assert_gt(Input.get_action_strength("move_right"),.05);assert_eq(Input.get_action_strength("move_up"),0.)
  touch(origin+Vector2(45,0),false);await wait_physics_frames(2)
  scene.free();scene=null
