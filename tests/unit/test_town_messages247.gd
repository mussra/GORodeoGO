extends GutTest
func test_terminal_relays_first_pending_and_points_to_next_without_completing_all():
 var seed_:int=752026;var nodes:=TownNetwork234.base_nodes(seed_);var leaf:Dictionary={}
 for n in nodes.values():
  if 'saddler' in n.roles and not n.targets.has('saddler'):leaf=n;break
 var initial:Dictionary={'heard247':{}};var result:=TownMessages247.open(seed_,initial,leaf.id,'saddler')
 assert_false(result.relayed.is_empty());assert_false(result.target.is_empty());assert_false(result.complete)
 assert_eq(result.state.heard247[TownMessages247.key(leaf.id,'saddler')],'direct')
 assert_eq(result.state.heard247[TownMessages247.key(result.relayed,'saddler')],'relayed')
 assert_false(result.state.heard247.has(TownMessages247.key(result.target,'saddler')))
 assert_eq(initial,{'heard247':{}},'Pure resolution cannot mutate the saved state')
func test_repeated_leaf_eventually_recounts_every_missing_message_then_finishes():
 var seed_:int=752026;var leaf:=TownNetwork234.cell_node(seed_,Vector2i(30,40));var role_:String=leaf.roles[0];var state:Dictionary={};var count_:int=0
 while count_<100:
  var result:=TownMessages247.open(seed_,state,leaf.id,role_);state=result.state;count_+=1
  if result.complete:break
 assert_lt(count_,100);assert_eq(TownMessages247.pending(seed_,state,role_),[])
 var final:=TownMessages247.open(seed_,state,leaf.id,role_);assert_eq(final.relayed,'');assert_eq(final.target,'');assert_true(final.complete)
 for key_ in state.heard247:assert_true(str(key_).ends_with('|'+role_),'Other offices stay separate')
func test_known_and_revealed_are_not_conversations_and_invalid_records_are_removed():
 var seed_:int=752026;var state:Dictionary={'known':{'home':true},'revealed215':{'home':true}}
 assert_true('home' in TownMessages247.pending(seed_,state,'saddler'))
 var clean:=TownMessages247.clean({'home|saddler':'direct','home|florist':'relayed','home|bogus':'direct','bad|saddler':'direct','home|farmer':'visited'},seed_)
 assert_eq(clean,{'home|saddler':'direct','home|florist':'relayed'})
func test_normal_forward_recommendation_is_preserved():
 var seed_:int=752026;var state:Dictionary={}
 for role_ in TownNetwork234.ROLES:
  var result:=TownMessages247.open(seed_,state,'home',role_)
  assert_eq(result.target,TownNetwork234.base_nodes(seed_).home.targets[role_]);assert_eq(result.relayed,'');assert_false(result.complete)

func test_just_one_missing_is_told_here_without_sending_back():
 var seed_:int=752026;var state:Dictionary={'heard247':{}};var role_:String='saddler';var missing:String='home'
 for n in TownNetwork234.base_nodes(seed_).values():
  if role_ in n.roles and n.id!=missing:state.heard247[TownMessages247.key(n.id,role_)]='direct'
 var leaf:=TownNetwork234.cell_node(seed_,Vector2i(30,40))
 for cell_ in [Vector2i(30,40),Vector2i(31,40),Vector2i(32,40),Vector2i(33,40)]:
  var n:=TownNetwork234.cell_node(seed_,cell_)
  if role_ in n.roles:leaf=n;break
 var result:=TownMessages247.open(seed_,state,leaf.id,role_)
 assert_eq(result.relayed,missing);assert_eq(result.target,'');assert_true(result.complete)
 assert_eq(result.state.heard247[TownMessages247.key(missing,role_)],'relayed')
