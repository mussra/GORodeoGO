extends GutTest
## 3.0.43: los botones estrechos muestran su texto entero (antes el marco dejaba 5 px de texto: "Fi", botones vacios).
func _fits(b:Button)->bool:
	var f:Font=b.get_theme_font("font");var n:int=b.get_theme_font_size("font_size")
	var room:float=b.size.x-b.get_theme_stylebox("normal").get_minimum_size().x
	return f.get_string_size(b.text,HORIZONTAL_ALIGNMENT_LEFT,-1,n).x<=room
func test_compact_skin_leaves_room_for_short_labels()->void:
	for pair in [["Ficha",78],["De A",110],["Familia",90]]:
		var b:=Button.new();b.text=pair[0];b.size=Vector2(pair[1],48);add_child_autofree(b);ButtonSkin272.compact(b)
		assert_true(_fits(b),pair[0]+" cabe en %d px"%pair[1])
func test_invisible_tap_area_is_not_reskinned()->void:
	var b:=Button.new();b.set_meta("skin272",true)
	for state in ["normal","hover","pressed","focus","disabled"]:b.add_theme_stylebox_override(state,StyleBoxEmpty.new())
	add_child_autofree(b);assert_true(b.get_theme_stylebox("normal") is StyleBoxEmpty)
