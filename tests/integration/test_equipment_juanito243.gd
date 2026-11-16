extends GutTest
## Juanito's saddlery end-to-end: buy, upgrade, equip, persist, spurs, panel.
## Ant OK 16-nov-2026 21:46 (wamid...Q0ZFNTM5Q0IyMDFCNjI1RTRGNDMwRjI1NzdDQ0UzNAA=).
var saved:Dictionary={}
var collection:Dictionary={}
var old_debug:bool
var old_path:String
var old_points:int
var old_owned:Array[String]
var old_equipped:Dictionary
var old_marker:bool
func before_each()->void:
	for property in SaveData.get_script().get_script_property_list():
		var value:Variant=SaveData.get(property.name)
		saved[property.name]=value.duplicate(true) if value is Dictionary or value is Array else value
	collection=SaveData.horse_collection.export_state().duplicate(true)
	SaveData._load_valid=true;SaveData.trial_session_active=false;SaveData.world_seed=0;SaveData.debug_mode=false
	SaveData.world_cousins140={};SaveData.world_flora138={};SaveData.world_herd_town217={};SaveData.world_places144={};SaveData.country_ledger146={};SaveData.world_roaming139={};SaveData.world_quests={};SaveData.world_garden212=Garden212.fresh()
	old_path=SaveData.save_path;old_points=SaveData.equipment_points
	old_owned=SaveData.equipment_owned.duplicate();old_equipped=SaveData.equipment_equipped.duplicate();old_marker=SaveData.points_legacy_credit_applied
	SaveData.save_path="user://qa_juanito243.dat";SaveData.equipment_points=0;SaveData.equipment_owned.clear();SaveData.equipment_equipped.clear();SaveData.points_legacy_credit_applied=true
func after_each()->void:
	SaveData.save_path=old_path;SaveData.equipment_points=old_points
	SaveData.equipment_owned=old_owned;SaveData.equipment_equipped=old_equipped;SaveData.points_legacy_credit_applied=old_marker
	DirAccess.remove_absolute("user://qa_juanito243.dat")
	for key in saved:SaveData.set(key,saved[key])
	SaveData.horse_collection.restore(collection)
	Input.action_release("move_right")
func test_buy_upgrade_equip_and_persist_all_items()->void:
	SaveData.equipment_points=20000
	for id in EquipmentCatalog.ORDER:
		if EquipmentCatalog.ITEMS[id].has("requires") or EquipmentCatalog.ITEMS[id].get("blocked",false):continue
		assert_true(SaveData.buy_equipment(id),"buy %s"%id)
	for id in EquipmentCatalog.ORDER:
		if not EquipmentCatalog.ITEMS[id].has("requires") or EquipmentCatalog.ITEMS[id].get("blocked",false):continue
		assert_true(SaveData.buy_equipment(id),"upgrade %s"%id)
	var total:int=0
	for id in EquipmentCatalog.ORDER:
		if not EquipmentCatalog.ITEMS[id].get("blocked",false):total+=int(EquipmentCatalog.ITEMS[id].price)
	assert_eq(SaveData.equipment_points,20000-total,"every approved price charged once")
	for id in EquipmentCatalog.ORDER:
		if not EquipmentCatalog.ITEMS[id].get("blocked",false):assert_true(SaveData.equip_item(id),"equip %s"%id)
	SaveData.load_progress()
	assert_eq(SaveData.equipment_points,20000-total,"points survive reload")
	for id in ["whip_long","saddle_improved","reins_improved","stirrups_improved","spurs_improved","cosmetic_hat_deluxe","cosmetic_blanket_deluxe"]:
		var slot:String=EquipmentCatalog.ITEMS[id].slot
		assert_eq(str(SaveData.equipment_equipped.get(slot,"")),id,"%s keeps its slot after reload"%id)
	assert_eq(SaveData.equipped_whip_reach(),420.0)
