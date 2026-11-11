extends Node
var world
var note:Label
func _ready():run.call_deferred()
func shot(path:String):
 for i in 3:await get_tree().process_frame
 await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png(path)
func tick(actor,goat:bool,seconds:float,follow:bool=true):
 for i in roundi(seconds*20):
  if not is_instance_valid(actor) or actor.is_queued_for_deletion():break
  if follow:world.player.position=actor.position-Vector2(120,0)
  if goat:world._tick_goats(.05)
  else:world._tick_pigs(.05)
  await get_tree().process_frame
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es")
 SaveData.save_path="user://qa-escape78.cfg";SaveData.trial_session_active=true;SaveData.world_seed=7781;SaveData.world_position=Vector2(-360,400);SaveData.world_edits=[];SaveData.world_tamed=[];SaveData.world_pigs=[];SaveData.world_quests={};SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 world.set_process(false);world.set_physics_process(false);world.player.set_physics_process(false)
 for chunk in world._chunks.values():
  var pen=chunk.get_node_or_null("pigs")
  if pen!=null:pen.queue_free()
 for g in world._prototype_goats.get_children():g.queue_free()
 await get_tree().process_frame
 var layer=CanvasLayer.new();layer.layer=120;add_child(layer);note=Label.new();note.position=Vector2(25,110);note.add_theme_font_size_override("font_size",24);note.add_theme_color_override("font_color",Color("ffdf8b"));layer.add_child(note)
 var goat=world.GoatScript.new();goat.setup({"pos":Vector2(-2549,2000)});goat.set_meta("origin",Vector2(-600,500));world._prototype_goats.add_child(goat);goat.position=Vector2(-2000,2000)
 world.player.position=goat.position-Vector2(220,0);world.player.dodge_available=true;world.player.set_physics_process(true);world.player.request_dodge(Vector2.RIGHT);world.player.set_physics_process(false)
 world.player.dodge.step_dash(world.player.max_speed,.1);world.player.dodge.cancel()
 note.text="QA · Cabra: regate en el borde; gira y sigue huyendo"
 await tick(goat,true,2);await shot("/downloads/escape2778-goat-running.png")
 note.text="QA · La energía baja mientras corre"
 await tick(goat,true,5.1);await shot("/downloads/escape2778-goat-tired.png")
 note.text="QA · Sin lazo: descansa y recupera energía"
 await tick(goat,true,2.5);await shot("/downloads/escape2778-goat-recover.png")
 await tick(goat,true,2.6)
 note.text="QA · Recuperada: vuelve a huir"
 await tick(goat,true,.8);await shot("/downloads/escape2778-goat-restart.png")
 goat.queue_free();await get_tree().process_frame
 var chunk=world._chunks.values()[0];var pen=Node2D.new();pen.name="pigs";chunk.add_child(pen)
 var pig=world.PigScript.new();pig.name="QA_pig";pig.setup({"pos":world.player.position+Vector2(120,0)-Vector2(419,0)});pen.add_child(pig);pig.position=world.player.position+Vector2(120,0)
 note.text="QA · Cerdo: misma energía, sin bloqueo en el borde"
 await tick(pig,false,3.5);await shot("/downloads/escape2778-pig-running.png")
 await tick(pig,false,3.6);await shot("/downloads/escape2778-pig-tired.png")
 note.text="QA · Agotado y enlazado: ventana de captura"
 NpcQuests.accept(SaveData.world_quests,"farmer_pigs");world._on_lasso_prey_captured(pig)
 await tick(pig,false,.5);await shot("/downloads/escape2778-capture.png")
 await tick(pig,false,.6);await get_tree().process_frame
 note.text="QA · Diálogo de prueba: eventos adicionales para mostrar el cierre"
 world._quest_event("capture_animal","pig","qa-extra-one");world._quest_event("capture_animal","pig","qa-extra-two");world._quest_event("capture_animal","pig","qa-extra-three")
 world.player.position=NpcQuests.NPCS[0].position+Vector2(0,80);world._open_npc(NpcQuests.NPCS[0]);await shot("/downloads/escape2778-thanks.png")
 await get_tree().create_timer(1).timeout;get_tree().quit()
