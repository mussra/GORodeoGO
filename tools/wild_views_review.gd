extends SceneTree
## Directional wild-horse views review (Ant 7-nov 15:04): reference sheet views
## (left) vs derived game sprites (right), plus recolor check (white+chestnut).
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
	var anims := ["wild_down", "wild_up", "wild_diag_down", "wild_diag_up", "wild_side"]
	for g in range(genotypes.size()):
		for a in range(anims.size()):
			var base: Texture2D = load("res://art/world/wild_base/%s/frame_00.png" % (anims[a] as String).trim_prefix("wild_"))
			var tex: Texture2D = HorseAppearance.texture(base, anims[a], 0, genotypes[g])
			var s := Sprite2D.new()
			s.texture = tex
			s.scale = Vector2.ONE * 3.0
			s.position = Vector2(60 + a * 310, 30 + g * 360)
			s.centered = false
			root.add_child(s)
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png("/downloads/wild-views-recolor.png")
	print("done")
	quit()
