extends GutTest
var panel:AdornShop169
var old_path:String
func before_each():
 old_path=SaveData.save_path;SaveData.save_path="user://shop169-test.dat";SaveData._load_valid=true;SaveData.trial_session_active=false;SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.equipment_points=200000;SaveData.equipment_owned=[];SaveData.world_pig_captures=[];SaveData.world_goat_captures=[];SaveData.repeat_contract165=ProgressionEconomy165.new_contract()
 panel=AdornShop169.new();add_child(panel)
func after_each():
 if is_instance_valid(panel):panel.free()
 SaveData.save_path=old_path;DirAccess.remove_absolute("user://shop169-test.dat");await get_tree().process_frame
func test_real_shop_activity_buy_mix_remove_and_reload():
 var before:Dictionary=SaveData.horse_collection.export_state();assert_true(panel.buys[0].disabled);assert_true(panel.equips[0].disabled)
 for i in 40:SaveData.world_pig_captures.append("pig%d"%i)
 for i in 30:SaveData.world_goat_captures.append("goat%d"%i)
 SaveData.repeat_contract165=ProgressionEconomy165.new_contract(8);panel.refresh()
 for i in 2:assert_false(panel.buys[i].disabled);panel.buys[i].pressed.emit();assert_true(panel.buys[i].disabled)
 assert_eq(SaveData.equipment_points,182000)
 panel.equips[3].pressed.emit();panel.equips[2].pressed.emit();var horse:Dictionary=SaveData.horse_collection.find("original")
 assert_eq(HorseAdorn169.metal(horse,"legs"),"gold");assert_eq(HorseAdorn169.metal(horse,"boots"),"silver")
 SaveData.load_progress();assert_eq(HorseAdorn169.metal(SaveData.horse_collection.find("original"),"boots"),"silver")
 panel._remove("legs");panel._remove("boots");assert_eq(SaveData.horse_collection.export_state(),before);assert_eq(SaveData.equipment_points,182000)
func test_actor_anim_material_and_mixed_finish_every_frame():
 var horse:Dictionary=SaveData.horse_collection.find("original");horse.leg_adorn169="gold";horse.boot_adorn169="silver"
 var scene=load("res://src/Presentation/level_0.tscn").instantiate();add_child(scene);scene.player.set_physics_process(false)
 var sprite:AnimatedSprite2D=scene.player._sprite_swap._sprite
 for style in ["","ice"]:
  if style.is_empty():horse.erase("special_finish168")
  else:horse.special_finish168=style
  for animation in sprite.sprite_frames.get_animation_names():
   sprite.play(animation);sprite.pause()
   for frame in sprite.sprite_frames.get_frame_count(animation):
    sprite.frame=frame;HorseFinish168.update(sprite,horse);assert_not_null(sprite.material);assert_eq(sprite.material.get_shader_parameter("style"),0 if style.is_empty() else 3);assert_eq(sprite.material.get_shader_parameter("leg_metal169"),1);assert_eq(sprite.material.get_shader_parameter("boot_metal169"),2)
 scene.free()
func test_portrait_preview_layout_and_back():
 for i in 2:
  assert_eq(panel.previews[i].material.get_shader_parameter("leg_metal169"),2-i);assert_eq(panel.previews[i].material.get_shader_parameter("boot_metal169"),2-i)
 panel.set_anchors_preset(Control.PRESET_TOP_LEFT);panel.size=Vector2(960,540);panel._layout();assert_eq(panel.canvas.scale,Vector2(.75,.75))
 for button in panel.buys+panel.equips:assert_lte((button.position.y+button.size.y)*.75,540.)
 var event:=InputEventAction.new();event.action="ui_cancel";event.pressed=true;panel._unhandled_input(event);assert_true(panel.is_queued_for_deletion())
