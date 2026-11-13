extends GutTest
func test_fixed_long_names_are_bounded_with_floor_and_full_tooltip():
 var l:=Label.new();add_child(l);l.text="Verde · Trasera blanca\nCrin: Arcoíris"
 TextFit181.fixed(l,Vector2(228,60),23,18,2)
 await wait_process_frames(2)
 assert_lte(l.size.x,228.);assert_lte(l.size.y,60.);assert_gte(l.get_theme_font_size("font_size"),18);assert_true(l.clip_text);assert_eq(l.tooltip_text,l.text)
 l.text="Caballo extraordinariamente largo de nombre extraordinario".repeat(5);TextFit181.fixed(l,Vector2(228,60),23,18,2)
 await wait_process_frames(2)
 assert_lte(l.size.x,228.);assert_lte(l.size.y,60.);assert_eq(l.get_theme_font_size("font_size"),18);assert_eq(l.text_overrun_behavior,TextServer.OVERRUN_TRIM_ELLIPSIS);l.free()
func test_flow_preserves_complete_text_and_can_grow_vertically():
 var l:=Label.new();add_child(l);l.text="Texto muy largo sin quitar ninguna parte de una descripción. ".repeat(20);TextFit181.flow(l,300)
 await wait_process_frames(2)
 assert_lte(l.size.x,300.);assert_gt(l.size.y,100.);assert_eq(l.max_lines_visible,-1);assert_eq(l.text.length(),1220);l.free()
func test_button_cannot_enlarge_past_assigned_width_with_long_text():
 var b:=Button.new();add_child(b);b.text="Nombre larguísimo ".repeat(30);b.size=Vector2(230,48);TextFit181.button(b,Vector2(230,48))
 await wait_process_frames(2)
 assert_lte(b.size.x,230.);assert_eq(b.tooltip_text,b.text);b.free()
