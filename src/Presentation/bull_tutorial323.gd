class_name BullTutorial323
extends Control
## A modal host only. Movement, bulls, capture, pen, timer and HUD are level 1.
signal finished
var onboarding323:bool=false
var level325:Node2D
var previous_camera323:Camera2D
var previous_level325:int=1
var owns_session325:bool=false
var hidden325:Array[CanvasItem]=[]
func _ready()->void:
 name='BullTutorial323';z_index=190;set_meta('ui_modal',true)
 mouse_filter=Control.MOUSE_FILTER_IGNORE
 set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 previous_camera323=get_viewport().get_camera_2d();previous_level325=GameState.selected_level
 owns_session325=SaveData.begin_trial_session(false)
 if not owns_session325:
  _finish323.call_deferred();return
 for child in get_parent().get_children():
  if child!=self and child is CanvasItem and child.visible:
   hidden325.append(child);child.hide()
 _start325()
func _start325()->void:
 GameState.selected_level=1
 level325=load('res://src/Presentation/level_0.tscn').instantiate()
 level325.familiarization325=true
 level325.familiarization_exit325.connect(_finish323)
 level325.familiarization_restart325.connect(_restart325)
 add_child(level325)
func _restart325()->void:
 if is_instance_valid(level325):level325.queue_free()
 _restart_deferred325.call_deferred()
func _restart_deferred325()->void:
 await get_tree().process_frame
 if not is_queued_for_deletion():_start325()
func _finish323()->void:
 if is_queued_for_deletion():return
 if is_instance_valid(level325):level325.player.cancel_all_actions()
 get_tree().paused=false
 _restore325()
 finished.emit();queue_free()
func _restore325()->void:
 for item in hidden325:
  if is_instance_valid(item):item.show()
 hidden325.clear()
 if owns_session325:SaveData.end_trial_session();owns_session325=false
 GameState.selected_level=previous_level325
 if is_instance_valid(previous_camera323):previous_camera323.make_current()
func _exit_tree()->void:
 _restore325()
 for action in ['move_left','move_right','move_up','move_down','aim_left','aim_right','aim_up','aim_down']:Input.action_release(action)
func _unhandled_input(event:InputEvent)->void:
 if event.is_action_pressed('ui_cancel'):
  level325._toggle_pause();get_viewport().set_input_as_handled()
