extends GutTest
func test_device_resolution_and_fallback()->void:
 assert_eq(Localization.resolve_language("auto","es_ES"),"es")
 assert_eq(Localization.resolve_language("auto","en-US"),"en")
 assert_eq(Localization.resolve_language("auto","fr_FR"),"es")
 assert_eq(Localization.resolve_language("es","en_US"),"es")
 assert_eq(Localization.resolve_language("en","es_ES"),"en")
func test_native_catalog_and_plurals()->void:
 var before:String=TranslationServer.get_locale()
 for locale in ["es","en"]:
  TranslationServer.set_locale(locale)
  assert_eq(str(TranslationServer.translate("UI_035")),"AJUSTES" if locale=="es" else "SETTINGS")
  assert_eq(str(TranslationServer.translate_plural("HORSE_COUNT","HORSE_COUNTS",1))%1,"1 caballo" if locale=="es" else "1 horse")
  assert_eq(str(TranslationServer.translate_plural("HORSE_COUNT","HORSE_COUNTS",2))%2,"2 caballos" if locale=="es" else "2 horses")
 TranslationServer.set_locale(before)
func test_language_choice_persists_separately_and_failure_rolls_back()->void:
 var before:String=TranslationServer.get_locale()
 var service=load("res://src/Application/localization.gd").new();service.settings_path="user://language-fixture.cfg"
 assert_true(service.set_choice("en"));service.choice="auto";service.load_choice();assert_eq(service.choice,"en");assert_eq(TranslationServer.get_locale(),"en")
 assert_false(service.set_choice("xx"));assert_eq(service.choice,"en")
 service.settings_path="user://missing-language-dir/language.cfg";assert_false(service.set_choice("es"));assert_eq(service.choice,"en")
 DirAccess.remove_absolute("user://language-fixture.cfg");service.free();TranslationServer.set_locale(before)
func test_catalog_keys_and_format_placeholders_match()->void:
 var es:Translation=load("res://i18n/ui.es.po");var en:Translation=load("res://i18n/ui.en.po")
 assert_eq(es.get_message_list(),en.get_message_list())
 for key in es.get_message_list():
  assert_false(str(en.get_message(key)).is_empty())
  var format:=RegEx.new();format.compile("%[-+0-9.]*[dfs]|%%")
  var a:Array=[];var b:Array=[]
  for found in format.search_all(str(es.get_message(key))):a.append(found.get_string())
  for found in format.search_all(str(en.get_message(key))):b.append(found.get_string())
  assert_eq(a,b,"Matching placeholders: "+key)

func test_source_phrase_aliases_and_player_names()->void:
 var before:String=TranslationServer.get_locale()
 TranslationServer.set_locale("en")
 assert_eq(str(TranslationServer.translate("MAPA · pausa · toca para cerrar")),"MAP · paused · tap to close")
 assert_eq(str(TranslationServer.translate("Mantén para prolongar")),"Hold to extend")
 assert_eq(str(TranslationServer.translate("Fusta")),"Whip")
 assert_eq(str(TranslationServer.translate("Arcoíris de prueba")),"Arcoíris de prueba")
 var panel=load("res://src/Presentation/horse_panel.gd").new()
 panel.atlas_owned_first=false
 var entries:Array=panel.atlas_entries()
 assert_eq(entries[0].horse.name,HorseCollection.COATS[0])
 panel.free();TranslationServer.set_locale(before)
