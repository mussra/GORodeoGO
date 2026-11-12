extends Node
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es");SaveData.trial_session_active=false;SaveData.debug_mode=false;SaveData.save_path="user://qa142.dat";SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();GameState.selected_level=1;SaveData.dual_lasso_intro_shown=true
 var level=load("res://src/Presentation/level_0.tscn").instantiate();add_child(level)
 await get_tree().process_frame;await get_tree().process_frame;level.set_process(false);level.set_physics_process(false);level.player.set_physics_process(false)
 for b in level._active_bulls:b.set_physics_process(false);b.set_peers([])
 var bull=level._active_bulls[0];bull.set_player(level.player)
 var overlay:=CanvasLayer.new();overlay.layer=200;add_child(overlay)
 var bar:=ColorRect.new();bar.color=Color("10252d");bar.position=Vector2(20,110);bar.size=Vector2(1240,60);overlay.add_child(bar)
 var title:=Label.new();title.position=Vector2(34,125);title.add_theme_font_size_override("font_size",22);overlay.add_child(title)
 for pair in [[.5,"lenta"],[1.,"base"],[2.,"alta"]]:
  SaveData.horse_collection.find("original")["stats"]={"calm":pair[0]}
  bull.controller=BullController.new(BullState.State.CAPTURED,bull.tuning);bull.controller.state_changed.connect(bull._on_state_changed);bull.position=level.player.position+Vector2(60,60)
  for step in 180:bull._physics_process(1./60.)
  title.text="Simulación: Serenidad ×%.1f · 3s de lazo · nervios %.1f / 100"%[pair[0],bull.controller.current_nerves()]
  await get_tree().process_frame;await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png("/downloads/serenidad142-"+str(pair[1])+".png")
  print("SERENITY142 ",pair[0]," nerves=",bull.controller.current_nerves())
 level.free();get_tree().quit()
