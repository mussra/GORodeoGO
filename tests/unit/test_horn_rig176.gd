extends GutTest
func asset()->Dictionary:return {"approved":true,"view":"side","path":"res://fixture_horn.png","size":Vector2(512,512),"base":Vector2(256,450),"tip":Vector2(256,50)}
func anchor()->Dictionary:return {"approved":true,"base":Vector2(70,35),"tip":Vector2(82,17),"occlusion":"none"}
func test_base_and_tip_follow_head_pose_without_canvas_center_guess():
 var a:=asset();var p:=anchor();var placed:=HornRig176.placement(a,p);assert_false(placed.is_empty());var t:Transform2D=placed.transform
 assert_lt((t*a.base).distance_to(p.base),.0001);assert_lt((t*a.tip).distance_to(p.tip),.0001);assert_true(placed.mirror_with_host)
 p.base+=Vector2(3,-4);p.tip+=Vector2(3,-4);var moved:=HornRig176.placement(a,p);assert_lt((moved.transform*a.base).distance_to(p.base),.0001)
func test_incomplete_or_unreviewed_assets_anchors_and_occlusion_cannot_render():
 var a:=asset();var p:=anchor();a.approved=false;assert_eq(HornRig176.placement(a,p),{});a.approved=true;p.approved=false;assert_eq(HornRig176.placement(a,p),{})
 p=anchor();p.erase("occlusion");assert_eq(HornRig176.placement(a,p),{});p.occlusion="mask";assert_eq(HornRig176.placement(a,p),{});p.occlusion_path="res://occlusion.png";assert_false(HornRig176.placement(a,p).is_empty())
 a.tip=a.base;assert_eq(HornRig176.placement(a,p),{});a=asset();a.base=Vector2(INF,0);assert_eq(HornRig176.placement(a,p),{})
func test_jump_views_portrait_and_mirroring_reuse_five_supplied_views():
 for spec in FinishPose168.specs():assert_true(HornRig176.view_for(spec) in HornRig176.VIEWS)
 assert_eq(HornRig176.view_for({"view":"jump_diag_up"}),"diag_up");assert_eq(HornRig176.view_for({"kind":"portrait"}),"diag_down")
 assert_eq(SpriteSwap.direction_suffix(Vector2(-1,-1)),["diag_up",true]);assert_eq(SpriteSwap.direction_suffix(Vector2(1,-1)),["diag_up",false])
func test_normal_galaxy_never_grows_horn_and_all_views_poses_must_be_approved():
 var assets:Dictionary={};var anchors:Dictionary={"rider:side:0":anchor()}
 for view in HornRig176.VIEWS:var a:=asset();a.view=view;assets[view]=a
 var h:Dictionary={"traits":{"finish":"galaxy"}};assert_false(HornRig176.allowed(h,assets,anchors,["rider:side:0"]))
 h.species="unicorn";h.unicorn_variant="blue";assert_true(HornRig176.allowed(h,assets,anchors,["rider:side:0"]));assert_false(HornRig176.allowed(h,assets,anchors,["missing"]));assets.erase("up");assert_false(HornRig176.allowed(h,assets,anchors,["rider:side:0"]))
