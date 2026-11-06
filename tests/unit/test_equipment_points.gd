extends GutTest
# Examples are fixtures from the design conversation, not a shipped balance table.
const REWARDS={1:10,5:200,10:1000}
const CATALOG={"base_hat":{"slot":"hat","base":true,"price":0},"whip":{"slot":"whip","price":1000},"hat":{"slot":"hat","price":100},"bad":{"slot":"hat","price":-50}}
func test_repeats_award_points_but_duplicate_result_does_not()->void:
	var economy:=EquipmentPoints.new()
	assert_eq(economy.reward_completed_level(1,"win-a",REWARDS),10)
	assert_eq(economy.reward_completed_level(1,"win-b",REWARDS),10)
	assert_eq(economy.reward_completed_level(1,"win-a",REWARDS),0)
	assert_eq(economy.balance,20)
func test_purchase_and_equip_are_separate_and_cannot_double_spend()->void:
	var economy:=EquipmentPoints.new()
	assert_false(economy.buy("whip",CATALOG))
	assert_false(economy.equip("whip",CATALOG))
	economy.reward_completed_level(10,"win-a",REWARDS)
	assert_true(economy.buy("whip",CATALOG))
	assert_eq(economy.balance,0)
	assert_eq(economy.equipped,{})
	assert_true(economy.equip("whip",CATALOG))
	assert_false(economy.buy("whip",CATALOG))
	assert_eq(economy.balance,0)
func test_free_original_and_single_slot_selection()->void:
	var economy:=EquipmentPoints.new()
	assert_true(economy.equip("base_hat",CATALOG))
	economy.reward_completed_level(5,"win-a",REWARDS)
	assert_true(economy.buy("hat",CATALOG))
	assert_true(economy.equip("hat",CATALOG))
	assert_eq(economy.equipped["hat"],"hat")
	assert_true(economy.equip("base_hat",CATALOG))
	assert_eq(economy.equipped["hat"],"base_hat")
	assert_eq(economy.balance,100)
func test_invalid_entries_never_grant_or_spend_points()->void:
	var economy:=EquipmentPoints.new()
	assert_false(economy.buy("bad",CATALOG))
	assert_false(economy.buy("missing",CATALOG))
	assert_eq(economy.reward_completed_level(2,"win-a",REWARDS),0)
	assert_eq(economy.reward_completed_level(1,"",REWARDS),0)
	assert_eq(economy.reward_completed_level(1,"win-a",{1:-10}),0)
	assert_eq(economy.balance,0)

func test_upgrade_needs_basic_whip_and_replaces_slot_without_stacking()->void:
	var economy:=EquipmentPoints.new()
	economy.balance=5000
	assert_false(economy.buy("whip_long",EquipmentCatalog.ITEMS))
	assert_true(economy.buy("whip_basic",EquipmentCatalog.ITEMS))
	assert_true(economy.equip("whip_basic",EquipmentCatalog.ITEMS))
	assert_true(economy.buy("whip_long",EquipmentCatalog.ITEMS))
	assert_true(economy.equip("whip_long",EquipmentCatalog.ITEMS))
	assert_eq(economy.equipped.size(),1)
	assert_eq(economy.equipped["whip"],"whip_long")
	assert_eq(economy.balance,2000)
