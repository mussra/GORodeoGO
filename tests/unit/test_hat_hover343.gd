extends GutTest
## 3.0.43: al resaltar una opcion del desplegable, la vista previa combina esa opcion con las otras elegidas.
func test_pending_for_combines_color_finish_and_ink()->void:
	var panel:=HatPanel.new();add_child_autofree(panel)
	assert_eq(panel.pending_for343(0,0,0),"original")
	var with_finish:String=panel.pending_for343(3,5,2)
	assert_ne(with_finish,panel.pending_for343(4,5,2),"cambiar solo el color cambia el resultado")
	assert_ne(with_finish,panel.pending_for343(3,6,2),"cambiar solo el acabado cambia el resultado")
	assert_eq(panel.pending_for343(3,0,7),panel.pending_for343(3,0,1),"sin patron, el color del patron no cuenta")
func test_hovering_an_option_renders_it_and_closing_restores_the_selection()->void:
	var panel:=HatPanel.new();add_child_autofree(panel)
	var popup:PopupMenu=panel._color.get_popup()
	popup.id_focused.emit(2)
	assert_not_null(panel._preview)
	popup.popup_hide.emit()
	assert_eq(panel._pending,panel.pending_for343(panel._color.selected,panel._finish.selected,panel._ink.selected))
