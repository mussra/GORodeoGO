class_name WorldCamera243
extends HBoxContainer
## Camera-only presentation. No gesture recognizer, physics or streaming changes.
const STEPS:Array[float]=[.05,.1,.15,.25,.35,.5,.65,.75,.85,1.,1.25,1.5]
const PREF_PATH:String='user://world_camera243.cfg'
var world:Node
var camera:Camera2D
var minus:Button
var reset:Button
var plus:Button
var factor:float=1.
var arrival_active244:bool=false
var overview246:Node2D
func _ready()->void:
 name='WorldCamera243';add_theme_constant_override('separation',6)
 mouse_filter=Control.MOUSE_FILTER_IGNORE
 minus=_button('−',48.);minus.tooltip_text='Alejar la cámara'
 reset=_button('100%',108.);reset.tooltip_text='Volver a la vista normal'
 plus=_button('+',48.);plus.tooltip_text='Acercar la cámara'
 minus.pressed.connect(func():step(-1))
 reset.pressed.connect(func():set_factor(1.))
 plus.pressed.connect(func():step(1))
 get_viewport().size_changed.connect(_layout)
 var cfg:=ConfigFile.new()
 if cfg.load(PREF_PATH)==OK:factor=clampf(float(cfg.get_value('camera','zoom',1.)),.05,1.5)
 set_factor(factor,false);_layout();_overview246.call_deferred()
func _button(text_:String,width:float)->Button:
 var button:=Button.new();button.text=text_;button.custom_minimum_size=Vector2(width,46)
 button.focus_mode=Control.FOCUS_NONE;QuestButtonStyle.apply(button)
 add_child(button);return button
static func minimum_for(_extent:Vector2)->float:return .05
static func spawn_radius249(zoom_:float)->int:
 return 3 if zoom_<.25 else 2 if zoom_<.7 else 1
static func loaded_minimum246(extent:Vector2)->float:
 return clampf(maxf(extent.x,extent.y)/1848.,.75,1.)
func step(direction:int)->void:
 if arrival_active244 and world.get("_arrival244")!=null:world._arrival244.finish(false)
 var target:float=factor
 if direction<0:
  for i in range(STEPS.size()-1,-1,-1):
   if STEPS[i]<factor-.001:target=STEPS[i];break
 else:
  for value in STEPS:
   if value>factor+.001:target=value;break
 set_factor(target)
func set_factor(value:float,persist:bool=true)->void:
 factor=clampf(value,minimum_for(get_viewport_rect().size),1.5)
 if arrival_active244 and world!=null and world.get("_arrival244")!=null:world._arrival244.finish(false)
 if is_instance_valid(camera):camera.zoom=Vector2.ONE*factor
 # Only tiny, non-colliding decorative flowers disappear in overview. Collectible
 # quest flowers use another renderer and remain visible and interactive.
 for decor in get_tree().get_nodes_in_group('overview_decor243'):
  if decor.get_viewport()==get_viewport():decor.visible=factor>=.99
 _overview246()
 reset.text='%d%%'%roundi(factor*100.)
 minus.disabled=factor<=minimum_for(get_viewport_rect().size)+.001
 plus.disabled=factor>=1.499
 if persist:
  var cfg:=ConfigFile.new();cfg.set_value('camera','zoom',factor);cfg.save(PREF_PATH)
func _layout()->void:
 var extent:Vector2=get_viewport_rect().size
 position=Vector2(maxf(204.,extent.x-232.),62.)
 set_factor(factor,false)
func _process(_delta:float)->void:
 if not is_instance_valid(world):return
 visible=not world._loading_world and not world._map_overlay.expanded and not is_instance_valid(world._navigation) and not is_instance_valid(world._npc_dialog) and not is_instance_valid(world._journal140) and not is_instance_valid(world._note_dialog106) and not is_instance_valid(world._board_panel) and not world._quest_panel.visible and not world._edit_mode

func _overview246()->void:
 if not is_instance_valid(world) or not world is Node2D:return
 var needs:bool=factor<loaded_minimum246(get_viewport_rect().size)
 if needs and not is_instance_valid(overview246):
  overview246=load('res://src/Presentation/town_arrival_view244.gd').new();overview246.world=world;overview246.overview246=true;world.add_child(overview246)
 elif not needs and is_instance_valid(overview246):overview246.queue_free();overview246=null
 if world.get('_arrival244')!=null and not world._arrival244.active:world._arrival244._set_lod(factor<.7)
