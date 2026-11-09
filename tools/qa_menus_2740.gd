extends Node
var panel:HorsePanel
var graph:GenealogyPanel
func wait_ui()->void:await get_tree().create_timer(0.25).timeout
func shot(label:String)->void:
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/qa2740-"+label+".png")
func _ready()->void:
 var state:Dictionary=SaveData.horse_collection.export_state()
 var debug:bool=SaveData.debug_mode
 TranslationServer.set_locale("es")
 get_tree().root.size=Vector2i(1600,720)
 get_tree().root.theme=RanchTheme.create()
 SaveData.debug_mode=true
 SaveData.horse_collection.horses.clear();SaveData.horse_collection.seed_trial()
 for i in 10:SaveData.horse_collection.add_random_trial_pair()
 var c:=SaveData.horse_collection
 var kid:Dictionary=c.breed(c.horses[-2].id,c.horses[-1].id,{"coat":0,"pattern":0,"mane":0,"eyes":0})
 kid.name="Gris con rombos";kid.traits.coat=11;kid.traits.pattern=8
 panel=HorsePanel.new();get_tree().root.add_child.call_deferred(panel);await wait_ui()
 var scroll:ScrollContainer
 for node in panel.content.get_children():
  if node is ScrollContainer:scroll=node
 scroll.scroll_vertical=2147483647;await wait_ui();await shot("coleccion-ultima")
 var row:Control=scroll.get_child(0).get_children()[-1]
 var ficha:Button=row.get_children()[-1]
 var pt:Vector2=get_tree().root.get_final_transform()*ficha.get_global_rect().get_center()
 var sender:=GutInputSender.new(Input)
 sender.mouse_motion(pt);sender.mouse_left_button_down(pt);await wait_ui();sender.mouse_left_button_up(pt)
 await wait_ui();await shot("ficha-toque")
 for node in panel.content.get_children():
  if node is JumpBadge and node.skill=="dodge":node.show_explanation()
 await wait_ui();await shot("regate-titulo")
 for node in panel.content.get_children():
  if node is JumpBadge:
   for child in node.get_children():
    if child is Window:child.hide();child.queue_free()
 panel.hide()
 graph=GenealogyPanel.new();get_tree().root.add_child(graph);await wait_ui();await shot("mapa-antes")
 graph.select(kid.id)
 await get_tree().create_timer(0.5).timeout;await shot("mapa-enfoque")
 graph.select(kid.id)
 await get_tree().create_timer(0.5).timeout;await shot("mapa-restaurado")
 graph.queue_free();panel.queue_free()
 SaveData.horse_collection.restore(state);SaveData.debug_mode=debug
 get_tree().quit()
