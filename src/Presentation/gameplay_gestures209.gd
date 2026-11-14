class_name GameplayGestures209
extends Node
## One owner per touch: a clean HUD tap, or a complete riding gesture.
## Native sticks still calculate their own vector, deadzone, press and release.
const DRAG_DISTANCE:=12.0
var dispatching209:bool=false
var game:Node
var touches:Dictionary={}
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
  if not sticks.has(node):sticks.append(node)
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
func _stick_at(point:Vector2)->VirtualJoystick:
 var fallback:VirtualJoystick
 for stick in sticks:
  if not is_instance_valid(stick) or not stick.is_visible_in_tree():continue
  fallback=stick
  var rect:=stick.get_global_rect()
  if point.x>=rect.position.x and point.x<=rect.end.x:return stick
 return fallback
func _input(event:InputEvent)->void:
 if event.get_meta("routed209",false):return
 if event is InputEventMouse and event.device==InputEvent.DEVICE_ID_EMULATION and not dispatching209 and (_can_begin() or not touches.is_empty()):
  get_viewport().set_input_as_handled();return
 if event is InputEventScreenTouch:
  if event.pressed:
   if not _can_begin():return
   var ui:=_ui_at(game,event.position)
   touches[event.index]={"press":event.duplicate(),"ui":ui,"play":not ui,"offset":Vector2.ZERO,"last":event.position}
   if ui:get_viewport().set_input_as_handled()
  elif touches.has(event.index):
   var state:Dictionary=touches[event.index];touches.erase(event.index)
   get_viewport().set_input_as_handled()
   if event.canceled:
    game.player.cancel_input()
    if state.play:_send(event,state.offset,true)
    return
   if state.play:_send(event,state.offset,true)
   elif _can_begin() and event.position.distance_to(state.press.position)<DRAG_DISTANCE:
    _send(state.press,Vector2.ZERO,false);_send(event,Vector2.ZERO,false)
 elif event is InputEventScreenDrag and touches.has(event.index):
  var state:Dictionary=touches[event.index];state.last=event.position
  get_viewport().set_input_as_handled()
  if not state.play and event.position.distance_to(state.press.position)>=DRAG_DISTANCE:
   state.play=true
   var stick:=_stick_at(state.press.position)
   if stick!=null:
    var area:=stick.get_global_rect().grow(-minf(stick.joystick_size*.5+2.,minf(stick.size.x,stick.size.y)*.4))
    state.offset=state.press.position.clamp(area.position,area.end)-state.press.position
   _send(state.press,state.offset,true)
  if state.play:_send(event,state.offset,true)
func _filters(_node:Node,out:Array)->void:
 for control in controls209:
  if is_instance_valid(control):
   out.append([control,control.mouse_filter]);control.mouse_filter=Control.MOUSE_FILTER_IGNORE
func _send(event:InputEvent,offset:Vector2,bypass:bool)->void:
 # Deferral avoids recursively feeding the native input pipeline in its callback.
 _dispatch.call_deferred(event.duplicate(),offset,bypass)
func _dispatch(event:InputEvent,offset:Vector2,bypass:bool)->void:
 if not is_inside_tree():return
 event.set_meta("routed209",true);event.set_meta("riding209",bypass);event.position+=offset
 var filters:Array=[]
 var modes:Array=[]
 if bypass:
  _filters(game,filters)
  for stick in sticks:
   if is_instance_valid(stick):
    modes.append([stick,stick.process_mode]);stick.process_mode=Node.PROCESS_MODE_ALWAYS
 dispatching209=true
 Input.parse_input_event(event);Input.flush_buffered_events()
 dispatching209=false
 for saved in filters:
  if is_instance_valid(saved[0]):saved[0].mouse_filter=saved[1]
 for saved in modes:
  if is_instance_valid(saved[0]):saved[0].process_mode=saved[1]
func _notification(what:int)->void:
 if what==NOTIFICATION_APPLICATION_FOCUS_OUT and is_instance_valid(game):
  if is_instance_valid(game.get("player")):game.player.cancel_input()
  for index in touches:
   var state:Dictionary=touches[index]
   if state.play:
    var release:=InputEventScreenTouch.new();release.index=index;release.position=state.last;release.pressed=false;release.canceled=true
    _send(release,state.offset,true)
  touches.clear()
