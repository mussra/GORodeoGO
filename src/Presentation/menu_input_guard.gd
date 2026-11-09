class_name MenuInputGuard
extends Node
## Keep visual clipping, enabled state and input state in agreement. Event-driven:
## rebuild the small menu-control cache only when the tree changes; scrolling,
## visibility and layout changes only re-evaluate that cache.
var panel:Control
var controls:Array[Control]=[]
var saved:Dictionary={}
var dirty:bool=true
var rebuild:bool=true
static func install(target:Control)->void:
 target.set_meta("ui_modal",true)
 target.mouse_filter=Control.MOUSE_FILTER_STOP
 var guard:=MenuInputGuard.new();guard.panel=target;target.add_child(guard)
func _ready()->void:
 panel.visibility_changed.connect(_mark)
 panel.item_rect_changed.connect(_mark)
 get_tree().tree_changed.connect(_tree_changed)
func _tree_changed()->void:rebuild=true;dirty=true
func _mark()->void:dirty=true
func _collect(node:Node)->void:
 for child in node.get_children():
  if child is Control:
   controls.append(child)
   if not child.visibility_changed.is_connected(_mark):child.visibility_changed.connect(_mark)
   if not child.item_rect_changed.is_connected(_mark):child.item_rect_changed.connect(_mark)
  if child is ScrollContainer:
   child.clip_contents=true
   for bar in [child.get_h_scroll_bar(),child.get_v_scroll_bar()]:
    if not bar.value_changed.is_connected(_scrolled):bar.value_changed.connect(_scrolled)
  if child is Window and not child.visibility_changed.is_connected(_mark):child.visibility_changed.connect(_mark)
  _collect(child)
func _scrolled(_value:float)->void:dirty=true
func _process(_dt:float)->void:
 if not dirty:return
 dirty=false
 if rebuild:
  rebuild=false;controls.clear();_collect(panel)
  for key in saved.keys():
   if not is_instance_valid(key):saved.erase(key)
 sync()
func _modal(node:Node)->Node:
 var result:Node=null
 for child in node.get_children():
  if child is Window and child.visible:result=child
  if child is Control and child.has_meta("ui_modal") and child.is_visible_in_tree():result=child
  var nested:=_modal(child)
  if nested!=null:result=nested
 return result
func sync()->void:
 var modal:=_modal(panel)
 for c in controls:
  if not is_instance_valid(c):continue
  var blocked:bool=not c.is_visible_in_tree()
  if modal!=null and not modal.is_ancestor_of(c) and modal!=c:blocked=true
  # Godot clips partially-visible children to the intersection itself. Fully
  # clipped controls additionally lose focus/input until scrolled back in.
  var rect:Rect2=c.get_global_rect()
  var parent:Node=c.get_parent()
  while parent!=null and parent!=panel:
   if parent is Window:break # native/embedded dialog coordinates are a separate viewport
   if parent is Control and parent.clip_contents:
    rect=rect.intersection(parent.get_global_rect())
    if not rect.has_area():blocked=true
   parent=parent.get_parent()
  if blocked:
   if not saved.has(c):saved[c]={"mouse":c.mouse_filter,"focus":c.focus_mode,"disabled":c.disabled if c is BaseButton else false}
   c.mouse_filter=Control.MOUSE_FILTER_IGNORE;c.focus_mode=Control.FOCUS_NONE
   if c is BaseButton:c.disabled=true
  elif saved.has(c):
   var state:Dictionary=saved[c];c.mouse_filter=state.mouse;c.focus_mode=state.focus
   if c is BaseButton:c.disabled=state.disabled
   saved.erase(c)
