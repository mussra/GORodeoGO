extends SceneTree
## Repro at Ant's phone aspect (1599x719) with real SCREEN TOUCH events:
## FICHA must open the detail page every time, even right after the badge
## notice is open. Also measures badge->FICHA gaps on the equipped row.
var frame:int=0
var panel:Control
var stage:int=0
var stage_frame:int=0
var SD:Node
var emblem_row:Control
func _initialize()->void:
 call_deferred("setup")
func setup()->void:
 root.size=Vector2i(1599,719) # physical phone window; stretch canvas_items+expand does the rest
 SD=root.get_node("SaveData")
 SD.save_path="user://ficha-touch-save.dat"
 SD.debug_mode=true
 SD.equipment_equipped.erase("whip") # case A: dodge learned, NO whip -> notice must show
 var c=SD.horse_collection
 c.seed_trial();c.add_trial_parents()
 for i in range(5):
  c.add_random_trial_pair()
 var target=c.horses[3]
 target["can_dodge"]=true
 target.traits["emblem"]=(load("res://src/Application/horse_emblem.gd") as GDScript).get("DEFAULT").duplicate()
 panel=(load("res://src/Presentation/horse_panel.gd") as GDScript).new()
 root.add_child(panel)
func is_badge(n:Node)->bool:
 return n is Button and n.get("skill")!=null
func find(n:Node,cls:String)->Node:
 if n.get_class()==cls:return n
 for c in n.get_children():
  var r:=find(c,cls)
  if r!=null:return r
 return null
func emblem_row_find()->Control:
 var scroll:=find(panel.get("content"),"ScrollContainer")
 for row in scroll.get_child(0).get_children():
  var has_emblem:=false
  for child in row.get_children():
   if child is TextureRect and child.custom_minimum_size==Vector2(45,45):has_emblem=true
  if has_emblem:return row
 return null
func touch_at(pos:Vector2)->void:
 # Synthetic screen touches do not replicate device GUI delivery in this harness;
 # mouse events exercise the same BaseButton/Window input paths the fix changes.
 var screen_pos:Vector2=root.get_screen_transform()*pos
 for pressed in [true,false]:
  var ev:=InputEventMouseButton.new();ev.button_index=MOUSE_BUTTON_LEFT;ev.position=screen_pos;ev.global_position=screen_pos;ev.pressed=pressed
  root.push_input(ev)
func _process(_delta:float)->bool:
 frame+=1
 if stage==0 and frame>=20:
  emblem_row=emblem_row_find()
  var dodge:Button=null;var ficha:Button=null
  for child in emblem_row.get_children():
   if is_badge(child) and child.get("skill")=="dodge":dodge=child
   if child is Button and not is_badge(child) and child.text==tr("FICHA"):ficha=child
  print("DODGE RECT ",dodge.get_global_rect()," FICHA RECT ",ficha.get_global_rect())
  touch_at(dodge.get_global_rect().get_center())
  stage=1;stage_frame=frame;return false
 if stage==1 and frame>=stage_frame+6:
  print("AFTER BADGE TOUCH: page=",panel.get("page")," popup=",popup_state())
  var stack:Array=[root]
  while not stack.is_empty():
   var n:Node=stack.pop_back()
   if n is PanelContainer and n.z_index==50:
    print("NOTICE rect=",n.get_global_rect()," visible=",n.visible," modulate=",n.modulate," size=",n.size," top=",n.top_level)
   stack.append_array(n.get_children())
  shot("/downloads/touch-badge-notice.png")
  # Now tap FICHA while the notice is up: the ficha must open anyway.
  for child in emblem_row.get_children():
   if child is Button and not is_badge(child) and child.text==tr("FICHA"):
    touch_at(child.get_global_rect().get_center())
  stage=2;stage_frame=frame;return false
 if stage==2 and frame>=stage_frame+10:
  print("AFTER FICHA WITH NOTICE UP: page=",panel.get("page")," popup=",popup_state())
  shot("/downloads/touch-ficha-after-notice.png")
  # Case B: whip equipped -> tapping the badge must show nothing.
  # Wait out the case-A notice fade (2.2s + 0.4s at 60fps) before the rebuild.
  SD.equipment_equipped["whip"]="whip_basic"
  panel.queue_free()
  stage=3;stage_frame=frame;return false
 if stage==3 and frame>=stage_frame+175:
  panel=(load("res://src/Presentation/horse_panel.gd") as GDScript).new()
  root.add_child(panel)
  stage=4;stage_frame=frame;return false
 if stage==4 and frame>=stage_frame+30:
  emblem_row=emblem_row_find()
  for child in emblem_row.get_children():
   if is_badge(child) and child.get("skill")=="dodge":touch_at(child.get_global_rect().get_center())
  stage=5;stage_frame=frame;return false
 if stage==5 and frame>=stage_frame+6:
  var notices:=0
  for n in root.get_children():
   if n is PanelContainer:notices+=1
  print("WHIP EQUIPPED TAP: notices=",notices," page=",panel.get("page"))
  shot("/downloads/touch-badge-whip-quiet.png")
  quit()
 return false
func popup_state()->String:
 var stack:Array=[root]
 while not stack.is_empty():
  var n:Node=stack.pop_back()
  if n is Window and n!=root and n.visible:return "%s title='%s' text='%s'"%[n.get_class(),n.get("title"),n.get("dialog_text") if n.get("dialog_text")!=null else ""]
  stack.append_array(n.get_children())
 return "none"
func shot(path:String)->void:
 var img:Image=root.get_texture().get_image()
 img.save_png(path)
 print("SHOT ",path)
