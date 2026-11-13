extends GutTest
func test_all_adult_runtime_pose_sources_masks_and_uvs_exist_and_match_dimensions():
 var total:int=0
 for spec in FinishPose168.specs():
  for i in spec.count:
   var p:=FinishPose168.paths(spec,i);total+=1
   assert_true(ResourceLoader.exists(p.source),p.source);assert_true(ResourceLoader.exists(p.mask),p.mask)
   if not ResourceLoader.exists(p.source) or not ResourceLoader.exists(p.mask):continue
   var source:Texture2D=load(p.source);var mask:Texture2D=load(p.mask);assert_eq(source.get_size(),mask.get_size(),p.source)
   if not str(p.uv).is_empty():assert_true(ResourceLoader.exists(p.uv));var uv:Texture2D=load(p.uv);assert_eq(source.get_size(),uv.get_size())
 assert_eq(total,133)
func test_materials_are_shared_by_exact_style_pose_and_frame_only():
 var spec:Dictionary=FinishPose168.specs()[0]
 var gold:=FinishPose168.material("gold",spec,0)
 assert_same(gold,FinishPose168.material("gold",spec,0));assert_ne(gold,FinishPose168.material("ice",spec,0));assert_ne(gold,FinishPose168.material("gold",spec,1))
 assert_eq(gold.get_shader_parameter("style"),1)
