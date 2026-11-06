class_name JoystickAppearance
extends RefCounted
static func apply(level:Node)->void:
 var tex:=GradientTexture2D.new();tex.width=220;tex.height=220;tex.fill=GradientTexture2D.FILL_RADIAL;tex.fill_from=Vector2(.5,.5);tex.fill_to=Vector2(1,.5)
 var g:=Gradient.new();g.offsets=PackedFloat32Array([0,.86,.9,.96,1]);g.colors=PackedColorArray([Color(.18,.4,.43,.18),Color(.18,.4,.43,.18),Color(.85,.75,.5,.65),Color(.5,.85,.84,.7),Color(.5,.85,.84,0)]);tex.gradient=g
 var tip:=GradientTexture2D.new();tip.width=80;tip.height=80;tip.fill=GradientTexture2D.FILL_RADIAL;tip.fill_from=Vector2(.5,.5);tip.fill_to=Vector2(1,.5);var t:=Gradient.new();t.offsets=PackedFloat32Array([0,.78,.9,1]);t.colors=PackedColorArray([Color(.75,.94,.88,.78),Color(.35,.7,.66,.65),Color(.94,.8,.5,.85),Color(.94,.8,.5,0)]);tip.gradient=t
 for v in [level.get_node("TouchControls/MoveJoystick"),level.aim_joystick]:
  v.joystick_texture=tex;v.tip_texture=tip
  for key in ["ring_normal_color","tip_normal_color","ring_pressed_color","tip_pressed_color"]:v.add_theme_color_override(key,Color.WHITE)
