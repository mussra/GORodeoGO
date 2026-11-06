extends SceneTree
func _initialize()->void:call_deferred("run")
func run()->void:
 var checks:=0
 for frame in range(12):
  var source:Texture2D=load("res://art/player/walk_diag_up/frame_%02d.png"%frame);var raw:Image=source.get_image();var ownership:Image=load("res://art/horse_masks/walk_diag_up/frame_%02d.png"%frame).get_image()
  if ownership.is_compressed():ownership.decompress()
  if raw.is_compressed():raw.decompress()
  for coat in range(20):
   for mane in range(6):
    var actual:=HorseAppearance.texture(source,"walk_diag_up",frame,{"coat":coat,"mane":mane,"pattern":2}).get_image()
    for y in range(67,96):
     for x in range(34,76):
      var c:=raw.get_pixel(x,y)
      if ownership.get_pixel(x,y).g<.02 and c.a>.9 and c.r>.6 and c.g>.5 and c.b>.4 and absf(c.r-c.b)<.3:
       assert(actual.get_pixel(x,y)==c);checks+=1
 print("ASCENDING_ALL_20_COATS_6_MANES_12_PHASES_%d_SOCK_CHECKS_PASS"%checks);quit()
