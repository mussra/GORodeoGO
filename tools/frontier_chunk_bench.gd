extends SceneTree
## Chunk-gen spike bench: teleport across boundaries, record per-frame ms.
class Metrics extends Node:
	var times: Array[float] = []
	func _process(d: float) -> void:
		times.append(d * 1000.0)

func _initialize() -> void:
	call_deferred("run")

func bench(world: Node2D, m: Metrics, from_pos: Vector2, to_pos: Vector2, label: String) -> Dictionary:
	world.player.position = from_pos
	await create_timer(1.2).timeout  # amortized builds settle
	m.times.clear()
	world.player.position = to_pos  # crossing happens in next _process
	await create_timer(1.2).timeout
	var ts := m.times.duplicate()
	ts.sort()
	var total := 0.0
	for t in ts: total += t
	return {"label": label, "worst_ms": snappedf(ts[-1], 0.01), "sum_ms": snappedf(total, 0.01), "frames_over_8ms": ts.filter(func(t): return t > 8.0).size()}

func run() -> void:
	root.size = Vector2i(1599, 719)
	var SD: Node = root.get_node("SaveData")
	SD.save_path = "user://frontier-bench-save.dat"
	SD.world_seed = 0
	SD.world_discovered.clear(); SD.world_tamed.clear(); SD.world_missions.clear(); SD.world_pigs.clear(); SD.world_edits.clear()
	SD.horse_collection.seed_trial()
	var world: Node2D = load("res://src/Presentation/frontier_world.tscn").instantiate()
	root.add_child(world)
	var m := Metrics.new()
	root.add_child(m)
	await create_timer(2.0).timeout
	var results: Array = []
	# East crossing: from chunk 0 to chunk 1 (3 new chunks)
	results.append(await bench(world, m, Vector2(1000, 512), Vector2(1050, 512), "east_3chunks"))
	# Corner crossing: chunk (1,0) -> (2,1) diagonal (5 new chunks)
	results.append(await bench(world, m, Vector2(2000, 512), Vector2(2100, 1100), "corner_5chunks"))
	# Revisit: back west into known land (should be cheap)
	results.append(await bench(world, m, Vector2(1100, 1200), Vector2(1000, 1200), "revisit_west"))
	# Plain move inside same chunk (control)
	results.append(await bench(world, m, Vector2(1500, 1500), Vector2(1600, 1500), "control_inside"))
	# Direct full-build timing of one chunk (engine-only, no render frame):
	# same total work as the old synchronous _ensure_chunk, now step-driven.
	# Clear the genotype frame cache for a COLD comparable measurement.
	load("res://src/Presentation/wild_horse_art.gd").frame_cache.clear()
	var t0 := Time.get_ticks_usec()
	world._queue_build(5, 5)
	while not world._build_queue.is_empty():
		world._step_chunk_build()
	var direct_ms := (Time.get_ticks_usec() - t0) / 1000.0
	# WorldMap.generate alone
	t0 = Time.get_ticks_usec()
	for i in range(10):
		WorldMap.generate(0, 10 + i, 10)
	var gen_ms := (Time.get_ticks_usec() - t0) / 1000.0 / 10.0
	for r in results:
		print("BENCH ", JSON.stringify(r))
	print("BENCH ", JSON.stringify({"label": "full_chunk_build_ms", "worst_ms": snappedf(direct_ms, 0.01)}))
	print("BENCH ", JSON.stringify({"label": "worldmap_generate_ms", "worst_ms": snappedf(gen_ms, 0.01)}))
	quit()
