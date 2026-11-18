extends "res://tests/integration/test_camera243.gd"
class LayoutMap266 extends WorldDiscoveryMap159:
 func _ready():pass
 func _process(_delta):pass
 func _draw():pass
func test_buttons_animate_from_current_zoom_and_finish_exactly():
 controls.step(-1)
 assert_almost_eq(controls.camera.zoom.x,1.,.001)
 await wait_seconds(.14)
 assert_between(controls.camera.zoom.x,.851,.999)
 await wait_seconds(.4)
 assert_almost_eq(controls.camera.zoom.x,.85,.001)
 controls.plus.pressed.emit()
 await wait_seconds(.14)
 assert_between(controls.camera.zoom.x,.851,.999)
 await wait_seconds(.4)
 assert_almost_eq(controls.camera.zoom.x,1.,.001)
func test_rapid_taps_retarget_from_actual_camera_and_reset_animates():
 controls.step(-1);controls.step(-1);controls.step(-1)
 assert_almost_eq(controls.factor,.65,.001)
 await wait_seconds(.14)
 var before:float=controls.camera.zoom.x
 controls.reset.pressed.emit()
 assert_almost_eq(controls.camera.zoom.x,before,.001)
 await wait_seconds(.5)
 assert_almost_eq(controls.camera.zoom.x,1.,.001)
func test_minimap_above_controls_and_keeps_right_margin():
 var map:=LayoutMap266.new();map.size=Vector2(180,112);holder.add_child(map);map.set_process(false);map._layout()
 assert_almost_eq(map.position.x+map.size.x,controls.get_viewport_rect().size.x-18.,.01)
 assert_lt(map.position.y+map.size.y,controls.position.y)
 assert_false(map.get_global_rect().intersects(controls.get_global_rect()))
 map.expanded=true;map._layout();assert_almost_eq(map.position.x,(controls.get_viewport_rect().size.x-map.size.x)/2.,.01)
