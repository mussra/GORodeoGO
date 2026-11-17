extends GutTest
var host:Node2D
var player:Node2D
var aim_joystick:VirtualJoystick
func setup_touch249():
 ignore(get_tree().root.get_node("GutRunner"))
 host=Node2D.new();host.set_script(load("res://tests/integration/touch_host224.gd"));add_child(host)
 player=host.player;aim_joystick=host.aim_joystick;await wait_physics_frames(3)
func teardown_touch249():
 get_tree().paused=false
 if is_instance_valid(host):host.free()
 for a in ["move_left","move_right","move_up","move_down","aim_left","aim_right","aim_up","aim_down"]:Input.action_release(a)
 Engine.time_scale=1.;await wait_physics_frames(2)
func ignore(n:Node):
 if n is Control:n.mouse_filter=Control.MOUSE_FILTER_IGNORE
 for c in n.get_children():ignore(c)
func touch(p:Vector2,down:bool,index:int=0,cancel:bool=false):
 var e:=InputEventScreenTouch.new();e.position=get_viewport().get_final_transform()*p;e.index=index;e.pressed=down;e.canceled=cancel;Input.parse_input_event(e);Input.flush_buffered_events()
func drag(p:Vector2,index:int=0):
 var e:=InputEventScreenDrag.new();e.position=get_viewport().get_final_transform()*p;e.index=index;Input.parse_input_event(e);Input.flush_buffered_events()
func moving()->Vector2:return Input.get_vector("move_left","move_right","move_up","move_down")
func start():
 touch(Vector2(150,400),true);await wait_physics_frames(2);drag(Vector2(30,420));await wait_physics_frames(3);assert_gt(moving().length(),.1)

var details:QuestDetails179
func before_each():
 await setup_touch249()
 var layer:=CanvasLayer.new();layer.layer=20;host.add_child(layer)
 details=QuestDetails179.new();details.position=Vector2(650,60);details.size=Vector2(600,400);layer.add_child(details)
 for i in 12:details._card("Encargo %d"%i,"Objetivo real largo con varias líneas para leer y completar el encargo.","En curso",0,3)
 await wait_process_frames(5)
func test_drag_over_card_scrolls_without_turning_into_riding():
 var p:=details.get_global_rect().get_center()+Vector2(0,110)
 touch(p,true);await wait_process_frames(2)
 for i in 10:
  drag(p-Vector2(0,(i+1)*23));await wait_process_frames(2)
 touch(p-Vector2(0,230),false);await wait_process_frames(4)
 assert_gt(details.scroll_vertical,120)
 assert_eq(moving(),Vector2.ZERO);assert_false(player.lasso.is_charging());assert_false(player.dodge.drawing)
 assert_true(details.get_v_scroll_bar().visible);assert_gte(details.get_v_scroll_bar().size.x,22.)
func test_drag_scrollbar_and_both_limits_remain_ui():
 var bar:=details.get_v_scroll_bar();var p:=bar.get_global_rect().position+Vector2(11,12)
 touch(p,true);await wait_process_frames(2)
 for i in 10:drag(p+Vector2(0,(i+1)*28));await wait_process_frames(2)
 touch(p+Vector2(0,280),false);await wait_process_frames(4)
 assert_gt(details.scroll_vertical,100)
 details.scroll_vertical=100000;await wait_process_frames(2)
 assert_almost_eq(float(details.scroll_vertical),bar.max_value-bar.page,1.)
 details.scroll_vertical=-100;assert_eq(details.scroll_vertical,0)
 assert_eq(moving(),Vector2.ZERO);assert_false(player.lasso.is_in_flight())

func after_each():await teardown_touch249()
