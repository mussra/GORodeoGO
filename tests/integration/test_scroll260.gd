extends "res://tests/integration/test_quest_scroll249.gd"
func test_inertia_continues_briefly_and_stops_without_jump_or_click():
 var hits:Array=[0];var b:=Button.new();b.text="Do not activate on drag";b.custom_minimum_size=Vector2(500,70);details.rows.add_child(b);b.pressed.connect(func():hits[0]+=1)
 var p:=details.get_global_rect().get_center()+Vector2(0,100)
 touch(p,true);await wait_process_frames(2)
 for i in 6:drag(p-Vector2(0,(i+1)*20));await wait_process_frames(2)
 var before:int=details.scroll_vertical;touch(p-Vector2(0,120),false);await wait_process_frames(2);assert_gte(details.scroll_vertical,before);assert_lt(details.scroll_vertical-before,100)
 await wait_seconds(.7);var stopped:int=details.scroll_vertical;await wait_seconds(.2);assert_eq(details.scroll_vertical,stopped);assert_eq(hits[0],0)
func test_horizontal_slider_adjustment_and_vertical_scroll_are_separate():
 var s:=HSlider.new();s.min_value=0;s.max_value=100;s.value=50;s.custom_minimum_size=Vector2(450,70);details.rows.add_child(s)
 details.rows.move_child(s,0);details.scroll_vertical=0;await wait_process_frames(4)
 var p:=s.get_global_rect().get_center();touch(p,true);await wait_process_frames(2);drag(p+Vector2(90,3));await wait_process_frames(2);touch(p+Vector2(90,3),false);await wait_process_frames(2)
 assert_gt(s.value,55);assert_lt(details.scroll_vertical,3)
 s.value=50;p=s.get_global_rect().get_center();touch(p,true);await wait_process_frames(2);drag(p-Vector2(2,130));await wait_process_frames(2);touch(p-Vector2(2,130),false);await wait_process_frames(3)
 assert_eq(s.value,50.);assert_gt(details.scroll_vertical,90)
func test_scrollbar_drag_maps_to_content_and_release_does_not_fling():
 var bar:=details.get_v_scroll_bar();var p:=bar.get_global_rect().position+Vector2(12,12)
 touch(p,true);await wait_process_frames(2);drag(p+Vector2(0,160));await wait_process_frames(2);touch(p+Vector2(0,160),false);await wait_process_frames(2)
 var position_:int=details.scroll_vertical;assert_gt(position_,200);await wait_seconds(.4);assert_eq(details.scroll_vertical,position_)
func test_hidden_scroll_never_intercepts_and_focus_loss_stops_inertia():
 details.hide();await wait_process_frames(2);assert_null(GameState.get_node("SharedScroll260").at(details.get_global_rect().get_center()))
 details.show();await wait_process_frames(2);var manager:SharedScroll260=GameState.get_node("SharedScroll260");manager.active=details;manager.velocity=Vector2(0,500);manager.notification(NOTIFICATION_APPLICATION_FOCUS_OUT);assert_eq(manager.velocity,Vector2.ZERO)
