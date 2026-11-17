extends Node
var world:Node2D
func _ready():run.call_deferred()
func capture(label_:String):
 await get_tree().create_timer(.15).timeout;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png('/downloads/qa249-'+label_+'.png')
func touch(p:Vector2,down:bool,index:int=0):
 var e:=InputEventScreenTouch.new();e.position=get_viewport().get_final_transform()*p;e.index=index;e.pressed=down;Input.parse_input_event(e);Input.flush_buffered_events()
func drag(p:Vector2):
 var e:=InputEventScreenDrag.new();e.position=get_viewport().get_final_transform()*p;Input.parse_input_event(e);Input.flush_buffered_events()
func run():
 get_tree().root.size=Vector2i(1600,720);TranslationServer.set_locale('es');GameState.sound_enabled=false
 SaveData.save_path='user://qa249-scratch.dat';SaveData._load_valid=true;SaveData.trial_session_active=true;SaveData.world_seed=752026;SaveData.world_generator_version=6;SaveData.world_position=Vector2(1300,850);SaveData.world_edits=[];SaveData.world_discovered=[];SaveData.world_quests={};SaveData.world_jobs249={};SaveData.world_cousins140={};SaveData.world_flora138={};SaveData.world_herd_town217={};SaveData.horse_collection.seed_trial();SaveData.world_garden212=Garden212.fresh()
 for x in range(-3,4):
  for y in range(-3,4):SaveData.world_discovered.append(WorldMap.chunk_key(x,y))
 world=load('res://src/Presentation/frontier_world.gd').new();add_child(world);get_tree().current_scene=self
 while world._loading_world:await get_tree().process_frame
 await get_tree().create_timer(1.).timeout
 if world._arrival244.active:world._arrival244.finish(false)
 world._arrival244.set_process(false);world._camera_controls243.set_factor(1.,false)
 var cases:Dictionary={}
 for data in world._npcs98():
  if data.town234!='home' and not cases.has(data.role234):cases[data.role234]=data
 for role_ in ['farmer','florist','saddler','loco']:
  var data:Dictionary=cases[role_];world.player.position=data.position
  if role_=='farmer':SaveData.world_pig_captures=['owned-pig'];SaveData.world_goat_captures=['owned-goat'];SaveData.world_pigs_sold=0;SaveData.world_goats_given249=0
  world._open_npc(data);await capture('job-'+role_);world._close_npc();await get_tree().process_frame
 var data:Dictionary=cases.saddler;SaveData.world_jobs249[TownJobs249.key(data.town234,data.role234)]={'status':'done','count':1,'events':['qa-tame'],'thanked':true}
 world.player.position=data.position;world._open_npc(data);await capture('recommendation');world._close_npc();await get_tree().process_frame
 for data_ in world._npcs98():
  if SaveData.world_jobs249.size()>=10:break
  var q:=TownJobs249.job(SaveData.world_seed,data_.town234,data_.role234)
  NpcQuests.accept(SaveData.world_jobs249,TownJobs249.key(data_.town234,data_.role234),{TownJobs249.key(data_.town234,data_.role234):q})
 world.player.position=Vector2(1300,850);world._quest_panel.show();world._refresh_quest_hud();await capture('scroll-top')
 var p:Vector2=world._quest_details179.get_global_rect().get_center()+Vector2(0,120)
 touch(p,true);await get_tree().process_frame
 for i in 15:drag(p-Vector2(0,(i+1)*20));await get_tree().process_frame
 touch(p-Vector2(0,300),false)
 world._quest_details179.scroll_vertical=100000;await capture('scroll-bottom');world._quest_panel.hide()
 SaveData.world_jobs249={};SaveData.world_cousins140['routes249']={}
 for role_ in TownNetwork234.base_nodes(SaveData.world_seed).home.targets:
  var target:String=TownNetwork234.base_nodes(SaveData.world_seed).home.targets[role_]
  var point:Vector2=TownNetwork234.node_for(SaveData.world_seed,target).door
  if absf(point.y-358.)<5000.:continue
  SaveData.world_cousins140.revealed215[target]=true;SaveData.world_cousins140.routes249['home|'+role_]={'town':'home','role':role_,'target':target}
 world._toggle_map();await capture('map-two-destinations');world._toggle_map()
 world._arrival244.begin(TownEnclosures227.plans(SaveData.world_seed).town1);world._arrival244.elapsed=1.5;world._arrival244.apply_frame();await capture('arrival-title');world._arrival244.finish(false)
 world._camera_controls243.set_factor(.05,false);await capture('zoom-5-initial')
 world.free();get_tree().quit()
