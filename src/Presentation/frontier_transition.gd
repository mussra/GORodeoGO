class_name FrontierTransition
extends CanvasLayer
## One curtain across menu -> world. Existing art/cache only; no saved state.
const NODE_NAME="FrontierTransition"
var curtain:Control
var phase:float=0.0
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
func _process(delta:float):
 phase+=delta;curtain.queue_redraw()
func _paint():
 var size=get_viewport().get_visible_rect().size
 curtain.draw_rect(Rect2(Vector2.ZERO,size),Color("10252d"))
 var center=size*.5
 # Small warm orbit, no loading words or percent that could lie about progress.
 curtain.draw_arc(center,23,0,TAU,64,Color("25434a"),3,true)
 curtain.draw_arc(center,23,phase*2.6,phase*2.6+1.6,24,Color("dfbe7c"),3,true)
 curtain.draw_circle(center,4.0+sin(phase*2)*.6,Color("dfbe7c"))
func enter_world():
 var fade=create_tween();fade.tween_property(curtain,"modulate:a",1.0,.22).set_trans(Tween.TRANS_SINE)
 await fade.finished
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
   if Time.get_ticks_usec()-start>3000:
    await get_tree().process_frame;start=Time.get_ticks_usec()
  art.frame_cache[key]=frames
func reveal():
 if revealing:return
 revealing=true
 var fade=create_tween();fade.tween_property(curtain,"modulate:a",0.0,.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
 await fade.finished;queue_free()
