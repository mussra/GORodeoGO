class_name SiestaEye163
extends Control
## One feathered eye mask for all shared siesta transitions.
var aperture:float=0.:
 set(value):
  aperture=value
  if material!=null:material.set_shader_parameter("aperture",value)
  queue_redraw()
func _ready():
 var mask:=ShaderMaterial.new();mask.shader=preload("res://art/siesta_eye164.gdshader");mask.set_shader_parameter("aperture",aperture);material=mask
func _draw():
 if size.x>0. and size.y>0.:draw_rect(Rect2(Vector2.ZERO,size),Color.WHITE)
