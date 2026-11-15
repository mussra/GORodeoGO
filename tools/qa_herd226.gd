extends Node
func _ready():run.call_deferred()
func shot(id:String):
 for i in 5:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/herd226-"+id+"-960.png")
func run():
 get_tree().root.size=Vector2i(960,540);TranslationServer.set_locale("es");GameState.brand_intro_played=true
 SaveData.save_path="user://herd226-visual-only.cfg";SaveData._load_valid=true;SaveData.world_seed=752026;SaveData.world_generator_version=3
 SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.world_quests={};SaveData.world_missions={};SaveData.world_tamed=[];SaveData.world_roaming139={};SaveData.world_herd_town217={}
 SaveData.world_flora138=FloristJourney138.fresh([]);SaveData.world_cousins140=VillageCousins140.fresh(752026,[],SaveData.world_flora138)
 var choice:Vector2i;var base:Dictionary={};var distance:float=INF
 for cy in range(-4,5):
  for cx in range(-4,7):
   var data:Dictionary=WorldMap.generate(752026,cx,cy).get("herd",{})
   if data.is_empty():continue
   var look:=TownIdentity215.look(SaveData.world_cousins140,"home")
   if data.traits.coat==look.coat or data.traits.pattern==look.pattern:continue
   var d:float=(data.pos as Vector2).distance_to(Vector2(1680,300))
   if d<distance:choice=Vector2i(cx,cy);base=data;distance=d
 var key:String=WorldMap.chunk_key(choice.x,choice.y);var before:Array=WorldHerd.members(base,752026,choice.x,choice.y,false)
 print("QA226 CHOICE ",choice," base ",base.pos," town ",TownIdentity215.look(SaveData.world_cousins140,"home")," traits ",before.map(func(h):return h.traits))
 var legacy:Dictionary={"version":1,"seed":752026,"towns":SaveData.world_cousins140.duplicate(true),"excluded":{key:true},"herds":{key:before.map(func(h):return h.traits.duplicate(true))}}
 SaveData.world_discovered=[key];SaveData.world_position=base.pos+Vector2(-220,90)
 for stage in ["before","after"]:
  SaveData.world_herd_town217=legacy.duplicate(true)
  if stage=="before":SaveData.world_herd_town217.version=2;SaveData.world_herd_town217.revised226={key:true}
  var world=load("res://src/Presentation/frontier_world.tscn").instantiate();add_child(world)
  while world._loading_world:await get_tree().process_frame
  await get_tree().create_timer(.5).timeout;world.set_process(false);world.set_physics_process(false)
  for horse in world._herd_horses.values():horse.set_process(false);horse.set_physics_process(false)
  get_viewport().get_camera_2d().position=Vector2.ZERO;world.player.position=SaveData.world_position
  await shot(stage)
  print("QA226 ",stage," rows ",SaveData.world_herd_town217.herds.get(key,[]))
  world.free();await get_tree().process_frame
 get_tree().quit()
