extends Node
func _ready():run.call_deferred()
func shot(name_:String):
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/qa256-"+name_+".png")
func run():
 get_tree().root.size=Vector2i(1600,720);TranslationServer.set_locale("es");GameState.brand_intro_played=true;GameState.sound_enabled=false
 SaveData.save_path="user://qa256scratch.cfg";SaveData.horse_collection.seed_trial()
 var book:=BreedingBook256.new();add_child(book);await get_tree().create_timer(.4).timeout;await shot("cover")
 for i in 6:
  book.show_page(i);await get_tree().create_timer(.12).timeout;await shot("page%d"%i)
 book.finish();await get_tree().process_frame
 var menu=load("res://src/Presentation/main_menu.tscn").instantiate();add_child(menu);await get_tree().create_timer(.6).timeout;await shot("menu")
 menu._book256.pressed.emit();await get_tree().create_timer(.2).timeout;await shot("menu-open")
 print("MENU_BOOK_OPEN ",menu.get_children().any(func(c):return c is BreedingBook256))
 menu.free();await get_tree().process_frame
 var room:=SaddleryRoom256.new();add_child(room);await get_tree().create_timer(.3).timeout;await shot("workshop")
 room.open_equipment();await get_tree().create_timer(.2).timeout;await shot("equipment");room.free()
 get_tree().quit()
