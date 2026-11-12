extends GutTest
func test_sparse_index_moves_between_current_chunks_and_rejects_bad_rows():
 var store:=WorldHerdPositions139.new();store.setup({},42)
 var c:=Vector2i(-2,3);var id:=WorldHerd.member_id(c.x,c.y,1)
 store.put(id,c,1,Vector2(50,100));assert_eq(store.in_chunk(Vector2i.ZERO),[id])
 store.put(id,c,1,Vector2(5000,-2000));assert_eq(store.in_chunk(Vector2i.ZERO),[])
 assert_eq(store.in_chunk(Vector2i(4,-2)),[id]);assert_eq(store.state.horses.size(),1)
 var clean:=WorldHerdPositions139.clean(store.state,42);assert_eq(clean,store.state)
 assert_true(WorldHerdPositions139.clean(store.state,43).horses.is_empty())
 var bad:Dictionary=store.state.duplicate(true);bad.horses[id].pos=Vector2(INF,NAN)
 assert_true(WorldHerdPositions139.clean(bad,42).horses.is_empty())
 bad=store.state.duplicate(true);bad.horses[id].index=100
 assert_true(WorldHerdPositions139.clean(bad,42).horses.is_empty())
 store.erase(id);assert_true(store.state.horses.is_empty());assert_true(store.chunks.is_empty())
func test_loading_old_save_starts_with_no_invented_moved_individuals():
 assert_eq(WorldHerdPositions139.clean({},752026),{"version":1,"seed":752026,"horses":{}})
