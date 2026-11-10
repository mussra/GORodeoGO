extends Node
var panel
var note:Label
func _ready()->void:run.call_deferred()
func shot(path:String)->void:
 for i in 5:await get_tree().process_frame
 await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png(path)
func show_mode(debug:bool,trial:bool)->void:
 if is_instance_valid(panel):panel.queue_free();await get_tree().process_frame
 SaveData.debug_mode=debug;SaveData.trial_session_active=trial
 panel=HorsePanel.new();panel.page="detail";panel.focus_id="original";add_child(panel)
 note.text="MODO DEBUG · edición permitida" if debug else ("PRUEBA AISLADA · edición permitida" if trial else "MODO NORMAL · solo lectura y acciones del juego")
func run()->void:
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es")
 SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.horse_collection.add_trial_parents()
 var layer=CanvasLayer.new();layer.layer=120;add_child(layer);note=Label.new();note.position=Vector2(25,680);note.add_theme_font_size_override("font_size",18);layer.add_child(note)
 await show_mode(false,false);await shot("/downloads/normal2772.png");await get_tree().create_timer(2).timeout
 var scroll:ScrollContainer=find_scroll(panel);scroll.scroll_vertical=10000;await shot("/downloads/normal2772-actions.png");await get_tree().create_timer(1).timeout
 await show_mode(true,false);await shot("/downloads/debug2772.png");await get_tree().create_timer(2).timeout
 scroll=find_scroll(panel);scroll.scroll_vertical=10000;await shot("/downloads/debug2772-actions.png");await get_tree().create_timer(1).timeout
 await show_mode(false,true);await shot("/downloads/trial2772.png");await get_tree().create_timer(1).timeout
 get_tree().quit()
func find_scroll(node:Node)->ScrollContainer:
 if node is ScrollContainer:return node
 for c in node.get_children():
  var s=find_scroll(c)
  if s!=null:return s
 return null
