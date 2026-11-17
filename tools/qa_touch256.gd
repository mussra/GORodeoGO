extends Node
func _ready():run.call_deferred()
func tap(button:Button):
 var p:Vector2=button.get_global_rect().get_center()
 for down in [true,false]:
  var e:=InputEventScreenTouch.new();e.position=get_viewport().get_final_transform()*p;e.index=0;e.pressed=down;Input.parse_input_event(e);Input.flush_buffered_events()
  await get_tree().process_frame
 await get_tree().create_timer(.1).timeout
func find_button(root:Node,text_:String)->Button:
 for c in root.get_children():
  if c is Button:
   if c.text==text_:return c
   for child in c.get_children():
    if child is Label and child.text==text_:return c
  var b:=find_button(c,text_)
  if b!=null:return b
 return null
func run():
 get_tree().root.size=Vector2i(1600,720);TranslationServer.set_locale("es");GameState.sound_enabled=false
 SaveData.save_path="user://qa256touch.cfg";SaveData.horse_collection.seed_trial()
 var book:=BreedingBook256.new();add_child(book);await get_tree().create_timer(.2).timeout
 await tap(find_button(book,"Aprender con Alma"));assert(book.tutorial and book.page==0);print("TOUCH_START true")
 for i in 5:
  await tap(find_button(book,"Siguiente"));assert(book.page==i+1)
 print("TOUCH_SIX_STEPS true")
 await tap(find_button(book,"Volver a portada"));assert(book.page==-1)
 await tap(find_button(book,"Ahora no"));assert(not is_instance_valid(book));print("TOUCH_CLOSE true")
 var room:=SaddleryRoom256.new();add_child(room);await get_tree().create_timer(.2).timeout
 await tap(find_button(room,"Hablar y ver equipo"));assert(is_instance_valid(room.equipment) and room.equipment.visible);print("TOUCH_CATALOG true")
 await tap(find_button(room.equipment,"Volver"));assert(not room.equipment.visible);await get_tree().create_timer(.2).timeout;await tap(find_button(room,"Salir al rancho"));assert(not is_instance_valid(room));print("TOUCH_EXIT true")
 get_tree().quit()
