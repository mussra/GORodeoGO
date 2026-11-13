class_name SiestaTravel144
extends Node
var world:Node2D
var active:bool=false
var panel:Control
var curtain:SiestaCurtain147
var zlabel:Label
var message:Label
var target:Dictionary={}
var origin:Vector2
var prior_paused:bool=false
var rollback:bool=false
var last_error:String=""
var sites_panel:NavigationSheet
var visit_clock:float=0.
var discovered_before:Array[String]=[]
var missions_before:Dictionary={}
var travel_started:int=0
var partial163:Dictionary={}
func _ready():world=get_parent();process_mode=Node.PROCESS_MODE_ALWAYS
func candidates()->Array[Dictionary]:return WorldPlaces144.sites(SaveData.world_seed,SaveData.world_generator_version,SaveData.world_cousins140)
func record_visits()->void:
 if active or world._loading_world:return
 if Time.get_ticks_msec()<visit_clock:return
 visit_clock=Time.get_ticks_msec()+750.
 var state:=WorldPlaces144.clean(SaveData.world_places144,SaveData.world_seed,SaveData.world_generator_version)
 var changed:bool=not state.visited.has("ranch")
 state.visited.ranch=true # Every existing world starts at its own ranch; old distant saves retain a way home.
 if WorldPlaces144.visit(state,world.player.position,candidates(),SaveData.world_cousins140.get("known",{})) or changed:
  if not SaveData.commit_places144(state,world.player.position):
   visit_clock=Time.get_ticks_msec()+5000.;world._toast("No se pudo guardar este sitio visitado. Se reintentará.")
func available()->Array[Dictionary]:return WorldPlaces144.available(SaveData.world_places144,candidates())
func reason()->String:
 if active or world._loading_world or world._home_pending:return "Espera a que termine el viaje o la carga."
 if world._lasso_state!="" or world.player.lasso.is_in_flight() or world.player.lasso.is_charging():return "Termina la captura antes de viajar. No se soltará ningún animal."
 if world._edit_mode or is_instance_valid(world._npc_dialog) or is_instance_valid(world._journal140) or is_instance_valid(world._note_dialog106):return "Cierra el diálogo o el editor antes de viajar."
 if world.player._stun_time_remaining>0.:return "Espera a recuperarte del golpe antes de viajar."
 for horse in world._herd_horses.values():
  if is_instance_valid(horse) and float(horse.state.get("spook",0.))>0. and horse.position.distance_to(world.player.position)<300.:return "Aléjate de la manada en huida antes de echarte la siesta."
 return ""
func show_sites()->void:
 if active or is_instance_valid(sites_panel) or is_instance_valid(panel):return
 record_visits();var entries:Array=[]
 for site in available():entries.append({"id":site.id,"title":site.name,"hint":"Sitio visitado · ir con una siesta"})
 if entries.is_empty():world._toast("Acércate a un sitio para conocerlo antes de viajar.");return
 sites_panel=NavigationSheet.new();sites_panel.title="SITIOS VISITADOS";sites_panel.entries=entries
 sites_panel.selected.connect(func(id:String):sites_panel=null;choose.call_deferred(id))
 sites_panel.closed.connect(func():sites_panel=null)
 world._hud.add_child(sites_panel)
func close_confirmation()->void:
 if is_instance_valid(panel):panel.queue_free()
 panel=null;world.player.set_physics_process(not world._map_overlay.expanded)
func choose(id:String)->void:
 if is_instance_valid(panel) or active:return
 record_visits();target=WorldPlaces144.destination(SaveData.world_places144,candidates(),id)
 if target.is_empty():return
 var why:String=reason()
 if not why.is_empty():world._toast(why);return
 world.player.set_physics_process(false)
 var confirmation:=SiestaConfirmation148.new();confirmation.destination=str(target.name);panel=confirmation
 confirmation.confirmed.connect(func():close_confirmation();start(str(target.id)))
 confirmation.cancelled.connect(close_confirmation);world._hud.add_child(confirmation)

