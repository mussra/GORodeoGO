class_name EquipmentIcon229
extends Control
var kind:String="whip"
func _ready():mouse_filter=Control.MOUSE_FILTER_IGNORE
const KINDS300=["hat","back","horse","adorn","finish","buy","equip","saddle","reins","stirrups","shoes","spurs","blanket","hat_gala","whip","long"]
static var textures300:Dictionary={}
static func texture300(id:String)->Texture2D:
 var key:String=id if id in KINDS300 else "whip"
 if not textures300.has(key):textures300[key]=load("res://art/ui/icons300/"+key+".png")
 return textures300[key]
func _draw():
 # Menu emblem only. Never modifies the player's horse portrait or appearance.
 var art:=texture300(kind)
 var extent:Vector2=art.get_size();var k:float=minf(size.x/extent.x,size.y/extent.y)
 var fitted:Vector2=extent*k
 draw_texture_rect(art,Rect2((size-fitted)*.5,fitted),false)
