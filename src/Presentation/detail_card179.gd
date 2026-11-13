class_name DetailCard179
extends PanelContainer
## Shared reading surface for objectives, conversations and journal entries.
var heading:Label
var body:Label
var footer:Label
var progress:ProgressBar
static func style_panel(panel:Control)->void:
 var box:=RanchTheme.box(Color("10252dfa"),Color("8d794d"),14)
 box.content_margin_left=16;box.content_margin_right=16;box.content_margin_top=14;box.content_margin_bottom=14
 box.shadow_color=Color(0,0,0,.3);box.shadow_size=6;box.shadow_offset=Vector2(0,3)
 panel.add_theme_stylebox_override("panel",box)
static func style_body(label:Label,font:int=21)->void:
 label.add_theme_font_size_override("font_size",font)
 label.add_theme_color_override("font_color",RanchTheme.CREAM)
 label.add_theme_constant_override("line_spacing",5)
static func reading_surface(label:Label,translucent:bool=false)->void:
 style_body(label)
 var fill:=Color("1b3841");fill.a=.62 if translucent else 1.
 var box:=RanchTheme.box(fill,Color("45616a"),10)
 box.content_margin_left=14;box.content_margin_right=14;box.content_margin_top=12;box.content_margin_bottom=12
 label.add_theme_stylebox_override("normal",box)
func setup(title:String,text:String,status:String="",count:int=-1,goal:int=0,done:bool=false)->void:
 mouse_filter=Control.MOUSE_FILTER_PASS;size_flags_horizontal=Control.SIZE_EXPAND_FILL
 var box:=RanchTheme.box(Color("1b3841"),Color("45616a"),10)
 box.border_width_left=4;box.border_color=Color("80cdb8") if done else Color("bd9750")
 box.content_margin_left=14;box.content_margin_right=14;box.content_margin_top=12;box.content_margin_bottom=12
 add_theme_stylebox_override("panel",box)
 var column:=VBoxContainer.new();column.add_theme_constant_override("separation",8);add_child(column)
 heading=_label(title,22);heading.add_theme_color_override("font_color",Color("f7cf7c"));column.add_child(heading)
 body=_label(text,20);body.visible=not text.is_empty();column.add_child(body)
 if goal>0:
  var row:=HBoxContainer.new();row.add_theme_constant_override("separation",12);column.add_child(row)
  progress=ProgressBar.new();progress.max_value=goal;progress.value=count;progress.show_percentage=false;progress.custom_minimum_size=Vector2(0,10);progress.size_flags_horizontal=Control.SIZE_EXPAND_FILL;progress.size_flags_vertical=Control.SIZE_SHRINK_CENTER;progress.mouse_filter=Control.MOUSE_FILTER_IGNORE
  progress.add_theme_stylebox_override("background",RanchTheme.box(Color("0d252d"),Color.TRANSPARENT,5));progress.add_theme_stylebox_override("fill",RanchTheme.box(Color("80cdb8") if done else RanchTheme.GOLD,Color.TRANSPARENT,5));row.add_child(progress)
  var number:=_label("%d / %d"%[count,goal],20);row.add_child(number)
 footer=_label(status,18);footer.add_theme_color_override("font_color",Color("a9d8ca") if done else Color("bed0d0"));footer.visible=not status.is_empty();column.add_child(footer)
func _label(text:String,font:int)->Label:
 var label:=Label.new();label.text=text;label.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;label.size_flags_horizontal=Control.SIZE_EXPAND_FILL;label.mouse_filter=Control.MOUSE_FILTER_IGNORE;style_body(label,font);TextFit181.flow(label);return label
