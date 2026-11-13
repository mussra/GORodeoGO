extends Node
var panel:HorsePanel
func shot(id:String):
 for i in 5:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/icons187-"+id+".png")
func _ready():run.call_deferred()
func run():
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(960,540);SaveData.trial_session_active=true;SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.horse_collection.add_trial_parents()
 panel=HorsePanel.new();add_child(panel);panel.page="hub";panel._refresh();await shot("menu")
 panel.page="collection";panel._refresh();await shot("properties")
 panel.collection_mode182="ranch";panel._refresh();await shot("collection")
 var summary=panel.content.find_child("HorseSummary185_original",true,false);summary.get_child(0).pressed.emit();await shot("help")
 summary.get_children().filter(func(c):return c is AcceptDialog)[0].queue_free();panel.queue_free();await get_tree().process_frame
 var host:=Control.new();host.theme=RanchTheme.create();add_child(host)
 var bg:=ColorRect.new();bg.color=Color("10252d");bg.size=Vector2(960,540);host.add_child(bg)
 var pager:=ItemPager.create(host,Vector2(40,50),300,1,3,func(_i):pass)
 for i in 4:
  var b:=CheckBox.new();b.position=Vector2(40+i*220,180);b.text=["Foto","Foto sí","Lejos","Lejos sí"][i];b.add_theme_icon_override("unchecked",AntIcons187.sized(57 if i<2 else 59,Vector2i(36,36)));b.add_theme_icon_override("checked",AntIcons187.sized(58 if i<2 else 60,Vector2i(36,36)));b.button_pressed=i%2==1;host.add_child(b)
 for i in 3:
  var b:=Button.new();b.position=Vector2(40+i*120,280);b.size=Vector2(74,56);AntIcons187.button(b,21+i,30);host.add_child(b)
 var pick:=OptionButton.new();pick.position=Vector2(500,280);pick.size=Vector2(250,56);pick.add_item("Desplegable");host.add_child(pick)
 var toggle:=CheckButton.new();toggle.position=Vector2(500,380);toggle.text="Sonido";toggle.add_theme_icon_override("unchecked",AntIcons187.sized(61,Vector2i(32,16)));toggle.add_theme_icon_override("checked",AntIcons187.sized(62,Vector2i(32,16)));host.add_child(toggle)
 await shot("controls");pager.previous.pressed.emit();assert(pager.index==0);assert(pager.previous.disabled)
 host.queue_free();await get_tree().process_frame
 SaveData.trial_session_active=false;SaveData.save_path="user://icons187-qa.dat";SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.world_position=WorldNominal98.home();SaveData.country_ledger146={}
 var world:=CountrySession152.new();world.session_state=CountryLedger146.enter(CountryLedger146.fresh(752026,3),SaveData.world_position,752026);add_child(world);await get_tree().physics_frame;world.activate152();world.player.set_physics_process(false);world.set_process(false);world._process(0.)
 world.show_map();world._map_overlay._process(.01);await shot("map")
 world._open_map_note106(world.player.position);await shot("note")
 world.free();print("ICONS187_QA_OK");get_tree().quit()
