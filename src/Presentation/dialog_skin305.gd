class_name DialogSkin305
extends Node
## One event-driven skin for native confirmations and in-world conversations.
const PANELS=["npc_dialog.gd","florist_dialog138.gd","cousin_dialog140.gd","town_dialog234.gd","map_note_dialog106.gd","garden_panel212.gd","town_service_panel231.gd"]
func _ready()->void:
 process_mode=Node.PROCESS_MODE_ALWAYS
 get_tree().node_added.connect(_added)
func _added(node:Node)->void:
 if node is AcceptDialog or is_conversation(node):_apply.call_deferred(node)
 elif node is Button:
  var parent:=node.get_parent()
  while parent!=null:
   if parent is AcceptDialog or is_conversation(parent):_apply.call_deferred(parent);break
   parent=parent.get_parent()
static func is_conversation(node:Node)->bool:
 var script=node.get_script()
 return script!=null and script.resource_path.get_file() in PANELS
static func _apply(node)->void:
 if not is_instance_valid(node):return
 if node is AcceptDialog:
  RanchTheme.style_dialog(node)
 elif node is Control:
  node.theme=RanchTheme.create();ButtonSkin272.panel(node);_buttons(node);node.set_meta("dialog_skin305",true)
static func _buttons(node:Node)->void:
 for child in node.get_children():
  if child is Button and not child is CheckBox and not child is CheckButton:ButtonSkin272.apply(child)
  _buttons(child)
