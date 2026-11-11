class_name FrontierTransition
extends CanvasLayer
## One curtain across menu -> world. Existing art/cache only; no saved state.
const NODE_NAME="FrontierTransition"
var curtain:Control
var parade:LoadingParade
var entered_usec:int=0
var revealing:bool=false
var frame_ms:Array=[]
var last_frame_usec:int=0
var phase_name:String="prepare"
var worst_phase:String=""
var worst_ms:float=0
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
 var now=Time.get_ticks_usec()
 if last_frame_usec>0:
  var ms=(now-last_frame_usec)/1000.0;frame_ms.append(ms)
  if ms>worst_ms:worst_ms=ms;worst_phase=phase_name
 last_frame_usec=now
 if is_instance_valid(parade):parade.scale=get_viewport().get_visible_rect().size/Vector2(1280,720)
 curtain.queue_redraw()
func _paint():
 curtain.draw_rect(Rect2(Vector2.ZERO,get_viewport().get_visible_rect().size),Color("10252d"))
func enter_world():
 entered_usec=Time.get_ticks_usec()
 var fade=create_tween();fade.tween_property(curtain,"modulate:a",1.0,.22).set_trans(Tween.TRANS_SINE)
 await fade.finished
 if not parade.prepared:await parade.preparation_finished
 # ResourceLoader owns background I/O/import; nodes and gameplay caches remain on main.
 var scene_path="res://src/Presentation/frontier_world.tscn"
 var request_error=ResourceLoader.load_threaded_request(scene_path,"PackedScene")
 phase_name="warm_selected"
 await _warm_selected()
 phase_name="warm_showcase"
 await _warm_showcase()
 phase_name="world_resource"
 if request_error==OK:
  while ResourceLoader.load_threaded_get_status(scene_path)==ResourceLoader.THREAD_LOAD_IN_PROGRESS:
   await get_tree().process_frame
  if ResourceLoader.load_threaded_get_status(scene_path)==ResourceLoader.THREAD_LOAD_LOADED:
   var scene:PackedScene=ResourceLoader.load_threaded_get(scene_path)
   phase_name="scene_ready_chunks"
   get_tree().change_scene_to_packed(scene)
   return
 # Failure retains the established route instead of trapping the loading cover.
 push_warning("Background world load unavailable; using ordinary scene load")
 phase_name="scene_ready_chunks"
 get_tree().change_scene_to_file(scene_path)
func _warm_showcase():
 var art=load("res://src/Presentation/wild_horse_art.gd")
 for horse in WorldTestZone.HORSES:
  var traits:Dictionary=horse.traits;var key=PixelLabTrial.cache_key(traits)
  if art.frame_cache.has(key):continue
  var frames=SpriteFrames.new();var start=Time.get_ticks_usec()
  for step in PixelLabTrial.frame_specs("horse"):
   PixelLabTrial.append_pose(frames,"horse",step,traits)
   await get_tree().process_frame
  art.frame_cache[key]=frames
func _warm_selected():
 var horse=SaveData.horse_collection.find(SaveData.horse_collection.selected)
 var traits:Dictionary=horse.get("traits",{})
 # Prewarm the SAME loader's textures; no new visual pipeline or alternate art.
 var host=Node2D.new();var placeholder=Polygon2D.new();host.add_child(placeholder)
 var swap=SpriteSwap.new(host,placeholder,HatAppearance.art_root(SaveData.hat_color),PixelLabTrial.unreplaced_rider_animations(["idle","walk_side","walk_up","walk_down","walk_diag_down","walk_diag_up","gallop_side"]))
 if swap.has_sprite():
  for anim in swap._frames.get_animation_names():
   for i in swap._frames.get_frame_count(anim):
    HorseAppearance.texture(swap._frames.get_frame_texture(anim,i),anim,i,traits)
    await get_tree().process_frame
 for step in PixelLabTrial.frame_specs("rider"):
  PixelLabTrial.pose_texture("rider",step[0],step[1],traits)
  await get_tree().process_frame
 host.free()
func _write_metrics():
 if frame_ms.is_empty():return
 var ordered=frame_ms.duplicate();ordered.sort()
 var data={"version":"2.7.82+preview83","frames":ordered.size(),"p50_ms":ordered[int(ordered.size()*.5)],"p95_ms":ordered[int(ordered.size()*.95)],"max_ms":worst_ms,"worst_phase":worst_phase,"over_50ms":frame_ms.filter(func(x):return x>50).size(),"over_100ms":frame_ms.filter(func(x):return x>100).size()}
 var file=FileAccess.open("user://loading-last-profile.json",FileAccess.WRITE)
 if file:file.store_string(JSON.stringify(data))
 print("LOAD_FRAME_PROFILE ",JSON.stringify(data))
func reveal():
 if revealing:return
 revealing=true
 if not parade.prepared:await parade.preparation_finished
 phase_name="reveal"
 parade.finish()
 if entered_usec>0:print("LOAD_PARADE chunks_ready_ms=",(Time.get_ticks_usec()-entered_usec)/1000.0)
 var fade=create_tween();fade.tween_property(curtain,"modulate:a",0.0,.5)
 await fade.finished;_write_metrics();queue_free()
