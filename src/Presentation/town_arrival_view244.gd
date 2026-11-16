extends Node2D
## Complete low-detail terrain/contour, using the exact town plan and material.
## No new chunks, actors, colliders, discovery, rewards or simulation are created.
var plan:Dictionary
var world:Node
var ground:Node2D
var walls:Node2D
func _ready()->void:
 ground=Node2D.new();ground.z_index=-9;ground.texture_repeat=CanvasItem.TEXTURE_REPEAT_ENABLED;add_child(ground)
 ground.draw.connect(_ground)
 walls=Node2D.new();walls.z_index=-6;walls.texture_repeat=CanvasItem.TEXTURE_REPEAT_ENABLED;add_child(walls)
 walls.draw.connect(_walls)
func _ground()->void:
 var box:Rect2=(plan.bounds as Rect2).grow(7000.)
 var points:=PackedVector2Array([box.position,Vector2(box.end.x,box.position.y),box.end,Vector2(box.position.x,box.end.y)])
 var uv:=PackedVector2Array()
 for point in points:uv.append(WorldGrassTexture.uv_at(SaveData.world_seed,point))
 ground.draw_polygon(points,PackedColorArray([Color.WHITE]),uv,WorldGrassTexture.CACHE)
func _walls()->void:
 var shape:Dictionary=TownWallArt242.geometry(plan)
 var look:Dictionary=TownIdentity215.look(SaveData.world_cousins140,plan.id)
 for polygon in shape.outer:walls.draw_colored_polygon(polygon,Color('514537'))
 for polygon in shape.surface:walls.draw_colored_polygon(polygon,Color('ead7aa'))
 for polygon in shape.inset:
  var uv:=PackedVector2Array()
  for point in polygon:uv.append(point/128.)
  walls.draw_polygon(polygon,PackedColorArray([Color.WHITE]),uv,TownPaint215.texture(look))
