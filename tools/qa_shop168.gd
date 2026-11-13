extends Node
var panel:FinishShop168
func _ready():run.call_deferred()
func shot(name_:String):
 await get_tree().process_frame;await get_tree().process_frame;await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png("/downloads/shop168-"+name_+".png")
func run():
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(1280,720)
 SaveData.save_path="user://qa-shop168.dat";SaveData._load_valid=true;SaveData.trial_session_active=false;SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.world_position=WorldNominal98.home();SaveData.world_edits=[];SaveData.world_roaming139={};SaveData.country_ledger146={};SaveData.world_missions={};SaveData.world_quests={};SaveData.world_discovered=[];SaveData.world_places144={};SaveData.world_cousins140={};SaveData.world_flora138={};SaveData.world_pig_captures=[];SaveData.world_goat_captures=[];SaveData.world_pigs_sold=0;SaveData.repeat_contract165=ProgressionEconomy165.new_contract();SaveData.equipment_points=200000;SaveData.equipment_owned=[];SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial()
 panel=FinishShop168.new();add_child(panel);await shot("locked");assert(panel.buys[0].disabled)
 for i in 280:SaveData.world_pig_captures.append("qa-pig%d"%i)
 for i in 220:SaveData.world_goat_captures.append("qa-goat%d"%i)
 SaveData.repeat_contract165=ProgressionEconomy165.new_contract(56);panel.refresh();await shot("eligible")
 for i in 3:panel.buys[i].pressed.emit();assert(SaveData.equipment_owned.has("finish_"+SpecialFinish145.IDS[i]))
 assert(SaveData.equipment_points==68000)
 panel.equips[1].pressed.emit();assert(HorseFinish168.style(SaveData.horse_collection.find("original"))=="crystal");await shot("equipped")
 get_tree().root.size=Vector2i(960,540);await shot("small");get_tree().root.size=Vector2i(1280,720)
 panel.queue_free();await get_tree().process_frame
 var world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 await get_tree().create_timer(1.2).timeout;world.set_process(false);world.set_physics_process(false);world.player.set_physics_process(false)
 var sprite:AnimatedSprite2D=world.player._sprite_swap._sprite
 for style in ["gold","crystal","ice"]:
  SaveData.horse_collection.find("original").special_finish168=style
  for anim in ["walk_side","walk_up","walk_diag_down","jump_down","idle","rest_gesture107"]:
   sprite.play(anim);sprite.pause();sprite.frame=0;HorseFinish168.update(sprite,SaveData.horse_collection.find("original"))
   assert(sprite.material!=null);assert(sprite.material.get_shader_parameter("style")==SpecialFinish145.IDS.find(style)+1)
   await shot(style+"-"+anim)
 world.queue_free();await get_tree().process_frame;print("SHOP168_QA_PURCHASE_EQUIP_ALL_STYLES_OK");get_tree().quit()