func start(id:String)->bool:
 var why:String=reason();last_error=""
 if not why.is_empty():last_error=why;world._toast(why);return false
 target=WorldPlaces144.destination(SaveData.world_places144,candidates(),id)
 if target.is_empty():last_error="Ese sitio todavía no está visitado.";return false
 partial163=SiestaRoute163.frontier(world.player.position,target.pos)
 if partial163.is_empty():last_error="No hay una ruta conocida y segura, o queda muy poco camino. Continúa explorando a caballo.";world._toast(last_error);return false
 target=target.duplicate(true);target.pos=partial163.pos
 origin=world.player.position;missions_before=SaveData.world_missions.duplicate(true);discovered_before=SaveData.world_discovered.duplicate();world._snapshot_roaming139()
 if not SaveData.save_world_state(origin):last_error="No se pudo guardar el origen. No has viajado.";world._toast(last_error);return false
 active=true;travel_started=Time.get_ticks_msec();rollback=false;prior_paused=get_tree().paused;get_tree().paused=true
 world.player.cancel_input();world.player.velocity=Vector2.ZERO;world.player.set_physics_process(false)
 if world._map_overlay.expanded:world._map_overlay.expanded=false;world._map_overlay._layout()
 var touch_controls:Node=world.get_node_or_null("TouchControls")
 if touch_controls!=null:touch_controls.visible=false
 _cover()
 var walking_ok:bool=await curtain.close_eye(world.player,partial163.path)
 if not walking_ok:
  last_error="El paso está bloqueado. Sigues en el origen.";world.player.position=origin;rollback=true
  await curtain.open_eye();curtain.queue_free();curtain=null;active=false;get_tree().paused=prior_paused;world.player.set_physics_process(true)
  if touch_controls!=null:touch_controls.visible=not world._edit_mode
  world._toast(last_error);return false
 var transaction:=TravelTransaction147.new()
 var result:Dictionary=await transaction.run(_load_destination147,_validate_destination147,_commit_destination147,_restore_origin147)
 if not result.ok and not result.restored:
  message.text="La zona no pudo cargarse. El origen sigue guardado. Vuelve al menú para reabrirla."
  var back:=Button.new();back.text="Menú principal";back.position=Vector2(490,640);back.size=Vector2(300,56);curtain.add_child(back);back.pressed.connect(func():get_tree().paused=prior_paused;get_tree().change_scene_to_file("res://src/Presentation/main_menu.tscn"))
  return false
 if result.ok:message.text="Has avanzado media ruta hacia "+str(target.name)
 var camera:Camera2D=get_viewport().get_camera_2d()
 if camera!=null:camera.reset_smoothing()
 await curtain.open_eye()
 curtain.queue_free();curtain=null;zlabel=null;message=null;active=false;get_tree().paused=prior_paused
 world.player.set_physics_process(not world._map_overlay.expanded);world.visible=true
 var touch:Node=world.get_node_or_null("TouchControls")
 if touch!=null:touch.visible=not world._edit_mode
 if not last_error.is_empty():world._toast(last_error)
 return last_error.is_empty()
func _load_destination147()->bool:
 world.player.position=target.pos;await _load_area()
 # Two frames let new collision objects reach the physics server.
 await get_tree().process_frame;await get_tree().process_frame
 if not world._build_queue.is_empty():last_error="No hay una llegada libre. Vuelves al origen.";return false
 return true
func _validate_destination147()->Vector2:
 var landing:Vector2=_safe_landing(target.pos)
 if not landing.is_finite():last_error="No hay una llegada libre. Vuelves al origen."
 return landing
func _commit_destination147(landing:Vector2)->bool:
 world.player.position=landing
 SaveData.world_discovered=discovered_before.duplicate();SaveData.world_missions=missions_before.duplicate(true)
 if SaveData.save_world_state(landing):return true
 last_error="No se pudo guardar la llegada. Vuelves al origen.";return false
func _restore_origin147()->bool:
 rollback=true;SaveData.world_missions=missions_before;SaveData.world_discovered=discovered_before;SaveData.world_position=origin;world.player.position=origin;message.text=last_error;travel_started=Time.get_ticks_msec();await _load_area()
 SaveData.world_missions=missions_before.duplicate(true);SaveData.world_discovered=discovered_before.duplicate()
 return world._build_queue.is_empty()
func _load_area():
 world._update_chunks()
 var steps:int=0
 while not world._build_queue.is_empty() and steps<20000 and Time.get_ticks_msec()-travel_started<45000:
  world._drain_chunk_builds();steps+=1;await get_tree().process_frame
func _safe_landing(pos:Vector2)->Vector2:
 return TravelLanding148.find(world.player,pos,func(candidate:Vector2)->bool:return (not partial163.is_empty() and not partial163.allowed.call(candidate)) or (SaveData.world_generator_version>=3 and WorldTerrain103.blocked(SaveData.world_seed,candidate,14.)))

func _cover():
 curtain=SiestaCurtain147.new();curtain.destination=str(target.name);curtain.horse=SaveData.horse_collection.find(SaveData.horse_collection.selected);curtain.hat=SaveData.hat_color;add_child(curtain)
 zlabel=curtain.zlabel;message=curtain.message
func _unhandled_input(event:InputEvent)->void:
 if event.is_action_pressed("ui_cancel") and (active or is_instance_valid(panel)):
  if not active:close_confirmation()
  get_viewport().set_input_as_handled()
