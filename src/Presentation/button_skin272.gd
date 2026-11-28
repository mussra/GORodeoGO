class_name ButtonSkin272
extends RefCounted
## Approved 3.0.0 repeat skin. Fixed corners, tiled edges and center, unchanged actions.
static var cache:Dictionary={}
static func style(state:String,primary:bool=false)->StyleBoxTexture:
 var key:String=state if state in ["normal","pressed","disabled"] else "normal"
 if not cache.has(key):
  var result:=StyleBoxTexture.new()
  result.texture=load("res://art/ui/tiled300/"+key+".png")
  result.axis_stretch_horizontal=StyleBoxTexture.AXIS_STRETCH_MODE_TILE
  result.axis_stretch_vertical=StyleBoxTexture.AXIS_STRETCH_MODE_TILE
  for side in [SIDE_LEFT,SIDE_RIGHT]:result.set_texture_margin(side,32.0);result.set_content_margin(side,30.0)
  for side in [SIDE_TOP,SIDE_BOTTOM]:result.set_texture_margin(side,23.0);result.set_content_margin(side,8.0)
  if key=="pressed":
   result.set_content_margin(SIDE_TOP,11.0);result.set_content_margin(SIDE_BOTTOM,5.0)
  cache[key]=result
 return cache[key]
static func apply(button:BaseButton,primary:bool=false)->void:
 button.set_meta("skin272",true)
 for state in ["normal","hover","pressed","disabled"]:button.add_theme_stylebox_override(state,style(state,primary))
 # Hover while pressed must stay a pressed face, not flash back to the old theme.
 button.add_theme_stylebox_override("hover_pressed",style("pressed",primary))
 for state in ["font_color","font_hover_color","font_pressed_color","font_focus_color"]:button.add_theme_color_override(state,Color("fff1d2"))
 button.add_theme_color_override("font_disabled_color",Color("b4b6b2"))
 var focus:=StyleBoxFlat.new();focus.bg_color=Color.TRANSPARENT;focus.border_color=Color("fff1d2");focus.set_border_width_all(2);focus.set_corner_radius_all(9)
 button.add_theme_stylebox_override("focus",focus)
static func tree(host:Node)->void:
 for node in host.get_children():
  if node is BaseButton:apply(node)
  elif node is Panel or node is PanelContainer:panel(node)
  tree(node)

static func panel(target:Control)->void:
 var box:=style("normal").duplicate() as StyleBoxTexture
 box.content_margin_left=32;box.content_margin_right=32
 box.content_margin_top=28;box.content_margin_bottom=28
 target.add_theme_stylebox_override("panel",box)
 target.set_meta("tiled300",true)

## 3.0.43: botones estrechos (Ficha, Familia, filtros): mismo marco, margen lateral pequeño para que el texto quepa entero.
static func compact(button:BaseButton,side:float=10.0)->void:
 apply(button)
 for state in ["normal","hover","pressed","disabled","hover_pressed"]:
  var box:=button.get_theme_stylebox(state).duplicate() as StyleBoxTexture
  box.content_margin_left=side;box.content_margin_right=side
  button.add_theme_stylebox_override(state,box)
