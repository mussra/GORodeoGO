class_name SiestaCurtain147
extends CanvasLayer
## Shared eye transition and initial autonomous walk for all siesta adapters.
var destination:String=""
var horse:Dictionary={}
var hat:String="original"
var message:Label
var zlabel:Label
var clock:float=0.
var eye:SiestaEye163
var phase:String="idle"
var actor:CharacterBody2D
var route:PackedVector2Array
var route_index:int=1
var walking:bool=false
var walk_blocked:bool=false
var actor_mode:int
var actor_input:bool
func _ready():
 layer=220;process_mode=Node.PROCESS_MODE_ALWAYS
 eye=SiestaEye163.new();eye.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);eye.mouse_filter=Control.MOUSE_FILTER_STOP;add_child(eye)
 message=Label.new();message.text="Una siesta rumbo a "+destination;message.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER;message.add_theme_font_size_override("font_size",24);message.visible=true;eye.add_child(message)
 zlabel=Label.new();zlabel.text="";zlabel.visible=false;eye.add_child(zlabel)
 var fit:Callable=func():message.position=Vector2(20,eye.size.y*.64);message.size=Vector2(eye.size.x-40,96);message.add_theme_color_override("font_color",Color("fff2d2"));eye.queue_redraw()
 eye.resized.connect(fit);fit.call()
func close_eye(player:CharacterBody2D,path:PackedVector2Array)->bool:
 message.visible=false
 actor=player;actor_mode=actor.process_mode;actor_input=actor.is_processing_input();actor.process_mode=Node.PROCESS_MODE_ALWAYS;actor.set_process_input(false);_aperture(1.);route=path;phase="closing";walking=true;walk_blocked=false;route_index=1
 var tween:=create_tween();tween.tween_method(_aperture,1.,0.,1.);await tween.finished
 walking=false;actor.velocity=Vector2.ZERO;actor._update_animation(0.);phase="covered";message.visible=true;message.text="Cargando el camino...\nEspera un momento";return not walk_blocked
func open_eye()->void:
 phase="opening";message.visible=false
 var tween:=create_tween();tween.tween_method(_aperture,0.,1.,1.);await tween.finished;phase="done"
 if is_instance_valid(actor):actor.process_mode=actor_mode;actor.set_process_input(actor_input)
func _aperture(value:float)->void:eye.aperture=value;eye.queue_redraw()
func _physics_process(delta:float):
 clock+=delta
 if phase=="covered" and is_instance_valid(message) and message.text.begins_with("Cargando el camino"):message.text="Cargando el camino"+".".repeat(1+int(clock*2.)%3)+"\nEspera un momento"
 if not walking or not is_instance_valid(actor):return
 while route_index<route.size() and actor.position.distance_to(route[route_index])<3.:route_index+=1
 if route_index>=route.size():walking=false;return
 var direction:Vector2=actor.position.direction_to(route[route_index]);var speed:float=minf(90.,actor.max_speed*.35)
 var motion:Vector2=direction*minf(speed*delta,actor.position.distance_to(route[route_index]))
 actor.gait=WorldGait.PASO;actor.velocity=direction*speed
 if actor.move_and_collide(motion)!=null:walk_blocked=true;walking=false;actor.velocity=Vector2.ZERO
 actor._update_animation(delta)
