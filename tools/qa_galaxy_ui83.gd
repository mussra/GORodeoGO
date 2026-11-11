extends Node
func _ready():run.call_deferred()
func shot(path:String):
 await get_tree().create_timer(.5).timeout;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png(path)
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es");SaveData.horse_collection.seed_trial()
 var h=SaveData.horse_collection.find("original");h.traits.finish="galaxy"
 for n in range(1,21):HorseMastery.record(SaveData.horse_collection,h.id,n)
 var hats=HatPanel.new();add_child(hats)
 await shot("/downloads/galaxy-hats-final83.png");remove_child(hats);hats.queue_free()
 SaveData.highest_level_completed=20
 var panel=HorsePanel.new();panel.page="market";add_child(panel)
 await shot("/downloads/galaxy-market-final83.png")
 for node in panel.content.get_children():
  if node is ScrollContainer:node.scroll_vertical=1250
 await shot("/downloads/galaxy-market-galaxy-final83.png");remove_child(panel);panel.queue_free()
 var host=Control.new();host.size=Vector2(1280,720);add_child(host)
 var bg=ColorRect.new();bg.color=Color("10252d");bg.size=host.size;host.add_child(bg)
 for i in 4:
  h.completed_levels=[]
  for n in range(1,[1,11,20,21][i]):HorseMastery.record(SaveData.horse_collection,h.id,n)
  HorsePicker.preview(host,h,Vector2(i*310+10,40),300)
  var icon=TextureRect.new();icon.texture=HorsePicker.thumbnail(h);icon.position=Vector2(i*310+100,400);icon.size=Vector2(112,112);icon.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;icon.texture_filter=CanvasItem.TEXTURE_FILTER_NEAREST;host.add_child(icon)
  var l=Label.new();l.text=str([0,50,95,100][i])+"%";l.position=Vector2(i*310+140,540);l.add_theme_font_size_override("font_size",26);host.add_child(l)
 await shot("/downloads/galaxy-thumbnails-final83.png");get_tree().quit()
