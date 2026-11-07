extends SceneTree
## Post-fix visual evidence for Ant's 2.7 report (7-nov-2026):
##  1. collection with 12 horses: top text must not overlap "Entrenamiento"
##  2. dodge badge tap opens a dialog titled per-skill ("Regate"), not "Salto de vallas"
##  3. emblem chosen color stamped on the horse coat (dark, light and mid coats)
## Fully dynamic: -s main loops compile before autoloads register.
var frame:int=0
var panel:Control
var stage:int=0
var stage_frame:int=0
var SD:Node
func _initialize()->void:
 call_deferred("setup")
func setup()->void:
 root.content_scale_size=Vector2i(1280,720)
 SD=root.get_node("SaveData")
 SD.save_path="user://ficha-fix-save.dat"
 SD.debug_mode=true
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
func _process(_delta:float)->bool:
 frame+=1
 if stage==0 and frame>=20:
  shot("/downloads/postfix-collection.png")
  dump_rows()
  stage=1;stage_frame=frame;return false
 if stage==1:
  tap_badge_of_emblem_row()
  stage=2;stage_frame=frame;return false
 if stage==2 and frame>=stage_frame+8:
  var d:=dump_dialogs()
  shot("/downloads/postfix-dodge-dialog.png")
  if d!=null:d.hide()
  stage=3;stage_frame=frame;return false
 if stage==3 and frame>=stage_frame+4:
  show_portraits()
  stage=4;stage_frame=frame;return false
 if stage==4 and frame>=stage_frame+8:
  shot("/downloads/postfix-emblem-contrast.png")
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
func tap_badge_of_emblem_row()->void:
 var scroll:=find(panel.get("content"),"ScrollContainer")
 var rows:=scroll.get_child(0)
 for row in rows.get_children():
  var has_emblem:=false;var badge:Button=null
  for child in row.get_children():
   if child is TextureRect and child.custom_minimum_size==Vector2(45,45):has_emblem=true
   if is_badge(child) and child.get("skill")=="dodge":badge=child
  if has_emblem and badge!=null:
   var center:=badge.get_global_rect().get_center()
   print("TAPPING DODGE BADGE AT ",center," RECT ",badge.get_global_rect())
   for pressed in [true,false]:
    var ev:=InputEventMouseButton.new();ev.button_index=MOUSE_BUTTON_LEFT;ev.position=center;ev.global_position=center;ev.pressed=pressed
    root.push_input(ev)
   return
 print("NO EMBLEM ROW BADGE FOUND")
func dump_dialogs()->AcceptDialog:
 var stack:Array=[panel]
 while not stack.is_empty():
  var n:Node=stack.pop_back()
  if n is AcceptDialog and n.visible:
   print("DIALOG title='",n.title,"' text='",n.dialog_text,"'")
   return n
  stack.append_array(n.get_children())
 print("NO DIALOG OPEN")
 return null
func show_portraits()->void:
 panel.visible=false
 var HP:GDScript=load("res://src/Presentation/horse_portrait.gd")
 var bg:=PanelContainer.new();bg.set_anchors_preset(Control.PRESET_FULL_RECT)
 root.add_child(bg)
 var row:=HBoxContainer.new();row.set_anchors_preset(Control.PRESET_CENTER)
 row.add_theme_constant_override("separation",30)
 bg.add_child(row)
 var cases:Array=[
  {"label":"dark coat + teal","coat":0,"color":0},
  {"label":"light coat + pale yellow","coat":1,"color":4},
  {"label":"gray coat + blue","coat":11,"color":2},
 ]
 for spec in cases:
  var traits:Dictionary={"coat":spec.coat,"mane":1,"pattern":0,"finish":"normal","emblem":{"shape":0,"division":1,"left":0,"right":2,"color":spec.color}}
  var box:=VBoxContainer.new();row.add_child(box)
  var view:=TextureRect.new();view.custom_minimum_size=Vector2(320,336);view.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;view.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED
  HP.apply(view,traits)
  box.add_child(view)
  var lb:=Label.new();lb.text=spec.label;lb.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
  box.add_child(lb)
 print("PORTRAITS SHOWN")
