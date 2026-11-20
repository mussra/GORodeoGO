class_name StoryIntro319
extends Control
signal finished
const PAGES:Array[String]=[
 "Hola, me llamo "+RiderStory322.NAME+", soy el jinete más valiente de este lado del charco.",
 "Mi objetivo es hacerme con todos los caballos posibles. ¡Hay más de 40.000 combinaciones de apariencia! Los caballos se distinguen por las manchas, el color de su crin y el color de su pelaje.",
 "Tengo que investigar por el mundo para ir recolectando información sobre los caballos que pueda.",
 "Por el camino me encontraré misiones, me harán encargos que me servirán para buscarme la vida, poder ganar puntos y así poder mejorar mi equipo.",
 "Podrás también conseguir complementos como sombreros. Come la fruta, que te dará habilidades.",
 "Habla con personajes y explora el mundo para poder desbloquear diferentes tipos de pruebas y competiciones para hacer encima de tu caballo.",
 "Primero, vamos a practicar. Con el dedo izquierdo mueves a tu jinete. Toca la parte izquierda y arrastra hacia donde quieras ir. Suelta para parar. Mira la demostración y pruébalo en el recuadro.",
 "Con el dedo derecho manejas el lazo. Toca la parte derecha, arrastra para apuntar y suelta para lanzarlo. Puedes moverte y apuntar con los dos dedos a la vez. Practica aquí sin perder nada."
]
var page319:int=0
var appearance_clock319:float=0.
var preview_changes319:int=0
var persist319:bool=true
var practice_only323:bool=false
var body319:DialogueLabel319
var mounted319:Sprite2D
var counter319:Label
var next319:Button
var canvas319:Control
var tutorial323:ControlsTutorial323
var entrance322:Tween
var entrance_done322:bool=false
var rng319:=RandomNumberGenerator.new()
var traits319:Dictionary={"coat":10,"pattern":0,"mane":1}
var hat319:String="original"
func _ready()->void:
 name="StoryIntro319";set_meta("ui_modal",true);z_index=200;mouse_filter=Control.MOUSE_FILTER_STOP;process_mode=Node.PROCESS_MODE_ALWAYS
 set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);rng319.randomize()
 var bg:=MenuBackdrop.new();bg.art_mode300="main";bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(bg)
 var shade:=ColorRect.new();shade.color=Color(0.05,.09,.09,.62);shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(shade)
 canvas319=Control.new();canvas319.size=Vector2(1280,720);add_child(canvas319)
 var title:=Label.new();title.text="UNA VIDA A CABALLO";title.position=Vector2(65,45);title.add_theme_font_size_override("font_size",36);title.add_theme_color_override("font_color",Color("f7cf7c"));canvas319.add_child(title)
 mounted319=Sprite2D.new();mounted319.position=Vector2(300,375);canvas319.add_child(mounted319);_appearance319()
 tutorial323=ControlsTutorial323.new();tutorial323.position=Vector2(65,170);tutorial323.size=Vector2(470,400);tutorial323.hide();canvas319.add_child(tutorial323)
 var panel:=Panel.new();panel.position=Vector2(560,160);panel.size=Vector2(650,390);DetailCard179.style_panel(panel);canvas319.add_child(panel)
 var who:=Label.new();who.text=RiderStory322.NAME;who.position=Vector2(30,22);who.add_theme_font_size_override("font_size",28);panel.add_child(who)
 body319=DialogueLabel319.new();body319.characters_per_second319=32.;body319.position=Vector2(30,82);body319.size=Vector2(590,260);body319.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;body319.add_theme_font_size_override("font_size",26);body319.add_theme_color_override("font_color",Color("fff2d8"));panel.add_child(body319)
 counter319=Label.new();counter319.position=Vector2(580,575);counter319.add_theme_font_size_override("font_size",20);canvas319.add_child(counter319)
 next319=Button.new();next319.position=Vector2(900,570);next319.size=Vector2(310,62);QuestButtonStyle.apply(next319);canvas319.add_child(next319);next319.pressed.connect(_next319)
 var skip:=Button.new();skip.text="Saltar introducción";skip.position=Vector2(65,625);skip.size=Vector2(320,55);QuestButtonStyle.apply(skip);canvas319.add_child(skip);skip.pressed.connect(_finish319)
 var hint:=Label.new();hint.text="Toca el texto para mostrarlo entero";hint.position=Vector2(580,650);hint.add_theme_font_size_override("font_size",18);canvas319.add_child(hint)
 resized.connect(_fit319);_fit319();_page319();_entrance322(panel,shade);next319.grab_focus.call_deferred()
func _fit319()->void:
 if not is_instance_valid(canvas319):return
 var k:float=minf(size.x/1280.,size.y/720.);canvas319.scale=Vector2.ONE*k;canvas319.position=(size-Vector2(1280,720)*k)*.5
func _page319()->void:
 mounted319.visible=page319<6;tutorial323.visible=page319>=6
 if page319>=6:tutorial323.reset323(page319-6)
 appearance_clock319=0.;body319.text=PAGES[page319];body319.restart319()
 counter319.text="%d / %d"%[page319-5,2] if practice_only323 else "%d / %d"%[page319+1,PAGES.size()];next319.text=("Terminar práctica" if practice_only323 else "Practicar con un toro") if page319==PAGES.size()-1 else "Continuar"
func _process(delta:float)->void:
 appearance_clock319+=delta
 if page319 in [1,4] and appearance_clock319>=.85:
  appearance_clock319=0.
  if page319==1:
   traits319={"coat":rng319.randi_range(0,HorseCollection.COATS.size()-1),"pattern":rng319.randi_range(0,HorseCollection.PATTERNS.size()-1),"mane":rng319.randi_range(0,HorseCollection.MANES.size()-1)}
  else:hat319=["blue","hat:v3:2:6:10","hat:v3:8:13:0","hat:v3:13:14:2","original"][posmod(preview_changes319,5)]
  _appearance319()
func _appearance319()->void:
 HorsePortrait.apply(mounted319,traits319,hat319);mounted319.scale=Vector2.ONE*(420./mounted319.texture.get_height());preview_changes319+=1
func _next319()->void:
 _advance319()
func _advance319()->void:
 if page319>=PAGES.size()-1:_finish319();return
 page319+=1;_page319()
func _finish319()->void:
 if is_queued_for_deletion():return
 if persist319:
  SaveData.story_intro319=true
  if not SaveData.save_progress():SaveData.story_intro319=false
 finished.emit();queue_free()

func _unhandled_input(event:InputEvent)->void:
 if event.is_action_pressed("ui_cancel"):
  _finish319();get_viewport().set_input_as_handled()

## A short, staggered arrival. Text begins only after its reading panel settles.
func _entrance322(panel:Panel,shade:ColorRect)->void:
 body319.set_process(false);body319.visible_characters=0
 canvas319.modulate.a=0.;panel.position=Vector2(608,172);mounted319.position=Vector2(258,375);shade.modulate.a=0.
 entrance322=create_tween().set_parallel(true).set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
 entrance322.tween_property(shade,"modulate:a",1.,.35)
 entrance322.tween_property(canvas319,"modulate:a",1.,.42)
 entrance322.tween_property(mounted319,"position",Vector2(300,375),.65).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
 entrance322.tween_property(panel,"position",Vector2(560,160),.55).set_delay(.10).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
 entrance322.chain().tween_callback(func():
  entrance_done322=true;body319.restart319();body319.set_process(true))
