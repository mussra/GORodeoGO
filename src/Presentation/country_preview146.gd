class_name CountryPreview146
extends Node2D
signal return_requested
## Isolated topology/scale prototype. No access gate, ritual or save writes.
var seed:int=752026
var data:Dictionary
var ledger:Dictionary
var player:CharacterBody2D
var camera:Camera2D
var aim_joystick:VirtualJoystick
var status:Label
var visited_cells:Dictionary={}
var river_clock:float=0.
var hud_canvas:Control
const GRASS=preload("res://art/world/alternative92/grass-cache.png")
const TREE=preload("res://art/world/cartoon/tree.png")
func _ready():
 data=CountryRoute146.plan(seed);ledger=CountryLedger146.enter(CountryLedger146.fresh(maxi(1,SaveData.world_seed),SaveData.world_generator_version),SaveData.world_position,seed)
 texture_repeat=CanvasItem.TEXTURE_REPEAT_ENABLED
 var trunk:=Sprite2D.new();trunk.texture=TREE;trunk.centered=false;trunk.position=data.tree_art.position;trunk.scale=data.tree_art.size/Vector2(TREE.get_size());trunk.z_index=0;add_child(trunk)
 WorldPhysics.add_box(self,data.tree).collision_layer=128
 var river:PackedVector2Array=data.river
 for i in range(1,river.size()):
  var body:=StaticBody2D.new();body.collision_layer=128;body.position=(river[i-1]+river[i])/2.;body.rotation=(river[i]-river[i-1]).angle()
  var collision:=CollisionShape2D.new();var shape:=RectangleShape2D.new();shape.size=Vector2(river[i-1].distance_to(river[i]),CountryRoute146.WATER_RADIUS*2.);collision.shape=shape;body.add_child(collision);add_child(body)
 for point in river:
  var body:=StaticBody2D.new();body.collision_layer=128;body.position=point;var collision:=CollisionShape2D.new();var shape:=CircleShape2D.new();shape.radius=CountryRoute146.WATER_RADIUS;collision.shape=shape;body.add_child(collision);add_child(body)
 for box in [Rect2(-100,-100,12700,100),Rect2(-100,14000,12700,100),Rect2(-100,0,100,14000),Rect2(12500,0,100,14000)]:WorldPhysics.add_box(self,box).collision_layer=128
 player=load("res://src/Presentation/world_player.gd").new();player.position=data.entry;player.world_bounds=CountryRoute146.BOUNDS;add_child(player)
 camera=Camera2D.new();player.add_child(camera);camera.make_current()
 var layer:=CanvasLayer.new();add_child(layer)
 hud_canvas=Control.new();hud_canvas.size=Vector2(1280,720);layer.add_child(hud_canvas)
 var fit:Callable=func():
  var size_:Vector2=get_viewport().get_visible_rect().size;var k:float=minf(size_.x/1280.,size_.y/720.);hud_canvas.scale=Vector2.ONE*k;hud_canvas.position=(size_-Vector2(1280,720)*k)/2.
 get_viewport().size_changed.connect(fit);fit.call()
 var bar:=ColorRect.new();bar.color=Color("10252ded");bar.size=Vector2(1280,100);hud_canvas.add_child(bar)
 var title:=Label.new();title.text="País nuevo · maqueta sin guardado ni ritual";title.position=Vector2(20,10);title.add_theme_font_size_override("font_size",24);bar.add_child(title)
 var back:=Button.new();back.text="Volver a Frontera";back.position=Vector2(1010,10);back.size=Vector2(250,60);QuestButtonStyle.apply(back);back.pressed.connect(func():return_requested.emit());bar.add_child(back)
 status=Label.new();status.position=Vector2(20,50);status.add_theme_font_size_override("font_size",21);bar.add_child(status)
 var touch:CanvasLayer=load("res://src/Presentation/touch_controls.tscn").instantiate();add_child(touch)
 var joy:VirtualJoystick=touch.get_node("MoveJoystick");var aim:VirtualJoystick=touch.get_node("AimJoystick");aim_joystick=aim;player.lasso.set_aim_joystick(aim);player.dodge.set_move_joystick(joy);JoystickAppearance.apply(self)
 set_process(true);queue_redraw()
func _process(delta:float):
 river_clock+=delta
 var next:=CountryLedger146.record_position(ledger,player.position)
 if not next.is_empty():ledger=next
 var cell:=Vector2i(floori(player.position.x/512.),floori(player.position.y/512.));visited_cells[cell]=true
 status.text="Sitios encontrados: %d/3 · sigue la orilla río arriba · arte provisional"%ledger.maps.water146.visited.size()
 queue_redraw()
func _draw():
 if data.is_empty():return
 draw_texture_rect(GRASS,CountryRoute146.BOUNDS,true)
 draw_polyline(data.approach,Color("6d522d"),112.,true);draw_polyline(data.approach,Color("bf8952"),90.,true)
 draw_polyline(data.bank,Color("6d522d"),112.,true);draw_polyline(data.bank,Color("bf8952"),90.,true)
 draw_polyline(data.river,Color("37666c"),205.,true);draw_polyline(data.river,Color("4e9caf"),180.,true);draw_polyline(data.river,Color("6bb9c5"),112.,true)
 var river:PackedVector2Array=data.river
 for i in range(1,river.size()):
  var direction:Vector2=(river[i]-river[i-1]).normalized();var normal:=direction.orthogonal()
  for k in 12:
   var point:Vector2=river[i-1].lerp(river[i],fposmod(k/12.+river_clock*.035,1.))
   draw_line(point-normal*18.,point+normal*18.,Color("c8f4ef88"),3.,true)
 draw_circle(data.source,120.,Color("b8ece7"));draw_circle(data.source,78.,Color("4e9caf"))
 # Rainbow marks the linked entry only; no activation condition is invented.
 for i in 6:draw_arc(data.entry+Vector2(0,-70),90.+i*9.,PI,TAU,32,Color.from_hsv(i/7.,.55,.95),7.,true)
 draw_circle(data.entry,12.,Color("fff0b3"))

func _unhandled_input(event:InputEvent):
 if event.is_action_pressed("ui_cancel"):return_requested.emit();get_viewport().set_input_as_handled()
