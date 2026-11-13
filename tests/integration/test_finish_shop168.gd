extends GutTest
var panel:FinishShop168
var old_path:String
func before_each():
 old_path=SaveData.save_path;SaveData.save_path="user://shop168-test.dat";SaveData._load_valid=true;SaveData.trial_session_active=false;SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.equipment_points=200000;SaveData.equipment_owned=[];SaveData.world_pig_captures=[];SaveData.world_goat_captures=[];SaveData.repeat_contract165=ProgressionEconomy165.new_contract()
 panel=FinishShop168.new();add_child(panel)
func after_each():
 if is_instance_valid(panel):panel.free()
 SaveData.save_path=old_path;DirAccess.remove_absolute("user://shop168-test.dat");await get_tree().process_frame
func test_shop_requires_activity_purchase_once_equip_then_reload_without_genetic_change():
 var traits:Dictionary=SaveData.horse_collection.find("original").traits.duplicate(true);assert_true(panel.buys[0].disabled)
 for i in 280:SaveData.world_pig_captures.append("pig%d"%i)
 for i in 220:SaveData.world_goat_captures.append("goat%d"%i)
 SaveData.repeat_contract165=ProgressionEconomy165.new_contract(56);panel.refresh();assert_false(panel.buys[0].disabled)
 panel.buys[0].pressed.emit();assert_eq(SaveData.equipment_points,176000);assert_true(panel.buys[0].disabled);assert_false(panel.equips[0].disabled)
 panel.equips[0].pressed.emit();assert_eq(HorseFinish168.style(SaveData.horse_collection.find("original")),"gold");assert_true(panel.equips[0].disabled)
 SaveData.load_progress();assert_eq(SaveData.equipment_points,176000);assert_eq(SaveData.horse_collection.find("original").traits,traits);assert_eq(HorseFinish168.style(SaveData.horse_collection.find("original")),"gold")
func test_new_actor_uses_finish_for_every_mounted_animation_and_drink_pose_has_shared_material():
 SaveData.horse_collection.find("original").special_finish168="ice"
 var scene=load("res://src/Presentation/level_0.tscn").instantiate();add_child(scene);var actor=scene.player;actor.set_physics_process(false)
 var sprite:AnimatedSprite2D=actor._sprite_swap._sprite
 for animation in sprite.sprite_frames.get_animation_names():
  sprite.play(animation);sprite.pause()
  for frame in sprite.sprite_frames.get_frame_count(animation):
   sprite.frame=frame;HorseFinish168.update(sprite,SaveData.horse_collection.find("original"));assert_not_null(sprite.material,str(animation)+str(frame));assert_eq(sprite.material.get_shader_parameter("style"),3)
 scene.free()
func test_portrait_styles_and_small_layout_and_back():
 for i in 3:assert_eq(panel.previews[i].material.get_shader_parameter("special_finish168"),i+1)
 panel.set_anchors_preset(Control.PRESET_TOP_LEFT);panel.size=Vector2(960,540);panel._layout();assert_eq(panel.canvas.scale,Vector2(.75,.75))
 for button in panel.buys+panel.equips:assert_lte((button.position.y+button.size.y)*.75,540.)
 var event:=InputEventAction.new();event.action="ui_cancel";event.pressed=true;panel._unhandled_input(event);assert_true(panel.is_queued_for_deletion())
