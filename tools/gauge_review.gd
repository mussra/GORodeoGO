extends SceneTree
## Radial gauge preview (Ant 11:40): four states side by side.
func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	root.size = Vector2i(1599, 719)
	TranslationServer.set_locale("es")
	var bg := ColorRect.new()
	bg.color = Color("1d2a26")
	bg.size = Vector2(1599, 719)
	root.add_child(bg)
	var states: Array = [
		["Con ambas", [["stamina", true, 1.0], ["dodge", true, 1.0], ["jump", true, 1.0]]],
		["Sin regate", [["stamina", true, 0.8], ["dodge", false, 0.0], ["jump", true, 1.0]]],
		["Sin salto", [["stamina", true, 0.65], ["dodge", true, 1.0], ["jump", false, 0.0]]],
		["En recarga", [["stamina", true, 0.3], ["dodge", true, 0.55], ["jump", true, 0.7]]],
	]
	var font: Font = ThemeDB.fallback_font
	for i in states.size():
		var col: float = 200.0 + i * 330.0
		var label := Label.new()
		label.text = states[i][0]
		label.position = Vector2(col, 240)
		label.add_theme_font_size_override("font_size", 24)
		root.add_child(label)
		var specs: Array = states[i][1]
		for j in specs.size():
			var g := RadialGauge.new()
			g.skill = specs[j][0]
			g.position = Vector2(col + j * 92.0, 290)
			g.size = Vector2(84, 84)
			g.set_state(specs[j][1], specs[j][2])
			root.add_child(g)
	await create_timer(0.4).timeout
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("/downloads/frontier-gauges.png")
	print("gauges saved")
	quit()
