extends GutTest
func test_graph_is_connected_orthogonal_reciprocal_and_uses_all_road_kinds():
 var graph=ModularWorldLayout93.graph();var kinds={};var seen={};var queue=[graph.keys()[0]]
 while not queue.is_empty():
  var cell=queue.pop_front()
  if seen.has(cell):continue
  seen[cell]=true
  for next in graph[cell]:queue.append(next)
 assert_eq(seen.size(),graph.size())
 for cell in graph:
  var piece=ModularWorldLayout93.piece(graph,cell);assert_false(piece.is_empty());kinds[piece.kind]=true
  for next in graph[cell]:
   assert_eq(absi(next.x-cell.x)+absi(next.y-cell.y),1)
   assert_true(graph[next].has(cell))
  for i in 4:assert_eq(piece.ports[i],int(graph[cell].has(cell+ModularWorldLayout93.DIRS[i])))
 for kind in ["straight","corner","cross","t","end"]:assert_true(kinds.has(kind),kind)
func test_all_four_doors_connect_to_network_as_endpoints():
 var graph=ModularWorldLayout93.graph()
 for id in ModularWorldLayout93.DOORS:
  var cell=ModularWorldLayout93.DOORS[id]
  assert_true(graph.has(cell));assert_eq(graph[cell].size(),1)
  assert_eq(ModularWorldLayout93.piece(graph,cell).kind,"end")
  assert_eq(ModularWorldLayout93.nearest_distance(ModularWorldLayout93.world(cell)),0.)
