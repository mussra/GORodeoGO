extends GutTest

const BOUNDS: Rect2 = Rect2(-480, -270, 960, 540)
const MARGIN: float = 30.0

func _dir(pos: Vector2, player: Vector2, toward: bool = false, obstacles: Array = [], pen: Rect2 = Rect2()) -> Vector2:
	return FleeSteering.compute_direction(pos, player, toward, BOUNDS, obstacles, pen, MARGIN)

func test_flees_directly_away_in_open_space() -> void:
	var d := _dir(Vector2(100, 0), Vector2(0, 0))
	assert_almost_eq(d.x, 1.0, 0.001)
	assert_almost_eq(d.y, 0.0, 0.001)

func test_chaser_heads_toward_the_player() -> void:
	var d := _dir(Vector2(100, 0), Vector2(0, 0), true)
	assert_almost_eq(d.x, -1.0, 0.001)

func test_result_is_always_unit_length() -> void:
	assert_almost_eq(_dir(Vector2(-470, -260), Vector2(0, 0)).length(), 1.0, 0.001)

func test_coincident_positions_fall_back_to_right() -> void:
	assert_eq(_dir(Vector2(5, 5), Vector2(5, 5)), Vector2.RIGHT)

func test_near_left_edge_slides_along_the_wall_instead_of_into_it() -> void:
	# pure flee from a player below-right is mostly -x (into the wall)
	var d := _dir(Vector2(-470, 0), Vector2(0, 100))
	var open := _dir(Vector2(-300, 0), Vector2(-300 + 470, 100))
	assert_gt(d.x, open.x, "wall avoidance reduces the push into the wall")
	assert_lt(d.y, -0.5, "and redirects it along the wall, away from the player")

func test_obstacle_bends_the_flee_direction_away_from_its_centre() -> void:
	var rect := Rect2(-40, -30, 80, 60)
	var with_obstacle := _dir(Vector2(0, -50), Vector2(-50, -400), false, [rect])
	var without := _dir(Vector2(0, -50), Vector2(-50, -400))
	assert_lt(with_obstacle.y, without.y)

func test_pen_zone_bends_the_flee_direction_away_from_the_pen() -> void:
	var pen := Rect2(-340, -40, 80, 80)
	var with_pen := _dir(Vector2(-300, 60), Vector2(-250, 300), false, [], pen)
	var without := _dir(Vector2(-300, 60), Vector2(-250, 300))
	assert_gt(with_pen.y, without.y)
