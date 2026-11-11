class_name FrontierTransition
extends CanvasLayer
## One curtain across menu -> world. Existing art/cache only; no saved state.
const NODE_NAME="FrontierTransition"
var curtain:Control
var parade:LoadingParade
var entered_usec:int=0
var revealing:bool=false
static func obtain(tree:SceneTree,opaque:bool=true)->FrontierTransition:
 var old=tree.root.get_node_or_null(NODE_NAME)
 if old!=null:return old
 var cover=FrontierTransition.new();cover.name=NODE_NAME;tree.root.add_child(cover)
 cover.curtain.modulate.a=1.0 if opaque else 0.0
 return cover
func _ready():
 layer=200
 curtain=Control.new();curtain.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);curtain.mouse_filter=Control.MOUSE_FILTER_STOP;add_child(curtain)
 curtain.draw.connect(_paint)
 parade=LoadingParade.new();curtain.add_child(parade)
func _process(_delta:float):
 if is_instance_valid(parade):parade.scale=get_viewport().get_visible_rect().size/Vector2(1280,720)
 curtain.queue_redraw()
func _paint():
 curtain.draw_rect(Rect2(Vector2.ZERO,get_viewport().get_visible_rect().size),Color("10252d"))
func enter_world():
 entered_usec=Time.get_ticks_usec()
 var fade=create_tween();fade.tween_property(curtain,"modulate:a",1.0,.22).set_trans(Tween.TRANS_SINE)
 await fade.finished
 if not parade.prepared:await parade.preparation_finished
 await _warm_showcase()
 get_tree().change_scene_to_file("res://src/Presentation/frontier_world.tscn")
func _warm_showcase():
 var art=load("res://src/Presentation/wild_horse_art.gd")
 for horse in WorldTestZone.HORSES:
  var traits:Dictionary=horse.traits;var key=PixelLabTrial.cache_key(traits)
  if art.frame_cache.has(key):continue
  var frames=SpriteFrames.new();var start=Time.get_ticks_usec()
  for step in PixelLabTrial.frame_specs("horse"):
   PixelLabTrial.append_pose(frames,"horse",step,traits)
   if Time.get_ticks_usec()-start>8000:
    await get_tree().process_frame;start=Time.get_ticks_usec()
  art.frame_cache[key]=frames
func reveal():
 if revealing:return
 revealing=true
 if not parade.prepared:await parade.preparation_finished
 parade.finish()
 if entered_usec>0:print("LOAD_PARADE chunks_ready_ms=",(Time.get_ticks_usec()-entered_usec)/1000.0)
 var fade=create_tween();fade.tween_property(curtain,"modulate:a",0.0,.5)
 await fade.finished;queue_free()
