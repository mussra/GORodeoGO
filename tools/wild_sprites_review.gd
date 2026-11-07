extends SceneTree
## Wild-horse sprite v2 review: 4 genotypes x (idle + walk gait frames),
## rendered through WildHorseArt's own pipeline (bases + extended masks +
## HorseAppearance recolor), so the PNG is exactly what the game draws.
func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var bg := ColorRect.new()
	bg.size = Vector2(1280, 760)
	bg.color = Color("1e2a26")
	root.add_child(bg)
	var genotypes: Array = [
		{"coat": 5, "pattern": 0, "mane": 1, "eyes": 2, "finish": "normal"},
		{"coat": 19, "pattern": 5, "mane": 3, "eyes": 10, "finish": "normal"},
		{"coat": 2, "pattern": 6, "mane": 0, "eyes": 0, "finish": "normal"},
		{"coat": 9, "pattern": 8, "mane": 2, "eyes": 5, "finish": "normal"},
	]
	var frames := [["wild_idle", 0, "idle"], ["wild_walk_side", 0, "walk f0"], ["wild_walk_side", 3, "walk f3"], ["wild_walk_side", 6, "walk f6"]]
	for g in range(genotypes.size()):
		var t: Dictionary = genotypes[g]
		var x: float = g * 320
		var title := Label.new()
		title.text = "genotipo %d · pelaje %d · patrón %s" % [g, t["coat"], HorseCollection.PATTERNS[t["pattern"]]]
		title.position = Vector2(x + 10, 14)
		title.add_theme_font_size_override("font_size", 18)
		root.add_child(title)
		for f in range(frames.size()):
			var spec: Array = frames[f]
			var base: Texture2D = load("res://art/world/wild_base/%s/frame_%02d.png" % [(spec[0] as String).trim_prefix("wild_"), spec[1]])
			var tex: Texture2D = HorseAppearance.texture(base, spec[0], spec[1], t)
			var s := Sprite2D.new()
			s.texture = tex
			s.scale = Vector2.ONE * 1.7
			s.position = Vector2(x + 82, 120 + f * 158)
			s.centered = false
			root.add_child(s)
			var lb := Label.new()
			lb.text = spec[2]
			lb.position = Vector2(x + 200, 150 + f * 158)
			lb.add_theme_font_size_override("font_size", 15)
			root.add_child(lb)
	for j in range(6):
		await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("/downloads/wild-genotypes-v2.png")
	print("WILD_REVIEW_OK")
	quit()
