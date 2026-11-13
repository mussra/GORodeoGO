extends Node
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(960,540);TranslationServer.set_locale("es");SaveData.horse_collection.seed_trial();SaveData.horse_collection.add_trial_parents()
 var h=SaveData.horse_collection.find("trial_a");h.traits.finish="galaxy";h.name="Galaxy · ejemplo de maestría";h["completed_levels"]=[]
 h.traits["emblem"]=HorseEmblem.DEFAULT.duplicate(true)
 var panel=HorsePanel.new();panel.page="detail";panel.focus_id=h.id;add_child(panel)
 for stage in 4:
  h["completed_levels"]=[]
  h["mastery_rule179"]=1;h.erase("mastery_legacy179")
  h.completed_levels=[[],[36,37],[36,37,38,39,40],range(1,21)][stage]
  if stage==3:h["mastery_legacy179"]=true
  panel.refresh();await get_tree().create_timer(.6).timeout;await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png("/downloads/mastery-%d179.png"%stage)
 get_tree().quit()
