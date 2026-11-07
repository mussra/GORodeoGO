extends SceneTree
## Test-map zone preview (Ant 7-nov-2026 13:09): wide shot of the whole zone and
## a close-up of the two wandering wild horses (distinct fixed genotypes).
func _initialize()->void:call_deferred("run")
func _snap(path:String)->void:
 await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png(path)
func run()->void:
 root.size=Vector2i(1599,719)
 var SD:Node=root.get_node("SaveData")
 SD.save_path="user://testzone-review-save.dat"
 TranslationServer.set_locale("es")
 SD.world_seed=0;SD.world_discovered.clear();SD.world_tamed.clear();SD.world_missions.clear();SD.world_pigs.clear()
 SD.horse_collection.seed_trial()
 var world:Node2D=load("res://src/Presentation/frontier_world.tscn").instantiate()
 root.add_child(world)
 await create_timer(.4).timeout
 # wide: player north of the zone so the camera frames meadow, pen and houses
 world.player.position=Vector2(160,450)
 await create_timer(1.5).timeout
 await _snap("/downloads/testzone-wide.png")
 # close-up: next to the two horses while they wander (walk gait visible)
 world.player.position=Vector2(60,830)
 await create_timer(2.4).timeout
 await _snap("/downloads/testzone-horses.png")
 print("testzone review done")
 quit()
