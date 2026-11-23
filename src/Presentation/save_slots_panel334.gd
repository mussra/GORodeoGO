class_name SaveSlotsPanel334
extends Control
signal closed
var message:String=''
var list:VBoxContainer
func _ready():
 set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);z_index=150;mouse_filter=Control.MOUSE_FILTER_STOP
 var bg=ColorRect.new();bg.color=Color('102b31');bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(bg)
 var margin=MarginContainer.new();margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 for side in ['left','right','top','bottom']:margin.add_theme_constant_override('margin_'+side,28)
 add_child(margin);var column=VBoxContainer.new();column.add_theme_constant_override('separation',12);margin.add_child(column)
 var title=Label.new();title.text='PARTIDAS · '+('DEBUG' if SaveData.debug_mode else 'NORMAL');title.add_theme_font_size_override('font_size',28);column.add_child(title)
 var bar=HBoxContainer.new();column.add_child(bar)
 var available:bool=SaveData.slots334!=null and not SaveData.slots334.state.is_empty()
 var create_button=button(bar,'Nueva partida',func():name_dialog('','Nueva partida'));create_button.disabled=not available
 var save_button=button(bar,'Guardar actual',func():message='Partida guardada.' if SaveData.slots334.save_current(SaveData) else SaveData.slots334.error;rebuild());save_button.disabled=not available
 button(bar,'Volver',func():closed.emit();queue_free())
 var scroll=ScrollContainer.new();scroll.size_flags_vertical=Control.SIZE_EXPAND_FILL;column.add_child(scroll);list=VBoxContainer.new();list.size_flags_horizontal=Control.SIZE_EXPAND_FILL;list.add_theme_constant_override('separation',12);scroll.add_child(list);rebuild()
func button(parent:Node,text_:String,fn:Callable)->Button:
 var b=Button.new();b.text=text_;b.custom_minimum_size=Vector2(230 if text_=='Cambiar nombre' else 190,52);QuestButtonStyle.apply(b);parent.add_child(b);b.pressed.connect(fn);return b
func rebuild():
 for child in list.get_children():child.queue_free()
 var info=Label.new();info.text=message if not message.is_empty() else 'Cada partida conserva su progreso. No hay botón de borrar.';info.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;list.add_child(info)
 if SaveData.slots334==null or SaveData.slots334.state.is_empty():info.text='Catálogo protegido. No se modificarán las partidas.';return
 for row in SaveData.slots334.state.rows:
  if row.debug!=SaveData.debug_mode:continue
  var card=PanelContainer.new();list.add_child(card);var h=HBoxContainer.new();h.add_theme_constant_override('separation',18);card.add_child(h)
  var preview=TextureRect.new();preview.custom_minimum_size=Vector2(240,135);preview.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;preview.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;h.add_child(preview)
  if not row.thumbnail.is_empty() and FileAccess.file_exists(row.thumbnail):
   var image=Image.load_from_file(row.thumbnail)
   if image!=null:preview.texture=ImageTexture.create_from_image(image)
  else:
   var placeholder=Label.new();placeholder.text='Sin captura todavía\nEntra en Frontera y guarda.';placeholder.position=Vector2(12,42);preview.add_child(placeholder)
  var details=VBoxContainer.new();details.size_flags_horizontal=Control.SIZE_EXPAND_FILL;h.add_child(details)
  var title=Label.new();title.text=row.name+(' · ACTIVA' if row.path==SaveData.save_path else '');title.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;title.add_theme_font_size_override('font_size',23);details.add_child(title)
  var date=Label.new();date.text='Guardado: '+Time.get_datetime_string_from_unix_time(row.saved_at).replace('T',' ')+' UTC' if row.saved_at>0 else 'Partida existente · sin fecha registrada';details.add_child(date)
  var actions=HBoxContainer.new();details.add_child(actions)
  button(actions,'Continuar',func():
   if SaveData.slots334.select(row.id,SaveData):get_tree().reload_current_scene()
   else:message=SaveData.slots334.error;rebuild())
  button(actions,'Cambiar nombre',func():name_dialog(row.id,row.name))
func name_dialog(id:String,initial:String):
 var dialog=ConfirmationDialog.new();dialog.title='Nueva partida' if id.is_empty() else 'Nombre de la partida';dialog.min_size=Vector2i(650,180);add_child(dialog)
 var field=LineEdit.new();field.text='' if id.is_empty() else initial;field.placeholder_text='Nombre de la partida';field.max_length=48;field.custom_minimum_size=Vector2(600,60);dialog.add_child(field)
 dialog.confirmed.connect(func():
  var ok=SaveData.slots334.create(field.text,SaveData) if id.is_empty() else SaveData.slots334.rename(id,field.text)
  if ok and id.is_empty():get_tree().reload_current_scene()
  else:message='Nombre guardado.' if ok else SaveData.slots334.error;rebuild())
 dialog.popup_centered();field.grab_focus()
