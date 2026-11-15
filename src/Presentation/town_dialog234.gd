class_name TownDialog234
extends Panel
signal closed
signal recommend_requested(target:String)
signal service_requested(role:String,town:String)
var energy237:Dictionary={}
var town:String
var role:String
func _ready():
 size=Vector2(940,620);z_index=150;DetailCard179.style_panel(self);_fit();get_viewport().size_changed.connect(_fit)
 var node:Dictionary=TownNetwork234.nodes(SaveData.world_seed)[town]
 var title:=Label.new();title.text=TownNetwork234.npc_name(town,role)+" · "+TownIdentity215.title(SaveData.world_cousins140,town);title.position=Vector2(28,22);TextFit181.fixed(title,Vector2(880,66),26,19,2);add_child(title)
 var body:=Label.new();body.position=Vector2(28,104);body.size=Vector2(880,280);body.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;body.add_theme_font_size_override("font_size",21);add_child(body)
 var target:String=node.targets.get(role,"")
 if target.is_empty():body.text="Aquí termina esta cadena de recomendaciones, pero NO el mundo. Puedes seguir explorando y encontrarás más pueblos. Aquí tienes "+TownNetwork234.role_text(SaveData.world_seed,town)+". No te mandaré a un pueblo inexistente ni de vuelta por donde acabas de llegar."
 else:
  var next:Dictionary=TownNetwork234.node_for(SaveData.world_seed,target);var side:=TownNetwork234.direction(node.door,next.door)
  var route:=TravelEstimate237.route(SaveData.world_seed,town,role)
  var horse:Dictionary=SaveData.horse_collection.find(SaveData.horse_collection.selected);var stats:=HorseStats.read(horse)
  var nutrition:float=Garden212.multiplier(SaveData.world_garden212,SaveData.horse_collection.selected)
  var estimate:float=TravelEstimate237.seconds(route.distance,horse,energy237,nutrition)
  var lead:String="El siguiente pueblo" if route.hops==1 else "A %d pueblos de distancia"%route.hops
  body.text=lead+", hacia el "+side+": "+TownIdentity215.title(SaveData.world_cousins140,target)+".\nBusca ese color y dibujo en su muralla. Allí está mi "+("prima florista" if role=="florist" else "primo del oficio")+".\n"
  if route.hops>1:body.text+="El pueblo intermedio se puede visitar, pero NO es tu destino.\n"
  body.text+="Camino: ~%d unidades. Con %s (%d u/s): %s.\nIncluye cansancio y respiros; supone seguir el camino.\nEstimación orientativa ±20%%; desvíos, paradas y encuentros pueden alargarla."%[route.distance,horse.get("name","tu caballo"),stats.speed,TravelEstimate237.text(estimate)]
  button("Marcar destino · "+side,Vector2(28,412),func():recommend_requested.emit(target))
 button("Encargos actuales" if town=="home" and role in ["farmer","florist"] else "Ver equipo" if role=="saddler" else "Caballeriza" if role=="farmer" else "Sobre este oficio",Vector2(28,500),func():service_requested.emit(role,town))
 button("Seguir explorando",Vector2(500,500),func():closed.emit())
func button(text:String,at:Vector2,action:Callable):
 var b:=Button.new();b.text=text;b.position=at;b.size=Vector2(412,62);QuestButtonStyle.apply(b);add_child(b);b.pressed.connect(action)
func _fit():
 var v:=get_viewport_rect().size;scale=Vector2.ONE*minf(v.x/1280.,v.y/720.);position=(v-size*scale)*.5
