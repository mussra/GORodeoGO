extends GutTest

## Automated stand-in for the "UNVERIFIED: positions not play-tested" notes in LevelCatalog:
## the level data must never place anything where it cannot work. Spawn positions are read
## from level_0.tscn (their single source of truth).

const WORLD: Rect2 = Rect2(-480, -270, 960, 540)
const PLAYER_SPAWN: Vector2 = Vector2.ZERO
const PLAYER_HALF_HEIGHT: float = 18.0
const BULL_RADIUS: float = 24.0
const PEN_RECT: Rect2 = Rect2(-340, -40, 80, 80)

var _bull_spawns: Array = []

func before_all() -> void:
	var level: Node = (load("res://src/Presentation/level_0.tscn") as PackedScene).instantiate()
	for node_name in ["Bull", "Bull2", "Bull3", "Bull4", "Bull5", "Bull6", "Bull7", "Bull8", "Bull9", "Bull10"]:
		_bull_spawns.append((level.get_node(node_name) as Node2D).position)
	level.free()

func test_scene_has_ten_bull_spawns() -> void:
	assert_eq(_bull_spawns.size(), 10)

func test_obstacles_are_inside_the_arena() -> void:
	for n in range(1, LevelCatalog.MAX_LEVEL + 1):
		for rect: Rect2 in LevelCatalog.get_level(n).obstacle_rects:
			assert_true(WORLD.encloses(rect), "level %d obstacle %s leaves the arena" % [n, rect])

func test_obstacles_never_cover_player_spawn_or_pen() -> void:
	for n in range(1, LevelCatalog.MAX_LEVEL + 1):
		for rect: Rect2 in LevelCatalog.get_level(n).obstacle_rects:
			assert_false(rect.grow(PLAYER_HALF_HEIGHT).has_point(PLAYER_SPAWN), "level %d blocks player spawn" % n)
			assert_false(rect.intersects(PEN_RECT.grow(PLAYER_HALF_HEIGHT)), "level %d obstacle touches the pen" % n)

func test_obstacles_never_cover_a_bull_spawn() -> void:
	for n in range(1, LevelCatalog.MAX_LEVEL + 1):
		var data: LevelData = LevelCatalog.get_level(n)
		for i in range(min(data.bull_count, _bull_spawns.size())):
			for rect: Rect2 in data.obstacle_rects:
				assert_false(rect.grow(BULL_RADIUS).has_point(_bull_spawns[i]), "level %d: obstacle %s traps bull %d" % [n, rect, i])

func test_doors_are_reachable_by_the_player() -> void:
	for n in range(11, LevelCatalog.MAX_LEVEL + 1):
		var data: LevelData = LevelCatalog.get_level(n)
		for pen_entry: Dictionary in _physical_pens(data):
			var door: Vector2 = pen_entry["door_position"]
			assert_true(ArenaLayout.bounds_for_level(n).grow(-PLAYER_HALF_HEIGHT).has_point(door), "level %d door %s outside walkable area" % [n, door])
			for rect: Rect2 in data.obstacle_rects:
				assert_false(rect.grow(PLAYER_HALF_HEIGHT).has_point(door), "level %d door %s inside obstacle" % [n, door])

func test_doors_do_not_overlap_each_other() -> void:
	for n in range(11, LevelCatalog.MAX_LEVEL + 1):
		var pens: Array = _physical_pens(LevelCatalog.get_level(n))
		for i in range(pens.size()):
			for j in range(i + 1, pens.size()):
				var distance: float = (pens[i]["door_position"] as Vector2).distance_to(pens[j]["door_position"])
				assert_gte(distance, PenDoor.RADIUS * 2.0, "level %d doors %d and %d overlap" % [n, i, j])

func test_doors_are_not_under_the_player_spawn_or_the_pen() -> void:
	for n in range(11, LevelCatalog.MAX_LEVEL + 1):
		for pen_entry: Dictionary in _physical_pens(LevelCatalog.get_level(n)):
			var door: Vector2 = pen_entry["door_position"]
			assert_gt(door.distance_to(PLAYER_SPAWN), PenDoor.RADIUS + PLAYER_HALF_HEIGHT, "level %d: player would spawn inside a door" % n)
			assert_false(PEN_RECT.grow(PenDoor.RADIUS).has_point(door), "level %d: door %s overlaps the pen" % [n, door])

## Flood fill with bull-size clearance, more conservative than the rider's rectangle.
## This checks static route existence, not AI pathfinding or time-limit balance.
func test_all_doors_bulls_and_goal_have_connected_clearance_routes() -> void:
	for n in range(1, LevelCatalog.MAX_LEVEL + 1):
		var data: LevelData = LevelCatalog.get_level(n)
		var grid := AStarGrid2D.new()
		var bounds:Rect2=ArenaLayout.bounds_for_level(n).grow(-25)
		var first:=Vector2i(floori(bounds.position.x/10),floori(bounds.position.y/10))
		var last:=Vector2i(ceili(bounds.end.x/10),ceili(bounds.end.y/10))
		grid.region = Rect2i(first,last-first+Vector2i.ONE)
		grid.cell_size = Vector2(10, 10)
		grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
		grid.update()
		for x in range(grid.region.position.x,grid.region.end.x):
			for y in range(grid.region.position.y,grid.region.end.y):
				var point := Vector2(x * 10, y * 10)
				for rect: Rect2 in data.obstacle_rects:
					if rect.grow(BULL_RADIUS + 1).has_point(point):
						grid.set_point_solid(Vector2i(x, y))
		var targets: Array = [Vector2(-300, 0)]
		for i in range(data.bull_count): targets.append(_bull_spawns[i])
		for entry: Dictionary in _physical_pens(data): targets.append(entry["door_position"])
		for target: Vector2 in targets:
			var cell := Vector2i(roundi(target.x / 10), roundi(target.y / 10))
			assert_false(grid.get_id_path(Vector2i.ZERO, cell).is_empty(), "level %d route to %s with bull clearance" % [n, target])

func _physical_pens(data:LevelData)->Array:
	var pens:Array=data.pens.duplicate(true)
	for i in range(pens.size()):
		var layout:Dictionary=ArenaLayout.spread_corral(PuzzleCorralLayout.build(pens.size(),i,pens[i]["bull_indices"].size(),pens[i].get("layout_mirror_x",false)),ArenaLayout.scale_for_level(data.level_number))
		pens[i]["door_position"]=layout["door"]
	return pens
