extends GutTest
func test_common_picker_previews_each_option_and_selected_traits()->void:
 var host:=Control.new();add_child_autofree(host)
 var c:=HorseCollection.new();c.seed_trial();c.add_trial_parents()
 var selected:Array=[]
 var pick:=HorsePicker.create(host,c.horses,"trial_a",Vector2.ZERO,400,func(id:String):selected.append(id))
 assert_eq(str(pick.get_item_metadata(pick.selected)),"trial_a")
 for i in pick.item_count:assert_not_null(pick.get_item_icon(i))
 pick.item_selected.emit(2);assert_eq(selected,["trial_b"])
 var preview:=HorsePicker.preview(host,c.find("trial_b"),Vector2.ZERO,150);assert_not_null(preview.texture);assert_not_null(preview.material)
