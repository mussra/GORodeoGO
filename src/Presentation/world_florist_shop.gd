class_name WorldFloristShop
extends Node2D
## Fixed additive preview using Ant's original PNGs, no quest/save changes.
const SHOP=preload("res://art/world/supplied/florist_shop.png")
const FLORIST=preload("res://art/npc/florist.png")
const Decor=preload("res://src/Presentation/world_decor.gd")
const BASE=Vector2(650,400)
const HEIGHT=200.0
const WIDTH=300.0
const DOOR=Vector2(680,398)
const FLORIST_FEET=Vector2(740,430)
const RESERVED=Rect2(475,180,350,280)
const BODY=Rect2(540,285,235,85)
static func keep_decor(d:Dictionary,seed:int)->bool:
 # Never delete the user's editor placements. Seeded obstacles alone yield to
 # this new fixed building and its narrow access lane. The seed data is intact.
 if d.get("edited",false):return true
 if RESERVED.grow(35).has_point(d.pos):return false
 if d.kind=="flower":return true
 var lane=WorldPaths.florist_lane(seed)
 for i in lane.size()-1:
  if (d.pos as Vector2).distance_to(Geometry2D.get_closest_point_to_segment(d.pos,lane[i],lane[i+1]))<48:return false
 return true
func _ready():
 var world:Node2D=get_parent()
 var shop=Sprite2D.new();shop.name="FloristShopArt";shop.texture=SHOP;shop.offset=Vector2(0,-SHOP.get_height()*.5);shop.position=BASE
 shop.scale=Vector2.ONE*(HEIGHT/SHOP.get_height());world.add_child(shop)
 # Sort at the bottom of the image; no enterable interior is claimed.
 var solid=WorldPhysics.add_box(world,BODY);solid.name="FloristShopBody"
 if world.has_method("register_occluder"):world.register_occluder("florist_shop",Rect2(BASE-Vector2(WIDTH*.5,HEIGHT),Vector2(WIDTH,HEIGHT-30)))
 var woman=Sprite2D.new();woman.name="FloristArt";woman.texture=FLORIST;woman.scale=Vector2.ONE*(92.0/FLORIST.get_height());woman.position=FLORIST_FEET;woman.offset=Vector2(0,-FLORIST.get_height()*.5);world.add_child(woman)
 var flower_positions=[Vector2(500,365),Vector2(510,400),Vector2(525,430),Vector2(550,445),Vector2(580,440),Vector2(610,435),Vector2(635,425),Vector2(783,360),Vector2(800,390),Vector2(800,425),Vector2(780,450),Vector2(760,465),Vector2(725,465),Vector2(622,395),Vector2(730,390),Vector2(515,310),Vector2(795,315),Vector2(490,405)]
 for i in flower_positions.size():
  var flower=Sprite2D.new();flower.name="FloristFlowers%d"%i;flower.texture=Decor.FLOWER_TEXS[i%Decor.FLOWER_TEXS.size()];flower.scale=Vector2.ONE*((18.+i%3*3)/flower.texture.get_height());flower.position=flower_positions[i];flower.offset=Vector2(0,-flower.texture.get_height()*.5);world.add_child(flower)
