extends GutTest
func test_marker_size_is_fixed_and_not_map_cell_dependent():
 assert_eq(MapPlayerMarker99.RING_RADIUS,10.)
 assert_eq(MapPlayerMarker99.RING_WIDTH,2.)
 assert_eq(MapPlayerMarker99.BODY_RADIUS,7.)
 assert_eq(MapPlayerMarker99.ARROW_LENGTH,15.)
 assert_eq(MapPlayerMarker99.ARROW_HALF_WIDTH,4.)
 var script:Script=load("res://src/Presentation/map_player_marker99.gd")
 assert_false(script.source_code.contains("cell"+" *"))
 assert_false(script.source_code.contains("zoom"+" *"))
