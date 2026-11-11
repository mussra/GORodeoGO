class_name AnimalFatigueBar
extends RefCounted
## Same no-number energy bar above pigs and goats, including recovery.
static func draw(item:CanvasItem,state:Dictionary)->void:
 var energy:float=AnimalFatigue.energy(state)
 item.draw_line(Vector2(-26,-70),Vector2(26,-70),Color("172e32"),9,true)
 item.draw_line(Vector2(-25,-70),Vector2(-25+50*energy,-70),Color("e8bb67") if energy<.35 else Color("8ed5a5"),6,true)
 if bool(state.get("tired",false)):
  item.draw_arc(Vector2(0,10),22,0,TAU,32,Color("e8bb67"),2,true)
