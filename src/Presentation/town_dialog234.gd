class_name TownDialog234
extends Panel
signal closed
signal recommend_requested(target:String)
signal service_requested(role:String,town:String)
signal job_action249(action:String)
var energy237:Dictionary={}
var town:String
var role:String
var heading247:Label
var body247:Label
var route247:Label
var target247:String=""
var conversation247:Dictionary={}
func _ready():
 size=Vector2(940,560);z_index=150;DetailCard179.style_panel(self);_fit();get_viewport().size_changed.connect(_fit)
 var node:Dictionary=TownNetwork234.nodes(SaveData.world_seed)[town]
 _label247(TownNetwork234.npc_name(town,role),Vector2(32,24),Vector2(876,42),30,Color('f7cf7c'))
 _label247(TownIdentity215.display_name248(SaveData.world_cousins140,town),Vector2(32,72),Vector2(876,38),21,Color('bed0d0'))
 var line:=ColorRect.new();line.color=Color('45616a');line.position=Vector2(32,122);line.size=Vector2(876,2);line.mouse_filter=Control.MOUSE_FILTER_IGNORE;add_child(line)
 if not TownJobs249.delivered(town,role):
  _job249();return
 if conversation247.is_empty():conversation247=TownMessages247.after_job249(SaveData.world_seed,SaveData.world_cousins140,town,role)
 target247=conversation247.target
 heading247=_label247("",Vector2(32,148),Vector2(876,44),28,Color('fff2c5'))
 body247=_label247("",Vector2(32,206),Vector2(876,132),24,Color('e6eeea'))
 route247=_label247("",Vector2(32,348),Vector2(876,54),21,Color('bed0d0'))
 var relayed:String=conversation247.relayed
 if not relayed.is_empty():
  heading247.text="Tengo un recado para ti"
  body247.text=TownMessages247.message(SaveData.world_seed,relayed,role)
  route247.text="Siguiente recado: "+TownIdentity215.display_name248(SaveData.world_cousins140,target247)+"." if not target247.is_empty() else "Con este recado ya estás al día. ¡Buen viaje!"
 elif target247.is_empty():
  heading247.text="Gracias por tu ayuda"
  body247.text="Por ahora no me quedan encargos de este oficio. Sigue explorando y encontrarás otros pueblos."
 else:
  heading247.text="Gracias por ayudarme"
  var who:String={"loco":"mi primo","farmer":"mi primo, el granjero","florist":"mi prima, la florista","saddler":"mi primo, el guarnicionero"}[role]
  body247.text="Ve a ver a "+who+"."
  var route:=TravelEstimate237.route(SaveData.world_seed,town,role)
  if route.hops>1 and node.get("targets",{}).get(role,"")==target247:body247.text+=" Pasarás por otro pueblo antes de llegar."
 if not target247.is_empty():
  body247.size=Vector2(548,124)
  var side:String=TownMessages247.direction248(node.door,TownNetwork234.node_for(SaveData.world_seed,target247).door)
  if relayed.is_empty():body247.text+=" Está al "+side+"."
  var horse:Dictionary=SaveData.horse_collection.find(SaveData.horse_collection.selected)
  var nutrition:float=Garden212.multiplier(SaveData.world_garden212,SaveData.horse_collection.selected)
  var distance_:float=TravelEstimate237.between248(SaveData.world_seed,town,target247,role)
  var estimate:float=TravelEstimate237.seconds(distance_,horse,energy237,nutrition)
  route247.text=("El siguiente recado está al "+side+".\n" if not relayed.is_empty() else "")+TravelEstimate237.minutes248(estimate)
  route247.size=Vector2(548,88);route247.add_theme_font_size_override("font_size",20);route247.position.y=330
  var preview:=TownThumbnail248.new();preview.name='DestinationThumbnail248';preview.town=target247;preview.seed_=SaveData.world_seed;preview.position=Vector2(616,204);preview.size=Vector2(288,160);add_child(preview)
  _label247(TownIdentity215.display_name248(SaveData.world_cousins140,target247),Vector2(616,368),Vector2(288,25),18,Color('f7cf7c'))
  _label247(("Siguiente recado · " if not relayed.is_empty() else "Al ")+side,Vector2(616,394),Vector2(288,22),16,Color('bed0d0'))
 if not target247.is_empty():
  button("Marcar siguiente recado" if not relayed.is_empty() else "Marcar en el mapa",Vector2(32,420),func():recommend_requested.emit(target247),Vector2(876,58))
 var has_service:bool=role in ["saddler","farmer"] or (town=="home" and role=="florist")
 if has_service:
  var service:String="Ver encargos" if town=="home" and role in ["farmer","florist"] else "Ver equipo" if role=="saddler" else "Ver caballos"
  button(service,Vector2(32,492),func():service_requested.emit(role,town))
 button("Hasta luego",Vector2(486 if has_service else 32,492),func():closed.emit(),Vector2(422 if has_service else 876,52))
