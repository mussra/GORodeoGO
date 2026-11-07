extends GutTest
## World editor ops (Ant: editor con datos editables, 7-nov-2026): valid ops only,
## layered over the seed without mutating it, removable decor, placed pig pens.

func _base_chunk()->Dictionary:
 return {"decor":[{"kind":"tree","pos":Vector2(100,100),"scale":1.0}],"herd":{},"pigs":{}}

func test_add_decor_layers_over_seed():
 var out:=WorldEdits.apply(_base_chunk(),[{"type":"add_decor","kind":"pine","pos":Vector2(200,200),"scale":1.2}],0,0)
 assert_eq(out.decor.size(),2)
 assert_eq(out.decor[1].kind,"pine")
 assert_eq(_base_chunk().decor.size(),1)  # seed untouched

func test_remove_decor_only_inside_radius():
 var ops:Array=[{"type":"remove_decor","pos":Vector2(105,105),"radius":50.0}]
 assert_eq(WorldEdits.apply(_base_chunk(),ops,0,0).decor.size(),0)
 ops[0]={"type":"remove_decor","pos":Vector2(140,140),"radius":25.0}
 assert_eq(WorldEdits.apply(_base_chunk(),ops,0,0).decor.size(),1)

func test_add_pigs_fills_empty_pen_only():
 var with_pigs:=_base_chunk()
 with_pigs.pigs={"pos":Vector2(50,50),"count":3}
 var out:=WorldEdits.apply(with_pigs,[{"type":"add_pigs","pos":Vector2(300,300),"count":4}],0,0)
 assert_eq(int(out.pigs.count),3)  # existing pen wins
 out=WorldEdits.apply(_base_chunk(),[{"type":"add_pigs","pos":Vector2(300,300),"count":4}],0,0)
 assert_eq(int(out.pigs.count),4)
 assert_eq(WorldMap.pig_id(0,0),"pig_0,0")
 assert_eq(WorldEdits.edited_pen_id(Vector2(300,300)),"pig_0_0_edit")

func test_invalid_ops_are_dropped():
 assert_false(WorldEdits.valid_op({"type":"add_decor","kind":"house","pos":Vector2.ZERO,"scale":1.0}))
 assert_false(WorldEdits.valid_op({"type":"add_pigs","pos":Vector2.ZERO,"count":99}))
 assert_false(WorldEdits.valid_op("not-a-dict"))
 var out:=WorldEdits.apply(_base_chunk(),[{"type":"add_decor","kind":"house","pos":Vector2(5,5),"scale":1.0}],0,0)
 assert_eq(out.decor.size(),1)

func test_ops_in_other_chunks_do_not_leak():
 var far:Array=[{"type":"add_decor","kind":"flower","pos":Vector2(5000,5000),"scale":1.0}]
 assert_eq(WorldEdits.apply(_base_chunk(),far,0,0).decor.size(),1)
