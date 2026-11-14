class_name GardenPanel212
extends Panel
signal closed
signal chosen(action_:String)
var garden:Node
func _ready():
 size=Vector2(760,570);z_index=110;mouse_filter=Control.MOUSE_FILTER_STOP
 DetailCard179.style_panel(self)
 var viewport_size:=get_viewport_rect().size
 var k:=minf(viewport_size.x/1280.,viewport_size.y/720.)
 scale=Vector2.ONE*k;position=(viewport_size-size*k)*.5
 rebuild()
func rebuild():
 for child in get_children():child.queue_free()
 var state:Dictionary=SaveData.world_garden212
 var title:=Label.new();title.text="HORTELANO · Huerto de Lucía";title.position=Vector2(24,18);add_child(title);TextFit181.fixed(title,Vector2(712,42),26,22)
 var portrait:=TextureRect.new();portrait.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;portrait.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;portrait.texture=garden.GARDENER[garden.pose_name];portrait.position=Vector2(24,82);portrait.size=Vector2(120,150);add_child(portrait)
 if state.discovered:
  var crop:=TextureRect.new();crop.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;crop.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;crop.texture=garden.CARROTS[4];crop.position=Vector2(48,250);crop.size=Vector2(72,78);add_child(crop)
 var body:=Label.new();body.position=Vector2(164,78);body.size=Vector2(570,260);body.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;add_child(body);DetailCard179.reading_surface(body)
 body.text=Garden212.summary(state)+"\n\n"+garden.location_hint()+"\n\n"+("Zanahoria nutritiva: 15% menos gasto al trotar o galopar durante 120 s de juego en Frontera. Sin velocidad ni cambios genéticos." if state.discovered else "La propiedad de esta variedad se descubre con la primera cosecha. Sin árbol genético ni plantas que se marchiten.")
 TextFit181.fixed(body,body.size,21,18,13)
 var status:=Label.new();status.position=Vector2(24,348);status.size=Vector2(712,70);status.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;add_child(status)
 var horse:Dictionary=SaveData.horse_collection.find(SaveData.horse_collection.selected)
 status.text="Semillas: %d · Cosecha: %d · Caballo: %s"%[state.seeds,state.crops,horse.name]
 if state.food.left>0.:status.text+="\nAlimento activo: %ds · un solo efecto, sin acumular."%ceili(state.food.left)
 TextFit181.fixed(status,status.size,20,18,3)
 var action_:String={"locked":"introduce","intro":"accept","search":"sample","empty":"plant","growing":"water","ripe":"harvest"}[state.stage]
 var captions:Dictionary={"introduce":"Pedir presentación","accept":"Aceptar el huerto","sample":"Recoger muestra silvestre","plant":"Sembrar una semilla","water":"Regar y cuidar","harvest":"Cosechar"}
 var go:=button(captions[action_],Vector2(24,430),Vector2(350,56),func():chosen.emit(action_));go.disabled=not garden.can_act(action_)
 var feed:=button("Dar una al caballo",Vector2(388,430),Vector2(348,56),func():chosen.emit("feed"));feed.disabled=not garden.can_act("feed")
 button("Seguir explorando",Vector2(220,506),Vector2(320,48),func():closed.emit())
func button(text_:String,at:Vector2,dimensions:Vector2,fn:Callable)->Button:
 var b:=Button.new();b.text=text_;b.position=at;b.size=dimensions;QuestButtonStyle.apply(b);add_child(b);b.pressed.connect(fn);return b

func _unhandled_input(event:InputEvent):
 if event.is_action_pressed("ui_cancel"):
  closed.emit();get_viewport().set_input_as_handled()
