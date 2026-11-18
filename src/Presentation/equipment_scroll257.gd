class_name EquipmentScroll257
extends Node
var scroll:ScrollContainer
var finger:int=-1
var origin:Vector2
var start:int=0
var moved:bool=false
var replay:bool=false
func _ready():process_mode=Node.PROCESS_MODE_ALWAYS
func inside(p:Vector2)->bool:
 return is_instance_valid(scroll) and scroll.is_visible_in_tree() and scroll.get_global_rect().has_point(p)
func _input(e:InputEvent):
 if replay:return
 if e is InputEventMouseButton and inside(e.position) and e.button_index in [MOUSE_BUTTON_WHEEL_UP,MOUSE_BUTTON_WHEEL_DOWN]:
  if e.pressed:scroll.scroll_vertical+=(-90 if e.button_index==MOUSE_BUTTON_WHEEL_UP else 90)
  get_viewport().set_input_as_handled()
 elif e is InputEventScreenTouch:
  if e.pressed and finger==-1 and inside(e.position):
   finger=e.index;origin=e.position;start=scroll.scroll_vertical;moved=false;get_viewport().set_input_as_handled()
  elif not e.pressed and e.index==finger:
   finger=-1;get_viewport().set_input_as_handled()
   if not e.canceled and not moved and inside(e.position):_click.call_deferred(e.position)
 elif e is InputEventScreenDrag and e.index==finger:
  if e.position.distance_to(origin)>12:moved=true
  if moved:
   scroll.scroll_vertical=start+roundi((origin.y-e.position.y)/maxf(.01,scroll.get_global_transform().get_scale().y))
  get_viewport().set_input_as_handled()
 elif e is InputEventMouse and e.device==InputEvent.DEVICE_ID_EMULATION and (finger!=-1 or inside(e.position)):
  get_viewport().set_input_as_handled()
func _click(point:Vector2):
 replay=true
 for down in [true,false]:
  var e:=InputEventMouseButton.new();e.position=point;e.global_position=point;e.button_index=MOUSE_BUTTON_LEFT;e.pressed=down;e.button_mask=MOUSE_BUTTON_MASK_LEFT if down else 0
  Input.parse_input_event(e.xformed_by(get_viewport().get_final_transform()));Input.flush_buffered_events()
 replay=false
func _notification(what):
 if what==NOTIFICATION_APPLICATION_FOCUS_OUT:finger=-1
