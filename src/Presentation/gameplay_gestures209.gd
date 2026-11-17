class_name GameplayGestures209
extends Node
## One owner per touch: a clean HUD tap, or a complete riding gesture.
## Native sticks still calculate their own vector, deadzone, press and release.
const DRAG_DISTANCE:=12.0
var dispatching209:bool=false
var game:Node
var touches:Dictionary={}
var cancel_generation224:int=0
var sticks:Array[VirtualJoystick]=[]
var controls209:Array[Control]=[]
static func install(scene:Node)->void:
 if scene.has_node("GameplayGestures209"):return
 var gate:=GameplayGestures209.new();gate.name="GameplayGestures209";gate.game=scene
 scene.add_child(gate)
 scene.move_child.call_deferred(gate,-1)
func _ready()->void:
 process_mode=Node.PROCESS_MODE_ALWAYS
 game.child_entered_tree.connect(_watch_root209)
 for child in game.get_children():_watch_root209(child)
func _watch_root209(node:Node)->void:
 if node is Control or node is CanvasLayer:
  _watch_ui209(node)
  game.move_child.call_deferred(self,-1)
func _watch_ui209(node:Node)->void:
 if node is VirtualJoystick:
  if not sticks.has(node):
   sticks.append(node)
   _full_touch_area211.call_deferred(node)
  return
 if node is Control and not controls209.has(node):controls209.append(node)
 if not node.child_entered_tree.is_connected(_watch_ui209):node.child_entered_tree.connect(_watch_ui209)
 for child in node.get_children():_watch_ui209(child)
func _can_begin()->bool:
 if get_tree().paused:return false
 if not is_instance_valid(game.get("player")):return false
 if not game.player.is_physics_processing() or not game.player.can_process():return false
 if game is CanvasItem and not game.is_visible_in_tree():return false
 for key in ["selector","result","results","pause_panel"]:
  var panel=game.get(key)
  if panel is CanvasItem and panel.is_visible_in_tree():return false
 for stick in sticks:
  if is_instance_valid(stick) and stick.is_visible_in_tree():return true
 return false
func _ui_at(_node:Node,point:Vector2)->bool:
 for control in controls209:
  if is_instance_valid(control) and control.is_visible_in_tree() and control.mouse_filter!=Control.MOUSE_FILTER_IGNORE and control.get_global_rect().has_point(point):return true
 return false
func _scroll_at249(point:Vector2)->ScrollContainer:
 for control in controls209:
  if is_instance_valid(control) and control is ScrollContainer and control.is_visible_in_tree() and control.get_global_rect().has_point(point):return control
 return null
func _scroll_drag249(state:Dictionary,point:Vector2)->void:
 var scroll:ScrollContainer=state.scroll249
 if not is_instance_valid(scroll) or not scroll.is_visible_in_tree():return
 var bar:VScrollBar=scroll.get_v_scroll_bar()
 var dy:float=(state.press.position.y-point.y)/maxf(.01,scroll.get_global_transform().get_scale().y)
 if state.get("scrollbar249",false):
  var range_:float=maxf(0.,bar.max_value-bar.page)
  var thumb:float=maxf(24.,bar.size.y*bar.page/maxf(1.,bar.max_value))
  dy=-dy*range_/maxf(1.,bar.size.y-thumb)
 scroll.scroll_vertical=roundi(state.scroll_start249+dy)
func _full_touch_area211(stick:VirtualJoystick)->void:
 if not is_instance_valid(stick):return
 # UI tap/drag ownership is decided above the sticks. Both native touch areas
 # can cover the full height of their half without relocating any input event.
 stick.anchor_top=0.;stick.offset_top=0.;stick.anchor_bottom=1.;stick.offset_bottom=0.
