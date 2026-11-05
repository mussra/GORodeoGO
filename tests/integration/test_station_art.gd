extends GutTest
func test_own_art_loads_with_alpha_and_distraction_radius_is_unchanged()->void:
	for name in ["hay_round","water_trough"]:
		var texture:Texture2D=load("res://art/stations/"+name+".svg")
		assert_not_null(texture)
		var image:Image=texture.get_image()
		assert_eq(image.get_pixel(0,0).a,0.0,"no baked checkerboard")
		assert_eq(image.get_pixel(image.get_width()-1,image.get_height()-1).a,0.0)
	assert_eq(DistractionStation.TRIGGER_RADIUS,48.0,"visual only, unchanged effective area")
	var station:=DistractionStation.new()
	add_child_autofree(station)
	assert_eq(station.get_child_count(),0,"no new physics body")
