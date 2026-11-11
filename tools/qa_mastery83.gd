extends Node
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es");SaveData.horse_collection.seed_trial();SaveData.horse_collection.add_trial_parents()
 var h=SaveData.horse_collection.find("trial_a");h.traits.finish="galaxy";h.name="Galaxy · ejemplo de maestría";h["completed_levels"]=[]
 var panel=HorsePanel.new();panel.page="detail";panel.focus_id=h.id;add_child(panel)
 for stage in 2:
  h["completed_levels"]=[]
  for n in range(1,20 if stage==0 else 21):h.completed_levels.append(n)
  panel.refresh();await get_tree().create_timer(.6).timeout;await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png("/downloads/mastery-%d83.png"%stage)
 get_tree().quit()
