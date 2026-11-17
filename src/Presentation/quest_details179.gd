class_name QuestDetails179
extends ScrollContainer
## Read-only view. No accept, completion, payment or save logic lives here.
var rows:VBoxContainer
var signature:String=""
func _init():
 horizontal_scroll_mode=ScrollContainer.SCROLL_MODE_DISABLED;vertical_scroll_mode=ScrollContainer.SCROLL_MODE_SHOW_ALWAYS
 size_flags_horizontal=Control.SIZE_EXPAND_FILL;custom_minimum_size=Vector2(0,0)
 var bar:=get_v_scroll_bar();bar.custom_minimum_size.x=22
 bar.add_theme_stylebox_override("scroll",RanchTheme.box(Color("263e46"),Color("45616a"),8))
 for style in ["grabber","grabber_highlight","grabber_pressed"]:bar.add_theme_stylebox_override(style,RanchTheme.box(Color("f2c86d"),Color("8d794d"),8))
 rows=VBoxContainer.new();rows.mouse_filter=Control.MOUSE_FILTER_PASS;rows.size_flags_horizontal=Control.SIZE_EXPAND_FILL;rows.add_theme_constant_override("separation",12);add_child(rows)
func update_states(states:Dictionary,contract:Dictionary,flora:Dictionary)->void:
 var next:String=var_to_str([states,contract,flora,SaveData.world_jobs249,SaveData.world_pig_captures.size(),SaveData.world_goat_captures.size(),SaveData.world_pigs_sold,SaveData.world_goats_given249])
 if next==signature:return
 signature=next
 for child in rows.get_children():rows.remove_child(child);child.queue_free()
 var found:bool=false
 for id in NpcQuests.QUESTS:
  var q:Dictionary=NpcQuests.QUESTS[id];var s:Dictionary=NpcQuests.state(states,id)
  if s.status!="active" and not (s.status=="done" and q.npc in ["farmer","florist"] and not s.get("thanked",false)):continue
  found=true
  var done:bool=s.status=="done"
  var contact:String="la florista" if q.npc=="florist" else "el granjero"
  _card(q.title,q.active,"Completado · habla con "+contact if done else "En curso",int(s.count),int(q.goal),done)
 for id in SaveData.world_jobs249:
  var q:Dictionary=TownJobs249.definitions(SaveData.world_seed,{id:SaveData.world_jobs249[id]}).get(id,{})
  if q.is_empty():continue
  var s:Dictionary=SaveData.world_jobs249[id]
  if s.get("thanked",false):continue
  found=true
  var n:int=mini(int(q.goal),TownJobs249.inventory(q.target)) if q.kind=="capture_animal" else int(s.count)
  var ready_:bool=TownJobs249.ready(q,s)
  _card(q.title+" · "+TownIdentity215.display_name248(SaveData.world_cousins140,q.town),q.active,"Listo · vuelve a entregar" if ready_ else TownNetwork234.NAMES[q.role]+" · En curso",n,int(q.goal),ready_)
 if not found:_card("Encargos del pueblo","Habla con el granjero del rancho para empezar.","Por descubrir")
 var animal:String="cerdos" if ProgressionEconomy165.target(contract)=="pig" else "cabras"
 var active:bool=contract.get("active",false);var ready:bool=contract.get("ready",false)
 _card("Encargos del rancho",("Captura cinco "+animal) if active or ready else "Habla con el granjero para aceptar un encargo.","Listo · vuelve a cobrar 400 puntos" if ready else "Recompensa · 400 puntos" if active else "Granjero del rancho",contract.get("events",[]).size() if active or ready else -1,5 if active or ready else 0,ready)
 if not flora.is_empty():_card("Flores del Camino del Este",FloristJourney138.hud(flora),"Florista")
func _card(title:String,text:String,status:String,count:int=-1,goal:int=0,done:bool=false)->void:
 var card:=DetailCard179.new();card.setup(title,text,status,count,goal,done);rows.add_child(card)
