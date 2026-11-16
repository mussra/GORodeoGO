class_name ModeCrowns240
extends Control
## Visual catalogue only. No award threshold or mode lock is introduced here.
const TITLES=["Rodeo de toros","Carreras","Duelo de lazos","Justa con lazos","Hípica de memoria","Copa"]
const FLOWERS=["Amapolas","Girasoles","Acianos","Violetas","Margaritas","Rosas"]
const COLORS=[Color("f97b77"),Color("ffc962"),Color("7db5ff"),Color("c7a0f4"),Color("fff4d6"),Color("f49ec7")]
var canvas:Control
var notice:Label
func _ready()->void:
 MenuInputGuard.install(self);set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);z_index=180;theme=RanchTheme.create()
 var bg:=ColorRect.new();bg.color=Color("10252d");bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(bg)
 canvas=Control.new();canvas.size=Vector2(1280,720);add_child(canvas);resized.connect(_layout);_layout()
 MenuNavigation.header(canvas,"CORONAS Y VICTORIAS",queue_free)
 _label("Registro "+("DEBUG · separado" if SaveData.debug_mode else "normal")+" · solo victorias guardadas desde esta versión",Vector2(40,83),20,Color("bbd4dc"))
 var cup:=RaceCupSession194.load_state()
 var cup_complete:bool=cup.get("ok",false) and RaceCup194.current(cup.state).is_empty()
 for i in ModeVictories240.MODES.size():
  var mode:String=ModeVictories240.MODES[i];var count:int=SaveData.victories240.wins.get(mode,0)
  var obtained:bool=cup_complete if mode=="cup" else count>=ModeVictories240.CROWN_WINS
  var card:=Panel.new();card.position=Vector2(40+i%3*410,136+int(i/3)*232);card.size=Vector2(380,214);card.add_theme_stylebox_override("panel",RanchTheme.box(Color("1b3d49"),Color("478b9a"),16));canvas.add_child(card)
  var wreath:=Wreath.new();wreath.position=card.position+Vector2(73,61);wreath.flower_color=COLORS[i];wreath.variant=i;wreath.modulate=Color.WHITE if obtained else Color(.65,.65,.65,.48);canvas.add_child(wreath)
  _label(TITLES[i],card.position+Vector2(144,20),22,Color.WHITE)
  _label(FLOWERS[i],card.position+Vector2(144,53),20,COLORS[i])
  _label(("%d / %d objetivos"%[cup.state.completed.size(),RaceCup194.CHALLENGES.size()] if cup.get("ok",false) else "Registro de Copa no disponible") if mode=="cup" else ("1 victoria registrada" if count==1 else "%d victorias registradas"%count),card.position+Vector2(20,126),21,Color("a1f1ef") if count>0 else Color("bbd4dc"))
  _label(("✓ Conseguida" if obtained else "Pendiente")+" · "+("32 objetivos" if mode=="cup" else "%d victoria"%ModeVictories240.CROWN_WINS),card.position+Vector2(20,164),19,Color("a1f1ef") if obtained else Color("bbd4dc"))
 _label("Regla de prueba: primera victoria (Copa: 32 objetivos). Aún no se equipan en caballos.",Vector2(40,613),20,Color("bbd4dc"))
 notice=_label("Consulta los requisitos de acceso en Juegos.",Vector2(40,654),20,Color("bbd4dc"))
 if not SaveData.pending_victory240.is_empty():
  notice.text="Hay victorias sin guardar."
  var retry:=Button.new();retry.text="Reintentar guardado";retry.position=Vector2(865,642);retry.size=Vector2(370,58);canvas.add_child(retry)
  retry.pressed.connect(func():
   if SaveData.retry_victory240():queue_free();get_parent().add_child(ModeCrowns240.new())
   else:notice.text="No se ha guardado. Progreso anterior protegido.")
func _label(text:String,at:Vector2,font:int,color:Color)->Label:
 var label:=Label.new();label.text=text;label.position=at;label.add_theme_font_size_override("font_size",font);label.add_theme_color_override("font_color",color);canvas.add_child(label);return label
func _layout()->void:
 var k:float=minf(size.x/1280.,size.y/720.);canvas.scale=Vector2.ONE*k;canvas.position=(size-Vector2(1280,720)*k)/2.
func _unhandled_input(event:InputEvent)->void:
 if event.is_action_pressed("ui_cancel"):queue_free();get_viewport().set_input_as_handled()
class Wreath extends Control:
 var flower_color:Color=Color.WHITE
 var variant:int=0
 func _draw()->void:
  draw_arc(Vector2.ZERO,44.,-.35,PI+.35,36,Color("659c80"),6.,true)
  for i in 9:
   var a:float=-.25+float(i)/8.*(PI+.5)
   var p:=Vector2(cos(a),sin(a))*44.
   var petals:int=4+variant%3
   for j in petals:
    var t:float=TAU*float(j)/petals
    draw_circle(p+Vector2(cos(t),sin(t))*6.,4.5,flower_color)
   draw_circle(p,3.,Color("754f3b"))
  draw_line(Vector2(-12,7),Vector2(-24,29),Color("659c80"),7.,true)
  draw_line(Vector2(12,7),Vector2(24,29),Color("659c80"),7.,true)
