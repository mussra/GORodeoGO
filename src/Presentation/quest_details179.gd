class_name QuestDetails179
extends ScrollContainer
## Read-only view. No accept, completion, payment or save logic lives here.
var rows:VBoxContainer
var signature:String=""
func _init():
 horizontal_scroll_mode=ScrollContainer.SCROLL_MODE_DISABLED;vertical_scroll_mode=ScrollContainer.SCROLL_MODE_AUTO
 size_flags_horizontal=Control.SIZE_EXPAND_FILL;custom_minimum_size=Vector2(0,0)
 rows=VBoxContainer.new();rows.size_flags_horizontal=Control.SIZE_EXPAND_FILL;rows.add_theme_constant_override("separation",12);add_child(rows)
func update_states(states:Dictionary,contract:Dictionary,flora:Dictionary)->void:
 var next:String=var_to_str([states,contract,flora])
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
 if not found:_card("Encargos del pueblo","Habla con el granjero del rancho para empezar.","Por descubrir")
 var animal:String="cerdos" if ProgressionEconomy165.target(contract)=="pig" else "cabras"
 var active:bool=contract.get("active",false);var ready:bool=contract.get("ready",false)
 _card("Encargos del rancho",("Captura cinco "+animal) if active or ready else "Habla con el granjero para aceptar un encargo.","Listo · vuelve a cobrar 400 puntos" if ready else "Recompensa · 400 puntos" if active else "Granjero del rancho",contract.get("events",[]).size() if active or ready else -1,5 if active or ready else 0,ready)
 if not flora.is_empty():_card("Flores del Camino del Este",FloristJourney138.hud(flora),"Florista")
func _card(title:String,text:String,status:String,count:int=-1,goal:int=0,done:bool=false)->void:
 var card:=DetailCard179.new();card.setup(title,text,status,count,goal,done);rows.add_child(card)
