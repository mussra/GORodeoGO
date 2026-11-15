class_name TownLayer227
extends Node2D
## Gate posts, signs and shared access roads. Walls stream through Mountains103.
var seed:int
func _ready():z_index=-5;texture_repeat=CanvasItem.TEXTURE_REPEAT_ENABLED
func _draw():
 var font:Font=ThemeDB.fallback_font
 for plan in TownEnclosures227.plans(seed).values():
  var road:PackedVector2Array=plan.road
  for i in road.size()-1:
   if road[i].distance_to(road[i+1])>1.:ContinuousRoadArt.access(self,PackedVector2Array([road[i],road[i+1]]),40.)
  var look:=TownIdentity215.look(SaveData.world_cousins140,plan.id)
  for post in plan.posts:
   draw_style_box(RanchTheme.box(Color(look.base),Color("514537"),5),Rect2(post-Vector2(46,48),Vector2(92,96)))
   draw_line(post+Vector2(-43,-40),post+Vector2(43,-40),Color("f3dfb3"),7.)
   # Open wooden leaves rest alongside the wall, never across the passage.
   var side:float=-1. if post.x<plan.gate.x else 1.
   var leaf:=Rect2(post+Vector2(side*46. if side>0 else -146.,-22),Vector2(100,44))
   draw_style_box(RanchTheme.box(Color("8b5e37"),Color("e3c086"),3),leaf)
   for plank in 5:
    var x:float=leaf.position.x+plank*20.;draw_line(Vector2(x,leaf.position.y+4),Vector2(x,leaf.end.y-4),Color("573d2b"),2.)
  var at:Vector2=plan.gate+plan.outward*140.+Vector2(130,-30)
  var label:String=TownIdentity215.title(SaveData.world_cousins140,plan.id)
  var width:float=font.get_string_size(label,HORIZONTAL_ALIGNMENT_LEFT,-1,23).x+36.
  draw_line(at+Vector2(0,8),at+Vector2(0,75),Color("725138"),10.)
  draw_style_box(RanchTheme.box(Color("4e3827"),Color("dab66d"),6),Rect2(at-Vector2(18,31),Vector2(width,49)))
  draw_string(font,at,label,HORIZONTAL_ALIGNMENT_LEFT,-1,23,Color("fff1cd"))
