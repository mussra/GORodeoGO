extends GutTest
func test_spatial_search_preserves_all_360_reference_textures_exactly():
 SaveData.hat_color="original"
 var expected=JSON.parse_string(FileAccess.get_file_as_string("res://tests/fixtures/horse_patterns84_sha256.json"))
 var count=0
 for kind in ["horse","rider"]:
  for pattern in 12:
   var traits={"coat":3,"mane":1,"pattern":pattern,"finish":"normal"}
   for view in ["side","down","up","diag_down","diag_up"]:
    for frame in [0,4,8]:
     var image=PixelLabTrial.pose_texture(kind,view,frame,traits).get_image()
     var hash=HashingContext.new();hash.start(HashingContext.HASH_SHA256);hash.update(image.get_data())
     var key=kind+view+str(frame)+str(pattern)
     assert_eq(hash.finish().hex_encode(),expected[key],"Exact RGBA "+key);count+=1
 assert_eq(count,360)
func test_bucket_returns_every_spot_that_can_contribute_even_outside_body():
 for p in [Vector2(-8,-8),Vector2(0,0),Vector2(8,8),Vector2(64,64),Vector2(128,104),Vector2(132,108)]:
  var nearby=HorseAppearance.nearby_spots(p)
  for item in HorseAppearance.spots():
   if p.distance_to(Vector2(item.x,item.y))<=item.z*1.9+.8:assert_true(nearby.has(item))
