extends SceneTree
var frame: int = 0
var menu: Control
func _initialize() -> void: call_deferred("setup")
func setup() -> void:
	menu = load("res://src/Presentation/" + ("main_menu_cartoon.tscn" if OS.get_environment("MENU_VARIANT") == "cartoon" else "main_menu.tscn")).instantiate()
	root.add_child(menu)
func _process(_delta: float) -> bool:
	frame += 1
	if frame == 65: call_deferred("shot","/downloads/gorodeo/menu-" + OS.get_environment("MENU_VARIANT") + "-new.png")
	if frame == 115: menu._show_levels()
	if frame == 140: call_deferred("shot","/downloads/gorodeo/menu-" + OS.get_environment("MENU_VARIANT") + "-levels.png")
	if frame >= 180: quit()
	return false
func shot(path: String) -> void:
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(path)
