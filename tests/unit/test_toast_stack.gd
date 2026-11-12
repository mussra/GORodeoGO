extends GutTest
func test_duration_bounded_for_gameplay_and_honors_explicit_minimum()->void:
 assert_gte(ToastStack.reading_seconds("Hola"),3.0)
 assert_lte(ToastStack.reading_seconds("Mensaje largo ".repeat(30)),7.0)
 assert_gte(ToastStack.reading_seconds("Hola",20),20.0)
func test_single_notice_and_fifo_preserve_each_reading_time()->void:
 var stack:=ToastStack.new();add_child_autofree(stack);stack.set_process(false)
 for i in 5:stack.push("Aviso "+["A","B","C","D","E"][i])
 assert_eq(stack.active.size(),1);assert_eq(stack.pending.size(),4)
 for i in 5:
  assert_eq(stack.active[0].text,"Aviso "+["A","B","C","D","E"][i])
  assert_gte(stack.active[0].left,3.0)
  stack.advance(20)
 assert_eq(stack.active.size(),0);assert_eq(stack.pending.size(),0)
func test_repeat_does_not_erase_other_queued_messages()->void:
 var stack:=ToastStack.new();add_child_autofree(stack);stack.set_process(false)
 stack.push("A");stack.push("B");stack.advance(1);stack.push("A")
 assert_eq(stack.active.size(),1);assert_eq(stack.pending.size(),1)
 assert_eq(stack.pending[0].text,"B");assert_gte(stack.active[0].left,3.0)
 stack.clear();assert_eq(stack.active.size(),0);assert_eq(stack.pending.size(),0)
func test_long_message_is_narrow_translucent_and_leaves_center_right_clear()->void:
 var stack:=ToastStack.new();add_child_autofree(stack);stack.set_process(false)
 stack.push("No se fía de nuestro caballo. Tendremos que buscar uno que se le parezca.")
 stack.push("Un caballo de pelaje y crin parecidos ganará su confianza... o un Líder de manada.")
 await wait_process_frames(4)
 assert_eq(stack.active.size(),1)
 var label:Label=stack.active[0].label
 assert_eq(label.mouse_filter,Control.MOUSE_FILTER_IGNORE)
 assert_lte(label.get_global_rect().end.x,get_viewport().get_visible_rect().size.x*.5)
 assert_lte(label.get_global_rect().size.y,100.0)
 assert_lt((label.get_theme_stylebox("normal") as StyleBoxFlat).bg_color.a,.65)
func test_world_and_level_share_the_single_notice_queue()->void:
 var world=load("res://src/Presentation/frontier_world.tscn").instantiate();add_child_autofree(world);await wait_process_frames(3)
 world._toasts.clear();world._toast("Primero");world._toast("Segundo")
 assert_eq(world._toasts.active.size(),1);assert_eq(world._toasts.pending.size(),1)
 assert_eq(world._toasts.active[0].text,"Primero")
 var level=load("res://src/Presentation/level_0.tscn").instantiate();add_child_autofree(level);await wait_process_frames(3)
 level.hud._toasts.clear();level.hud.flash_hint("Primero",1.8);level.hud.flash_hint("Segundo",1.8)
 assert_eq(level.hud._toasts.active.size(),1);assert_eq(level.hud._toasts.pending.size(),1)
 assert_gte(level.hud._toasts.active[0].left,3.0)

func test_new_count_replaces_visible_notice_immediately_and_resets_fade()->void:
 var stack:=ToastStack.new();add_child_autofree(stack);stack.set_process(false)
 stack.push("Flor recogida · 1/3");stack.advance(2.9);stack.push("Flor recogida · 2/3");stack.push("Flor recogida · 3/3")
 assert_eq(stack.active.size(),1);assert_eq(stack.pending.size(),0)
 assert_eq(stack.active[0].text,"Flor recogida · 3/3");assert_eq(stack.active[0].label.text,"Flor recogida · 3/3")
 assert_gte(stack.active[0].left,3.);assert_eq(stack.active[0].label.modulate.a,1.)
func test_pending_state_replaced_without_losing_unrelated_notices()->void:
 var stack:=ToastStack.new();add_child_autofree(stack);stack.set_process(false)
 stack.push("Otro aviso");stack.push("Capturas: 1 · puntos: 20");stack.push("Guardar falló");stack.push("Capturas: 2 · puntos: 40")
 assert_eq(stack.pending.size(),2);assert_eq(stack.pending[0].text,"Capturas: 2 · puntos: 40")
 stack.advance(20);assert_eq(stack.active[0].text,"Capturas: 2 · puntos: 40")
 stack.advance(20);assert_eq(stack.active[0].text,"Guardar falló")
func test_explicit_type_replaces_changed_wording_and_keeps_other_quests()->void:
 var stack:=ToastStack.new();add_child_autofree(stack);stack.set_process(false)
 stack.push("Recoge flores",0.,"quest:blue");stack.push("Captura cabras",0.,"quest:goat")
 stack.push("Azules · 3/3",0.,"quest:blue")
 assert_eq(stack.active[0].text,"Azules · 3/3");assert_eq(stack.pending[0].text,"Captura cabras")
