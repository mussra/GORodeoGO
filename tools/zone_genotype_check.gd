extends SceneTree
func _initialize() -> void:
	call_deferred("run")
func run() -> void:
	var bg := ColorRect.new()
	bg.size = Vector2(1280, 760)
	bg.color = Color("2e5d33")
	root.add_child(bg)
	var genotypes: Array = [
		{"coat": 10, "pattern": 0, "mane": 0, "eyes": 0, "finish": "normal"},
		{"coat": 1, "pattern": 2, "mane": 1, "eyes": 1, "finish": "normal"},
	]
	var frames := [["wild_idle", 0, "idle f0"], ["wild_walk_side", 0, "walk f0"], ["wild_walk_side", 3, "walk f3"], ["wild_walk_side", 6, "walk f6"]]
	for g in range(genotypes.size()):
		var t: Dictionary = genotypes[g]
		for f in range(frames.size()):
			var spec: Array = frames[f]
			var base: Texture2D = load("res://art/world/wild_base/%s/frame_%02d.png" % [(spec[0] as String).trim_prefix("wild_"), spec[1]])
			var tex: Texture2D = HorseAppearance.texture(base, spec[0], spec[1], t)
			var s := Sprite2D.new()
			s.texture = tex
			s.scale = Vector2.ONE * 3.0
			s.position = Vector2(60 + g * 620, 40 + f * 180)
			s.centered = false
			root.add_child(s)
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("/downloads/zone-genotype-check.png")
	print("done")
	quit()
