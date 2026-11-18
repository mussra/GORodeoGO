class_name TownLayer234
extends Node2D
var world:Node2D
var built:Dictionary={}
func _ready():world=get_parent()
func _process(_delta:float):
 for node in TownNetwork234.nodes(SaveData.world_seed).values():
  var near:bool=world.player.position.distance_to(node.door)<2100.
  if world.player.position.distance_to(node.door)<500. and not SaveData.world_cousins140.known.has(node.id):
   var next:=SaveData.world_cousins140.duplicate(true);next.doors[node.id]=node.door;next.known[node.id]=true;next.revealed215[node.id]=true
   SaveData.commit_cousins140(next,world.player.position)
  if near and not built.has(node.id):built[node.id]=build(node)
  if not near and built.has(node.id):built[node.id].queue_free();built.erase(node.id)
func build(node:Dictionary)->Node2D:
 if not SaveData.world_cousins140.doors.has(node.id):
  SaveData.world_cousins140.doors[node.id]=node.door
  SaveData.world_cousins140.towns215[node.id]=TownIdentity215.look236(SaveData.world_seed,node.id)
 var root:=Node2D.new();root.y_sort_enabled=true;world.add_child(root)
 if node.id!="home":
  for x in [-380,380]:
   var h:=Sprite2D.new();h.texture=WorldTestZone.HOUSE_TEX;h.position=node.door+Vector2(x,-130);h.offset=Vector2(0,-h.texture.get_height()/2.);h.scale=Vector2.ONE*116./h.texture.get_height();h.position.y-=20.;h.offset.y+=20./h.scale.y;root.add_child(h);WorldPhysics.add_box(root,Rect2(h.position+Vector2(-58,-30),Vector2(116,30)))
 for role in node.roles:
  if node.id=="home" and role in ["florist","saddler"]:continue
  var art:=Sprite2D.new();art.texture=WorldFloristShop.FLORIST if role=="florist" else load("res://art/npc/loco-normal140.png") if role=="loco" else WorldNpc.PORTRAIT;art.position=TownNetwork234.point(SaveData.world_seed,node.id,role);NpcScale214.apply(art,art.texture);root.add_child(art)
  if role=="saddler":art.modulate=Color("efd59f")
  var label:=Label.new();label.text=TownNetwork234.npc_name(node.id,role);label.position=art.position+Vector2(-80,10);label.add_theme_font_size_override("font_size",17);root.add_child(label)
 return root
func _exit_tree():
 for node in built.values():
  if is_instance_valid(node):node.queue_free()
