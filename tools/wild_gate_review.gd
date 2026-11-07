extends SceneTree
## Ant's gate: original (with rider) vs wild derived (riderless), same genotype,
## enlarged, side by side. Uses the game's own recolor so it is exact.
func _initialize() -> void:
	call_deferred("run")

func _cell(t: Texture2D, x: float, y: float, sc: float, label: String) -> void:
	var tr := TextureRect.new()
	tr.texture = t
	tr.position = Vector2(x, y)
	tr.size = Vector2(96 * sc, 96 * sc)
	tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	tr.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	root.add_child(tr)
	var lb := Label.new()
	lb.text = label
	lb.position = Vector2(x, y + 96 * sc + 4)
	lb.add_theme_font_size_override("font_size", 17)
	root.add_child(lb)

func run() -> void:
	var bg := ColorRect.new()
	bg.size = Vector2(1280, 720)
	bg.color = Color("1e2a26")
	root.add_child(bg)
	var genotypes: Array = [
		{"coat": 5, "pattern": 0, "mane": 1, "eyes": 2, "finish": "normal"},
		{"coat": 19, "pattern": 5, "mane": 3, "eyes": 10, "finish": "normal"},
	]
	var pairs := [["walk_side", 0, "wild_walk_side"], ["walk_side", 3, "wild_walk_side"], ["idle", 0, "wild_idle"]]
	for g in range(genotypes.size()):
		var t: Dictionary = genotypes[g]
		var y: float = 30 + g * 345
		var head := Label.new()
		head.text = "pelaje %d · patrón %s · crin %d" % [t["coat"], HorseCollection.PATTERNS[t["pattern"]], t["mane"]]
		head.position = Vector2(20, y - 4)
		head.add_theme_font_size_override("font_size", 20)
		root.add_child(head)
		for p in range(pairs.size()):
			var anim: String = pairs[p][0]
			var idx: int = pairs[p][1]
			var wild: String = pairs[p][2]
			var x: float = 30 + p * 430
			var orig: Texture2D = load("res://art/player/%s/frame_%02d.png" % [anim, idx])
			var orig_tex: Texture2D = HorseAppearance.texture(orig, anim, idx, t)
			_cell(orig_tex, x, y + 26, 2.0, "original %s f%d" % [anim, idx])
			var base: Texture2D = load("res://art/world/wild_base/%s/frame_%02d.png" % [anim, idx])
			var wild_tex: Texture2D = HorseAppearance.texture(base, wild, idx, t)
			_cell(wild_tex, x + 205, y + 26, 2.0, "salvaje")
	for j in range(6):
		await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("/downloads/wild-gate-v2.png")
	print("GATE_REVIEW_OK")
	quit()
