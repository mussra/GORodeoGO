class_name TownDialog234
extends Panel
signal closed
signal recommend_requested(target:String)
signal service_requested(role:String,town:String)
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
 _label247(TownIdentity215.title(SaveData.world_cousins140,town),Vector2(32,72),Vector2(876,38),21,Color('bed0d0'))
 var line:=ColorRect.new();line.color=Color('45616a');line.position=Vector2(32,122);line.size=Vector2(876,2);line.mouse_filter=Control.MOUSE_FILTER_IGNORE;add_child(line)
 if conversation247.is_empty():conversation247=TownMessages247.open(SaveData.world_seed,SaveData.world_cousins140,town,role)
 target247=conversation247.target
 heading247=_label247("",Vector2(32,148),Vector2(876,44),28,Color('fff2c5'))
 body247=_label247("",Vector2(32,206),Vector2(876,132),24,Color('e6eeea'))
 route247=_label247("",Vector2(32,348),Vector2(876,54),21,Color('bed0d0'))
 var relayed:String=conversation247.relayed
 if not relayed.is_empty():
  heading247.text="Tengo un recado para ti"
  body247.text=TownMessages247.message(SaveData.world_seed,relayed,role)
  route247.text="Siguiente recado: "+TownIdentity215.title(SaveData.world_cousins140,target247)+"." if not target247.is_empty() else "Con este recado ya estás al día. ¡Buen viaje!"
 elif target247.is_empty():
  heading247.text="Ya estás al día"
  body247.text="Ya has oído todos los recados de %s. Si sigues explorando, encontrarás otros pueblos."%TownMessages247.PLURALS[role]
 else:
  var next:Dictionary=TownNetwork234.node_for(SaveData.world_seed,target247);var side:=TownNetwork234.direction(node.door,next.door)
  var route:=TravelEstimate237.route(SaveData.world_seed,town,role)
  var horse:Dictionary=SaveData.horse_collection.find(SaveData.horse_collection.selected)
  var nutrition:float=Garden212.multiplier(SaveData.world_garden212,SaveData.horse_collection.selected)
  var estimate:float=TravelEstimate237.seconds(route.distance,horse,energy237,nutrition)
  heading247.text="Tengo a alguien que presentarte"
  var who:String={"loco":"mi primo","farmer":"mi primo, el granjero,","florist":"mi prima, la florista,","saddler":"mi primo, el guarnicionero,"}[role]
  body247.text="Busca a %s en %s, hacia el %s. Reconocerás el pueblo por el color y el dibujo de su muralla."%[who,TownIdentity215.title(SaveData.world_cousins140,target247),side]
  if route.hops>1:body247.text+=" Pasarás por otro pueblo antes de llegar."
  route247.text="A caballo: %s, aproximadamente. Sigue el camino."%TravelEstimate237.text(estimate)
 if not target247.is_empty():
  button("Marcar siguiente recado" if not relayed.is_empty() else "Marcar en el mapa",Vector2(32,420),func():recommend_requested.emit(target247),Vector2(876,58))
 var has_service:bool=role in ["saddler","farmer"] or (town=="home" and role=="florist")
 if has_service:
  var service:String="Ver encargos" if town=="home" and role in ["farmer","florist"] else "Ver equipo" if role=="saddler" else "Ver caballos"
  button(service,Vector2(32,492),func():service_requested.emit(role,town))
 button("Hasta luego",Vector2(486 if has_service else 32,492),func():closed.emit(),Vector2(422 if has_service else 876,52))
func _label247(text_:String,at:Vector2,extent:Vector2,font:int,color:Color)->Label:
 var label:=Label.new();label.text=text_;label.position=at;label.size=extent;label.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;label.mouse_filter=Control.MOUSE_FILTER_IGNORE
 label.add_theme_font_size_override('font_size',font);label.add_theme_color_override('font_color',color);label.add_theme_constant_override('line_spacing',4);add_child(label);return label
func button(text:String,at:Vector2,action:Callable,extent:Vector2=Vector2(422,52)):
 var b:=Button.new();b.text=text;b.position=at;b.size=extent;QuestButtonStyle.apply(b);b.add_theme_font_size_override('font_size',22);add_child(b);b.pressed.connect(action)
func _fit():
 var v:=get_viewport_rect().size;scale=Vector2.ONE*minf(v.x/1280.,v.y/720.);position=(v-size*scale)*.5