func _label247(text_:String,at:Vector2,extent:Vector2,font:int,color:Color)->Label:
 var label:=Label.new();label.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;label.position=at;label.size=extent;label.text=text_;label.mouse_filter=Control.MOUSE_FILTER_IGNORE
 label.add_theme_font_size_override('font_size',font);label.add_theme_color_override('font_color',color);label.add_theme_constant_override('line_spacing',4);add_child(label);return label
func button(text:String,at:Vector2,action:Callable,extent:Vector2=Vector2(422,52)):
 var b:=Button.new();b.text=text;b.position=at;b.size=extent;QuestButtonStyle.apply(b);b.add_theme_font_size_override('font_size',22);add_child(b);b.pressed.connect(action)
func _fit():
 var v:=get_viewport_rect().size;scale=Vector2.ONE*minf(v.x/1280.,v.y/720.);position=(v-size*scale)*.5

func _job249()->void:
 var q:=TownJobs249.job(SaveData.world_seed,town,role)
 var id:=TownJobs249.key(town,role)
 var s:=NpcQuests.state(SaveData.world_jobs249,id)
 var ready_:bool=TownJobs249.ready(q,s)
 heading247=_label247(q.title,Vector2(32,148),Vector2(876,50),28,Color('fff2c5'))
 var text_:String=q.text
 if q.kind=="capture_animal" and ready_:text_="Veo que ya tienes "+("un cerdo" if q.target=="pig" else "una cabra")+". Me vendría bien. "+("¿Me lo vendes" if q.target=="pig" else "¿Me la vendes")+" por 40 puntos?"
 elif s.status=="done":text_=q.done+" Tu recompensa: %d puntos."%q.reward
 elif s.status=="active":text_=q.active+". Llevas %d de %d."%[s.count,q.goal]
 body247=_label247(text_,Vector2(32,214),Vector2(876,140),25,Color('e6eeea'))
 route247=_label247("Después de ayudarme, te presentaré a otro vecino.",Vector2(32,370),Vector2(876,40),21,Color('bed0d0'))
 var label_:String="Vender 1 "+("cerdo" if q.target=="pig" else "cabra")+" · 40 puntos" if q.kind=="capture_animal" and ready_ else "Entregar encargo · %d puntos"%q.reward if ready_ else "Aceptar encargo" if s.status=="locked" else "Ver objetivo en el mapa"
 button(label_,Vector2(32,430),func():job_action249.emit("deliver" if ready_ else "accept" if s.status=="locked" else "map"),Vector2(876,58))
 var service:bool=role in ["saddler","farmer"]
 if service:button("Ver equipo" if role=="saddler" else "Ver caballos",Vector2(32,500),func():service_requested.emit(role,town))
 button("Hasta luego",Vector2(486 if service else 32,500),func():closed.emit(),Vector2(422 if service else 876,52))
