extends "res://tools/qa_flowers139.gd"
func snap140(name_:String,text:String):
 title.text=text
 await get_tree().process_frame;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/primos140/"+name_+".png")
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es")
 SaveData.save_path="user://qa-cousins140.dat";SaveData.trial_session_active=false;SaveData._load_valid=true;SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.world_edits=[];SaveData.world_flora138={};SaveData.world_roaming139={};SaveData.world_cousins140={};SaveData.world_discovered=[];SaveData.world_missions={};SaveData.world_quests={};SaveData.horse_collection.seed_trial();SaveData.world_position=WorldNominal98.home()
 world=load("res://src/Presentation/frontier_world.gd").new();add_child(world);world.set_physics_process(false)
 while world._loading_world:await get_tree().process_frame
 world.set_process(false);world.player.set_physics_process(false);world._toasts.visible=false
 var layer:=CanvasLayer.new();layer.layer=200;add_child(layer);var bar:=ColorRect.new();bar.color=Color("10252d");bar.size=Vector2(1280,56);layer.add_child(bar);title=Label.new();title.position=Vector2(18,16);title.add_theme_font_size_override("font_size",23);layer.add_child(title)
 await get_tree().create_timer(1.).timeout
 for id in VillageCousins140.IDS:
  await move_to(VillageCousins140.point(SaveData.world_cousins140,id)+Vector2(90,30))
  world._tick_npcs()
  await snap140(id+"-mundo","Primo estático de 90px · "+str(VillageCousins140.LABELS[id]))
  world._open_cousin140(id);await snap140(id+"-pista","Pista distinta por pueblo · diario guardado")
  world._npc_dialog.body.text=VillageCousins140.cousin_hint(SaveData.world_cousins140,id)
  await snap140(id+"-primos","Dirección cardinal a un primo aún desconocido")
  world._close_npc();world.player.set_physics_process(false)
 world._show_journal140();await snap140("diario","Diario persistente · cuatro primos y cuatro pistas")
 world._journal140.queue_free();world._journal140=null
 SaveData.horse_collection.find(SaveData.horse_collection.selected).species="unicorn"
 await get_tree().process_frame
 world._open_cousin140("east140");await snap140("sorpresa","Variante de sorpresa · montura unicornio solo en partida de QA")
 print("COUSINS140_QA_DONE ",SaveData.world_cousins140)
 get_tree().quit()
