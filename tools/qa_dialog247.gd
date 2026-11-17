extends Node
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(1600,720)
 TranslationServer.set_locale('es');GameState.sound_enabled=false
 SaveData.save_path='user://qa246-only.dat';SaveData.trial_session_active=true;SaveData.world_seed=752026;SaveData.world_generator_version=6;SaveData.world_position=Vector2(1300,850);SaveData.world_edits=[];SaveData.world_discovered=[];SaveData.world_quests={};SaveData.horse_collection.seed_trial()
 for x in range(-5,15):
  for y in range(-5,15):SaveData.world_discovered.append(WorldMap.chunk_key(x,y))
 var world=load('res://tools/perf_world242.gd').new();add_child(world);get_tree().current_scene=self
 while world._loading_world:await get_tree().process_frame
 await get_tree().create_timer(2.).timeout
 if world._arrival244.active:world._arrival244.finish(false)
 world._arrival244.set_process(false);world.player.set_physics_process(false)
 GameState.set_performance_osd245(true)
 var nodes:Dictionary=TownNetwork234.nodes(SaveData.world_seed)
 var cases:Dictionary={}
 for n in nodes.values():
  for role_ in n.roles:
   var hops:int=TownNetwork234.recommendation_path(SaveData.world_seed,n.id,role_).size()-1
   var key:String='end' if hops==0 else 'next' if hops==1 else 'via'
   if not cases.has(key):cases[key]={'town':n.id,'role':role_}
 for n in nodes.values():
  if 'saddler' in n.roles and not n.targets.has('saddler'):cases['saddler']={'town':n.id,'role':'saddler'};break
 cases['complete']=cases['saddler']
 for key in ['end','next','via','saddler','complete']:
  var spec:Dictionary=cases[key]
  if key=='complete':
   SaveData.world_cousins140['heard247']={}
   for n in TownNetwork234.base_nodes(SaveData.world_seed).values():
    for r in n.roles:SaveData.world_cousins140.heard247[TownMessages247.key(n.id,r)]='direct'
  var dialog:=TownDialog234.new();dialog.town=spec.town;dialog.role=spec.role;world._hud.add_child(dialog);world._npc_dialog=dialog
  await get_tree().create_timer(.7).timeout;await RenderingServer.frame_post_draw
  get_viewport().get_texture().get_image().save_png('/downloads/dialog247-'+str(get_meta('phase','after'))+'-'+key+'.png')
  dialog.free();world._npc_dialog=null
 world.free();get_tree().quit()
