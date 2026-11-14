extends GutTest
func test_all_twelve_crops_have_alpha():
 for cell in range(1,13):
  var texture:=AntIcons188.texture(cell);assert_not_null(texture)
  var image:=texture.get_image()
  if image.is_compressed():image.decompress()
  assert_true(image.detect_alpha()!=Image.ALPHA_NONE)
func test_petals_tint_without_changing_centre_alpha_or_source():
 var blue:=AntIcons188.flower(Color("68cfff")).get_image();var pink:=AntIcons188.flower(Color("e8688b")).get_image()
 if blue.is_compressed():blue.decompress()
 if pink.is_compressed():pink.decompress()
 assert_eq(blue.get_size(),pink.get_size());assert_ne(blue.get_data(),pink.get_data())
 var center:Vector2i=Vector2i(blue.get_size()/2);assert_eq(blue.get_pixelv(center),pink.get_pixelv(center))
 assert_eq(blue.get_pixel(0,0).a,pink.get_pixel(0,0).a)
func test_native_ring_style_uses_art_only_and_does_not_replace_tip():
 var a:=AntIcons188.joystick_ring(false);var b:=AntIcons188.joystick_ring(true)
 assert_eq(a.texture,AntIcons188.texture(8));assert_eq(b.texture,a.texture);assert_lt(a.modulate_color.a,b.modulate_color.a)
 assert_eq(a.texture_margin_left,0.);assert_eq(a.texture_margin_top,0.)
func test_clocks_and_plates_stay_untouched():
 for id in ["stamina","dodge","jump"]:assert_true(RadialGauge.ART[id].resource_path.begins_with("res://art/ui/skills/"))
 var script:Script=load("res://src/Presentation/quest_button_style.gd")
 assert_false(script.source_code.contains("AntIcons188"))
