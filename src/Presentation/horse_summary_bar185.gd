class_name HorseSummaryBar185
extends VBoxContainer
static func create(host:Node,h:Dictionary,width:float)->HorseSummaryBar185:
 var view:=HorseSummaryBar185.new();view.name="HorseSummary185_"+str(h.id);view.custom_minimum_size=Vector2(width,48);view.add_theme_constant_override("separation",2);host.add_child(view)
 var button:=Button.new();button.text="Promedio %d%%"%roundi(HorseSummary185.average(h));button.custom_minimum_size.y=28;button.add_theme_font_size_override("font_size",18);button.flat=true
 for state in ["normal","hover","pressed","focus"]:button.add_theme_stylebox_override(state,StyleBoxEmpty.new())
 TextFit181.button(button);button.tooltip_text=HorseSummary185.HELP;view.add_child(button)
 button.pressed.connect(func():
  var dialog:=AcceptDialog.new();dialog.title="Resumen de propiedades";dialog.dialog_text=HorseSummary185.HELP;dialog.dialog_autowrap=true;dialog.min_size=Vector2i(550,240);view.add_child(dialog);RanchTheme.style_dialog(dialog,true);dialog.confirmed.connect(dialog.queue_free);dialog.canceled.connect(dialog.queue_free);dialog.popup_centered())
 var bar:=ProgressBar.new();bar.name="AverageBar185";bar.min_value=0;bar.max_value=100;bar.step=0;bar.value=HorseSummary185.average(h);bar.show_percentage=false;bar.custom_minimum_size=Vector2(width,14);bar.mouse_filter=Control.MOUSE_FILTER_IGNORE
 bar.add_theme_stylebox_override("background",RanchTheme.box(Color("183b46"),Color("547b83"),5));bar.add_theme_stylebox_override("fill",RanchTheme.box(Color("d9b565"),Color("e6c47c"),5));view.add_child(bar);return view
