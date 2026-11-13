extends Node
var panel:HorsePanel
func _ready():run.call_deferred()
func shot(id:String):
 for i in 5:await get_tree().process_frame
 await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png("/downloads/summary185-"+id+".png")
func run():
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(1600,720);SaveData.trial_session_active=true;SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.horse_collection.add_trial_parents()
 panel=HorsePanel.new();add_child(panel);panel.page="atlas";panel.atlas_owned_first=false;panel.atlas_page=51;panel._refresh();await shot("atlas-1600")
 get_tree().root.size=Vector2i(960,540);panel.size=get_viewport().get_visible_rect().size;panel.layout();await shot("atlas-960")
 var count:int=0
 for child in panel.content.get_node("AtlasVisibleGrid117").get_children():
  if child is Label:
   assert(child.get_rect().end.x<=1240.);assert(child.size.x<=228.);count+=1
 assert(count>=18)
 var h:Dictionary=SaveData.horse_collection.find("original");h.name="Caballo extraordinario de nombre largo para revisar ajuste";assert(h.name.length()<=60)
 panel.page="collection";panel._refresh();await shot("collection-list-960")
 panel.content.get_node("CollectionRanch182").pressed.emit();await shot("collection-ranch-960")
 var ranch:RanchPasturePanel141
 for child in panel.content.get_children():
  if child is RanchPasturePanel141:ranch=child
 ranch.content.find_child("PastureHorse_trial_a",true,false).pressed.emit();await shot("collection-detail-960")
 panel.go_back();await shot("collection-ranch-return-960")
 var summary=panel.content.find_child("HorseSummary185_original",true,false)
 summary.get_child(0).pressed.emit();await shot("help-960")
 summary.get_children().filter(func(c):return c is AcceptDialog)[0].queue_free();await get_tree().process_frame
 panel.page="collection";panel.collection_mode182="ranch"
 SaveData.horse_collection.breed("trial_a","trial_b",{})
 panel._refresh();await shot("foal-960")
 for c in panel.content.get_children():
  if c is RanchPasturePanel141:c.family_id="child_1";c.refresh()
 await shot("family-960")
 for i in 14:
  var extra:Dictionary=SaveData.horse_collection.find("trial_a").duplicate(true);extra.id="extra"+str(i);extra.name="Prueba de colección numerosa "+str(i);SaveData.horse_collection.horses.append(extra)
 panel._refresh();await shot("many-960")
 for c in panel.content.get_children():
  if c is RanchPasturePanel141:c.content.get_node("RanchCardsScroll185").scroll_vertical=1000
 await shot("many-scrolled-960")
 for c in panel.content.get_children():
  if c is RanchPasturePanel141:
   var scroll=c.content.get_node("RanchCardsScroll185")
   assert(scroll.scroll_horizontal==0)
   for n in scroll.get_child(0).get_children():
    if n is HorseSummaryBar185:assert(n.position.y+n.size.y<=ceili(12./4.)*180.)
 SaveData.horse_collection.horses=[SaveData.horse_collection.find("original")];panel.collection_mode182="list";panel._refresh();await shot("singular-960")
 panel.page="market";panel._refresh();await shot("mercado-960")
 TranslationServer.set_locale("en");panel.page="atlas";panel.atlas_page=51;panel._refresh();await shot("atlas-en-960")
 panel.queue_free();await get_tree().process_frame
 var uni:=UnicornAtlasPanel.new();add_child(uni);await shot("unicornios-960");uni.free()
 var menu:=Control.new();menu.size=Vector2(1280,720);add_child(menu);MenuNavigation.cards(menu,[{"id":"collection","title":"Nombre de sección extraordinariamente largo para comprobar límites","hint":"Esta descripción muy larga debe permanecer dentro de su tarjeta sin pisar ninguna otra tarjeta de navegación."},{"id":"atlas","title":"ATLAS","hint":"Segunda tarjeta"},{"id":"market","title":"MERCADO","hint":"Tercera tarjeta"}],func(_id):pass);menu.scale=Vector2.ONE*.75;await shot("menu-extremo-960")
 print("SUMMARY185_VISUAL_OK");get_tree().quit()
