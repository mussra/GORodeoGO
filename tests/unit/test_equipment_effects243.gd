extends GutTest
## Juanito's saddlery catalog + derived effects (Ant OK 16-nov-2026 21:46).
var old_points:int
var old_owned:Array[String]
var old_equipped:Dictionary
func before_each()->void:
	old_points=SaveData.equipment_points
	old_owned=SaveData.equipment_owned.duplicate()
	old_equipped=SaveData.equipment_equipped.duplicate()
	SaveData.equipment_owned.clear()
	SaveData.equipment_equipped.clear()
func after_each()->void:
	SaveData.equipment_points=old_points
	SaveData.equipment_owned=old_owned
	SaveData.equipment_equipped=old_equipped
func _own_equip(id:String)->void:
	if not SaveData.equipment_owned.has(id):SaveData.equipment_owned.append(id)
	var slot:String=EquipmentCatalog.ITEMS[id].slot
	SaveData.equipment_equipped[slot]=id
func test_catalog_matches_approved_proposal()->void:
	var expected:Dictionary={"whip_basic":1000,"whip_long":2000,"saddle_basic":800,"saddle_improved":1600,"reins_basic":600,"reins_improved":1200,"stirrups_basic":700,"stirrups_improved":1400,"shoes_basic":900,"shoes_improved":1800,"spurs_basic":900,"spurs_improved":1800,"cosmetic_hat":300,"cosmetic_hat_deluxe":600,"cosmetic_blanket":300,"cosmetic_blanket_deluxe":600}
	for id in expected:
		assert_true(EquipmentCatalog.ITEMS.has(id),"catalog has %s"%id)
		assert_eq(int(EquipmentCatalog.ITEMS[id].price),expected[id],"approved price of %s"%id)
	for id in ["whip_long","saddle_improved","reins_improved","stirrups_improved","shoes_improved","spurs_improved","cosmetic_hat_deluxe","cosmetic_blanket_deluxe"]:
		assert_true(EquipmentCatalog.ITEMS[id].has("requires"),"%s is an upgrade"%id)
		assert_eq(str(EquipmentCatalog.ITEMS[id].slot),str(EquipmentCatalog.ITEMS[EquipmentCatalog.ITEMS[id].requires].slot),"upgrade shares the basic slot")
	assert_false(EquipmentCatalog.ITEMS.has("saddlebags"),"alforjas stay blocked until a limited inventory exists")
	assert_false(EquipmentCatalog.ITEMS.has("alforjas"))
func test_defaults_are_neutral_without_equipment()->void:
	assert_eq(EquipmentEffects.running_drain_multiplier(),1.0)
	assert_eq(EquipmentEffects.dodge_recharge_multiplier(),1.0)
	assert_eq(EquipmentEffects.stun_multiplier(),1.0)
	assert_eq(EquipmentEffects.spurs(),{})
	assert_eq(EquipmentEffects.equipped_id("cosmetic_hat"),"")
func test_equipped_basic_and_improved_values()->void:
	_own_equip("saddle_basic");assert_eq(EquipmentEffects.running_drain_multiplier(),0.95)
	_own_equip("saddle_improved");assert_eq(EquipmentEffects.running_drain_multiplier(),0.90,"improved replaces basic in the slot")
	_own_equip("reins_improved");assert_eq(EquipmentEffects.dodge_recharge_multiplier(),0.90)
	_own_equip("stirrups_basic");assert_eq(EquipmentEffects.stun_multiplier(),0.95)
	_own_equip("spurs_basic")
	var spurs:Dictionary=EquipmentEffects.spurs()
	assert_eq(float(spurs.spur_boost),0.10);assert_eq(float(spurs.spur_seconds),1.0);assert_eq(float(spurs.spur_cooldown),8.0);assert_eq(float(spurs.spur_stamina_cost),0.15)
func test_equip_requires_ownership()->void:
	SaveData.equipment_equipped["saddle"]="saddle_basic"
	assert_eq(EquipmentEffects.running_drain_multiplier(),1.0,"equipped but not owned gives no effect")
func test_stamina_tick_applies_saddle()->void:
	var state:Dictionary=WorldStamina.new_state(0.65)
	var plain:Dictionary=WorldStamina.tick(state,WorldGait.GALOPE,true,1.0,false)
	var saddled:Dictionary=WorldStamina.tick(state,WorldGait.GALOPE,true,1.0,false,1.0,0.90)
	var drain_plain:float=float(state.value)-float(plain.value)
	var drain_saddled:float=float(state.value)-float(saddled.value)
	assert_almost_eq(drain_saddled,drain_plain*0.90,0.001,"montura cuts running drain 10%")
	var trote_plain:Dictionary=WorldStamina.tick(state,WorldGait.TROTE,true,1.0,false,1.0,0.90)
	assert_almost_eq(float(state.value)-float(trote_plain.value),WorldStamina.DRAIN_TROTE/WorldStamina.ENDURANCE_MULT*0.90,0.001,"montura reduces running drain, trot included")

func test_upgrade_rules_in_points_state()->void:
	var state:=EquipmentPoints.new()
	state.balance=5000
	assert_false(state.can_buy("saddle_improved",EquipmentCatalog.ITEMS),"upgrade requires the basic item")
	assert_true(state.buy("saddle_basic",EquipmentCatalog.ITEMS))
	assert_true(state.can_buy("saddle_improved",EquipmentCatalog.ITEMS))
	assert_true(state.buy("saddle_improved",EquipmentCatalog.ITEMS))
	assert_eq(state.balance,5000-800-1600)
	assert_false(state.can_buy("saddle_basic",EquipmentCatalog.ITEMS),"single purchase, no stacking copies")
	assert_true(state.equip("saddle_improved",EquipmentCatalog.ITEMS))
	assert_true(state.equip("saddle_basic",EquipmentCatalog.ITEMS),"equipping back is free")
	assert_eq(str(state.equipped["saddle"]),"saddle_basic")

func test_horseshoes_blocked_without_terrain_mechanic()->void:
	var state:=EquipmentPoints.new();state.balance=10000
	assert_false(state.can_buy("shoes_basic",EquipmentCatalog.ITEMS))
	assert_false(state.buy("shoes_basic",EquipmentCatalog.ITEMS))
	assert_eq(state.balance,10000)
