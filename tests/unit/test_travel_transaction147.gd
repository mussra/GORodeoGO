extends GutTest
func test_commit_only_after_load_and_safe_arrival_in_order():
 var order:Array=[];var tx:=TravelTransaction147.new()
 var result:=await tx.run(func():order.append("load");return true,func():order.append("validate");return Vector2(12,34),func(pos):order.append(pos);return true,func():order.append("restore");return true)
 assert_eq(order,["load","validate",Vector2(12,34)]);assert_true(result.ok);assert_false(result.restored);assert_false(tx.running);assert_eq(tx.phase,"done")
func test_each_failure_restores_once_without_later_stage_commits():
 for failure in ["load","landing","save"]:
  var order:Array=[];var tx:=TravelTransaction147.new()
  var result:=await tx.run(func():order.append("load");return failure!="load",func():order.append("validate");return Vector2(INF,INF) if failure=="landing" else Vector2.ZERO,func(_pos):order.append("commit");return failure!="save",func():order.append("restore");return true)
  assert_false(result.ok);assert_eq(result.reason,failure);assert_true(result.restored);assert_eq(order.count("restore"),1);assert_eq(order.back(),"restore")
  if failure!="save":assert_false(order.has("commit"))
  assert_false(tx.running)
func test_failed_restore_is_reported_and_concurrent_start_is_rejected():
 var tx:=TravelTransaction147.new();tx.running=true
 var result:=await tx.run(func():fail_test("must not load");return true,func():return Vector2.ZERO,func(_p):return true,func():return true)
 assert_eq(result.reason,"busy");tx.running=false
 result=await tx.run(func():return false,func():return Vector2.ZERO,func(_p):return true,func():return false)
 assert_false(result.restored);assert_eq(result.reason,"load")
