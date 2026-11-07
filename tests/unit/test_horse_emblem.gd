extends GutTest
func test_config_validation_and_old_save_compatibility()->void:
 assert_true(HorseEmblem.valid(HorseEmblem.DEFAULT));assert_false(HorseEmblem.valid({}));var bad:=HorseEmblem.DEFAULT.duplicate();bad.shape=88;assert_false(HorseEmblem.valid(bad))
 var c:=HorseCollection.new();c.seed_trial();var snapshot:=c.export_state();assert_true(c.restore(snapshot));snapshot.horses[0].traits["emblem"]={};assert_false(c.restore(snapshot))
func test_save_load_remove_and_cosmetic_only()->void:
 var s=load("res://src/Application/save_data.gd").new();s.save_path="user://emblem-test-save.dat";s.horse_collection.seed_trial();s.horse_collection.add_trial_parents();var before:int=HorseMarket.tier(s.horse_collection.find("original"))
 assert_true(s.set_horse_emblem("original",HorseEmblem.DEFAULT));assert_eq(HorseMarket.tier(s.horse_collection.find("original")),before);s.load_progress();assert_eq(s.horse_collection.find("original").traits.emblem,HorseEmblem.DEFAULT)
 var child:Dictionary=s.horse_collection.breed("trial_a","trial_b",{});assert_false(child.traits.has("emblem"))
 assert_true(s.set_horse_emblem("original",{}));assert_false(s.horse_collection.find("original").traits.has("emblem"));assert_false(s.set_horse_emblem("missing",HorseEmblem.DEFAULT));s.free();DirAccess.remove_absolute("user://emblem-test-save.dat")
func test_failed_save_rolls_back_and_rejects_bad_config()->void:
 var s=load("res://src/Application/save_data.gd").new();s.save_path="user://missing-emblem-dir/fail.dat";s.horse_collection.seed_trial();var before:Dictionary=s.horse_collection.export_state();assert_false(s.set_horse_emblem("original",HorseEmblem.DEFAULT));assert_eq(s.horse_collection.export_state(),before);assert_false(s.set_horse_emblem("original",{}));assert_push_error_count(2);s.free()
func test_no_pixels_change_outside_separate_zone()->void:
 var source:Texture2D=load("res://art/player/walk_side/frame_00.png");var image:Image=source.get_image();if image.is_compressed():image.decompress()
 var before:=image.duplicate();var zone:Image=load("res://art/lineage_masks/walk_side/frame_00.png").get_image();if zone.is_compressed():zone.decompress()
 HorseEmblem.stamp(image,zone,HorseEmblem.DEFAULT);var changes:int=0
 for y in image.get_height():
  for x in image.get_width():
   if zone.get_pixel(x,y).a<.5:assert_eq(image.get_pixel(x,y),before.get_pixel(x,y))
   elif image.get_pixel(x,y)!=before.get_pixel(x,y):changes+=1
 assert_gt(changes,0)
func test_all_shapes_and_symbols_render()->void:
 for shape in 3:
  for division in 3:
   for symbol in 5:
    var cfg:=HorseEmblem.DEFAULT.duplicate();cfg.shape=shape;cfg.division=division;cfg.left=symbol;assert_false(HorseEmblem.mask(cfg).get_image().is_empty())
func test_chosen_color_leads_and_stays_readable()->void:
 for ci in HorseEmblem.COLORS.size():
  var cfg:=HorseEmblem.DEFAULT.duplicate();cfg.color=ci
  var chosen:=Color(HorseEmblem.COLORS[ci])
  for bg in [0.05,0.3,0.5,0.7,0.95]:
   var pair:Array=HorseEmblem.ink(cfg,bg);var fg:Color=pair[0]
   assert_gt(absf(fg.get_luminance()-bg),.3,"color %d readable on bg %.2f"%[ci,bg])
   if absf(chosen.get_luminance()-bg)>=.34:assert_eq(fg,chosen,"color %d kept when it already contrasts"%ci)
func test_badge_dialog_title_matches_skill()->void:
 var dodge:=JumpBadge.new();dodge.skill="dodge";dodge.capable=true
 assert_eq(dodge.explanation_title(),tr("DODGE_BADGE_TITLE"));assert_eq(dodge.explanation_text(),tr("DODGE_CAPABLE"))
 dodge.free()
 var jump:=JumpBadge.new();jump.capable=true
 assert_eq(jump.explanation_title(),tr("JUMP_BADGE_TITLE"));assert_eq(jump.explanation_text(),tr("JUMP_CAPABLE"))
 jump.free()

func test_badge_notice_never_blocks_stable_buttons()->void:
 var badge:=JumpBadge.new();badge.skill="dodge";badge.capable=true
 add_child_autofree(badge);badge.size=Vector2(64,56)
 badge.show_explanation()
 await wait_frames(3)
 var notice:PanelContainer=null
 for n in get_tree().root.get_children():
  if n is PanelContainer:notice=n
 assert_true(notice!=null and notice.visible,"notice shows at scene root")
 assert_eq(notice.mouse_filter,Control.MOUSE_FILTER_IGNORE,"notice never sees input")
 var lb:Label=notice.get_child(0)
 assert_eq(lb.mouse_filter,Control.MOUSE_FILTER_IGNORE)
 assert_true(lb.text.begins_with(tr("DODGE_BADGE_TITLE")+": "))
 badge.free()
