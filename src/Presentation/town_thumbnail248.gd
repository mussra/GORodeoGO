class_name TownThumbnail248
extends TextureRect
## One-shot raster of the real town contour. Cache textures, never live worlds.
static var cache:Dictionary={}
const LIMIT:int=24
const EXTENT:Vector2i=Vector2i(288,160)
var town:String
var seed_:int
var plan248:Dictionary={}
var look248:Dictionary={}
var raster248:SubViewport
func _ready():
 mouse_filter=Control.MOUSE_FILTER_IGNORE;expand_mode=TextureRect.EXPAND_IGNORE_SIZE;stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED
 plan248=TownEnclosures227.plans(seed_).get(town,{})
 look248=TownIdentity215.look(SaveData.world_cousins140,town)
 if plan248.is_empty():return
 var key_:String=str(hash([plan248.segments,look248]))
 if cache.has(key_):texture=cache[key_];return
 # Sizing/texture work happens only at dialog opening. UPDATE_ONCE is disabled
 # by the renderer after its first image, then this viewport is released.
 raster248=SubViewport.new();raster248.size=EXTENT;raster248.transparent_bg=false;raster248.render_target_update_mode=SubViewport.UPDATE_ONCE;raster248.disable_3d=true;add_child(raster248)
 var canvas:=Node2D.new();canvas.texture_repeat=TownPaint215.REPEAT248;raster248.add_child(canvas)
 canvas.draw.connect(func():draw248(canvas,plan248,look248))
 canvas.queue_redraw()
 if DisplayServer.get_name()=='headless':return
 await RenderingServer.frame_post_draw
 if not is_instance_valid(raster248):return
 var image:Image=raster248.get_texture().get_image()
 if image!=null:
  texture=ImageTexture.create_from_image(image)
  if cache.size()>=LIMIT:cache.erase(cache.keys()[0])
  cache[key_]=texture
 raster248.queue_free();raster248=null
static func draw248(canvas:CanvasItem,plan:Dictionary,look:Dictionary)->void:
 canvas.draw_rect(Rect2(Vector2.ZERO,Vector2(EXTENT)),Color('23443f'))
 var box:Rect2=(plan.bounds as Rect2).grow(80.)
 var scale_:float=minf(214./box.size.x,140./box.size.y)
 var offset_:Vector2=Vector2(118,80)-box.get_center()*scale_
 # Same contour, gate opening, colours and global UVs as world and map.
 var geometry:Dictionary=TownWallArt242.geometry(plan)
 for layer_ in ['outer','surface','inset']:
  for polygon in geometry[layer_]:
   var points:=PackedVector2Array();var uv:=PackedVector2Array()
   for point in polygon:points.append(offset_+point*scale_);uv.append(TownPaint215.uv248(point))
   if layer_=='inset':canvas.draw_polygon(points,PackedColorArray([Color.WHITE]),uv,TownPaint215.texture(look))
   else:canvas.draw_colored_polygon(points,Color('514537') if layer_=='outer' else Color('ead7aa'))
 # The map-sized outline can be subpixel thick. A material sample makes its
 # real pattern legible without inventing a thicker wall or a generic village.
 var swatch:=Rect2(232,16,44,128)
 canvas.draw_rect(swatch.grow(2.),Color('ead7aa'))
 canvas.draw_texture_rect(TownPaint215.texture(look),swatch,true)
