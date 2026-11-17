extends "res://tests/integration/test_herd_migration226.gd"
func test_goat_container_participates_in_world_feet_sort_and_jump_keeps_same_layer():
 SaveData.world_generator_version=6;SaveData.world_cousins140={};SaveData.world_flora138={};SaveData.world_herd_town217={};SaveData.world_discovered=[];SaveData.world_tamed=[];SaveData.world_garden212=Garden212.fresh();SaveData.world_position=WorldNominal98.home()
 await launch()
 assert_true(world.y_sort_enabled);assert_true(world._prototype_goats.y_sort_enabled)
 var goat=load('res://src/Presentation/wild_goat.gd').new();goat.setup({'pos':Vector2(200,600)});world._prototype_goats.add_child(goat)
 goat._fence_jump=.3;goat._process(0.)
 assert_eq(goat.z_index,world.player.z_index);assert_lt(goat.goat_art.position.y,0.,'Jump still lifts the art; no universal foreground layer')
 for chunk in world._chunks.values():assert_true(chunk.y_sort_enabled)
func test_destination_preview_name_below_image_no_technical_text_and_mounted_time():
 SaveData.world_generator_version=6;SaveData.world_cousins140={};SaveData.world_flora138={};SaveData.world_herd_town217={};SaveData.world_discovered=[];SaveData.world_tamed=[];SaveData.world_garden212=Garden212.fresh();SaveData.world_position=WorldNominal98.home()
 await launch()
 var data:Dictionary={}
 for n in world._npcs98():
  if n.town234=='home' and n.role234=='loco':data=n;break
 world.player.position=data.position;world._open_npc(data)
 var dialog:TownDialog234=world._npc_dialog;var preview:TownThumbnail248=dialog.get_node('DestinationThumbnail248')
 assert_eq(preview.town,TownNetwork234.base_nodes(SaveData.world_seed).home.targets.loco)
 assert_false(dialog.body247.text.contains('muralla'));assert_false(dialog.body247.text.contains('unidades'));assert_false(dialog.body247.text.contains('u/s'))
 assert_true(dialog.route247.text.begins_with('Tardarás aproximadamente '));assert_true(dialog.route247.text.ends_with('con ese caballo.'));assert_false(dialog.route247.text.contains(' - '))
 var below:bool=false
 for child in dialog.get_children():
  if child is Label:
   assert_false(child.text.contains(' · Inicio'));assert_false(child.text.contains(',0'))
   if child.text==TownIdentity215.display_name248(SaveData.world_cousins140,preview.town):below=child.position.y>=preview.position.y+preview.size.y
 assert_true(below)
func test_relay_card_name_direction_time_and_marker_share_one_pending_target():
 SaveData.world_generator_version=6;SaveData.world_cousins140={};SaveData.world_flora138={};SaveData.world_herd_town217={};SaveData.world_discovered=[];SaveData.world_tamed=[];SaveData.world_garden212=Garden212.fresh();SaveData.world_position=WorldNominal98.home()
 await launch()
 var data:Dictionary={}
 for n in world._npcs98():
  if not TownNetwork234.node_for(SaveData.world_seed,n.town234).targets.has(n.role234):data=n;break
 world.player.position=data.position;world._open_npc(data)
 var dialog:TownDialog234=world._npc_dialog;var target_:String=dialog.conversation247.target
 assert_false(target_.is_empty());assert_eq(dialog.get_node('DestinationThumbnail248').town,target_)
 var expected_direction:String=TownMessages247.direction248(TownNetwork234.node_for(SaveData.world_seed,data.town234).door,TownNetwork234.node_for(SaveData.world_seed,target_).door)
 assert_true(dialog.route247.text.begins_with('El siguiente recado está al '+expected_direction+'.'))
 var horse_:Dictionary=SaveData.horse_collection.find(SaveData.horse_collection.selected)
 var distance_:float=TravelEstimate237.between248(SaveData.world_seed,data.town234,target_,data.role234)
 var seconds_:float=TravelEstimate237.seconds(distance_,horse_,dialog.energy237,Garden212.multiplier(SaveData.world_garden212,SaveData.horse_collection.selected))
 assert_true(dialog.route247.text.ends_with(TravelEstimate237.minutes248(seconds_)))
 dialog.recommend_requested.emit(target_);assert_eq(SaveData.world_cousins140.hint215,target_)
