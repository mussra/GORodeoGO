class_name CountrySession152
extends CountryPreview146
## Persistent session adapter. No production navigation or gate is enabled here.
## The route coordinator must validate initial arrival, commit, then activate.
var session_state:Dictionary={}
var activated:bool=false
var save_clock:float=0.
var save_error:String=""
var exit_handler:Callable
func initial_ledger149()->Dictionary:return CountryLedger146.upgrade(session_state)
func session_title149()->String:return "País nuevo · prueba guardada · sin ritual"
func persists149()->bool:return true
func _ready():
 super._ready();player.set_physics_process(false);touch_controls.visible=false;set_process(false)
func activate152()->bool:
 if session_state.is_empty() or not CountryLedger146.valid(session_state,SaveData.world_seed,SaveData.world_generator_version) or session_state.active!=CountryRoute146.ID:return false
 activated=true;set_process(true);player.set_physics_process(true);touch_controls.visible=true;return true
func _process(delta:float):
 super._process(delta)
 if not activated:return
 if travelling:return
 save_clock+=delta
 if save_clock>=5.:
  save_clock=0.;save_now152()
 if not save_error.is_empty():status.text+=" · "+save_error
func snapshot152()->Dictionary:return CountryLedger146.record_exploration(ledger,player.position,visited_cells)
func save_now152()->bool:
 if not activated or travelling:return false
 var state:=snapshot152()
 if state.is_empty() or not SaveData.store_country_ledger146(state):
  save_error="No se pudo guardar. Se reintentará.";return false
 ledger=state;save_error="";return true
func prepare_travel149()->bool:return save_now152()
func _commit_travel148(pos:Vector2)->bool:
 var cells:=visited_cells.duplicate(true);CountryExploration148.reveal(cells,pos)
 var next:=CountryLedger146.record_exploration(ledger,pos,cells)
 if next.is_empty() or not SaveData.store_country_ledger146(next):return false
 ledger=next;player.position=pos;visited_cells=cells;camera.reset_smoothing();return true
func request_return():
 if not activated or travelling or is_instance_valid(modal):return
 if not exit_handler.is_valid():save_error="Salida no preparada. Sigues en este país.";return
 _lock_player();travelling=true
 var ok:bool=await exit_handler.call(self)
 travelling=false
 if ok:return_requested.emit()
 else:save_error="No se pudo guardar la salida. Sigues en este país.";_unlock_player()

func suspend_to_menu152():
 if not save_now152():return
 var error:Error=get_tree().change_scene_to_file("res://src/Presentation/main_menu.tscn")
 if error!=OK:save_error="No se pudo abrir el menú. Sigues aquí.";return
 queue_free()
func _notification(what:int):
 if what==NOTIFICATION_APPLICATION_PAUSED and activated and not travelling:save_now152()
