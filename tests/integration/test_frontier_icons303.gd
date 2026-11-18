extends GutTest
func test_five_supplied_icons_keep_alpha_and_targets():
 var ids={'book256':'book','crowns240':'crowns','rodeo240':'mission','debug213':'debug','performance245':'performance'}
 var nav:=NavigationSheet.new();nav.title='FRONTERA'
 for id in ids:nav.entries.append({'id':id,'title':id,'hint':'same action'})
 add_child(nav);await wait_process_frames(5)
 var selected:Array=[];nav.selected.connect(func(id):selected.append(id))
 for id in ids:
  var path='res://art/ui/frontier303/'+ids[id]+'.png'
  assert_eq(MenuNavigation.ICONS302[id],path)
  var icon=nav.canvas.get_node('Navigate_'+id+'/GameIcon223')
  assert_eq(icon.texture.resource_path,path);assert_eq(icon.texture.get_size(),Vector2(256,256))
  var image=icon.texture.get_image();assert_eq(image.get_pixel(0,0).a,0.)
  assert_gt(image.get_pixel(128,128).a,.5)
  assert_eq(icon.mouse_filter,Control.MOUSE_FILTER_IGNORE)
 nav.canvas.get_node('Navigate_book256').pressed.emit();assert_eq(selected,['book256'])
 nav.free()
