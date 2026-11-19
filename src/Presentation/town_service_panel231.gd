class_name TownServicePanel231
extends Panel
signal closed
signal open_requested
var town_id:String=""
func _ready():
 size=Vector2(680,350);z_index=150;DetailCard179.style_panel(self)
 _fit();get_viewport().size_changed.connect(_fit)
 var title:=Label.new();title.text="Caballeriza" if town_id=="west140" else "Juanito · guarnicionero";title.position=Vector2(28,24);title.add_theme_font_size_override("font_size",28);add_child(title)
 var body:=DialogueLabel319.new();body.position=Vector2(28,85);body.size=Vector2(624,140);body.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;body.add_theme_font_size_override("font_size",22)
 body.text="Puedes ver tus caballos y elegir cuáles quieres criar. Tu caballeriza te acompaña vayas donde vayas." if town_id=="west140" else "Echa un vistazo al equipo para ti y tu caballo. Aquí puedes comprarlo y mejorarlo con tus puntos."
 add_child(body)
 var open:=Button.new();open.text="Ver caballos" if town_id=="west140" else "Ver equipo";open.position=Vector2(28,260);open.size=Vector2(300,58);QuestButtonStyle.apply(open);add_child(open);open.pressed.connect(func():open_requested.emit())
 var back:=Button.new();back.text="Hasta luego";back.position=Vector2(352,260);back.size=Vector2(300,58);QuestButtonStyle.apply(back);add_child(back);back.pressed.connect(func():closed.emit())

func _fit():
 var viewport:=get_viewport_rect().size
 scale=Vector2.ONE*minf(viewport.x/1280.,viewport.y/720.);position=(viewport-size*scale)*.5
