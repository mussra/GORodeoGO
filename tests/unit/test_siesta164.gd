extends GutTest
func test_shared_eye_uses_feathered_shader_and_has_no_overlay_when_fully_open():
 var eye:=SiestaEye163.new();add_child_autofree(eye);eye.aperture=1.
 assert_true(eye.material is ShaderMaterial);assert_eq(eye.material.get_shader_parameter("aperture"),1.)
 eye.aperture=0.;assert_eq(eye.material.get_shader_parameter("aperture"),0.)
 assert_true(eye.material.shader.code.contains("smoothstep"));assert_true(eye.material.shader.code.contains("if(aperture>=0.99999)"))
func test_closed_loading_has_clear_message_and_message_hides_before_open():
 var curtain:=SiestaCurtain147.new();add_child_autofree(curtain)
 curtain._physics_process(.1)
 assert_true(curtain.message.visible);assert_true(curtain.message.text.contains("Cargando el camino"));assert_true(curtain.message.text.contains("Espera un momento"))
 curtain.phase="covered";curtain._physics_process(.8);assert_true(curtain.message.visible)
 curtain.open_eye();assert_false(curtain.message.visible)
 await get_tree().create_timer(1.1).timeout
 assert_eq(curtain.phase,"done");assert_eq(curtain.eye.aperture,1.)
