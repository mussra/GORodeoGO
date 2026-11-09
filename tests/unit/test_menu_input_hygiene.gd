extends GutTest
## Ant 9-nov-2026: en la colección, tocar FICHA disparó el diálogo del icono de
## salto; y el diálogo del icono de regate salía con el título "Salto de vallas".
## Estos tests fijan: títulos por skill, clicks simulados en FICHA/EQUIPAR de
## filas de arriba/medio/última, solapes de rect, clipping del scroll y la regla
## "oculto => deshabilitado/sin input".
var _state:Dictionary
var _debug:bool
var _panel:HorsePanel
var _sender:GutInputSender
var _window_size:Vector2i
var _locale:String

func before_each()->void:
 _window_size=get_tree().root.size
 _locale=TranslationServer.get_locale()
 TranslationServer.set_locale("es")
 _state=SaveData.horse_collection.export_state()
 _debug=SaveData.debug_mode
 SaveData.debug_mode=true
 SaveData.horse_collection.seed_trial()
 for i in range(4):SaveData.horse_collection.add_random_trial_pair()
 _panel=HorsePanel.new()
 get_tree().root.add_child(_panel)
 _neutralize_other_ui()
 _sender=GutInputSender.new(Input)
 _sender.set_auto_flush_input(true)
 await wait_process_frames(3)

func after_each()->void:
 _sender.release_all()
 if is_instance_valid(_panel):_panel.queue_free()
 SaveData.horse_collection.restore(_state)
 SaveData.debug_mode=_debug
 TranslationServer.set_locale(_locale)
 get_tree().root.size=_window_size

func _neutralize_other_ui()->void:
 for c in get_tree().root.get_children():
  if c!=_panel:_ignore_input(c)

func _ignore_input(node:Node)->void:
 if node is Control:node.mouse_filter=Control.MOUSE_FILTER_IGNORE
 for c in node.get_children():_ignore_input(c)

func _buttons_in(node:Node)->Array:
 var out:Array=[]
 for c in node.get_children():
  if c is Button:out.append(c)
  out.append_array(_buttons_in(c))
 return out

func _rows()->Array:
 var scroll:=_find_scroll(_panel)
 if scroll==null or scroll.get_child_count()==0:return []
 return scroll.get_child(0).get_children()

func _find_scroll(node:Node)->ScrollContainer:
 for c in node.get_children():
  if c is ScrollContainer:return c
  var r:=_find_scroll(c)
  if r!=null:return r
 return null

func _dialogs()->Array:
 return _find_dialogs(_panel)

func _find_dialogs(node:Node)->Array:
 var out:Array=[]
 for child in node.get_children():
  if child is AcceptDialog and child.visible:out.append(child)
  out.append_array(_find_dialogs(child))
 return out

func _click(control:Control)->void:
 var center:Vector2=get_tree().root.get_final_transform()*control.get_global_rect().get_center()
 _sender.mouse_left_button_down(center)
 await wait_process_frames(2)
 gut.p("click en %s | hovered: %s | ficha rect: %s"%[control.text,get_tree().root.gui_get_hovered_control(),control.get_global_rect()])
 _sender.mouse_left_button_up(center)
 await wait_process_frames(3)

func test_badge_dialog_title_matches_skill()->void:
 var jump:=JumpBadge.new();jump.capable=false;jump.skill="jump"
 add_child_autofree(jump);jump.show_explanation()
 var jd:AcceptDialog=jump.get_children().filter(func(c):return c is AcceptDialog)[0]
 assert_eq(jd.title,tr("JUMP_BADGE_TITLE"))
 assert_string_contains(jd.dialog_text,tr("JUMP_GROUNDED"))
 jd.hide();jd.queue_free()
 await wait_process_frames(2)
 var dodge:=JumpBadge.new();dodge.capable=false;dodge.skill="dodge"
 add_child_autofree(dodge);dodge.show_explanation()
 var dd:AcceptDialog=dodge.get_children().filter(func(c):return c is AcceptDialog)[0]
 assert_eq(dd.title,tr("DODGE_BADGE_TITLE"),"el icono de regate debe titularse Regate, no Salto de vallas")
 assert_string_contains(dd.dialog_text,tr("DODGE_GROUNDED"))

func test_ficha_click_top_middle_last_opens_detail()->void:
 var rows:=_rows()
 assert_gt(rows.size(),3,"hay 9 caballos sembrados")
 var scroll:=_find_scroll(_panel)
 for row in rows:
  var ficha:Button=null
  for b in _buttons_in(row):
   if b.text==tr("FICHA"):ficha=b
  assert_not_null(ficha)
 # fila de arriba, del medio y la última (con scroll al fondo para la última)
 var indices:Array=[0,rows.size()/2,rows.size()-1]
 for idx in indices:
  scroll=_find_scroll(_panel)
  var row:Control=_rows()[idx]
  scroll.ensure_control_visible(row)
  await wait_process_frames(3)
  var ficha:Button=null
  for b in _buttons_in(row):
   if b.text==tr("FICHA"):ficha=b
  await _click(ficha)
  assert_eq(_panel.page,"detail","FICHA de la fila %d abre la ficha"%idx)
  assert_eq(_dialogs().size(),0)
  _panel.show_page("collection")
  await wait_process_frames(3)

