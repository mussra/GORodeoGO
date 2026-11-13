class_name MapNoteDialog106
extends Panel
signal saved(text:String,photo:bool)
signal deleted
signal closed
var note:Dictionary
var entry:TextEdit
var photo_box:CheckBox
func setup(existing:Dictionary,horse_text:String):
 note=existing;position=Vector2(270,110);size=Vector2(740,510);clip_contents=true;z_index=150;mouse_filter=Control.MOUSE_FILTER_STOP
 add_theme_stylebox_override("panel",RanchTheme.box(Color("10252d"),Color("e8b64e"),12))
 var title=Label.new();title.text="Nota del mapa · "+("Caballo" if not horse_text.is_empty() else "Lugar");title.position=Vector2(24,18);title.add_theme_font_size_override("font_size",26);add_child(title)
 entry=TextEdit.new();entry.position=Vector2(24,65);entry.size=Vector2(690,105);entry.text=str(existing.get("text",horse_text));entry.placeholder_text="Ej.: caballo rojo con crin arcoíris";entry.add_theme_font_size_override("font_size",22);add_child(entry)
 photo_box=CheckBox.new();photo_box.text="Guardar foto local de la vista del mundo";photo_box.position=Vector2(24,183);photo_box.size=Vector2(690,45);add_child(photo_box)
 var info=Label.new();info.text="La nota no congela al caballo ni cambia su posición.\nMáximo 240 caracteres por nota.";info.position=Vector2(24,235);info.add_theme_font_size_override("font_size",18);add_child(info)
 var photo_path:String=str(existing.get("photo",""))
 if photo_path.begins_with("user://map-photos/") and FileAccess.file_exists(photo_path):
  var image:Image=Image.load_from_file(photo_path)
  if image!=null:
   image.resize(250,113,Image.INTERPOLATE_LANCZOS)
   var preview=TextureRect.new();preview.texture=ImageTexture.create_from_image(image);preview.position=Vector2(24,290);preview.size=Vector2(250,130);preview.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;preview.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;add_child(preview)
 var actions=HBoxContainer.new();actions.position=Vector2(24,430);actions.size=Vector2(690,62);add_child(actions)
 for label in ["Guardar","Eliminar","Cerrar"]:
  var button=Button.new();button.text=label;button.custom_minimum_size=Vector2(220,56);QuestButtonStyle.apply(button);actions.add_child(button)
  if label=="Guardar":button.pressed.connect(func():saved.emit(entry.text.left(240),photo_box.button_pressed))
  elif label=="Eliminar":button.disabled=existing.is_empty();button.pressed.connect(func():deleted.emit())
  else:button.pressed.connect(func():closed.emit())