func test_upgrade_blocked_without_basic_and_without_points()->void:
	SaveData.equipment_points=5000
	assert_false(SaveData.buy_equipment("spurs_improved"),"upgrade requires the basic spurs")
	assert_true(SaveData.buy_equipment("spurs_basic"))
	SaveData.equipment_points=100
	assert_false(SaveData.buy_equipment("spurs_improved"),"not enough points")
	assert_eq(SaveData.equipment_owned.count("spurs_basic"),1,"no duplicate copies")
	assert_false(SaveData.buy_equipment("spurs_basic"),"cannot rebuy")
func test_spurs_activation_guards_and_cost()->void:
	SaveData.equipment_points=5000
	assert_true(SaveData.buy_equipment("spurs_basic"))
	assert_true(SaveData.equip_item("spurs_basic"))
	var player:CharacterBody2D=load("res://src/Presentation/world_player.gd").new()
	add_child(player)
	await wait_physics_frames(1)
	Input.action_press("move_right");player.spurs_world_enabled243=true
	player.stamina_state243=WorldStamina.new_state();player.stamina_ratio243=1.0
	assert_true(player.try_activate_spurs(),"burst starts with full stamina")
	assert_almost_eq(WorldStamina.ratio(player.stamina_state243),0.85,0.0001,"15% spent immediately, on the currently mounted horse")
	assert_almost_eq(player.spur_boost_left,1.0,0.0001)
	assert_almost_eq(player.spur_cooldown_left,8.0,0.0001)
	assert_false(player.try_activate_spurs(),"no stacking while active")
	player.spur_boost_left=0.0
	assert_false(player.try_activate_spurs(),"cooldown blocks reactivation")
	player.spur_cooldown_left=0.0;player.stamina_ratio243=0.10
	assert_false(player.try_activate_spurs(),"not enough stamina for the cost")
	Input.action_press("move_right");player.spurs_world_enabled243=true
	player.stamina_state243=WorldStamina.new_state();player.stamina_ratio243=1.0;player.stamina_forced243=true
	assert_false(player.try_activate_spurs(),"exhausted horse cannot burst")
	player.free()
func test_spurs_speed_and_cooldown_tick_down()->void:
	SaveData.equipment_points=5000
	SaveData.buy_equipment("spurs_basic");SaveData.equip_item("spurs_basic")
	var player:CharacterBody2D=load("res://src/Presentation/world_player.gd").new()
	add_child(player)
	await wait_physics_frames(1)
	Input.action_press("move_right");player.spurs_world_enabled243=true
	player.stamina_state243=WorldStamina.new_state();player.stamina_ratio243=1.0
	assert_true(player.try_activate_spurs())
	var before:float=player.spur_boost_left
	await wait_physics_frames(3)
	assert_lt(player.spur_boost_left,before,"boost burns down in physics")
	player.free()
func test_panel_lists_every_item_and_keeps_whip_behavior()->void:
	SaveData.equipment_points=5000
	SaveData.buy_equipment("whip_basic");SaveData.buy_equipment("whip_long");SaveData.equip_item("whip_long")
	var panel:=EquipmentPanel.new();add_child(panel)
	await wait_physics_frames(1)
	for id in EquipmentCatalog.ORDER:
		assert_true(panel._buy.has(id) and panel._equip.has(id),"panel has a row for %s"%id)
	assert_eq(panel._equip["whip_long"].get_node("Caption229").text,tr("UI_061"))
	assert_true(panel._equip["whip_long"].disabled)
	assert_eq(panel._buy["whip_long"].get_node("Caption229").text,"Conseguido")
	assert_eq(panel._buy["spurs_basic"].get_node("Caption229").text,"Conseguir")
	assert_true(SaveData.equipment_state().can_buy("spurs_basic",EquipmentCatalog.ITEMS),"off-screen buttons are input-blocked until scrolled into view")
	assert_eq(panel._buy["spurs_improved"].get_node("Caption229").text,"Mejorar")
	assert_true(panel._buy["spurs_improved"].disabled,"upgrade disabled without the basic")
	panel.free()
