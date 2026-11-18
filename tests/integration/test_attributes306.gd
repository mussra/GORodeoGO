extends GutTest
func test_all_equipment_properties_share_bounded_five_sector_component():
 for id in EquipmentCatalog.ORDER:
  for spec in EquipmentAttributes306.specs(id):
   assert_gt(float(spec[3]),float(spec[2]));assert_gte(float(spec[1]),float(spec[2]));assert_lte(float(spec[1]),float(spec[3]))
 var bar:=AttributeBar306.new();bar.min_value=0;bar.max_value=1;bar.value=.6;add_child_autofree(bar)
 assert_false(bar.show_percentage);assert_true(bar.ends306)
func test_purchase_properties_and_costs_are_visible_without_technical_dimensions():
 var old_path:String=SaveData.save_path;var owned=SaveData.equipment_owned.duplicate();var equipped=SaveData.equipment_equipped.duplicate(true);var points:int=SaveData.equipment_points;var trial:bool=SaveData.trial_session_active
 SaveData.trial_session_active=false;SaveData.equipment_points=10000;SaveData.equipment_owned.clear();SaveData.equipment_equipped.clear()
 var p:=EquipmentPanel.new();add_child(p);p._confirm_purchase('scare_whip265');await wait_process_frames(5)
 assert_eq(SaveData.equipment_points,10000);assert_not_null(p._confirm_bars306.get_node_or_null('Attributes306'))
 assert_lt(p._confirm.size.y,700)
 for id in EquipmentCatalog.ORDER:
  assert_false(p._effect_text(id).contains('px'));assert_false(p._upgrade_diff_text(id).contains('px'))
  assert_false(str(EquipmentCatalog.ITEMS[id].description).contains('px'))
 p.free();SaveData.save_path=old_path;SaveData.equipment_owned=owned;SaveData.equipment_equipped=equipped;SaveData.equipment_points=points;SaveData.trial_session_active=trial
func test_equipped_position_is_preserved_and_upgrade_is_not_an_invented_bonus():
 var old=SaveData.equipment_equipped.duplicate(true);SaveData.equipment_equipped.scare_whip='scare_whip265'
 assert_almost_eq(EquipmentAttributes306.value_for('scare_whip265','Alcance del ruido'),240./310.,.0001)
 assert_eq(EquipmentAttributes306.value_for('scare_whip_plus265','Alcance del ruido'),1.)
 var host:=VBoxContainer.new();add_child_autofree(host);var panel:=EquipmentAttributes306.create(host,'scare_whip_plus265',650)
 assert_almost_eq(panel.get_child(0).get_child(1).baseline306,240./310.,.0001)
 SaveData.equipment_equipped=old

func test_central_default_ranges_and_five_sectors():
 assert_eq(AttributeRanges306.SECTORS,5)
 assert_eq(HorseSummary185.STATS,AttributeRanges306.HORSE_STATS)
 for bounds in AttributeRanges306.RANGES.values():assert_gt(float(bounds[1]),float(bounds[0]))
 assert_almost_eq(EquipmentAttributes306.value_for('reins_improved','Rapidez de recarga'),1.,.0001)
 assert_lt(EquipmentAttributes306.value_for('reins_basic','Rapidez de recarga'),1.)
