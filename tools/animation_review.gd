extends SceneTree
## Deterministic real-engine playback, for movie capture and visual review.
var frame: int = 0
var stage: Node2D
var label: Label
func _initialize() -> void:
	call_deferred("setup")
func setup() -> void:
	stage = Node2D.new()
	root.add_child(stage)
	var bg := ColorRect.new()
	bg.color = Color("d7b17b")
	bg.size = Vector2(1280, 720)
	stage.add_child(bg)
	var title := Label.new()
	title.text = "GO Rodeo GO · Animaciones integradas"
	title.position = Vector2(32, 20)
	title.add_theme_color_override("font_color", Color("332b28"))
	title.add_theme_font_size_override("font_size", 30)
	stage.add_child(title)
	for row: int in range(2):
		var entity: String = "player" if row == 0 else "bull"
		var prefix: String = "walk_" if row == 0 else "flee_"
		var index: int = 0
		for direction: String in ["side", "up", "down", "diag_down", "diag_up"]:
			var host := Node2D.new()
			host.position = Vector2(136 + index * 250, 230 + row * 300)
			host.scale = Vector2(2, 2)
			stage.add_child(host)
			var placeholder := Polygon2D.new()
			host.add_child(placeholder)
			var swap := SpriteSwap.new(host, placeholder, "res://art/%s/" % entity, [prefix + direction])
			swap.play(prefix + direction)
			var caption := Label.new()
			caption.text = prefix + direction
			caption.position = Vector2(-50, 57)
			caption.scale = Vector2(0.65, 0.65)
			caption.add_theme_color_override("font_color", Color("332b28"))
			host.add_child(caption)
			index += 1
func _process(_delta: float) -> bool:
	frame += 1
	if frame >= 180:
		quit()
	return false
