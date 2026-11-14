class_name TownIcon215
extends Control
var look:Dictionary={}
func _ready():mouse_filter=Control.MOUSE_FILTER_IGNORE;texture_repeat=CanvasItem.TEXTURE_REPEAT_ENABLED
func _draw():
 if not look.is_empty():TownPaint215.icon(self,Rect2(Vector2.ZERO,size),look)
