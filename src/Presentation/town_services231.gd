class_name TownServices231
extends Node2D
## V5 houses and non-duplicating service access. Shared existing game systems.
var world:Node2D
var nodes:Dictionary={}
func _ready():world=get_parent()
func _process(_delta:float):
 for id in ["west140","east140"]:
  var door:Vector2=SaveData.world_cousins140.doors[id];var near:bool=world.player.position.distance_to(door)<1900.
  if near and not nodes.has(id):nodes[id]=build(id,door)
  if not near and nodes.has(id):nodes[id].queue_free();nodes.erase(id)
func build(id:String,door:Vector2)->Node2D:
 var root:=Node2D.new();root.name="Service231_"+id;root.y_sort_enabled=true;world.add_child(root)
 for side in [-1,1]:
  var house:=Sprite2D.new();house.texture=WorldTestZone.HOUSE_TEX;house.position=door+Vector2(side*210,-48);house.offset=Vector2(0,-house.texture.get_height()/2.);house.scale=Vector2.ONE*116./house.texture.get_height();root.add_child(house)
  WorldPhysics.add_box(root,Rect2(house.position+Vector2(-58,-50),Vector2(116,30)))
 var figure:=Sprite2D.new();figure.texture=WorldNpc.PORTRAIT;figure.position=door+Vector2(110,32);NpcScale214.apply(figure,figure.texture);figure.modulate=Color("b8d9ff") if id=="west140" else Color("f0d39d");root.add_child(figure)
 # Reuse the farmer art as a labelled stand-in; the service has no fake identity.
 var label:=Label.new();label.text=TownEnclosures227.role231(id)+" · arte provisional";label.position=figure.position+Vector2(-150,16);label.add_theme_font_size_override("font_size",17);root.add_child(label)
 var sign:=Label.new();sign.text=TownEnclosures227.role231(id);sign.position=door+Vector2(-150,-210);sign.add_theme_font_size_override("font_size",22);root.add_child(sign)
 return root
func _exit_tree():
 for node in nodes.values():
  if is_instance_valid(node):node.queue_free()
