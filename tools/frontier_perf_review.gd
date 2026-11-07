extends SceneTree
## Frontier perf + memory harness (Ant 11:30:39/11:30:45): gallop across chunk
## boundaries, record frame times and memory/node monitors before and after.
class Metrics extends Node:
	var times: Array[float] = []
	func _process(d: float) -> void:
		times.append(d * 1000.0)

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	root.size = Vector2i(1599, 719)
	var SD: Node = root.get_node("SaveData")
	SD.save_path = "user://frontier-perf-save.dat"
	SD.world_seed = 0
	SD.world_discovered.clear(); SD.world_tamed.clear(); SD.world_missions.clear(); SD.world_pigs.clear(); SD.world_edits.clear()
	SD.horse_collection.seed_trial()
	var world: Node2D = load("res://src/Presentation/frontier_world.tscn").instantiate()
	root.add_child(world)
	var m := Metrics.new()
	root.add_child(m)
	await create_timer(2.0).timeout
	var nodes0: float = Performance.get_monitor(Performance.OBJECT_NODE_COUNT)
	var res0: float = Performance.get_monitor(Performance.OBJECT_RESOURCE_COUNT)
	var mem0: float = Performance.get_monitor(Performance.MEMORY_STATIC)
	m.times.clear()
	Input.action_press("move_right", 1.0)
	for i in range(5):
		await create_timer(3.0).timeout
		print("NODES@", i, " ", Performance.get_monitor(Performance.OBJECT_NODE_COUNT), " chunks=", world._chunks.size(), " pos=", world.player.position.x)
	Input.action_release("move_right")
	# turn around: revisiting known land must reuse the same node budget (no leak)
	Input.action_press("move_left", 1.0)
	for i in range(5):
		await create_timer(3.0).timeout
		print("NODES_BACK@", i, " ", Performance.get_monitor(Performance.OBJECT_NODE_COUNT), " chunks=", world._chunks.size(), " pos=", world.player.position.x)
	Input.action_release("move_left")
	await create_timer(0.5).timeout
	var nodes1: float = Performance.get_monitor(Performance.OBJECT_NODE_COUNT)
	var res1: float = Performance.get_monitor(Performance.OBJECT_RESOURCE_COUNT)
	var mem1: float = Performance.get_monitor(Performance.MEMORY_STATIC)
	m.times = m.times.slice(60)  # drop warmup
	m.times.sort()
	var avg: float = 0.0
	for t in m.times: avg += t
	avg /= m.times.size()
	var p95: float = m.times[int(m.times.size() * 0.95)]
	var worst: float = m.times[-1]
	var out := {
		"frames": m.times.size(), "avg_ms": snappedf(avg, 0.01), "p95_ms": snappedf(p95, 0.01), "worst_ms": snappedf(worst, 0.01),
		"nodes_before": nodes0, "nodes_after": nodes1, "resources_before": res0, "resources_after": res1,
		"mem_static_before_mb": snappedf(mem0 / 1048576.0, 0.1), "mem_static_after_mb": snappedf(mem1 / 1048576.0, 0.1),
		"player_pos": world.player.position,
	}
	var f := FileAccess.open("/tmp/frontier-perf.json", FileAccess.WRITE)
	f.store_string(JSON.stringify(out, "  "))
	f.close()
	print("PERF ", JSON.stringify(out))
	quit()
