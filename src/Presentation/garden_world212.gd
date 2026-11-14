class_name GardenWorld212
extends Node
const CARROTS=[preload("res://art/garden212/carrot-0.png"),preload("res://art/garden212/carrot-1.png"),preload("res://art/garden212/carrot-2.png"),preload("res://art/garden212/carrot-3.png"),preload("res://art/garden212/carrot-4.png")]
var world:Node2D
var home:Vector2
var plot:Vector2
var sample:Vector2
var previous:Vector2
var marker:Node2D
var panel:GardenPanel212
var button:Button
var direction_label:Label
var description:Label
var last_stage:String=""
var notice:String=""
var gardener:Sprite2D
var pose_seconds:float=0.
var pose_name:String="idle"
const GARDENER={"idle":preload("res://art/garden212/gardener-idle.png"),"walk":preload("res://art/garden212/gardener-walk.png"),"water":preload("res://art/garden212/gardener-water.png"),"plant":preload("res://art/garden212/gardener-plant.png"),"harvest":preload("res://art/garden212/gardener-harvest.png")}
func _ready():
 world=get_parent();home=world._npcs98()[1].position
 plot=clear_point(home+Vector2(-190,160))
 sample=clear_point(home+Vector2(-650,-480))
 var anchors:Dictionary=SaveData.world_garden212.anchors
 if not anchors.is_empty():home=anchors.home;plot=anchors.plot;sample=anchors.sample
 previous=world.player.position
 marker=load("res://src/Presentation/world_draw_node.gd").new();marker.z_index=-1;marker.draw_fn=_draw_plot;world.add_child(marker)
 for spot in [plot,sample]:
  var leaves:=Sprite2D.new();leaves.texture=CARROTS[1] if spot==plot else CARROTS[3];leaves.position=spot;leaves.scale=Vector2.ONE*.55;marker.add_child(leaves)
 description=Label.new();description.position=plot+Vector2(-125,-65);description.add_theme_font_size_override("font_size",18);description.text="Huerto de Lucía · piloto";description.modulate=Color("fff1cd");marker.add_child(description)
 var label:=Label.new();label.position=sample+Vector2(-115,-55);label.add_theme_font_size_override("font_size",18);label.text="Zanahoria silvestre";label.modulate=Color("fff1cd");marker.add_child(label)
 gardener=Sprite2D.new();gardener.name="Hortelano212";gardener.position=plot+Vector2(150,25);world.add_child(gardener);set_pose("idle")
 button=Button.new();button.position=Vector2(475,565);button.size=Vector2(330,56);QuestButtonStyle.apply(button);world._hud.add_child(button);button.pressed.connect(open)
 direction_label=Label.new();direction_label.position=Vector2(235,55);direction_label.size=Vector2(770,54);direction_label.mouse_filter=Control.MOUSE_FILTER_IGNORE;direction_label.add_theme_font_size_override("font_size",20);world._hud.add_child(direction_label);ToastStack.backdrop(direction_label)
func clear_point(base:Vector2)->Vector2:
 for i in 180:
  var candidate:=base+Vector2.from_angle(float(i%18)*TAU/18.)*float(i/18)*40.
  if SaveData.world_generator_version>=3 and WorldTerrain103.blocked(SaveData.world_seed,candidate,80.):continue
  var reserved:bool=false
  if WorldNominal98.enabled():
   for door in WorldNominal98.doors().values():
    if Rect2(ModularWorldLayout93.world(door)-Vector2(200,235),Vector2(400,310)).grow(70.).has_point(candidate):reserved=true
  if not reserved and WorldFlowers105.clear_ground(SaveData.world_seed,candidate):return candidate
 return base
func can_act(action_:String)->bool:
 if SaveData.trial_session_active:return false
 var p:Vector2=world.player.position
 if action_=="introduce":return p.distance_to(home)<170.
 if action_=="accept":return p.distance_to(plot)<170.
 if action_=="sample":return p.distance_to(sample)<130.
 if action_=="feed":return SaveData.world_garden212.crops>0 and SaveData.world_garden212.food.left<=0.
 if p.distance_to(plot)>150.:return false
 return not (action_=="water" and SaveData.world_garden212.watered)
func location_hint()->String:
 var state:Dictionary=SaveData.world_garden212
 var target:Vector2=sample if state.stage=="search" else home if state.stage=="locked" else plot
 var noun:String="Muestra" if state.stage=="search" else "Florista" if state.stage=="locked" else "Parcela"
 return "%s: %s · %d m. %s"%[noun,world.arrow_to(world.player.position,target),int(world.player.position.distance_to(target)/8.),notice]
