class_name CousinDialog140
extends Panel
signal closed
signal journal_requested
var body:Label
var town:String
var state:Dictionary
func setup(id:String,state_:Dictionary,surprise:bool):
 town=id;state=state_
 add_theme_stylebox_override("panel",RanchTheme.box(RanchTheme.INK,Color("6d9b94"),12))
 position=Vector2(270,140);size=Vector2(740,510);z_index=100;mouse_filter=Control.MOUSE_FILTER_STOP
 var title:=Label.new();title.text="Loco de "+str(VillageCousins140.LABELS[id]);title.position=Vector2(24,20);title.add_theme_font_size_override("font_size",24);add_child(title);TextFit181.fixed(title,Vector2(size.x-48,44),24,20,2)
 var portrait:=Sprite2D.new();portrait.texture=load("res://art/npc/loco-"+("sorpresa" if surprise else "normal")+"140.png");portrait.position=Vector2(92,175);portrait.scale=Vector2.ONE*1.1;add_child(portrait)
 body=Label.new();body.position=Vector2(185,80);body.size=Vector2(525,270);body.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;body.add_theme_font_size_override("font_size",22);body.text=("¡Esos cuernos! ¡Yo sabía que existían!\n\n" if surprise else "")+VillageCousins140.clue(id);add_child(body)
 DetailCard179.style_panel(self)
 DetailCard179.reading_surface(body)
 TextFit181.fixed(body,body.size,21,18,9)
 _button("¿Y tus primos?",Vector2(24,365),func():body.text=VillageCousins140.cousin_hint(state,town))
 _button("Repetir la pista",Vector2(385,365),func():body.text=VillageCousins140.clue(town))
 _button("Diario de primos",Vector2(24,435),func():journal_requested.emit())
 _button("Seguir explorando",Vector2(385,435),func():closed.emit())
func _button(text:String,at:Vector2,action:Callable):
 var b:=Button.new();b.text=text;b.position=at;b.size=Vector2(330,52);QuestButtonStyle.apply(b);add_child(b);b.pressed.connect(action)
