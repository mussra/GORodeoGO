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
 var loaded:=RaceCupSession194.load_state()
 if not loaded.ok:
  body.text="No se puede abrir la copa. Tus archivos anteriores no se han reemplazado.\n\n"+("Sal del modo de sesión temporal para usar progreso guardado." if loaded.reason=="trial_session" else "El registro no se puede leer o pertenece a otra versión.");play.disabled=true;return
 goal=RaceCup194.current(loaded.state)
 if goal.is_empty():body.text="Copa completada · 16/16 objetivos\n\nEste avance no concede aún caballo ni objeto elemental. Esos premios y su historia siguen en preparación.\n\nPuedes seguir jugando carreras libres y duelos desde el menú.";play.disabled=true;return
 var detail:String="Gana un duelo al mejor de tres." if goal.mode=="duel" else "Termina la vuelta pasando las 16 puertas. Puesto máximo: %d/4."%goal.rank
 if goal.mode=="race":detail=(RaceCourse190.TITLES[goal.course] if goal.course>=0 else "Cualquier circuito")+". "+detail
 if goal.has("landed"):detail+=" Acierta al menos un lazo."
 if goal.has("dodges"):detail+=" Usa al menos un regate."
 if goal.has("max_hits"):detail+=" No recibas ningún lazo."
 body.text="Capítulo %d · objetivo %d/16\n%s\n\n%s\n\n%s\nProgreso guardado por separado al terminar. Sin premios todavía ni esperas obligatorias."%[goal.chapter,loaded.state.completed.size()+1,goal.title,detail,RaceCupSession194.last_notice]
func _play()->void:
 var started:=RaceCupSession194.begin()
 if not started.ok:return
 goal=started.goal
 if goal.mode=="duel":get_tree().change_scene_to_file("res://src/Presentation/duel193.tscn")
 else:
  RaceCourse190.selected=maxi(0,goal.course);RaceCourse190.start_selected=true
  get_tree().change_scene_to_file("res://src/Presentation/race190.tscn")
