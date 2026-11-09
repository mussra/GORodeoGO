class_name MenuExperience
extends Node
## One shared finish for guarded menus. Event-driven wiring, no per-frame scan.
var panel:Control
var pending:bool=false
var wired:Dictionary={}
func _ready()->void:
 process_mode=Node.PROCESS_MODE_ALWAYS
 panel=get_parent() as Control
 panel.visibility_changed.connect(_visibility)
 get_tree().tree_changed.connect(_queue_scan)
 call_deferred("_setup")
func _setup()->void:
 if not is_instance_valid(panel):return
 panel.theme=RanchTheme.create()
 var has_backdrop:bool=false
 for child in panel.get_children():
  if child is MenuBackdrop:has_backdrop=true
 if not has_backdrop:
  var backdrop:=MenuBackdrop.new();backdrop.name="SharedMenuAmbience"
  backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
  panel.add_child(backdrop);panel.move_child(backdrop,0)
  # Static landscape: same atmosphere without a redraw loop on every window.
  backdrop.set_process(false)
  for child in panel.get_children():
   if child is ColorRect and child.anchor_right==1.0 and child.anchor_bottom==1.0:
    child.color.a=.88;break
 _visibility();_scan()
func _visibility()->void:
 if panel.is_visible_in_tree():
  MenuSounds.play("open")
  panel.modulate.a=0.0
  panel.create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS).tween_property(panel,"modulate:a",1.0,.14)
func _queue_scan()->void:
 if pending:return
 pending=true;call_deferred("_scan")
func _scan()->void:
 pending=false
 if not is_instance_valid(panel):return
 _wire(panel)
 for key in wired.keys():
  if not is_instance_valid(key):wired.erase(key)
func _wire(node:Node)->void:
 for child in node.get_children():
  if child is Control and child!=panel and child.has_meta("ui_modal"):continue
  if child is BaseButton and not wired.has(child):
   wired[child]=true
   child.pressed.connect(_pressed.bind(child))
  _wire(child)
func _pressed(button:BaseButton)->void:
 var text:String=button.text.to_lower() if button is Button else ""
 MenuSounds.play("back" if button.name=="NavigationBack" or text.contains("volver") or text.contains("atrás") else "tap")