func attach(dialog:Control,data:Dictionary):
 if data.id!="florist":return
 var b:=Button.new();b.text="Huerto de Lucía · zanahorias";b.position=Vector2(24,dialog.size.y+8);b.size=Vector2(dialog.size.x-48,52);QuestButtonStyle.apply(b);dialog.add_child(b);dialog.size.y+=76
 dialog.call_deferred("_fit165")
 b.pressed.connect(func():
  if SaveData.world_garden212.stage=="locked" and not SaveData.garden_action212("introduce","",{"home":home,"plot":plot,"sample":sample}):return
  world._close_npc();open())
func open():
 if is_instance_valid(panel):return
 world.player.cancel_input();world.player.set_physics_process(false)
 panel=GardenPanel212.new();panel.garden=self;world._hud.add_child(panel);panel.closed.connect(close);panel.chosen.connect(act)
func close():
 if is_instance_valid(panel):panel.queue_free()
 panel=null;world.player.cancel_input();world.player.set_physics_process(true);notice=""
func act(action_:String):
 if not can_act(action_):notice="Acércate al lugar indicado para esta acción.";panel.rebuild();return
 if not SaveData.garden_action212(action_,SaveData.horse_collection.selected):notice="No se pudo guardar. No se ha consumido ni concedido nada.";panel.rebuild();return
 notice={"introduce":"El hortelano te espera junto a la parcela.","accept":"Busca una muestra silvestre; la parcela queda reservada.","sample":"Ya tienes la semilla. Vuelve a tu parcela.","plant":"Sembrada. Ahora riega y cuida.","water":"Cuidada. Explora a caballo y vuelve.","harvest":"Tres zanahorias y una semilla guardadas.","feed":"Zanahoria consumida; alimento activo."}.get(action_,"")
 pose_seconds=2.;set_pose({"plant":"plant","water":"water","harvest":"harvest","sample":"harvest"}.get(action_,"idle"))
 panel.rebuild();marker.queue_redraw()
func _process(delta:float):
 if not is_instance_valid(world) or not is_instance_valid(world.player):return
 var state:Dictionary=SaveData.world_garden212
 gardener.visible=state.stage!="locked"
 if pose_seconds>0.:
  pose_seconds=maxf(0.,pose_seconds-delta)
  if pose_seconds<=0.:set_pose("idle")
 var active:bool=world.visible and world.player.is_physics_processing() and world.player.can_process() and not is_instance_valid(panel)
 var distance:float=world.player.position.distance_to(previous);previous=world.player.position
 if active:
  var next:=Garden212.tick(state,distance if distance<maxf(100.,delta*800.) else 0.,delta)
  SaveData.world_garden212=next
  if state.stage!=next.stage:
   if not SaveData.save_progress():SaveData.world_garden212=state
   else:world._toast("Huerto: tus zanahorias ya están listas.")
  state=SaveData.world_garden212
 marker.visible=state.stage!="locked"
 if marker.visible:
  marker.get_child(0).visible=state.stage in ["growing","ripe"]
  marker.get_child(0).texture=CARROTS[3] if state.stage=="ripe" else CARROTS[2] if state.watered and state.distance>450. else CARROTS[1] if state.watered else CARROTS[0];marker.get_child(1).visible=state.stage=="search";marker.get_child(3).visible=state.stage=="search"
  description.text="Huerto de Lucía · "+("cosecha lista" if state.stage=="ripe" else "brote cuidado" if state.stage=="growing" and state.watered else "parcela piloto")
 direction_label.visible=active and state.stage!="locked"
 direction_label.text="Huerto · "+location_hint()+(" · alimento: %ds"%ceili(state.food.left) if state.food.left>0. else "")
 button.visible=active and state.stage!="locked" and (world.player.position.distance_to(plot)<150. or (state.stage=="search" and world.player.position.distance_to(sample)<130.))
 button.text="Recoger zanahoria silvestre" if state.stage=="search" and world.player.position.distance_to(sample)<130. else "Hablar con el hortelano"
 if state.stage!=last_stage:last_stage=state.stage;marker.queue_redraw()
func _draw_plot(_canvas:Node2D):
 if SaveData.world_garden212.stage=="locked":return
 marker.draw_style_box(RanchTheme.box(Color("755134"),Color("b39461"),5),Rect2(plot-Vector2(125,40),Vector2(250,95)))
 marker.draw_string(ThemeDB.fallback_font,plot+Vector2(95,65),"Hortelano",HORIZONTAL_ALIGNMENT_LEFT,-1,16,Color("fff1cd"))
 for i in 4:marker.draw_line(plot+Vector2(-108,-20+i*22),plot+Vector2(108,-20+i*22),Color("4d3527"),4.)
 if SaveData.world_garden212.stage=="search":
  marker.draw_arc(sample,42.,0,TAU,48,Color("f2b55d"),3.,true)

func set_pose(pose:String):
 pose_name=pose;gardener.texture=GARDENER[pose]
 gardener.scale=Vector2.ONE*120./gardener.texture.get_height();gardener.offset=Vector2(0,-gardener.texture.get_height()*.5)
