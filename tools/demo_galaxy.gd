extends Control
## Isolated storyboard/simulation. No SaveData reads/writes, breeding mutation or RNG promise.
var canvas:Control
var stage:int=0
var automated:bool=false
const STEPS=[
 ["Encuentra dos caballos especiales","Una familia lleva el secreto de la crin arcoíris; otra, el de los ojos Galaxy.","1 · Portadores"],
 ["Prepara a los padres","Condición de DEMO: ambos han completado su entrenamiento. La condición final está por decidir.","2 · Condición de prueba"],
 ["Cruza y descubre la cría","Tener los dos secretos no garantiza un Galaxy. Este intento da una cría normal que puede conservar un secreto.","3 · Un intento sin Galaxy"],
 ["Otro intento... aparece un Galaxy","Crin arcoíris + ojos Galaxy. El resultado especial no es una recompensa garantizada por repetir un número fijo de veces.","4 · Resultado de prueba"]]
func _ready():
 set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 canvas=Control.new();canvas.size=Vector2(1280,720);add_child(canvas);resized.connect(layout);layout();build()
func layout():
 var k=minf(size.x/1280,size.y/720);canvas.scale=Vector2.ONE*k;canvas.position=(size-Vector2(1280,720)*k)/2
func text(value:String,pos:Vector2,width:float,font:int,color:Color=Color("f4edd8"))->Label:
 var l=Label.new();l.text=value;l.position=pos;l.size.x=width;l.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;l.add_theme_font_size_override("font_size",font);l.add_theme_color_override("font_color",color);canvas.add_child(l);l.size=Vector2(width,120);return l
func card(pos:Vector2,title:String,traits:Dictionary,caption:String):
 var panel=Panel.new();panel.position=pos;panel.size=Vector2(365,425);panel.add_theme_stylebox_override("panel",RanchTheme.box(Color("183740"),Color("587f85"),12));canvas.add_child(panel)
 text(title,pos+Vector2(18,12),329,24)
 var portrait=TextureRect.new();portrait.position=pos+Vector2(50,48);portrait.size=Vector2(260,270);HorsePortrait.apply_horse(portrait,{"traits":traits});canvas.add_child(portrait)
 text(caption,pos+Vector2(18,325),329,19,Color("b6dccc"))
func build():
 for child in canvas.get_children():canvas.remove_child(child);child.queue_free()
 var bg=ColorRect.new();bg.color=Color("10252d");bg.size=Vector2(1280,720);canvas.add_child(bg)
 text("GALAXY · DEMO DE CRIANZA",Vector2(30,18),1000,30)
 text("SIMULACIÓN AISLADA · No cambia tu colección · Reglas y probabilidades NO definitivas",Vector2(30,60),1220,18,Color("e8bb67"))
 text(STEPS[stage][0],Vector2(30,98),1220,28)
 text(STEPS[stage][1],Vector2(30,140),1220,20)
 var a={"coat":3,"pattern":1,"mane":0,"eyes":10,"finish":"normal"}
 var b={"coat":6,"pattern":10,"spots":6,"mane":1,"eyes":10,"finish":"normal"}
 card(Vector2(30,210),"Padre A",a,"Lleva gen: crin Arcoíris (oculto)\n"+("Entrenamiento listo" if stage>0 else "Entrenamiento pendiente"))
 card(Vector2(455,210),"Padre B",b,"Lleva gen: ojos Galaxy (oculto)\n"+("Entrenamiento listo" if stage>0 else "Entrenamiento pendiente"))
 if stage>=2:
  var child={"coat":6,"pattern":0,"mane":5 if stage==3 else 1,"eyes":21 if stage==3 else 10,"finish":"normal"}
  card(Vector2(880,210),"¡Galaxy!" if stage==3 else "Cría normal",child,"Crin Arcoíris · ojos Galaxy\nEvolución a unicornio: por decidir" if stage==3 else "No ha salido Galaxy\nEl secreto puede seguir en la familia")
 else:
  var panel=Panel.new();panel.position=Vector2(880,210);panel.size=Vector2(365,425);panel.add_theme_stylebox_override("panel",RanchTheme.box(Color("142c35"),Color("587f85"),12));canvas.add_child(panel)
  text("¿Qué nacerá?",Vector2(900,235),325,25)
  text("Hay que cumplir la condición.\nEsta demo no gasta recursos\nni cambia tu colección.",Vector2(900,305),325,21)
 text("Ejemplo de prueba: 1 entre 200 por intento válido. NO aprobado para el juego.",Vector2(30,650),940,18,Color("e8bb67"))
 var next=Button.new();next.position=Vector2(1010,649);next.size=Vector2(240,50);next.text="Repetir demo" if stage==3 else "Continuar";canvas.add_child(next);next.pressed.connect(func():stage=(stage+1)%4;build())