func test_equipar_click_selects_horse()->void:
 var rows:=_rows()
 var eq:Button=null
 for b in _buttons_in(rows[1]):
  if b.text==tr("UI_059") or b.text==tr("UI_060"):eq=b
 assert_not_null(eq)
 var target:String=SaveData.horse_collection.horses[1].id
 await _click(eq)
 assert_eq(SaveData.horse_collection.selected,target,"EQUIPAR selecciona ese caballo")
 assert_eq(_dialogs().size(),0,"EQUIPAR no abre diálogos de iconos")

func test_row_controls_do_not_overlap()->void:
 for row in _rows():
  var bs:=_buttons_in(row)
  for i in bs.size():
   for j in range(i+1,bs.size()):
    var a:Rect2=bs[i].get_global_rect();var b:Rect2=bs[j].get_global_rect()
    assert_false(a.intersects(b),"botones de fila solapados: %s y %s"%[bs[i].text,bs[j].text])

func test_scroll_clips_input_to_its_rect()->void:
 var scroll:=_find_scroll(_panel)
 assert_not_null(scroll)
 assert_true(scroll.clip_contents,"el scroll recorta lo dibujado")
 scroll.scroll_vertical=2147483647
 await wait_process_frames(2)
 # La primera fila queda fuera (arriba) del área visible: un clic donde está su
 # FICHA no debe alcanzarla.
 var first_ficha:Button=null
 for b in _buttons_in(_rows()[0]):
  if b.text==tr("FICHA"):first_ficha=b
 assert_not_null(first_ficha)
 var r:Rect2=first_ficha.get_global_rect()
 if r.intersects(scroll.get_global_rect()):pass_test("la fila sigue visible; nada que comprobar");return
 _sender.mouse_left_button_down(r.get_center())
 await wait_process_frames(2)
 _sender.mouse_left_button_up(r.get_center())
 await wait_process_frames(3)
 assert_eq(_panel.page,"collection","un clic fuera del área del scroll no abre la ficha")
 assert_eq(_dialogs().size(),0)

func test_hidden_controls_take_no_input()->void:
 var bad:Array=[]
 _audit(_panel,bad)
 assert_eq(bad.size(),0,"controles ocultos con input activo: %s"%[", ".join(bad)])

func _audit(node:Node,bad:Array)->void:
 for c in node.get_children():
  if c is Control and not c.visible and c.mouse_filter!=Control.MOUSE_FILTER_IGNORE:
   bad.append("%s(%s)"%[c.get_class(),c.name])
  _audit(c,bad)

func test_mobile_ratio_mouse_and_touch_top_middle_last()->void:
 for dimensions in [Vector2i(1600,720),Vector2i(960,540)]:
  get_tree().root.size=dimensions
  await wait_process_frames(3)
  for idx in [0,4,8]:
   var scroll:=_find_scroll(_panel)
   var row:Control=_rows()[idx];scroll.ensure_control_visible(row)
   await wait_process_frames(3)
   var buttons:=_buttons_in(row)
   var ficha:Button=buttons[-1]
   var expected:String=SaveData.horse_collection.horses[idx].id
   # ScreenTouch follows the same Android-to-mouse emulation as the device.
   var center:Vector2=get_tree().root.get_final_transform()*ficha.get_global_rect().get_center()
   var touch:=InputEventScreenTouch.new();touch.index=0;touch.position=center;touch.pressed=true
   Input.parse_input_event(touch);Input.flush_buffered_events()
   await wait_process_frames(2)
   touch=touch.duplicate();touch.pressed=false
   Input.parse_input_event(touch);Input.flush_buffered_events()
   await wait_process_frames(3)
   assert_eq(_panel.page,"detail","toque Android FICHA %d en %s"%[idx,dimensions])
   assert_eq(_panel.focus_id,expected)
   assert_eq(_dialogs().size(),0)
   _panel.show_page("collection");await wait_process_frames(3)
   scroll=_find_scroll(_panel);row=_rows()[idx];scroll.ensure_control_visible(row)
   await wait_process_frames(3)
   buttons=_buttons_in(row)
   var eq:Button=buttons[-2]
   if not eq.disabled:await _click(eq)
   assert_eq(SaveData.horse_collection.selected,expected)
   assert_eq(_dialogs().size(),0)

