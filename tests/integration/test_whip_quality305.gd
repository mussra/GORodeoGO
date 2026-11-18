extends GutTest
func test_quality_increases_range_and_full_effect_duration():
 assert_gt(AnimalScare265.IMPROVED.radius,AnimalScare265.BASIC.radius)
 assert_gt(AnimalScare265.IMPROVED.seconds,AnimalScare265.BASIC.seconds)
 var pig=load('res://src/Presentation/wild_pig.gd').new();pig.setup({'pos':Vector2(275,0)});add_child_autofree(pig)
 assert_false(AnimalScare265.apply_to(pig,Vector2.ZERO,AnimalScare265.BASIC))
 assert_true(AnimalScare265.apply_to(pig,Vector2.ZERO,AnimalScare265.IMPROVED));assert_eq(pig.scare_left265,1.4)
func test_bulls_and_horses_receive_advertised_seconds_without_hidden_reduction():
 GameState.selected_level=5;var old:bool=SaveData.trial_session_active;SaveData.trial_session_active=true
 var level=load('res://src/Presentation/level_0.tscn').instantiate();add_child(level)
 var bull=level._active_bulls[0];bull.set_physics_process(false)
 var horse=load('res://src/Presentation/wild_horse.gd').new();add_child(horse);horse.set_physics_process(false)
 for quality in [1,2]:
  var settings:=AnimalScare265.for_quality305(quality)
  assert_true(bull.scare265(Vector2.ZERO,settings.seconds));assert_eq(bull.scare_left265,settings.seconds)
  assert_true(horse.scare265(Vector2.ZERO,settings.seconds));assert_eq(horse.scare_left265,settings.seconds)
 horse.free();level.free();SaveData.trial_session_active=old
func test_shop_uses_same_settings_and_explains_quality():
 var p:=EquipmentPanel.new();add_child_autofree(p)
 assert_eq(EquipmentAttributes306.specs('scare_whip265')[0][1],240.)
 assert_eq(EquipmentAttributes306.specs('scare_whip_plus265')[1][1],1.4)
 assert_string_contains(p._effect_text('scare_whip265'),'sin daño')
 assert_string_contains(p._upgrade_diff_text('scare_whip_plus265'),'verde: mejora')
