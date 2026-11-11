class_name HorseStatBars
extends VBoxContainer
## Shared numeric-stat presentation. Numbers stay in simulation, never in labels.
static func row(host:Node,title:String,value:float,low:float=0.0,high:float=100.0,compact:bool=false)->HBoxContainer:
 var line:=HBoxContainer.new();line.custom_minimum_size.y=24 if compact else 40;line.add_theme_constant_override("separation",12);host.add_child(line)
 var label:=Label.new();label.text=title;label.custom_minimum_size.x=175 if compact else 250;label.add_theme_font_size_override("font_size",15 if compact else 20);line.add_child(label)
 var bar:=ProgressBar.new();bar.name="StatBar";bar.show_percentage=false;bar.min_value=0;bar.max_value=1;bar.value=clampf(inverse_lerp(low,high,value),0,1);bar.size_flags_horizontal=Control.SIZE_EXPAND_FILL;bar.custom_minimum_size=Vector2(80,12 if compact else 18);bar.size_flags_vertical=Control.SIZE_SHRINK_CENTER
 bar.add_theme_stylebox_override("background",RanchTheme.box(Color("183b46"),Color("547b83"),5));bar.add_theme_stylebox_override("fill",RanchTheme.box(Color("d9b565"),Color("e6c47c"),5));line.add_child(bar);return line
static func create(host:Node,h:Dictionary,concrete:bool,compact:bool=false)->HorseStatBars:
 var view:=HorseStatBars.new();view.name="HorseStatBars";view.size_flags_horizontal=Control.SIZE_EXPAND_FILL;view.add_theme_constant_override("separation",2 if compact else 7);host.add_child(view)
 if not concrete:
  var note:=Label.new();note.text="Rendimiento y habilidades: por descubrir";note.add_theme_font_size_override("font_size",15 if compact else 20);note.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;view.add_child(note);return view
 var stats:Dictionary=HorseStats.read(h)
 for spec in [["Velocidad","speed",240,300],["Manejo","handling",600,1500],["Fuerza","power",.5,.9],["Agilidad","dodge",.75,1.0],["Serenidad","calm",.5,2.0]]:row(view,spec[0],stats[spec[1]],spec[2],spec[3],compact)
 for skill in ["jump","dodge"]:
  var title:String="Salto" if skill=="jump" else "Esquiva"
  var known:bool=HorseTraining.knows(h,skill)
  var line:=row(view,title,learned_value(h,skill),0,100,compact)
  if known:line.get_child(1).add_theme_stylebox_override("fill",RanchTheme.box(Color("74c9a0"),Color("9de0b9"),5))
 return view

## Availability is complete learning, not a gift of mastery or recovery bonus.
static func learned_value(h:Dictionary,skill:String)->float:
 return 100.0 if HorseTraining.knows(h,skill) else HorseTraining.progress(h,skill)
