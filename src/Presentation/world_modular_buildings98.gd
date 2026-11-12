class_name WorldModularBuildings98
extends Node2D
const Layout=preload("res://src/Presentation/modular_world_layout93.gd")
var collision_rects:Array[Rect2]=[]
func _ready():
 y_sort_enabled=true
 _buildings()
func _sprite(texture:Texture2D,feet:Vector2,height:float,name_:String)->Sprite2D:
 var sprite=Sprite2D.new();sprite.texture=texture;sprite.position=feet;sprite.offset=Vector2(0,-texture.get_height()/2.);sprite.scale=Vector2.ONE*height/texture.get_height();sprite.name=name_;add_child(sprite)
 if height>=116 and get_parent().has_method("register_occluder"):
  var width:float=texture.get_width()*sprite.scale.x
  get_parent().register_occluder("nominal98_"+name_,Rect2(feet-Vector2(width/2,height),Vector2(width,height-16)))
 return sprite
func _solid(rect:Rect2):collision_rects.append(rect);WorldPhysics.add_box(self,rect)
func _buildings():
 for id in ["house_west","house_east"]:
  var door=Layout.world(Layout.DOORS[id]);var width=140.;var height=116.
  # Ant's house door at 37% of the art width, threshold at the base.
  var feet=door+Vector2((.5-.37)*width,0)
  _sprite(WorldTestZone.HOUSE_TEX,feet,height,id)
  _solid(Rect2(feet+Vector2(-58,-50),Vector2(116,30)))
 var ranch=Layout.world(Layout.DOORS.ranch)
 _sprite(preload("res://src/Presentation/world_ranch.gd").BARN_TEX,ranch+Vector2(8,0),120,"RanchBarn")
 _solid(Rect2(ranch+Vector2(-48,-45),Vector2(96,25)))
 var door=Layout.world(Layout.DOORS.florist);var offset=door-WorldFloristShop.DOOR
 _sprite(WorldFloristShop.SHOP,WorldFloristShop.BASE+offset,200,"FloristShop")
 _solid(Rect2(WorldFloristShop.BODY.position+offset,WorldFloristShop.BODY.size))
 _sprite(WorldFloristShop.FLORIST,WorldFloristShop.FLORIST_FEET+offset,92,"Florist")
 for i in 16:
  var side=-1 if i<8 else 1;var feet=door+Vector2(side*(65+(i%4)*16),18+(i%4)*10)
  _sprite(WorldFloristShop.Decor.FLOWER_TEXS[i%WorldFloristShop.Decor.FLOWER_TEXS.size()],feet,18+i%3*3,"Flower%d"%i)
