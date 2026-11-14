extends Control
var body:Label
var play:Button
var goal:Dictionary={}
func _ready()->void:
 RaceCupSession194.active=false
 theme=RanchTheme.create();set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 var panel:=Panel.new();panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER);panel.position=Vector2(-480,-280);panel.size=Vector2(960,560);add_child(panel)
 var title:=Label.new();title.text="COPA DEL RANCHO · PRUEBA DE OBJETIVOS";title.position=Vector2(28,22);panel.add_child(title);TextFit181.fixed(title,Vector2(900,60),27,22,2)
 var scroll:=ScrollContainer.new();scroll.position=Vector2(28,100);scroll.size=Vector2(900,310);scroll.horizontal_scroll_mode=ScrollContainer.SCROLL_MODE_DISABLED;panel.add_child(scroll)
 body=Label.new();scroll.add_child(body);DetailCard179.reading_surface(body);TextFit181.flow(body,865.)
 play=Button.new();play.text="Jugar el objetivo";play.position=Vector2(28,450);play.size=Vector2(410,65);panel.add_child(play);play.pressed.connect(_play)
 var back:=Button.new();back.text="Menú";back.position=Vector2(520,450);back.size=Vector2(410,65);panel.add_child(back);back.pressed.connect(func():get_tree().change_scene_to_file("res://src/Presentation/main_menu.tscn"))
 if not RaceCupSession194.pending_result.is_empty():
  body.text=RaceCupSession194.last_notice+"\n\nReintenta guardar en el mismo modo antes de continuar. No se inicia otro objetivo mientras este resultado esté pendiente."
  play.text="Reintentar guardado";return
 var loaded:=RaceCupSession194.load_state()
 if not loaded.ok:
  body.text="No se puede abrir la copa. Tus archivos anteriores no se han reemplazado.\n\n"+("Sal del modo de sesión temporal para usar progreso guardado." if loaded.reason=="trial_session" else "El registro no se puede leer o pertenece a otra versión.");play.disabled=true;return
 goal=RaceCup194.current(loaded.state)
 if goal.is_empty():
  _completed();return

 var detail:String=("Gana el duelo 2-0, sin ceder manga." if goal.has("max_rival_wins") else "Gana un duelo al mejor de tres.") if goal.mode=="duel" else "Termina la vuelta pasando las 16 puertas. Puesto máximo: %d/4."%goal.rank
 if goal.mode=="race":detail=(RaceCourse190.TITLES[goal.course] if goal.course>=0 else "Cualquier circuito")+". "+detail
 if goal.has("landed"):detail+=" Acierta al menos %d lazo(s)."%goal.landed
 if goal.has("dodges"):detail+=" Inicia al menos %d regate(s)."%goal.dodges
 if goal.has("max_hits"):detail+=" No recibas ningún lazo."
 body.text="Capítulo %d · objetivo %d/%d\n%s\n\n%s\n\n%s\nProgreso guardado por separado al terminar. Premio final: Brisa del Alba y Brújula del Viento. Sin esperas obligatorias."%[goal.chapter,loaded.state.completed.size()+1,RaceCup194.CHALLENGES.size(),goal.title,detail,RaceCupSession194.last_notice]
func _play()->void:
 if not RaceCupSession194.pending_result.is_empty():
  var retried:=RaceCupSession194.retry_pending()
  if retried.ok:get_tree().reload_current_scene()
  else:body.text+="\nNo se ha podido guardar. Mantén el juego abierto y reintenta en el modo original."
  return
 if goal.is_empty():
  var granted:=SaveData.claim_cup195()
  if granted.ok:_completed()
  else:body.text+="\nNo se ha podido guardar. Tus premios no se han aplicado. Puedes reintentar."
  return
 var started:=RaceCupSession194.begin()
 if not started.ok:return
 goal=started.goal
 if goal.mode=="duel":get_tree().change_scene_to_file("res://src/Presentation/duel193.tscn")
 else:
  RaceCourse190.selected=maxi(0,goal.course);RaceCourse190.start_selected=true
  get_tree().change_scene_to_file("res://src/Presentation/race190.tscn")

func _completed()->void:
 var claimed:bool=SaveData.horse_collection.cup_rewards195.has(CupRewards195.RECEIPT)
 body.text="Copa completada · %d/%d objetivos\n\n"%[RaceCup194.CHALLENGES.size(),RaceCup194.CHALLENGES.size()]
 body.text+="Brisa del Alba: caballo de pelaje celeste y estrellas, con Temple de cruce. Reduce de 0,65 a 0,52 s el freno por roce del molino. No aumenta la velocidad. Una cría con al menos un progenitor con este temple lo hereda.\n\n"
 body.text+="Brújula del Viento: objeto elemental único. Pista: 'El viento recuerda el camino; busca sus señales junto al árbol madre'. No activa ni convierte un unicornio.\n\n"
 body.text+=("Premios guardados. Brisa te espera en la colección. La brújula queda registrada aquí." if claimed else "Recoge ambos premios juntos. Si no se pueden guardar, no se concede ninguno.")
 play.text="Premios recogidos" if claimed else "Recoger premios"
 play.disabled=claimed
func _unhandled_input(event:InputEvent)->void:
 if event.is_action_pressed("ui_cancel"):
  get_viewport().set_input_as_handled()
  get_tree().change_scene_to_file("res://src/Presentation/main_menu.tscn")
