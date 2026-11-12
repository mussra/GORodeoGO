extends Node2D
## Isolated playable new-map preview, no SaveData mutation and no old-world migration.
const Layout=preload("res://src/Presentation/modular_world_layout93.gd")
const Player=preload("res://src/Presentation/world_player.gd")
const Horse=preload("res://src/Presentation/wild_horse.gd")
const LightGrass=preload("res://art/world/derived88/grass-cache91.png")
const DarkGrass=preload("res://art/world/alternative92/grass-cache.png")
signal return_requested
var aim_joystick:VirtualJoystick
var dark=false
var tiles={}
var roads:Node2D
var ground:Node2D
var player:Node2D
var animals=[]
var hud:CanvasLayer
var stamina:Dictionary={}
var road_surface:WorldRoadSurface94
var stamina_label:Label
func road_surface_contains94(point:Vector2,margin:float=0.)->bool:
 if road_surface==null:road_surface=WorldRoadSurface94.new(0,true,dark)
 road_surface.dark=dark
 return road_surface.contains(point,margin)
func _physics_process(delta:float):
 if not is_instance_valid(player):return
 stamina=WorldStamina.tick(stamina,player.gait,player.velocity.length()>12.,delta,road_surface_contains94(player.global_position))
 player.gait_cap=WorldStamina.cap_gait(stamina,WorldGait.GALOPE)
 if is_instance_valid(stamina_label):stamina_label.text="Energía: %d%%"%roundi(WorldStamina.ratio(stamina)*100)
var collision_rects:Array[Rect2]=[]
func _ready():
 dark=OS.get_environment("MODULAR93_ART")=="dark"
 y_sort_enabled=true
 for kind in ["straight","corner","t","cross","end","dot"]:
  var name="tee" if kind=="t" else kind
  tiles[kind]=load("res://art/world/"+("alternative92/" if dark else "derived88/")+name+".png")
 ground=Node2D.new();ground.z_index=-10;ground.texture_repeat=CanvasItem.TEXTURE_REPEAT_ENABLED;ground.draw.connect(_draw_ground);add_child(ground)
 roads=Node2D.new();roads.z_index=-8;roads.texture_filter=CanvasItem.TEXTURE_FILTER_LINEAR;roads.draw.connect(_draw_roads);add_child(roads)
 var buildings=WorldModularBuildings98.new();add_child(buildings);collision_rects=buildings.collision_rects
 _decor();_landmarks96()
 # Invisible perimeter for this fixed-size test map, outside all access paths.
 for wall in [Rect2(-120,-45,1520,10),Rect2(-120,675,1520,10),Rect2(-120,-45,10,730),Rect2(1390,-45,10,730)]:WorldPhysics.add_box(self,wall)
 player=Player.new();add_child(player);player.position=Layout.world(Vector2i(9,5))+Vector2(20,-35)
 stamina=WorldStamina.new_state(HorseStats.read(SaveData.horse_collection.find(SaveData.horse_collection.selected)).get("power",.65))
 player.lasso.prey_provider=func()->Array:return animals
 player.lasso.prey_captured.connect(func(prey):prey.roped=true;prey.rider=player;prey.held=999)
 for data in [{"pos":Layout.world(Vector2i(0,2)),"traits":{"coat":10,"pattern":0,"mane":0,"eyes":0,"finish":"normal"}},{"pos":Layout.world(Vector2i(11,5))+Vector2(25,0),"traits":{"coat":1,"pattern":2,"mane":1,"eyes":1,"finish":"normal"}}]:
  var horse=Horse.new();horse.setup(data);horse.wander=true;horse.wander_radius=40;add_child(horse);horse.player_ref=player;animals.append(horse)
 var camera=Camera2D.new();camera.position=Vector2(640,340);add_child(camera);camera.make_current()
 var touch=load("res://src/Presentation/touch_controls.tscn").instantiate();touch.name="TouchControls";touch.layer=0;add_child(touch)
 var joy=touch.get_node("MoveJoystick");joy.anchor_top=.32
 aim_joystick=touch.get_node("AimJoystick");aim_joystick.anchor_top=.32
 player.lasso.set_aim_joystick(aim_joystick);player.dodge.set_move_joystick(joy);JoystickAppearance.apply(self)
 player.lasso.release_requested.connect(func():
  for horse in animals:horse.roped=false)
 _hud()
