class_name RepeatContractsPanel165
extends Control
signal closed
var canvas:Control
var detail:Label
var balance:Label
var action:Button
var message:Label
static func summary()->String:
 var state:Dictionary=SaveData.repeat_contract165
 var animal:String="cerdos" if ProgressionEconomy165.target(state)=="pig" else "cabras"
 if state.ready:return "Encargo listo · vuelve al granjero para cobrar 400 puntos"
 if state.active:return "Encargo del rancho: %d/5 %s"%[state.events.size(),animal]
 return "Encargos del rancho: habla con el granjero"
func _ready():
 MenuInputGuard.install(self);set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);z_index=150
 var bg:=ColorRect.new();bg.color=Color("10252d");bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(bg)
 canvas=Control.new();canvas.size=Vector2(1280,720);add_child(canvas)
 _label("ENCARGOS DEL RANCHO",Vector2(60,35),32)
 var back:=Button.new();back.text="Volver al camino";back.position=Vector2(930,30);back.size=Vector2(290,58);QuestButtonStyle.apply(back);canvas.add_child(back);back.pressed.connect(func():closed.emit();queue_free())
 balance=_label("",Vector2(60,120),23)
 detail=_label("",Vector2(60,190),28);detail.size=Vector2(1120,150);detail.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
 DetailCard179.reading_surface(detail)
 var explanation:=_label("Hoy hacen falta cinco animales nuevos. Acepta antes de salir y vuelve a cobrar cuando los hayas capturado. Después tocará el otro rebaño.",Vector2(60,350),24);explanation.size=Vector2(1120,110);explanation.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
 DetailCard179.reading_surface(explanation)
 action=Button.new();action.name="ContractAction165";action.position=Vector2(60,495);action.size=Vector2(600,66);action.add_theme_font_size_override("font_size",26);QuestButtonStyle.apply(action);canvas.add_child(action)
 action.pressed.connect(func():
  var ready:bool=SaveData.repeat_contract165.ready
  var ok:bool=SaveData.claim_repeat_contract165()>0 if ready else SaveData.accept_repeat_contract165()
  message.text=("Trato hecho. ¡Hasta la próxima!" if ready else "¡A por ellos! Te espero aquí.") if ok else "No se ha podido guardar el encargo. Inténtalo de nuevo."
  refresh())
 message=_label("",Vector2(60,590),23);message.size=Vector2(1120,70);message.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
 resized.connect(_layout);_layout();refresh()
func _label(text_:String,pos:Vector2,font:int)->Label:
 var l:=Label.new();l.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;l.size=Vector2(1120,100);l.text=text_;l.position=pos;l.add_theme_font_size_override("font_size",font);canvas.add_child(l);TextFit181.fixed(l,l.size,font,18,3);return l
func _layout():
 if canvas==null:return
 var k:float=minf(size.x/1280.,size.y/720.);canvas.scale=Vector2.ONE*k;canvas.position=(size-Vector2(1280,720)*k)/2.
func refresh():
 var state:Dictionary=SaveData.repeat_contract165
 balance.text="Puntos: %d · Encargos cobrados: %d · Cerdos: %d · Cabras: %d"%[SaveData.equipment_points,state.completed,SaveData.world_pig_captures.size(),SaveData.world_goat_captures.size()]
 var animal:String="cerdos" if ProgressionEconomy165.target(state)=="pig" else "cabras"
 detail.text=summary()+"\n"+("Cinco %s · recompensa: 400 puntos"%animal)
 action.text="Cobrar 400 puntos" if state.ready else "Encargo en marcha" if state.active else "Aceptar: cinco "+animal
 action.disabled=state.active or SaveData.trial_session_active
func _unhandled_input(event:InputEvent):
 if event.is_action_pressed("ui_cancel"):closed.emit();queue_free();get_viewport().set_input_as_handled()
