class_name ArenaMinimap
extends Control
var level:Node
var expanded:bool=false
var _paused_for_map:bool=false
func _ready()->void:
	process_mode=Node.PROCESS_MODE_ALWAYS
	mouse_filter=Control.MOUSE_FILTER_STOP
	gui_input.connect(_on_input)
	_layout()
func _on_input(event:InputEvent)->void:
	if (event is InputEventMouseButton and event.device!=InputEvent.DEVICE_ID_EMULATION and event.pressed and event.button_index==MOUSE_BUTTON_LEFT):
		set_expanded(not expanded)
		accept_event()
func _layout()->void:
	var viewport:Vector2=get_viewport_rect().size
	size=Vector2(minf(700,viewport.x-80),minf(410,viewport.y-180)) if expanded else Vector2(180,112)
	position=(viewport-size)/2 if expanded else Vector2(viewport.x-size.x-18,84)
func _process(_delta:float)->void:
	_layout()
	visible=is_instance_valid(level) and not level._game_over
	queue_redraw()
func _point(world:Vector2,area:Rect2)->Vector2:
	return area.position+(world-level.world_bounds.position)/level.world_bounds.size*area.size
func _draw()->void:
	if not is_instance_valid(level):return
	draw_style_box(RanchTheme.box(Color(.04,.13,.17,.94),Color("89bdb7"),9),Rect2(Vector2.ZERO,size))
	var area:=Rect2(Vector2(12,27),size-Vector2(24,42))
	draw_rect(area,Color("34575c"))
	if expanded:
		# Inspectable consequences before choosing an opening. One line per link,
		# with a destination arrow; gameplay floor still keeps only the focused trail.
		for i in range(level._pens_data.size()):
			for target in PenLinkResolver.get_linked_pen_indices(level._pens_data,i):
				var a:Vector2=_point(level._puzzle_corrals[i].layout["door"],area)
				var b:Vector2=_point(level._puzzle_corrals[target].layout["door"],area)
				var toward:Vector2=(b-a).normalized()
				draw_line(a,b,Color("d9af72"),1.5,true)
				draw_polyline(PackedVector2Array([b-toward*9+toward.orthogonal()*4,b,b-toward*9-toward.orthogonal()*4]),Color("f3cc8e"),2,true)
	for corral in level._puzzle_corrals:
		var rect:Rect2=corral.layout["rect"]
		var mapped:=Rect2(_point(rect.position,area),rect.size/level.world_bounds.size*area.size)
		draw_rect(mapped,Color("547d7d"))
		draw_rect(mapped,Color("8ac2bb"),false,1.0)
		var gate:Vector2=_point(corral.layout["door"],area)
		draw_circle(gate,2.5,Color("83dec3") if corral.opened else Color("f0c86d"))
		if expanded:draw_string(ThemeDB.fallback_font,mapped.get_center()+Vector2(-18,4),"%d (%d)"%[corral.number,level._pens_data[corral.number-1]["bull_indices"].size()],HORIZONTAL_ALIGNMENT_LEFT,-1,13,Color("fff0c9"))
	var goal:Vector2=_point(level.pen.global_position,area)
	draw_rect(Rect2(goal-Vector2(4,4),Vector2(8,8)),Color("f2d179"))
	var rider:Vector2=_point(level.player.global_position,area)
	draw_circle(rider,5,Color("071b24"))
	draw_circle(rider,3.4,Color("f5fcfa"))
	# Viewport footprint gives context for what the follow camera currently shows.
	var camera:Camera2D=level.get_node("Camera2D")
	var half:Vector2=get_viewport_rect().size/(camera.zoom*2)
	var camera_center:Vector2=camera.get_screen_center_position()
	var view:=Rect2(_point(camera_center-half,area),half*2/level.world_bounds.size*area.size)
	view=view.intersection(area)
	draw_rect(view,Color(1,1,1,.4),false,1)
	var title:String=tr("MAPA · pausa · toca para cerrar") if expanded else tr("MAPA +")
	draw_string(ThemeDB.fallback_font,Vector2(12,18),title,HORIZONTAL_ALIGNMENT_LEFT,-1,13,Color("fff1cd"))
	if expanded:
		draw_string(ThemeDB.fallback_font,Vector2(12,size.y-9),"● Tú   ■ Meta   Nº (toros)   Flecha: abre   Dorado: cerrado",HORIZONTAL_ALIGNMENT_LEFT,-1,13,Color("e5e9ce"))

func set_expanded(value:bool)->void:
	expanded=value
	if expanded and not get_tree().paused:
		level.player.cancel_all_actions()
		level._reset_touch_controls()
		get_tree().paused=true
		RanchMusic.set_paused(true)
		_paused_for_map=true
	elif not expanded and _paused_for_map:
		get_tree().paused=false
		RanchMusic.set_paused(false)
		_paused_for_map=false
	_layout()
func _exit_tree()->void:
	if _paused_for_map:
		get_tree().paused=false
		RanchMusic.set_paused(false)

func _input(event:InputEvent)->void:
	# Native virtual joysticks consume screen touches before Control.gui_input.
	# Claim map touches in the same native input stage, above the joystick layer.
	if event is InputEventScreenTouch and visible and Rect2(position,size).has_point(event.position):
		get_viewport().set_input_as_handled()
		if event.pressed:set_expanded(not expanded)