func _input(event:InputEvent)->void:
 if event.get_meta("routed209",false):return
 if event is InputEventMouse and event.device==InputEvent.DEVICE_ID_EMULATION and not dispatching209 and (_can_begin() or not touches.is_empty()):
  get_viewport().set_input_as_handled();return
 if event is InputEventScreenTouch:
  if event.pressed:
   if not _can_begin():return
   if touches.has(event.index):_cancel_touches224()
   var ui:=_ui_at(game,event.position)
   touches[event.index]={"press":event.duplicate(),"ui":ui,"play":not ui,"offset":Vector2.ZERO,"last":event.position,"scroll249":_scroll_at249(event.position) if ui else null}
   if touches[event.index].scroll249!=null:
    var scroll:ScrollContainer=touches[event.index].scroll249
    touches[event.index]["scroll_start249"]=scroll.scroll_vertical
    touches[event.index]["scrollbar249"]=scroll.get_v_scroll_bar().get_global_rect().has_point(event.position)
   if ui:get_viewport().set_input_as_handled()
  elif touches.has(event.index):
   var state:Dictionary=touches[event.index];touches.erase(event.index)
   get_viewport().set_input_as_handled()
   if event.canceled:
    _cancel_touches224()
    return
   if state.get("scroll249")!=null:_scroll_drag249(state,event.position)
   elif state.play:_send(event,state.offset,true)
   elif _can_begin() and event.position.distance_to(state.press.position)<DRAG_DISTANCE:
    _send(state.press,Vector2.ZERO,false);_send(event,Vector2.ZERO,false)
 elif event is InputEventScreenDrag and touches.has(event.index):
  var state:Dictionary=touches[event.index];state.last=event.position
  # Drawing deliberately extends a trace at the screen edge. Ordinary holds do not.
  if not get_viewport().get_visible_rect().grow(-2.).has_point(event.position) and not game.player.dodge.drawing:
   _cancel_touches224();get_viewport().set_input_as_handled();return
  get_viewport().set_input_as_handled()
  if state.get("scroll249")!=null:
   _scroll_drag249(state,event.position);return
  if not state.play and event.position.distance_to(state.press.position)>=DRAG_DISTANCE:
   state.play=true
   _send(state.press,state.offset,true)
  if state.play:_send(event,state.offset,true)
func _filters(_node:Node,out:Array)->void:
 for control in controls209:
  if is_instance_valid(control):
   out.append([control,control.mouse_filter]);control.mouse_filter=Control.MOUSE_FILTER_IGNORE
func _send(event:InputEvent,offset:Vector2,bypass:bool)->void:
 # Deferral avoids recursively feeding the native input pipeline in its callback.
 _dispatch.call_deferred(event.duplicate(),offset,bypass,cancel_generation224)
func _dispatch(event:InputEvent,offset:Vector2,bypass:bool,generation:int)->void:
 if not is_inside_tree() or generation!=cancel_generation224:return
 event.set_meta("routed209",true);event.set_meta("riding209",bypass);event.position+=offset
 var filters:Array=[]
 var modes:Array=[]
 if bypass:
  _filters(game,filters)
  for stick in sticks:
   if is_instance_valid(stick):
    modes.append([stick,stick.process_mode]);stick.process_mode=Node.PROCESS_MODE_ALWAYS
 dispatching209=true
 # _input is already in viewport coordinates. parse_input_event accepts screen
 # coordinates, so replay must apply stretch exactly once, not twice.
 var screen_event:InputEvent=event.xformed_by(get_viewport().get_final_transform())
 Input.parse_input_event(screen_event);Input.flush_buffered_events()
 dispatching209=false
 for saved in filters:
  if is_instance_valid(saved[0]):saved[0].mouse_filter=saved[1]
 for saved in modes:
  if is_instance_valid(saved[0]):saved[0].process_mode=saved[1]
func _cancel_touches224()->void:
 # Do not synthesize a release: release commits aim/drawn regate. Cancel first,
 # then use the native resize reset to clear touch IDs, action strengths and art.
 cancel_generation224+=1
 touches.clear()
 if is_instance_valid(game) and is_instance_valid(game.get("player")):game.player.cancel_input()
 for stick in sticks:
  if is_instance_valid(stick):stick.notification(Control.NOTIFICATION_RESIZED)
func _process(_delta:float)->void:
 if not touches.is_empty() and not _can_begin():_cancel_touches224()
func _notification(what:int)->void:
 if what in [NOTIFICATION_APPLICATION_FOCUS_OUT,NOTIFICATION_WM_WINDOW_FOCUS_OUT,NOTIFICATION_APPLICATION_PAUSED] and is_instance_valid(game):_cancel_touches224()
