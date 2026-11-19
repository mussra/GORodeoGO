class_name CousinDialog140
extends Panel
signal closed
signal journal_requested
var body:Label
var town:String
var state:Dictionary
var world_position215:Vector2
func setup(id:String,state_:Dictionary,surprise:bool):
 town=id;state=state_
 add_theme_stylebox_override("panel",RanchTheme.box(RanchTheme.INK,Color("6d9b94"),12))
 position=Vector2(270,140);size=Vector2(740,510);z_index=100;mouse_filter=Control.MOUSE_FILTER_STOP
 var title:=Label.new();title.text="Loco de "+TownIdentity215.display_name248(state,id);title.position=Vector2(24,20);title.add_theme_font_size_override("font_size",24);add_child(title);TextFit181.fixed(title,Vector2(size.x-48,44),24,20,2)
 var portrait:=Sprite2D.new();portrait.texture=load("res://art/npc/loco-"+("sorpresa" if surprise else "normal")+"140.png");portrait.position=Vector2(92,175);portrait.scale=Vector2.ONE*1.1;add_child(portrait)
 body=DialogueLabel319.new();body.position=Vector2(185,80);body.size=Vector2(525,200);body.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;body.add_theme_font_size_override("font_size",22);body.text=("¡Esos cuernos! ¡Yo sabía que existían!\n\n" if surprise else "")+VillageCousins140.clue(id);add_child(body)
 if id in [SaveData.world_places144.get("teach217",""),SaveData.world_places144.get("teach_far220","")]:body.text=HerdTown217.dialogue220(SaveData.world_places144,SaveData.world_cousins140,id)
 DetailCard179.style_panel(self)
 DetailCard179.reading_surface(body)
 TextFit181.fixed(body,body.size,21,18,9)
 if SaveData.world_generator_version<5:_button("¿Y tus primos?",Vector2(24,365),_hint215)
 else:_button("Tu pueblo",Vector2(24,365),func():body.text="Soy el único loco de estos pueblos. Aquí cuidamos caballos. Sigue los caminos y los carteles para encontrar los demás oficios.")
 _button("Repetir la pista",Vector2(385,365),func():body.text=HerdTown217.dialogue220(SaveData.world_places144,SaveData.world_cousins140,town))
 _button("Diario del loco" if SaveData.world_generator_version>=5 else "Diario de primos",Vector2(24,435),func():journal_requested.emit())
 _button("Seguir explorando",Vector2(385,435),func():closed.emit())
func _button(text:String,at:Vector2,action:Callable):
 var b:=Button.new();b.text=text;b.position=at;b.size=Vector2(330,52);QuestButtonStyle.apply(b);add_child(b);b.pressed.connect(action)

func _hint215():
 var next:=TownIdentity215.hint(state,town)
 if next.is_empty():body.text=VillageCousins140.cousin_hint(state,town);return
 if not SaveData.commit_cousins140(next,world_position215):body.text="No se pudo guardar el destino. Vuelve a pedirme la indicación.";return
 state=SaveData.world_cousins140
 body.text=VillageCousins140.cousin_hint(state,town)
 var existing:=get_node_or_null("TownPreview215")
 if existing!=null:existing.free()
 var preview:=Control.new();preview.name="TownPreview215";add_child(preview)
 var icon:=TownIcon215.new();icon.look=TownIdentity215.look(state,state.hint215);icon.position=Vector2(185,288);icon.size=Vector2(90,64);preview.add_child(icon)
 var label:=Label.new();label.position=Vector2(290,288);label.text=TownIdentity215.display_name248(state,state.hint215)+"\nMarcado · primera visita a caballo";TextFit181.fixed(label,Vector2(410,64),18,16,3);preview.add_child(label)
func _ready():
 _fit215();get_viewport().size_changed.connect(_fit215)
func _fit215():
 var viewport:Vector2=get_viewport_rect().size
 scale=Vector2.ONE*minf(viewport.x/1280.,viewport.y/720.)
 position=(viewport-size*scale)*.5
