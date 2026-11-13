class_name MapNotesList162
extends Control
## Shared view only. Note persistence and map navigation stay in their owners.
signal selected(note:Dictionary)
signal travel170(note:Dictionary)
signal closed
var notes:Dictionary={}
var canvas:Control
var rows:VBoxContainer
func _ready()->void:
 set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);z_index=180;mouse_filter=Control.MOUSE_FILTER_STOP;MenuInputGuard.install(self)
 var background:=ColorRect.new();background.color=Color("10252d");background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(background)
 canvas=Control.new();canvas.size=Vector2(1280,720);add_child(canvas);resized.connect(layout);layout()
 var title:=Label.new();title.text="NOTAS DEL MAPA";title.position=Vector2(44,26);title.add_theme_font_size_override("font_size",30);canvas.add_child(title)
 var back:=Button.new();back.name="CloseNotes162";back.text="Volver al mapa";back.position=Vector2(980,20);back.size=Vector2(256,56);QuestButtonStyle.apply(back);back.pressed.connect(func():closed.emit());canvas.add_child(back)
 var hint:=Label.new();hint.text="Toca una nota para centrar su marcador. No mueve al caballo.";hint.position=Vector2(44,85);hint.add_theme_font_size_override("font_size",20);canvas.add_child(hint)
 var scroll:=ScrollContainer.new();scroll.position=Vector2(44,125);scroll.size=Vector2(1192,552);scroll.horizontal_scroll_mode=ScrollContainer.SCROLL_MODE_DISABLED;canvas.add_child(scroll)
 rows=VBoxContainer.new();rows.size_flags_horizontal=Control.SIZE_EXPAND_FILL;rows.add_theme_constant_override("separation",12);scroll.add_child(rows)
 var entries:=WorldNotes106.list162(notes)
 if entries.is_empty():
  var empty:=Label.new();empty.text="Todavía no hay notas en este mundo.\nVuelve al mapa y mantén pulsado un punto para añadir una.";empty.add_theme_font_size_override("font_size",24);rows.add_child(empty)
 for note in entries:
  var button:=Button.new();button.name="Note162_"+str(rows.get_child_count());button.custom_minimum_size=Vector2(1140,126);button.size_flags_horizontal=Control.SIZE_EXPAND_FILL;QuestButtonStyle.apply(button);rows.add_child(button)
  var preview:=TextureRect.new();preview.position=Vector2(14,12);preview.size=Vector2(190,102);preview.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;preview.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;preview.mouse_filter=Control.MOUSE_FILTER_STOP;button.add_child(preview)
  var path:String=str(note.get("photo",""))
  if path.begins_with("user://map-photos/") and FileAccess.file_exists(path):
   var image:=Image.load_from_file(path)
   if image!=null:
    preview.texture=ImageTexture.create_from_image(image)
    preview.gui_input.connect(func(event:InputEvent):
     if (event is InputEventMouseButton and event.button_index==MOUSE_BUTTON_LEFT and event.pressed) or (event is InputEventScreenTouch and event.pressed):MapPhotoViewer171.open(self,image);preview.accept_event())
  if preview.texture==null:
   var blank:=Label.new();blank.text="Sin foto";blank.position=Vector2(48,43);blank.add_theme_color_override("font_color",Color("342313"));blank.mouse_filter=Control.MOUSE_FILTER_IGNORE;button.add_child(blank)
  var text:=Label.new();text.position=Vector2(224,12);text.size=Vector2(610,68);text.text=str(note.text) if not str(note.text).strip_edges().is_empty() else "Nota sin texto";text.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;text.max_lines_visible=2;text.text_overrun_behavior=TextServer.OVERRUN_TRIM_ELLIPSIS;text.add_theme_font_size_override("font_size",23);text.add_theme_color_override("font_color",Color("342313"));text.mouse_filter=Control.MOUSE_FILTER_IGNORE;button.add_child(text)
  var date:=Label.new();date.position=Vector2(224,89);date.text=WorldNotes106.date162(note);date.add_theme_font_size_override("font_size",18);date.add_theme_color_override("font_color",Color("342313"));date.mouse_filter=Control.MOUSE_FILTER_IGNORE;button.add_child(date)
  var travel:=Button.new();travel.text="Ir a esta nota";travel.position=Vector2(870,34);travel.size=Vector2(250,55);QuestButtonStyle.apply(travel);button.add_child(travel)
  travel.pressed.connect(func():travel170.emit(note))
  button.pressed.connect(func():selected.emit(note))
func layout()->void:
 var k:float=minf(size.x/1280.,size.y/720.);canvas.scale=Vector2.ONE*k;canvas.position=(size-Vector2(1280,720)*k)/2.
func _unhandled_input(event:InputEvent)->void:
 if event.is_action_pressed("ui_cancel"):closed.emit();get_viewport().set_input_as_handled()
