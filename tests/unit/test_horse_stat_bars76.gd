extends GutTest
func test_values_are_normalized_hidden_numbers_and_shared():
 var host=VBoxContainer.new();add_child_autofree(host)
 var h={"stats":{"speed":270,"handling":1050,"power":.7,"dodge":.875,"calm":1.25},"can_jump":true}
 var bars=HorseStatBars.create(host,h,true)
 assert_eq(bars.get_child_count(),7)
 for row in bars.get_children():
  assert_true(row.get_child(1) is ProgressBar);assert_false(row.get_child(1).show_percentage)
  assert_almost_eq(row.get_child(1).value,.5,.001) if row.get_index()<5 else assert_gte(row.get_child(1).value,0)
  var title:String=row.get_child(0).text
  for digit in "0123456789%":assert_false(title.contains(digit))
func test_unowned_has_no_invented_bars():
 var host=VBoxContainer.new();add_child_autofree(host)
 var bars=HorseStatBars.create(host,{},false);assert_eq(bars.get_child_count(),1);assert_true(bars.get_child(0) is Label);assert_true(bars.get_child(0).text.contains("por descubrir"))
func test_limits_and_training_use_same_row():
 var host=VBoxContainer.new();add_child_autofree(host)
 var low=HorseStatBars.row(host,"Dominio",-1);var high=HorseStatBars.row(host,"Dominio",101)
 assert_eq(low.get_child(1).value,0.0);assert_eq(high.get_child(1).value,1.0)
