extends GutTest
class StubWorld extends Node2D:
 var player=Node2D.new()
 var notes:int=0
 var _flower_nodes105:Dictionary={}
 func _toggle_map():pass
 func _open_map_note106(_point):notes+=1
func setup_map():
 SaveData.world_discovered=[]
 for x in range(-20,21):
  for y in range(-20,21):SaveData.world_discovered.append(WorldMap.chunk_key(x,y))
 var world=StubWorld.new();add_child_autofree(world);world.add_child(world.player)
 var map=load("res://src/Presentation/frontier_world.gd").DiscoveryMap.new();map.world=world;map.expanded=true;world.add_child(map);map._layout();map._set_zoom(8.)
 return map
func touch(map,index,point,pressed):
 var event=InputEventScreenTouch.new();event.index=index;event.position=point;event.pressed=pressed;map._gui_input(event)
func drag(map,index,point):
 var event=InputEventScreenDrag.new();event.index=index;event.position=point;map._gui_input(event)
func test_pinch_anchor_drag_and_note_suppression():
 var map=setup_map();var middle:Vector2=map._map_geometry.area.get_center();var anchor:Vector2=map._map_point106(middle)
 touch(map,2,middle-Vector2(40,0),true);touch(map,5,middle+Vector2(40,0),true)
 drag(map,2,middle-Vector2(80,0));drag(map,5,middle+Vector2(80,0))
 assert_almost_eq(map.zoom,16.,.001);assert_lt(map._map_point106(middle).distance_to(anchor),.1)
 map._press_time106-=1.;map._process(.1);assert_eq(map.world.notes,0)
 touch(map,2,middle-Vector2(80,0),false);var before:Vector2=map.pan;drag(map,5,middle+Vector2(110,20));assert_gt(map.pan.distance_to(before),1.)
 map._press_time106-=1.;map._process(.1);assert_eq(map.world.notes,0);touch(map,5,middle,false);assert_false(map._dragging)
func test_wheel_anchor_mouse_drag_find_and_clamps():
 var map=setup_map();var p:Vector2=map._map_geometry.area.get_center()+Vector2(30,-20);var anchor:Vector2=map._map_point106(p)
 var event=InputEventMouseButton.new();event.position=p;event.button_index=MOUSE_BUTTON_WHEEL_UP;event.pressed=true;map._gui_input(event)
 assert_almost_eq(map.zoom,9.2,.001);assert_lt(map._map_point106(p).distance_to(anchor),.1)
 event.button_index=MOUSE_BUTTON_LEFT;map._gui_input(event);var before:Vector2=map.pan
 var motion=InputEventMouseMotion.new();motion.position=p+Vector2(40,30);map._gui_input(motion);assert_gt(map.pan.distance_to(before),1.)
 event.pressed=false;event.position=motion.position;map._gui_input(event)
 map.world.player.position=Vector2(3000,2500);var zoom:float=map.zoom;map._find108.pressed.emit();assert_eq(map.zoom,zoom)
 var marker:Vector2=map._to_map(map.world.player.position,map._map_geometry.data.mins,map._map_geometry.cell,map._map_geometry.origin);assert_lt(marker.distance_to(map._map_geometry.area.get_center()),.01)
 map._zoom_at108(100.,p,p);assert_eq(map.zoom,32.);map._zoom_at108(.01,p,p);assert_eq(map.zoom,.5)
func test_one_finger_drag_still_allows_fresh_long_press():
 var map=setup_map();var p:Vector2=map._map_geometry.area.get_center();touch(map,1,p,true);drag(map,1,p+Vector2(40,20));touch(map,1,p+Vector2(40,20),false)
 touch(map,3,p,true);map._press_time106-=1.;map._process(.1);assert_eq(map.world.notes,1);touch(map,3,p,false)
