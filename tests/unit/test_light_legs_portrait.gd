extends GutTest
func test_pattern_has_independent_editable_texture()->void:
 var mat:=HorsePortrait.material_for({"coat":8,"mane":3,"pattern":4})
 assert_eq(mat.get_shader_parameter("light_legs_mask"),HorsePortrait.LIGHT_LEGS)
 assert_eq(mat.get_shader_parameter("pattern"),4)
 var image:=HorsePortrait.LIGHT_LEGS.get_image()
 if image.is_compressed():image.decompress()
 assert_eq(image.get_size(),Vector2i(936,983))
 assert_eq(image.get_pixel(500,500).r,0.0,"No stockings on body or rider")
 assert_gt(image.get_pixel(594,808).r,.9,"Front ankle marking exists")
 assert_eq(image.get_pixel(594,760).r,0.0,"Front marking follows its own height")
 assert_gt(image.get_pixel(235,780).r,.9,"Rear stocking uses another height")
func test_other_pattern_ids_and_material_masks_unchanged()->void:
 for pattern in [0,1,2,3,5,6,7,8,9]:
  var mat:=HorsePortrait.material_for({"coat":8,"mane":3,"pattern":pattern})
  assert_eq(mat.get_shader_parameter("pattern"),pattern)
  assert_eq(mat.get_shader_parameter("region_mask"),HorsePortrait.MASK)
