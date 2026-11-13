extends Node
var panel:HorsePanel
func shot(id:String):
 for i in 5:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/modal186-"+id+".png")
func _ready():run.call_deferred()
func run():
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(960,540);SaveData.trial_session_active=true;SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.horse_collection.add_trial_parents()
 panel=HorsePanel.new();add_child(panel);panel.page="collection";panel.collection_mode182="ranch";panel._refresh()
 await shot("before")
 var summary=panel.content.find_child("HorseSummary185_original",true,false)
 var grid=summary.get_parent()
 var tap:Button
 var actor:AnimatedSprite2D
 for c in grid.get_children():
  if c is Button and c.text.is_empty() and tap==null:tap=c
  if c is AnimatedSprite2D and actor==null:actor=c
 print("BEFORE disabled=",tap.disabled," style=",tap.get_theme_stylebox("disabled").get_class()," actor_visible=",actor.is_visible_in_tree())
 summary.get_child(0).pressed.emit();await shot("open")
 print("OPEN disabled=",tap.disabled," style=",tap.get_theme_stylebox("disabled").get_class()," actor_visible=",actor.is_visible_in_tree())
 var dialog:AcceptDialog=summary.get_children().filter(func(c):return c is AcceptDialog)[0]
 await get_tree().create_timer(.3).timeout;await shot("open-later")
 dialog.queue_free();await shot("closed")
 print("CLOSED disabled=",tap.disabled," actor_visible=",actor.is_visible_in_tree())
 print("MODAL186_OK");get_tree().quit()
