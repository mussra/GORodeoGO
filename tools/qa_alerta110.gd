extends Node
var world:Node2D
func _ready():run.call_deferred()
func shot(name_:String):
 await get_tree().process_frame;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/alerta110-"+("telefono-" if OS.get_environment("MAP106_SMALL")=="1" else "")+name_+".png")
func run():
 get_tree().root.size=Vector2i(896,414) if OS.get_environment("MAP106_SMALL")=="1" else Vector2i(1598,720);TranslationServer.set_locale("es")
 SaveData.save_path="user://qa106.dat";SaveData.trial_session_active=true;SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.world_edits=[];SaveData.world_discovered=[];SaveData.world_missions={};SaveData.world_quests={};SaveData.world_notes106={};SaveData.horse_collection.seed_trial();SaveData.world_position=WorldNominal98.home()
 world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 await get_tree().create_timer(1.).timeout
 world.player.set_physics_process(false);world.player.velocity=Vector2.ZERO;world._toasts.clear();world._toasts.visible=false
 world.player.position=WorldNominal98.home()+Vector2(0,500);world.player.velocity=Vector2.RIGHT*70.
 for item in world._herd_horses.values():item.set_physics_process(false)
 world.set_physics_process(false);world.set_process(false)
 var base:Vector2=world.player.position
 var group:Array=[]
 for i in 4:
  var horse=world.WildHorseScript.new();horse.setup({"pos":base+Vector2(150+i*55,30+i*35),"member_id":"qa110#"+str(i),"member_index":i,"traits":{"coat":3+i,"mane":1,"pattern":i},"temperament":.2,"stats":{"speed":260}});horse.set_meta("c",Vector2i(99,99));world.add_child(horse);horse.set_physics_process(false);horse.player_ref=world.player;group.append(horse);world._herd_horses[horse.herd.member_id]=horse
 for tick in 20:world._tick_taming(.016)
 await shot("alerta")
 world._on_lasso_prey_captured(group[0]);await shot("captura")
 for tick in 100:
  world._tick_taming(.016)
  for i in range(1,4):group[i]._physics_process(.016)
 await shot("huida")
 for tick in 160:
  world._tick_taming(.016)
  for i in range(1,4):group[i]._physics_process(.016)
 await shot("fuera")
 world._quest_toggle.pressed.emit();await shot("encargos")
 get_tree().quit()