func test_hidden_and_clipped_controls_are_disabled()->void:
 SaveData.debug_mode=false
 _panel.show_page("collection");await wait_process_frames(3)
 var scroll:=_find_scroll(_panel)
 scroll.scroll_vertical=2147483647;await wait_process_frames(3)
 for b in _buttons_in(_rows()[0]):
  assert_true(b.disabled)
  assert_eq(b.mouse_filter,Control.MOUSE_FILTER_IGNORE)
 _panel.hide();await wait_process_frames(3)
 for b in _buttons_in(_panel):
  assert_true(b.disabled)
  assert_eq(b.mouse_filter,Control.MOUSE_FILTER_IGNORE)
 _panel.show();await wait_process_frames(3)
 scroll.ensure_control_visible(_rows()[-1]);await wait_process_frames(3)
 assert_false(_buttons_in(_rows()[-1])[-1].disabled)

func test_modal_panel_blocks_background_and_restores_it()->void:
 var training:=TrainingPanel.new();_panel.add_child(training)
 await wait_process_frames(4)
 for b in _buttons_in(_panel.content):assert_true(b.disabled)
 training.queue_free();await wait_process_frames(4)
 var scroll:=_find_scroll(_panel);scroll.ensure_control_visible(_rows()[0]);await wait_process_frames(3)
 assert_false(_buttons_in(_rows()[0])[-1].disabled)

func test_genealogy_focus_fits_and_restores_positions_scroll()->void:
 var c:=SaveData.horse_collection
 var kid:Dictionary=c.breed(c.horses[0].id,c.horses[8].id,{"coat":0,"pattern":0,"mane":0,"eyes":0})
 var graph:=GenealogyPanel.new();_panel.add_child(graph)
 await wait_process_frames(4)
 graph.view.scroll_horizontal=400;graph.view.scroll_vertical=90
 var old:=Vector2(graph.view.scroll_horizontal,graph.view.scroll_vertical)
 var original:=graph.display_positions.duplicate()
 graph.select(kid.id)
 await wait_seconds(0.5)
 for id in graph.relation_nodes:
  var rect:Rect2=graph.card_nodes[id].get_global_rect()
  var area:Rect2=graph.view.get_global_rect()
  assert_true(area.encloses(rect),"tarjeta %s dentro del mapa"%id)
 assert_eq(graph.view.scroll_horizontal,0)
 assert_eq(graph.view.scroll_vertical,0)
 graph.select(kid.id)
 await wait_seconds(0.5)
 assert_eq(graph.display_positions,original)
 assert_eq(Vector2(graph.view.scroll_horizontal,graph.view.scroll_vertical),old)
 graph.queue_free()

func test_audit_all_menu_pages_and_overlay_panels()->void:
 for page in ["collection","breed","atlas","market","detail"]:
  _panel.focus_id=SaveData.horse_collection.horses[0].id
  _panel.show_page(page);await wait_process_frames(4)
  _panel.hide();await wait_process_frames(3)
  for b in _buttons_in(_panel):
   assert_true(b.disabled,"oculto: %s / %s"%[page,b.text])
   assert_eq(b.mouse_filter,Control.MOUSE_FILTER_IGNORE)
  _panel.show();await wait_process_frames(3)
 for type in [TrainingPanel,GenealogyPanel,EmblemPanel,EquipmentPanel,HatPanel,load("res://src/Presentation/trial_panel.gd")]:
  var overlay:Control=type.new();_panel.add_child(overlay);await wait_process_frames(4)
  for b in _buttons_in(_panel.content):assert_true(b.disabled,"panel de fondo bloqueado")
  overlay.hide();await wait_process_frames(3)
  for b in _buttons_in(overlay):
   assert_true(b.disabled)
   assert_eq(b.mouse_filter,Control.MOUSE_FILTER_IGNORE)
  overlay.queue_free();await wait_process_frames(3)

func test_popup_blocks_background_and_ok_remains_enabled()->void:
 var scroll:=_find_scroll(_panel);scroll.scroll_vertical=2147483647;await wait_process_frames(3)
 var badge:JumpBadge=_buttons_in(_rows()[-1])[0]
 badge.show_explanation();await wait_process_frames(4)
 var dialog:AcceptDialog=badge.get_children().filter(func(c):return c is AcceptDialog)[0]
 assert_false(dialog.get_ok_button().disabled,"OK debe funcionar incluso si el icono está dentro de scroll")
 for b in _buttons_in(_rows()[-1]):assert_true(b.disabled)
 var page_before:String=_panel.page
 var ficha:Button=_buttons_in(_rows()[-1])[-1]
 await _click(ficha)
 assert_eq(_panel.page,page_before,"clic no atraviesa el popup")
 dialog.hide();dialog.queue_free();await wait_process_frames(4)
 assert_false(ficha.disabled)

func test_action_titles_have_distinct_es_and_en_translations()->void:
 for locale in ["es","en"]:
  TranslationServer.set_locale(locale)
  assert_ne(tr("JUMP_BADGE_TITLE"),tr("DODGE_BADGE_TITLE"))
  assert_ne(tr("DODGE_BADGE_TITLE"),"DODGE_BADGE_TITLE")
