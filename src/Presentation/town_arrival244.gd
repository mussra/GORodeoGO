class_name TownArrival244
extends Node
## A short camera presentation, never pauses the rider or grows streaming radius.
const PREF_PATH:String='user://town_arrivals244.cfg'
const OUT_SECONDS:float=.65
const HOLD_SECONDS:float=1.
const BACK_SECONDS:float=.65
const CHECK_SECONDS:float=.25
var world:Node
var camera:Camera2D
var controls:WorldCamera243
var seen:Dictionary={}
var active:bool=false
var elapsed:float=0.
var clock:float=0.
var plan:Dictionary={}
var target_zoom:float=1.
var start_zoom:float=1.
var start_offset:Vector2=Vector2.ZERO
var preview:Node2D
var title:Label
var checks:int=0
var attempted:Dictionary={}
var lod_applied:bool=false
var hidden_nodes:Dictionary={}
func _ready()->void:
 var cfg:=ConfigFile.new()
 if cfg.load(PREF_PATH)==OK:
  var values=cfg.get_value('arrival','seen',{})
  if values is Dictionary:seen=values
 camera=world.get_viewport().get_camera_2d();controls=world._camera_controls243
 var layer:=CanvasLayer.new();layer.layer=21;add_child(layer)
 title=Label.new();title.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER;title.mouse_filter=Control.MOUSE_FILTER_IGNORE
 title.add_theme_font_size_override('font_size',20)
 title.add_theme_stylebox_override('normal',RanchTheme.box(Color('183c30ee'),Color('d9ab58'),6))
 layer.add_child(title);title.hide()
func key(id:String)->String:return '%s|%d|%d|%s'%[SaveData.save_path,SaveData.world_seed,SaveData.world_generator_version,id]
func blocked()->bool:
 return world._loading_world or world._map_overlay.expanded or is_instance_valid(world._navigation) or is_instance_valid(world._npc_dialog) or is_instance_valid(world._journal140) or is_instance_valid(world._note_dialog106) or is_instance_valid(world._board_panel) or world._quest_panel.visible or world._edit_mode or (world._travel144!=null and (world._travel144.active or is_instance_valid(world._travel144.panel))) or not world.player.is_physics_processing() or get_tree().paused
func _process(delta:float)->void:
 if active:
  if blocked() or world.player.dodge.drawing or world.player.lasso.is_charging():finish(false);return
  elapsed+=delta;apply_frame()
  if elapsed>=OUT_SECONDS+HOLD_SECONDS+BACK_SECONDS:finish(true)
  return
 clock+=delta
 if clock<CHECK_SECONDS:return
 clock=0.;checks+=1
 if blocked() or SaveData.world_generator_version<4:return
 if world.player.dodge.drawing or world.player.lasso.is_charging():return
 for candidate in TownEnclosures227.plans(SaveData.world_seed).values():
  if seen.has(key(candidate.id)) or attempted.has(key(candidate.id)):continue
  # Trigger at any wall approach, including side entrances, not only the gate.
  var distance:float=INF
  for segment in candidate.segments:
   distance=minf(distance,world.player.position.distance_to(Geometry2D.get_closest_point_to_segment(world.player.position,segment.a,segment.b)))
  if distance<=420. or (candidate.bounds as Rect2).has_point(world.player.position):
   begin(candidate);return
static func fitted_zoom(bounds:Rect2,extent:Vector2)->float:
 # Reserve the top HUD/title, bottom controls and a small margin around the wall.
 var available:Vector2=(extent-Vector2(100,270)).max(Vector2(100,100))
 return minf(available.x/(bounds.size.x+180.),available.y/(bounds.size.y+180.))
func begin(candidate:Dictionary)->void:
 if active:return
 attempted[key(candidate.id)]=true
 plan=candidate;start_zoom=controls.factor;start_offset=camera.offset
 target_zoom=minf(start_zoom,fitted_zoom(plan.bounds,get_viewport().get_visible_rect().size))
 elapsed=0.;active=true;controls.arrival_active244=true
 preview=load('res://src/Presentation/town_arrival_view244.gd').new();preview.plan=plan;preview.world=world;world.add_child(preview)
 title.text='Vista de llegada · '+TownIdentity215.title(SaveData.world_cousins140,plan.id)
 var extent:Vector2=get_viewport().get_visible_rect().size
 title.size=Vector2(minf(650.,extent.x-40.),40.);title.position=Vector2((extent.x-title.size.x)*.5,62.);title.show()
 apply_frame()
func apply_frame()->void:
 var blend:float
 if elapsed<OUT_SECONDS:blend=smoothstep(0.,1.,elapsed/OUT_SECONDS)
 elif elapsed<OUT_SECONDS+HOLD_SECONDS:blend=1.
 else:blend=1.-smoothstep(0.,1.,(elapsed-OUT_SECONDS-HOLD_SECONDS)/BACK_SECONDS)
 camera.zoom=Vector2.ONE*lerpf(start_zoom,target_zoom,blend)
 # Center stays still for the full one-second hold; player simulation continues.
 var center:Vector2=plan.bounds.get_center()+Vector2(0,-20.)
 camera.offset=start_offset.lerp(center-world.player.global_position,blend)
 preview.visible=blend>.02
 _set_lod(camera.zoom.x<.7)
func finish(completed:bool)->void:
 if not active:return
 _set_lod(false)
 active=false;camera.zoom=Vector2.ONE*controls.factor;camera.offset=start_offset;controls.arrival_active244=false
 if is_instance_valid(preview):preview.queue_free()
 title.hide()
 if completed:
  seen[key(plan.id)]=true
  var cfg:=ConfigFile.new();cfg.set_value('arrival','seen',seen)
  if cfg.save(PREF_PATH)!=OK:push_warning('Could not save town arrival preference; it may replay next session.')
func _set_lod(enabled:bool)->void:
 if enabled==lod_applied:return
 lod_applied=enabled
 if enabled:
  for group in ['arrival_decor244','arrival_streamed244']:
   for item in get_tree().get_nodes_in_group(group):
    if item.get_viewport()!=get_viewport():continue
    hidden_nodes[item]=item.visible;item.hide()
 else:
  for item in hidden_nodes:
   if is_instance_valid(item):item.visible=hidden_nodes[item]
  # Nodes streamed while overview was active were hidden in their _ready.
  for group in ['arrival_decor244','arrival_streamed244']:
   for item in get_tree().get_nodes_in_group(group):
    if item.get_viewport()!=get_viewport():continue
    if hidden_nodes.has(item):continue
    if group=='arrival_streamed244':item.show()
    elif item.kind!='flower' or controls.factor>=.99:item.show()
  hidden_nodes.clear()
func _exit_tree()->void:
 if active and is_instance_valid(camera):
  _set_lod(false)
  camera.offset=start_offset
  camera.zoom=Vector2.ONE*start_zoom
  if is_instance_valid(controls):controls.arrival_active244=false
  if is_instance_valid(preview):preview.queue_free()
