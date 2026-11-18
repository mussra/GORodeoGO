extends GutTest
func test_all_navigation_titles_get_same_art_tiles_back_and_reused_icons():
 for title_ in ['FRONTERA','FRONTERA · DEBUG','JUEGOS']:
  var p:=NavigationSheet.new();p.title=title_;p.entries=[{'id':'book256','title':'Libro de crianza','hint':'Alma'},{'id':'crowns240','title':'Coronas','hint':'Registro'},{'id':'debug213','title':'DEBUG','hint':'Herramientas'},{'id':'performance245','title':'Rendimiento','hint':'OSD'}];add_child(p);await wait_process_frames(6)
  assert_eq(p.get_meta('background300'),'content')
  var bg=p.get_node('SharedMenuAmbience');assert_true(bg is MenuBackdrop);assert_eq(bg.art_mode300,'content')
  var back=p.canvas.get_node('NavigationBack');assert_true(back.get_theme_stylebox('normal') is StyleBoxTexture);assert_not_null(back.icon)
  for entry in p.entries:
   var card=p.canvas.get_node('Navigate_'+entry.id);assert_true(card.get_theme_stylebox('normal') is StyleBoxTexture);assert_true(card.has_node('GameIcon223'));assert_not_null(card.get_node('GameIcon223').texture)
  p.free()
func test_book_keeps_paper_and_dynamic_buttons_receive_tiles():
 var book:=BreedingBook256.new();add_child(book);await wait_process_frames(6)
 assert_eq(book.shell.get_meta('background300'),'content')
 assert_true(book.content.get_child(1).get_theme_stylebox('panel') is StyleBoxFlat)
 for child in book.content.get_children():
  if child is Button:assert_true(child.get_theme_stylebox('normal') is StyleBoxTexture)
 book.show_page(0);await wait_process_frames(6)
 for child in book.content.get_children():
  if child is Button:assert_true(child.get_theme_stylebox('normal') is StyleBoxTexture)
 book.free()
