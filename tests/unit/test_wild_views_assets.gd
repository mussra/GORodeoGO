extends GutTest
## The wild horse directional views (Ant's reference sheets) must ship with
## base frames + recolor masks for every direction the wander logic can pick.

const DIRS: Array[String] = ["down", "up", "diag_down", "diag_up"]

func test_directional_frames_exist():
	for d in DIRS:
		assert_true(ResourceLoader.exists("res://art/world/wild_base/%s/frame_00.png" % d), "missing base " + d)

func test_directional_masks_exist():
	for d in DIRS:
		assert_true(ResourceLoader.exists("res://art/horse_masks/wild_%s/frame_00.png" % d), "missing mask " + d)

const Art := preload("res://src/Presentation/wild_horse_art.gd")

func test_wild_art_exposes_direction_anims():
	var frames: SpriteFrames = Art._build_frames({})
	for a in ["walk_down", "walk_up", "walk_diag_down", "walk_diag_up", "walk", "idle"]:
		assert_true(frames.has_animation(a), "missing anim " + a)
