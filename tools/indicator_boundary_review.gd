extends SceneTree
var level:Node
var bull:Node2D
var edge:EdgeIndicators
var label:Label
var frame:int=0
var toggles:int=0
var last:bool=false
func _initialize()->void:call_deferred("setup")
func setup()->void:
	root.get_node("GameState").selected_level=20
	root.get_node("SaveData").dual_lasso_intro_shown=true
	level=load("res://src/Presentation/level_0.tscn").instantiate()
	root.add_child(level)
	level.set_process(false)
	for item in level._active_bulls:item.set_physics_process(false)
	level.player.set_physics_process(false)
	bull=level._active_bulls[0]
	edge=level._edge_indicators
	edge.set_process(false)
	var layer:=CanvasLayer.new();layer.layer=100;root.add_child(layer)
	label=Label.new();label.position=Vector2(180,65);label.add_theme_font_size_override("font_size",23);layer.add_child(label)
	AudioServer.set_bus_mute(0,true)
func _process(delta:float)->bool:
	if level==null:return false
	frame+=1
	var phase:int=0 if frame<=240 else 1
	if frame==241:toggles=0;last=false;edge._visibility.clear()
	var local_frame:int=(frame-1)%240
	var x:float=1280.0+sin(local_frame*1.4)*1.5
	var target:=Vector2(x,355)
	bull.global_position=level.get_global_transform_with_canvas().affine_inverse()*target
	edge.markers.clear();edge._frame_delta=delta
	var visible:=Rect2(0,80,1280,570)
	if phase==0:
		if not visible.has_point(target):
			edge.markers.append({"point":ArenaLayout.edge_point(target,Rect2(70,110,1140,485)),"direction":Vector2.RIGHT,"label":"TORO","color":Color("efab81"),"count":1})
	else:edge._add_marker(target,Rect2(70,110,1140,485),"TORO",Color("efab81"),false,bull.get_instance_id())
	var shown:bool=not edge.markers.is_empty()
	if shown!=last:toggles+=1
	last=shown
	edge.queue_redraw()
	label.text=("ANTES" if phase==0 else "CORREGIDO")+" | Toro oscilando ±1,5 px en borde derecho | Cambios de flecha: %d"%toggles
	if frame==470:call_deferred("shot")
	if frame>=480:print("VISUAL_JITTER final toggles=",toggles);quit()
	return false
func shot()->void:
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("/downloads/gorodeo/indicator-boundary-fixed.png")
