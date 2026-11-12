class_name CousinLayer140
extends Node2D
var world:Node2D
var nodes:Dictionary={}
var previous:Vector2
func _ready():world=get_parent();previous=world.player.position
func _process(_delta:float):
 if SaveData.world_cousins140.is_empty():return
 var state:Dictionary=SaveData.world_cousins140
 var surprise:=VillageCousins140.surprised(SaveData.horse_collection.find(SaveData.horse_collection.selected))
 for id in VillageCousins140.IDS:
  var point:=VillageCousins140.point(state,id);var near:bool=world.player.position.distance_to(point)<1800.
  if world.player.position.distance_to(previous)<300. and previous.distance_to(point)>=600. and world.player.position.distance_to(point)<600.:state.arrivals[id]=VillageCousins140.direction(point,previous)
  if near and not nodes.has(id):nodes[id]=_build(id,point)
  if not near and nodes.has(id):nodes[id].queue_free();nodes.erase(id)
  if nodes.has(id):nodes[id].get_node("CousinArt").texture=load("res://art/npc/loco-"+("sorpresa" if surprise else "normal")+"140.png")
 previous=world.player.position
func _build(id:String,point:Vector2)->Node2D:
 var root:=Node2D.new();root.name="Cousin_"+id;root.y_sort_enabled=true;world.add_child(root)
 var art:=Sprite2D.new();art.name="CousinArt";art.position=point;art.offset=Vector2(0,-88);art.scale=Vector2.ONE*.625;root.add_child(art)
 var label:=Label.new();label.text="Loco del pueblo";label.position=point+Vector2(-55,8);label.add_theme_font_size_override("font_size",16);root.add_child(label)
 var path=load("res://src/Presentation/world_draw_node.gd").new();path.z_index=-5;path.draw_fn=func(n):ContinuousRoadArt.access(n,PackedVector2Array([Vector2(point.x,470),point]),32.)
 root.add_child(path)
 if id in ["west140","east140"]:
  var door:Vector2=SaveData.world_cousins140.doors[id]
  for side in [-1,1]:
   var house:=Sprite2D.new();house.texture=WorldTestZone.HOUSE_TEX;house.position=door+Vector2(side*210,-48);house.offset=Vector2(0,-house.texture.get_height()/2.);house.scale=Vector2.ONE*116./house.texture.get_height();root.add_child(house)
   WorldPhysics.add_box(root,Rect2(house.position+Vector2(-58,-50),Vector2(116,30)))
  var sign:=Label.new();sign.text=VillageCousins140.LABELS[id];sign.position=door+Vector2(-170,-220);sign.add_theme_font_size_override("font_size",20);root.add_child(sign)
 return root
func _exit_tree():
 for node in nodes.values():
  if is_instance_valid(node):node.queue_free()
static func reserved(state:Dictionary,p:Vector2)->bool:
 if state.is_empty():return false
 for id in VillageCousins140.IDS:
  var point:=VillageCousins140.point(state,id)
  if p.distance_to(point)<100.:return true
  if p.distance_to(Geometry2D.get_closest_point_to_segment(p,Vector2(point.x,470),point))<55.:return true
  if id in ["west140","east140"] and Rect2(state.doors[id]+Vector2(-700,-340),Vector2(1400,560)).has_point(p):return true
 return false