func test_stamina_tick_consumes_spur_cost()->void:
	SaveData.equipment_points=5000
	SaveData.buy_equipment("spurs_basic");SaveData.equip_item("spurs_basic")
	var player:CharacterBody2D=load("res://src/Presentation/world_player.gd").new()
	add_child(player)
	await wait_physics_frames(1)
	var gauges:Dictionary={"stamina":RadialGauge.new()}
	add_child(gauges.stamina)
	Input.action_press("move_right");player.spurs_world_enabled243=true
	player.stamina_state243=WorldStamina.new_state();player.stamina_ratio243=1.0;player.gait=WorldGait.PASO
	var state:Dictionary=WorldStamina.new_state(0.65)
	var bound:Dictionary=MountedStatus154.stamina(player,gauges,state,0.0,true)
	assert_true(player.try_activate_spurs())
	assert_almost_eq(float(bound.value),float(bound.max)*.85,0.001,"world's energy is charged immediately")
	var next:Dictionary=MountedStatus154.stamina(player,gauges,bound,0.0,true)
	assert_almost_eq(float(next.value),float(bound.value),0.001,"next stamina tick does not charge twice")
	gauges.stamina.free();player.free()
func test_spurs_measured_speed_restrictions_and_no_race_effect()->void:
	SaveData.equipment_points=5000
	SaveData.buy_equipment("spurs_basic");SaveData.equip_item("spurs_basic")
	var player=load("res://tests/integration/equipment_mover243.gd").new()
	add_child(player);player.set_physics_process(false)
	player.max_speed=260.;player.gait=WorldGait.GALOPE;player.spurs_world_enabled243=true
	player.stamina_state243=WorldStamina.new_state();player.stamina_ratio243=1.
	assert_false(player.try_activate_spurs(),"a paused/modal world cannot activate")
	player.set_physics_process(true)
	player.spurs_world_enabled243=false
	assert_false(player.try_activate_spurs(),"races/duels never bind world stamina")
	player.spurs_world_enabled243=true
	player.wish243=Vector2.ZERO
	assert_false(player.try_activate_spurs(),"must willingly ride")
	player.wish243=Vector2.RIGHT
	player._stun_time_remaining=1.
	assert_false(player.try_activate_spurs(),"no burst when stunned")
	player._stun_time_remaining=0.;player._jump_time=1.
	assert_false(player.try_activate_spurs(),"no burst while jumping")
	player._jump_time=0.;player.dodge.drawing=true
	assert_false(player.try_activate_spurs(),"no burst while drawing")
	player.dodge.drawing=false;player.dodge.remaining=1.
	assert_false(player.try_activate_spurs(),"no stacking with a sprint")
	player.dodge.remaining=0.;player.dodge.coast_remaining=1.
	assert_false(player.try_activate_spurs(),"no stacking with post-dodge sprint")
	player.dodge.coast_remaining=0.
	player.velocity=Vector2.RIGHT*260.
	assert_true(player.try_activate_spurs())
	player.step_shared_movement(.1)
	assert_almost_eq(player.velocity.length(),286.,.01,"+10% ordinary gallop speed")
	assert_almost_eq(player.max_speed,260.,.01,"no permanent top speed increase")
	player.spur_boost_left=0.;player.step_shared_movement(.1)
	assert_almost_eq(player.velocity.length(),260.,.01,"returns to prior ordinary speed")
	player.free()
func test_save_failure_rolls_back_points_ownership_and_equipped()->void:
	SaveData.equipment_points=5000
	SaveData.save_path="user://missing_parent243/never_created/equipment.dat"
	assert_false(SaveData.buy_equipment("saddle_basic"))
	assert_eq(SaveData.equipment_points,5000)
	assert_false(SaveData.equipment_owned.has("saddle_basic"))
	SaveData.equipment_owned.append("saddle_basic")
	assert_false(SaveData.equip_item("saddle_basic"))
	assert_eq(SaveData.equipment_equipped,{})
	assert_push_error_count(2)