func _draw_ground():
 var rect=Rect2(-400,-350,2400,1500);var points=PackedVector2Array([rect.position,Vector2(rect.end.x,rect.position.y),rect.end,Vector2(rect.position.x,rect.end.y)]);var uv=PackedVector2Array()
 for p in points:uv.append(p/1024.)
 ground.draw_polygon(points,PackedColorArray([Color.WHITE]),uv,DarkGrass if dark else LightGrass)
func _draw_roads():
 var graph=Layout.graph()
 for cell in graph:
  var piece=Layout.piece(graph,cell);roads.draw_set_transform(Layout.world(cell),piece.rotation*PI/2)
  roads.draw_texture_rect(tiles[piece.kind],Rect2(-Vector2.ONE*Layout.CELL/2,Vector2.ONE*Layout.CELL),false)
 roads.draw_set_transform(Vector2.ZERO)
func _decor():
 for data in [{"kind":"tree","pos":Vector2(150,355)},{"kind":"tree","pos":Vector2(430,180)},{"kind":"tree","pos":Vector2(850,560)},{"kind":"stump","pos":Vector2(110,550)}]:
  var node=load("res://src/Presentation/world_decor.gd").new();node.configure121(data.kind,data.pos,1.,0);add_child(node)
  var box:Rect2=WorldFloristShop.Decor.solid_box(data.kind,data.pos,node.size_scale)
  if box.has_area():WorldPhysics.add_box(self,box);collision_rects.append(box)
func _hud():
 hud=CanvasLayer.new();add_child(hud)
 var bar=ColorRect.new();bar.color=Color(.04,.12,.09,.85);bar.size=Vector2(1598,44);bar.mouse_filter=Control.MOUSE_FILTER_IGNORE;hud.add_child(bar)
 var label=Label.new();label.text="Mapa modular nuevo · "+("hoja oscura" if dark else "césped claro")+" · prueba aislada, no guarda partidas";label.position=Vector2(20,8);label.add_theme_font_size_override("font_size",20);hud.add_child(label)
 stamina_label=Label.new();stamina_label.position=Vector2(1100,8);stamina_label.add_theme_font_size_override("font_size",18);hud.add_child(stamina_label)
 var toggle=Button.new();toggle.text="Cambiar césped";toggle.position=Vector2(1350,52);toggle.size=Vector2(220,42);QuestButtonStyle.apply(toggle);hud.add_child(toggle)
 toggle.pressed.connect(func():dark=not dark;_reload_art();ground.queue_redraw();roads.queue_redraw();label.text="Mapa modular nuevo · "+("hoja oscura" if dark else "césped claro")+" · prueba aislada, no guarda partidas")
 var back=Button.new();back.text="Volver al mundo anterior";back.position=Vector2(1280,4);back.size=Vector2(300,38);QuestButtonStyle.apply(back);hud.add_child(back);back.pressed.connect(func():return_requested.emit())
 var hint=Label.new();hint.text="WASD/flechas: mover · joystick táctil del jinete · lazo compartido · sin encargos ni progreso persistente";hint.position=Vector2(20,695);hint.add_theme_font_size_override("font_size",16);hud.add_child(hint)
func _reload_art():
 # A different painted shoulder can grow a few pixels: keep all wild hooves off it.
 for animal in animals:
  WorldWildRoads94.bind_spawn(animal,animal.road_provider94)
 for kind in tiles:
  var name="tee" if kind=="t" else kind
  tiles[kind]=load("res://art/world/"+("alternative92/" if dark else "derived88/")+name+".png")

func _landmarks96():
 for item in [{"id":"west_pass","text":"Paso oeste"},{"id":"east_pass","text":"Paso este"},{"id":"lookout","text":"Mirador"}]:
  var label=Label.new();label.name="Landmark_"+item.id;label.text=item.text
  label.position=Layout.world(Layout.LANDMARKS[item.id])+Vector2(-35,25)
  label.add_theme_font_size_override("font_size",18);label.add_theme_color_override("font_shadow_color",Color.BLACK);label.add_theme_constant_override("shadow_outline_size",3)
  add_child(label)
