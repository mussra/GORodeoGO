extends Node
var world:Node2D
var label:Label
func _ready():run.call_deferred()
func shot(name_:String,text:String):
 label.text=text
 await get_tree().process_frame;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/lazo128-"+name_+".png")
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es")
 SaveData.save_path="user://qa128.dat";SaveData.trial_session_active=true;SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.world_edits=[];SaveData.world_discovered=[];SaveData.world_missions={};SaveData.world_quests={};SaveData.horse_collection.seed_trial();SaveData.world_position=WorldNominal98.home()
 world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 world.player.set_physics_process(false);world.player.velocity=Vector2.ZERO;world.set_physics_process(false);world.set_process(false)
 for item in world._herd_horses.values():item.free()
 world._herd_horses.clear();world.player.position=WorldNominal98.home()+Vector2(0,500)
 var layer=CanvasLayer.new();layer.layer=100;add_child(layer);var panel=ColorRect.new();panel.color=Color(0,0,0,.8);panel.size=Vector2(1280,100);layer.add_child(panel)
 label=Label.new();label.position=Vector2(24,14);label.add_theme_font_size_override("font_size",25);layer.add_child(label)
 var group:Array=[]
 for i in 4:
  var h=world.WildHorseScript.new();h.setup({"pos":world.player.position+Vector2(180+i*48,(-1 if i%2==0 else 1)*60),"member_id":"qa128#"+str(i),"member_index":i,"traits":{"coat":3+i,"mane":1,"pattern":i},"temperament":.2,"stats":{"speed":260}});h.set_meta("c",Vector2i(99,99));world.add_child(h);h.set_physics_process(false);h.player_ref=world.player;group.append(h);world._herd_horses[h.herd.member_id]=h
 await get_tree().create_timer(.4).timeout
 world.player.lasso.throw_guard=func():return true
 world.player.lasso._charge_distance=180.;world.player.lasso.aim_direction=Vector2.RIGHT
 # Miss at (180,0), all horses60px or more away; flight uses actual controller.
 world.player.lasso._release_throw()
 await get_tree().create_timer(.1).timeout
 await shot("vuelo","Lazo en vuelo: ninguno recibe susto del lanzamiento\nSimulación de escritorio · radio de caída 300 px · sin Android físico")
 await get_tree().create_timer(.3).timeout
 for tick in 28:
  world._tick_taming(.016)
  for h in group:h._physics_process(.016)
 await shot("fallo","El lazo cae y falla: todos los cercanos huyen\nSimulación de escritorio · radio 300 px desde caída")
 world.player.lasso.cancel_all_actions();world._end_lasso()
 for i in group.size():
  var h=group[i];h.position=world.player.position+Vector2(180+i*40,i*40);h.state=WorldTaming.new_state();h.set_meta("panic_left",0.);h.set_meta("escape_left110",0.);h._flee=Vector2.ZERO
 world.player.lasso._charge_distance=180.;world.player.lasso._release_throw()
 await get_tree().create_timer(.4).timeout
 for tick in 24:
  world._tick_taming(.016)
  for h in group:h._physics_process(.016)
 await shot("captura","Caída con captura: el atrapado se queda, los demás huyen\nSimulación de escritorio · mismo controlador de lazo")
 get_tree().quit()
