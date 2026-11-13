class_name MapNoteDialog106
extends Panel
signal saved(text:String,photo:bool)
signal deleted
signal closed
var note:Dictionary
var entry:TextEdit
var photo_box:CheckBox
var photo_preview:TextureRect
var photo_status:Label
var captured_photo:Image
var stored_photo:Image
func setup(existing:Dictionary,horse_text:String,capture:Image=null):
 captured_photo=capture
 note=existing;position=Vector2(270,110);size=Vector2(740,510);clip_contents=true;z_index=150;mouse_filter=Control.MOUSE_FILTER_STOP
 add_theme_stylebox_override("panel",RanchTheme.box(Color("10252d"),Color("e8b64e"),12))
 var title=Label.new();title.text="Nota del mapa · "+("Caballo" if not horse_text.is_empty() else "Lugar");title.position=Vector2(24,18);title.add_theme_font_size_override("font_size",26);add_child(title)
 entry=TextEdit.new();entry.position=Vector2(24,65);entry.size=Vector2(690,105);entry.text=str(existing.get("text",horse_text));entry.placeholder_text="Ej.: caballo rojo con crin arcoíris";entry.add_theme_font_size_override("font_size",22);add_child(entry)
 photo_box=CheckBox.new();photo_box.text="Adjuntar captura de pantalla";photo_box.position=Vector2(24,183);photo_box.size=Vector2(690,50);QuestButtonStyle.apply(photo_box);photo_box.add_theme_stylebox_override("hover_pressed",photo_box.get_theme_stylebox("pressed"));photo_box.add_theme_color_override("font_hover_pressed_color",Color("342313"));photo_box.add_theme_constant_override("h_separation",16);photo_box.add_theme_icon_override("unchecked",photo_icon160(false));photo_box.add_theme_icon_override("checked",photo_icon160(true));add_child(photo_box)
 var info=Label.new();info.text="La nota no congela al caballo ni cambia su posición.\nMáximo 240 caracteres por nota.";info.position=Vector2(24,235);info.add_theme_font_size_override("font_size",18);add_child(info)
 var photo_path:String=str(existing.get("photo",""))
 if photo_path.begins_with("user://map-photos/") and FileAccess.file_exists(photo_path):stored_photo=Image.load_from_file(photo_path)
 photo_preview=TextureRect.new();photo_preview.position=Vector2(24,290);photo_preview.size=Vector2(250,130);photo_preview.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;photo_preview.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;photo_preview.mouse_filter=Control.MOUSE_FILTER_IGNORE;add_child(photo_preview)
 photo_status=Label.new();photo_status.position=Vector2(294,290);photo_status.size=Vector2(396,130);photo_status.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;photo_status.add_theme_font_size_override("font_size",18);add_child(photo_status)
 photo_box.toggled.connect(func(_on:bool):refresh_photo160());refresh_photo160()
 var actions=HBoxContainer.new();actions.position=Vector2(24,430);actions.size=Vector2(690,62);add_child(actions)
 for label in ["Guardar","Eliminar","Cerrar"]:
  var button=Button.new();button.text=label;button.custom_minimum_size=Vector2(220,56);QuestButtonStyle.apply(button);actions.add_child(button)
  if label=="Guardar":button.pressed.connect(func():saved.emit(entry.text.left(240),photo_box.button_pressed))
  elif label=="Eliminar":button.disabled=existing.is_empty();button.pressed.connect(func():deleted.emit())
  else:button.pressed.connect(func():closed.emit())

func refresh_photo160()->void:
 var image:Image=captured_photo if photo_box.button_pressed else stored_photo
 photo_box.text="Captura activada · se adjuntará al guardar" if photo_box.button_pressed else "Adjuntar captura de pantalla"
 photo_preview.visible=image!=null
 if image!=null:
  var small:Image=image.duplicate();small.resize(250,113,Image.INTERPOLATE_LANCZOS);photo_preview.texture=ImageTexture.create_from_image(small)
 photo_status.text=("Esta captura se adjuntará cuando pulses Guardar." if captured_photo!=null else "No hay captura disponible. Cierra el mapa y vuelve a abrirlo.") if photo_box.button_pressed else ("Foto ya guardada. Se conserva si no activas otra captura." if stored_photo!=null else "Toca el recuadro amarillo de arriba para añadir la vista del mundo anterior al mapa. Después pulsa Guardar.")
func photo_icon160(checked:bool)->Texture2D:
 var image:=Image.create(36,36,false,Image.FORMAT_RGBA8)
 for x in 36:
  for y in 36:
   var border:bool=x<4 or y<4 or x>=32 or y>=32
   var tick:bool=checked and (Vector2(x,y).distance_to(Geometry2D.get_closest_point_to_segment(Vector2(x,y),Vector2(8,18),Vector2(15,25)))<2.4 or Vector2(x,y).distance_to(Geometry2D.get_closest_point_to_segment(Vector2(x,y),Vector2(15,25),Vector2(28,10)))<2.4)
   image.set_pixel(x,y,Color("342313") if tick else Color("efb950") if border or checked else Color("10252d"))
 return ImageTexture.create_from_image(image)
