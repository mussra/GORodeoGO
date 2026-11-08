extends Node

## Minimal cross-scene state. Registered as an Autoload (see project.godot [autoload])
## so it survives get_tree().change_scene_to_file() calls between menu <-> level.

var selected_level: int = 1

var sound_enabled: bool = true

# Menu variant persists only for this process, never changes saved progress.
var menu_scene: String = "res://src/Presentation/main_menu.tscn"

var brand_intro_played: bool = false

# Test build only. Never persisted or applied by normal builds without explicit flag.
func trial_tools_enabled()->bool:
 return bool(ProjectSettings.get_setting("rancho/trial_tools",false))
func debug_cheats_active()->bool:
 return trial_tools_enabled() and (SaveData.debug_mode or SaveData.trial_session_active)

var _exit_dialog:ConfirmationDialog
func _ready()->void:
 process_mode=Node.PROCESS_MODE_ALWAYS
 get_tree().quit_on_go_back=false
 get_tree().auto_accept_quit=false
func _notification(what:int)->void:
 if what==NOTIFICATION_WM_GO_BACK_REQUEST:request_back()
 if what==NOTIFICATION_WM_CLOSE_REQUEST:confirm_exit()
func _unhandled_key_input(event:InputEvent)->void:
 if event.is_action_pressed("ui_cancel") and not event.is_echo():
  request_back();get_viewport().set_input_as_handled()
func close_top_overlay(node:Node)->bool:
 var children:Array=node.get_children();children.reverse()
 for child in children:
  if child is CanvasItem and not child.is_visible_in_tree():continue
  if child is Window:
   if child.visible:child.hide();child.queue_free();return true
   continue
  if close_top_overlay(child):return true
  if child is EmblemPanel:child.request_close();return true
  if child is TrainingPanel or child is GenealogyPanel:child.queue_free();return true
  if child is HorsePanel:
   if child.page!="collection":child.show_page("collection")
   else:child.hide()
   return true
  if child is HatPanel:child.hide();return true
  if child is EquipmentPanel:child.hide();child.closed.emit();return true
  if child.get_script()==load("res://src/Presentation/trial_panel.gd"):child.queue_free();return true
  if child.get_meta("back_closes",false):child.queue_free();return true
 return false
func request_back()->void:
 if is_instance_valid(_exit_dialog):_exit_dialog.queue_free();_exit_dialog=null;return
 var scene:Node=get_tree().current_scene
 if scene==null:return
 if close_top_overlay(scene):return
 if scene.has_method("navigate_back"):scene.navigate_back();return
 confirm_exit()
func confirm_exit()->void:
 if is_instance_valid(_exit_dialog):return
 _exit_dialog=ConfirmationDialog.new();_exit_dialog.title=tr("BACK_EXIT_TITLE");_exit_dialog.dialog_text=tr("BACK_EXIT_BODY");_exit_dialog.get_cancel_button().text=tr("MARKET_CANCEL");_exit_dialog.dialog_autowrap=true;var vw:int=get_tree().root.size.x;_exit_dialog.min_size=Vector2i(mini(480,vw-48),170);get_tree().root.add_child(_exit_dialog);RanchTheme.style_dialog(_exit_dialog,true)
 _exit_dialog.confirmed.connect(func():get_tree().quit());_exit_dialog.canceled.connect(func():_exit_dialog.queue_free();_exit_dialog=null);_exit_dialog.popup_centered()
 if _exit_dialog.size.x>vw-32:_exit_dialog.size.x=vw-32;_exit_dialog.position.x=int((vw-_exit_dialog.size.x)*0.5)
