extends GutTest
func test_duration_grows_with_text_and_honors_minimum()->void:
 assert_gte(ToastStack.reading_seconds("Hola"),5.0)
 assert_gt(ToastStack.reading_seconds("Mensaje largo ".repeat(9)),ToastStack.reading_seconds("Hola"))
 assert_gte(ToastStack.reading_seconds("Hola",20),20.0)
func test_distinct_notices_stack_and_overflow_keeps_full_duration()->void:
 var stack:=ToastStack.new();add_child_autofree(stack);stack.set_process(false)
 for i in 5:stack.push("Aviso %d"%i)
 assert_eq(stack.active.size(),3);assert_eq(stack.pending.size(),2)
 assert_eq(stack.active[0].text,"Aviso 0");assert_eq(stack.active[1].text,"Aviso 1")
 stack.advance(20)
 assert_eq(stack.active.size(),2);assert_eq(stack.pending.size(),0)
 assert_eq(stack.active[0].text,"Aviso 3")
 assert_gte(stack.active[0].left,5.0,"cola recibe tiempo entero al mostrarse")
 for notice in stack.active:
  assert_eq(notice.label.mouse_filter,Control.MOUSE_FILTER_IGNORE)
  assert_true(notice.label.has_theme_stylebox_override("normal"))
func test_repeat_extends_without_erasing_other_messages()->void:
 var stack:=ToastStack.new();add_child_autofree(stack);stack.set_process(false)
 stack.push("A");stack.push("B");stack.advance(3);stack.push("A")
 assert_eq(stack.active.size(),2);assert_eq(stack.active[1].text,"B")
 assert_gte(stack.active[0].left,5.0)
 stack.clear();assert_eq(stack.active.size(),0);assert_eq(stack.pending.size(),0)
func test_long_messages_wrap_and_do_not_overlap()->void:
 var stack:=ToastStack.new();add_child_autofree(stack);stack.set_process(false)
 stack.push("Ups... parece que tendremos que cambiar de estrategia.")
 stack.push("Otro aviso distinto que debe seguir visible sin sustituir al anterior.")
 await wait_process_frames(4)
 assert_false(stack.active[0].label.get_global_rect().intersects(stack.active[1].label.get_global_rect()))
 assert_lte(stack.column.size.x,get_viewport().get_visible_rect().size.x-48)

func test_world_and_level_share_the_same_stack_without_replacing_messages()->void:
 var world=load("res://src/Presentation/frontier_world.tscn").instantiate()
 add_child_autofree(world);await wait_process_frames(3)
 world._toasts.clear()
 world._toast("Primero");world._toast("Segundo")
 assert_eq(world._toasts.active.size(),2)
 assert_eq(world._toasts.active[0].text,"Primero")
 var level=load("res://src/Presentation/level_0.tscn").instantiate()
 add_child_autofree(level);await wait_process_frames(3)
 level.hud._toasts.clear()
 level.hud.flash_hint("Primero",1.8);level.hud.flash_hint("Segundo",1.8)
 assert_eq(level.hud._toasts.active.size(),2)
 assert_gte(level.hud._toasts.active[0].left,5.0)
