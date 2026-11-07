extends SceneTree
## Repro for Ant's 2.7 report (7-nov-2026): after setting an emblem, opening the
## FICHA shows an ability explanation dialog. Grounds the actual tap routing and
## the collection layout with 12 horses instead of inferring from his capture.
## Fully dynamic: -s main loops compile before autoloads register.
var frame:int=0
var panel:Control
var stage:int=0
var SD:Node
func _initialize()->void:
 call_deferred("setup")
func setup()->void:
 root.content_scale_size=Vector2i(1280,720)
 SD=root.get_node("SaveData")
 SD.save_path="user://ficha-bug-save.dat"
 SD.debug_mode=true
 var c=SD.horse_collection
 c.seed_trial();c.add_trial_parents()
 for i in range(5):
  c.add_random_trial_pair()
 var target=c.horses[3]
 target["can_dodge"]=true
 target.traits["emblem"]=ClassDB.class_get_property_list("Object") # placeholder, replaced below
 target.traits["emblem"]=(load("res://src/Application/horse_emblem.gd") as GDScript).get("DEFAULT").duplicate()
 panel=(load("res://src/Presentation/horse_panel.gd") as GDScript).new()
 root.add_child(panel)
func is_badge(n:Node)->bool:
 return n is Button and n.get("skill")!=null
func _process(_delta:float)->bool:
 frame+=1
 if stage==0 and frame>=20:
  shot("/tmp/ficha-collection.png")
  dump_rows()
  stage=1;return false
 if stage==1:
  tap_ficha_of_emblem_row()
  stage=2;return false
 if stage==2:
  print("PAGE AFTER FICHA TAP: ",panel.get("page"))
  dump_dialogs()
  shot("/tmp/ficha-after-tap.png")
  quit()
 return false
func shot(path:String)->void:
 var img:Image=root.get_texture().get_image()
 img.save_png(path)
 print("SHOT ",path," ",img.get_size())
func find(n:Node,cls:String)->Node:
 if n.get_class()==cls:return n
 for c in n.get_children():
  var r:=find(c,cls)
  if r!=null:return r
 return null
func dump_rows()->void:
 var scroll:=find(panel.get("content"),"ScrollContainer")
 if scroll==null:print("NO SCROLL");return
 var rows:=scroll.get_child(0)
 var i:=0
 for row in rows.get_children():
  var parts:Array=["ROW %d"%i];i+=1
  for child in row.get_children():
   if not child is Control:continue
   var r:Rect2=child.get_global_rect()
   var tag:String=child.get_class()
   if is_badge(child):tag="Badge:"+str(child.get("skill"))
   elif child is Button:tag="Btn:"+child.text
   elif child is TextureRect:tag="Emblem"
   parts.append("%s@[%s]"%[tag,r])
  print(" ".join(parts))
func tap_ficha_of_emblem_row()->void:
 var scroll:=find(panel.get("content"),"ScrollContainer")
 var rows:=scroll.get_child(0)
 for row in rows.get_children():
  var has_emblem:=false;var fam:Button=null
  for child in row.get_children():
   if child is TextureRect and child.custom_minimum_size==Vector2(45,45):has_emblem=true
   if child is Button and not is_badge(child) and child.text==tr("FICHA"):fam=child
  if has_emblem and fam!=null:
   var center:=fam.get_global_rect().get_center()
   print("TAPPING FICHA AT ",center," RECT ",fam.get_global_rect())
   for pressed in [true,false]:
    var ev:=InputEventMouseButton.new();ev.button_index=MOUSE_BUTTON_LEFT;ev.position=center;ev.global_position=center;ev.pressed=pressed
    root.push_input(ev)
   return
 print("NO EMBLEM ROW FOUND")
func dump_dialogs()->void:
 var found:=false
 var stack:Array=[panel]
 while not stack.is_empty():
  var n:Node=stack.pop_back()
  if n is AcceptDialog:
   print("DIALOG title='",n.title,"' text='",n.dialog_text,"' visible=",n.visible);found=true
  stack.append_array(n.get_children())
 if not found:print("NO DIALOG OPEN")
