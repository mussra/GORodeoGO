extends GutTest
var state:Dictionary
var panel:EmblemPanel
func before_each()->void:
 state=SaveData.horse_collection.export_state()
 SaveData.horse_collection.seed_trial()
 panel=EmblemPanel.new();get_tree().root.add_child(panel)
 await wait_process_frames(4)
func after_each()->void:
 panel.queue_free();SaveData.horse_collection.restore(state)
func test_initials_field_updates_both_previews_without_losing_focus()->void:
 var entry:LineEdit=panel.content.get_node("initials_entry")
 entry.grab_focus()
 var before:PackedByteArray=panel.content.get_node("emblem_badge").texture.get_image().get_data()
 entry.text="ALV";entry.text_changed.emit("ALV")
 await wait_process_frames(2)
 assert_eq(panel.config.letters,"ALV")
 assert_true(entry.has_focus())
 assert_ne(panel.content.get_node("emblem_badge").texture.get_image().get_data(),before)
 var mat:ShaderMaterial=panel.content.get_node("portrait_view").material
 assert_eq(mat.get_shader_parameter("emblem_mask"),HorseEmblem.portrait_mask(panel.config))
 entry.text_changed.emit("a!b4cD")
 assert_eq(panel.config.letters,"ABC")
 assert_eq(entry.text,"ABC")
func test_each_picker_updates_portrait_and_badge()->void:
 for key in ["shape","division","left","right","color"]:
  if key=="right":panel.config.division=1;panel.build();await wait_process_frames(2)
  var pick:OptionButton=panel.content.get_node("pick_"+key)
  var before:PackedByteArray=panel.content.get_node("emblem_badge").texture.get_image().get_data()
  var next:int=(int(panel.config[key])+1)%pick.item_count
  pick.item_selected.emit(next);await wait_process_frames(4)
  assert_eq(panel.config[key],next)
  var mat:ShaderMaterial=panel.content.get_node("portrait_view").material
  assert_eq(mat.get_shader_parameter("emblem_color"),Color(HorseEmblem.COLORS[panel.config.color]))
  if key!="color":assert_ne(panel.content.get_node("emblem_badge").texture.get_image().get_data(),before)
  else:assert_eq(panel.content.get_node("emblem_badge").modulate,Color(HorseEmblem.COLORS[next]))
func test_color_stamp_and_wrap_differ_and_old_save_survives()->void:
 var a:=HorseEmblem.DEFAULT.duplicate();var b:=a.duplicate();b.color=1
 assert_ne(HorseEmblem.ink(a,.2)[0],HorseEmblem.ink(b,.2)[0])
 assert_eq(HorseEmblem.ink(b,.2)[0],Color(HorseEmblem.COLORS[1]))
 var im:=HorseEmblem.mask(a).get_image()
 assert_ne(im.get_data(),HorseEmblem.warp_columns(im,.12).get_data())
 assert_true(HorseEmblem.valid(a));a.letters="ABC";a.letters_font=1
 assert_true(HorseEmblem.valid(a));a.letters="ABCD";assert_false(HorseEmblem.valid(a))
func test_translations_not_raw_keys()->void:
 var previous:=TranslationServer.get_locale()
 for locale in ["es","en"]:
  TranslationServer.set_locale(locale)
  for key in ["EMBLEM_LETTERS","EMBLEM_LETTERS_HINT","EMBLEM_FONT_BLOCK","EMBLEM_FONT_ENGRAVED","EMBLEM_SYMBOL_ADJ"]:assert_ne(tr(key),key)
 TranslationServer.set_locale(previous)
func test_save_reload_letters_font_and_position()->void:
 var s=load("res://src/Application/save_data.gd").new();s.save_path="user://qa-emblem-live.dat"
 s.horse_collection.seed_trial()
 var config:=HorseEmblem.DEFAULT.duplicate()
 config.letters="ALV";config.letters_font=1;config.color=1
 config.symbol_dx=-7;config.symbol_dy=8;config.symbol_scale=.7
 assert_true(s.set_horse_emblem("original",config))
 s.load_progress();assert_eq(s.horse_collection.find("original").traits.emblem,config)
 assert_eq(HorseEmblem.sanitize_letters("áñü"),"ANU")
 s.free();DirAccess.remove_absolute("user://qa-emblem-live.dat")
