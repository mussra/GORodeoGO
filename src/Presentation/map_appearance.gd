class_name MapAppearance
extends RefCounted
const OPACITY:float=.75
static func floor_color(hex:String)->Color:
 var color:=Color(hex);color.a=OPACITY;return color
static func terrain_over_base(hex:String)->Color:
 var color:=Color(hex);color.a=.20;return color
static func frame()->StyleBoxFlat:
 return RanchTheme.box(Color.TRANSPARENT,Color("89bdb7"),9)
