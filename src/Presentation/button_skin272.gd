class_name ButtonSkin272
extends RefCounted
## Ant's supplied artwork. Shared nine-slice skin, labels and hit areas unchanged.
static var cache:Dictionary={}
static func style(state:String,primary:bool=false)->StyleBoxTexture:
 var key:String=("primary" if primary else "secondary")+"_"+state
 if not cache.has(key):
  var image:Image=load("res://art/ui/skin272/"+key+".png").get_image()
  if image.is_compressed():image.decompress()
  image.resize(120,54,Image.INTERPOLATE_LANCZOS)
  var result:=StyleBoxTexture.new();result.texture=ImageTexture.create_from_image(image)
  for side in [SIDE_LEFT,SIDE_RIGHT]:result.set_texture_margin(side,20.0);result.set_content_margin(side,30.0)
  for side in [SIDE_TOP,SIDE_BOTTOM]:result.set_texture_margin(side,17.0);result.set_content_margin(side,8.0)
  cache[key]=result
 return cache[key]
static func apply(button:BaseButton,primary:bool=false)->void:
 button.set_meta("skin272",true)
 for state in ["normal","hover","pressed","disabled"]:button.add_theme_stylebox_override(state,style(state,primary))
 # Hover while pressed must stay a pressed face, not flash back to the old theme.
 button.add_theme_stylebox_override("hover_pressed",style("pressed",primary))
 for state in ["font_color","font_hover_color","font_pressed_color","font_focus_color"]:button.add_theme_color_override(state,Color("fff1d2"))
 button.add_theme_color_override("font_disabled_color",Color("e1d7bc"))
 var focus:=StyleBoxFlat.new();focus.bg_color=Color.TRANSPARENT;focus.border_color=Color("fff1d2");focus.set_border_width_all(2);focus.set_corner_radius_all(9)
 button.add_theme_stylebox_override("focus",focus)
static func tree(host:Node)->void:
 for node in host.get_children():
  if node is BaseButton:apply(node)
  tree(node)
