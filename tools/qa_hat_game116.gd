extends Node
var world:Node2D
func _ready():run.call_deferred()
func shot(name_:String):
 await get_tree().process_frame;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/sombrero-game116-"+("telefono-" if OS.get_environment("MAP106_SMALL")=="1" else "")+name_+".png")
func run():
 get_tree().root.size=Vector2i(896,414) if OS.get_environment("MAP106_SMALL")=="1" else Vector2i(1598,720);TranslationServer.set_locale("es")
 SaveData.save_path="user://qa106.dat";SaveData.trial_session_active=true;SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.world_edits=[];SaveData.world_discovered=[];SaveData.world_missions={};SaveData.world_quests={};SaveData.world_notes106={};SaveData.horse_collection.seed_trial();SaveData.world_position=WorldNominal98.home()
 world=load("res://src/Presentation/frontier_world.gd").new();add_child(world)
 while world._loading_world:await get_tree().process_frame
 await get_tree().create_timer(1.).timeout
 world.player.set_physics_process(false);world.player.velocity=Vector2.ZERO;world._toasts.clear();world._toasts.visible=false
 world.player.position=WorldNominal98.home()+Vector2(0,400)
 world.player.set_physics_process(false);world.set_physics_process(false);world.set_process(false)
 var horse:Dictionary=SaveData.horse_collection.find(SaveData.horse_collection.selected)
 for pair in [[3,13,"arcoiris"],[6,14,"galaxia"],[4,11,"vaca"],[5,0,"rojo"],[3,0,"azul"],[1,0,"blanco"],[0,0,"oscuro"]]:
  SaveData.hat_color=HatAppearance.encode(pair[0],pair[1])
  var frames=SpriteFrames.new();PixelLabTrial.apply(frames,"rider","walk_side",horse.traits,horse)
  var swap=world.player._sprite_swap;swap.restore_movement107();swap._sprite.sprite_frames=frames;swap.rest107.reset()
  RiderGaitVisual.apply(swap,Vector2.ZERO,270,0,.1);await shot(pair[2]+"-reposo")
  RiderGaitVisual.apply(swap,Vector2.RIGHT*180.,270,1,.1);await get_tree().create_timer(.15).timeout;await shot(pair[2]+"-marcha")
 get_tree().quit()
