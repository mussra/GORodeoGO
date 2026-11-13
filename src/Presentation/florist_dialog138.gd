class_name FloristDialog138
extends NpcDialog
signal journey_action(action_:String,species:String)
func setup_journey(remote_:bool)->void:
 add_theme_stylebox_override("panel",RanchTheme.box(Color("10252d"),Color("6d9b94"),12))
 position=Vector2(300,145);size=Vector2(680,530);z_index=100;mouse_filter=Control.MOUSE_FILTER_STOP
 var state:Dictionary=SaveData.world_flora138;var species:String=FloristJourney138.current(state);var current_stage:String=FloristJourney138.stage(state,species)
 var title:=Label.new();title.text="Floristería del Camino del Este" if remote_ else "Florista · semillas de otro pueblo";title.position=Vector2(24,18);title.add_theme_font_size_override("font_size",25);add_child(title);TextFit181.fixed(title,Vector2(size.x-48,44),24,20,2)
 var body:=Label.new();body.position=Vector2(24,70);body.size=Vector2(632,245);body.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;body.add_theme_font_size_override("font_size",22);add_child(body)
 DetailCard179.style_panel(self)
 DetailCard179.reading_surface(body)
 TextFit181.fixed(body,body.size,21,18,9)
 var recognition:String=""
 for key in FloristJourney138.SPECIES:
  if state.fields.get(key,false):recognition+="Gracias a tu muestra, he cultivado "+FloristJourney138.title(key)+" al sur de la tienda.\n"
 if species.is_empty():
  body.text=("Gracias por ayudar a mi compañera. Las muestras no se duplican." if remote_ else recognition+"Aquí hemos terminado. Gracias por tu ayuda. Ya no tengo más encargos para ti en este pueblo.")
 elif remote_:
  if current_stage=="active":
   body.text="Mi compañera necesita "+FloristJourney138.title(species)+". Puedo darte una muestra o indicarte un campo silvestre. Ambas vías sirven: vuelve a entregársela a ella.\nCampo al "+("norte" if species=="red" else "sur")+". Sigue el camino en esa dirección."
   button138("Pedir una muestra",Vector2(24,330),"sample",species)
   button138("¿Dónde puedo recogerla?",Vector2(344,330),"hint",species)
  elif current_stage=="sample":body.text="Ya tienes la muestra de "+FloristJourney138.title(species)+". Regresa a la florista del rancho; no hace falta pedir ni recoger otra."
  else:body.text="Mi compañera del rancho puede necesitar flores de esta región. Pregúntale antes de recoger una muestra para su encargo."
 else:
  match current_stage:
   "locked":
    body.text=recognition+"Aquí no crecen "+FloristJourney138.title(species)+". Mi compañera del pueblo del Camino del Este puede darte una muestra o decirte dónde conseguirla. Vuelve a entregármela.\nSigue el camino hacia el este: pasa por su pueblo."
    button138("Aceptar encargo",Vector2(24,330),"begin",species)
   "active":body.text=recognition+FloristJourney138.hud(state)
   "sample":
    body.text=recognition+"Has traído una muestra de "+FloristJourney138.title(species)+". Si me la entregas, podré crear aquí su propio cultivo."
    button138("Entregar muestra",Vector2(24,330),"deliver",species)
 button138("Seguir explorando",Vector2(184,448),"close",species)
func button138(text_:String,at:Vector2,action_:String,species:String)->void:
 var b:=Button.new();b.text=text_;b.position=at;b.size=Vector2(300,58);b.add_theme_font_size_override("font_size",19);QuestButtonStyle.apply(b);add_child(b)
 b.pressed.connect(func():
  if action_=="close":closed.emit()
  else:journey_action.emit(action_,species))