func test_reins_whip_and_stirrups_apply_without_new_abilities()->void:
	SaveData.equipment_owned.assign(["reins_improved","whip_long","stirrups_improved"])
	SaveData.equipment_equipped={"reins":"reins_improved","whip":"whip_long","stirrups":"stirrups_improved"}
	var player=load("res://src/Presentation/world_player.gd").new();add_child(player)
	var host:=Control.new();add_child(host)
	var gauges:Dictionary=MountedStatus154.create(host)
	var horse:Dictionary={"can_dodge":false,"can_jump":false}
	MountedStatus154.abilities(player,gauges,horse)
	assert_false(player.dodge_available,"equipment cannot replace the horse's learning")
	assert_eq(player.dodge.path_limit,420.)
	assert_almost_eq(player.dodge_recharge_seconds,2.25,.001)
	var state:Dictionary=WorldStamina.new_state()
	MountedStatus154.stamina(player,gauges,state,0.,false)
	player.stun(2.)
	assert_almost_eq(player._stun_time_remaining,1.8,.001)
	host.free();player.free()
func test_confirmation_does_not_spend_until_confirmed_and_cosmetics_can_be_removed()->void:
	SaveData.equipment_points=5000
	var panel:=EquipmentPanel.new();add_child(panel)
	panel._confirm_purchase("spurs_basic")
	assert_eq(SaveData.equipment_points,5000,"opening confirmation cannot spend")
	assert_true(panel._confirm.dialog_text.contains("Coste ahora: 900"))
	assert_true(panel._confirm.dialog_text.contains("Saldo después: 4100"))
	panel._confirm.confirmed.emit()
	assert_eq(SaveData.equipment_points,4100)
	panel._confirm.confirmed.emit()
	assert_eq(SaveData.equipment_points,4100,"duplicate confirm cannot spend twice")
	panel.free()
	assert_true(SaveData.buy_equipment("cosmetic_hat"));assert_true(SaveData.equip_item("cosmetic_hat"))
	assert_true(SaveData.unequip_cosmetic243("cosmetic_hat"))
	assert_true(SaveData.equipment_owned.has("cosmetic_hat"),"removing does not discard ownership")
	assert_eq(SaveData.equipment_points,3800)
	assert_true(SaveData.equip_item("cosmetic_hat"),"putting it on again is free")
	assert_eq(SaveData.equipment_points,3800)
	assert_false(SaveData.unequip_cosmetic243("whip"),"cosmetic removal cannot remove a whip unlock")
func test_cosmetic_frames_keep_size_and_alpha_without_changing_stats()->void:
	SaveData.equipment_owned.assign(["cosmetic_hat_deluxe","cosmetic_blanket_deluxe"])
	SaveData.equipment_equipped={"cosmetic_hat":"cosmetic_hat_deluxe","cosmetic_blanket":"cosmetic_blanket_deluxe"}
	var frames:=SpriteFrames.new();frames.remove_animation("default")
	frames.add_animation("walk_side");var original:Texture2D=load("res://art/experimental/pixellab/rider/side/frame_00.png");frames.add_frame("walk_side",original)
	JuanitoCosmetics243.apply(frames)
	var colored:Texture2D=frames.get_frame_texture("walk_side",0)
	assert_eq(colored.get_size(),original.get_size())
	var before:Image=original.get_image();var after:Image=colored.get_image()
	if before.is_compressed():before.decompress()
	if after.is_compressed():after.decompress()
	var changed:bool=false
	for y in before.get_height():
		for x in before.get_width():
			assert_eq(after.get_pixel(x,y).a,before.get_pixel(x,y).a)
			if after.get_pixel(x,y)!=before.get_pixel(x,y):changed=true
	assert_true(changed,"cosmetics visibly change pixels")
	assert_eq(EquipmentEffects.running_drain_multiplier(),1.)
	assert_eq(EquipmentEffects.stun_multiplier(),1.)
	assert_eq(EquipmentEffects.dodge_recharge_multiplier(),1.)
	assert_eq(EquipmentEffects.spurs(),{})
