extends SceneTree
func _initialize()->void:call_deferred("run")
func run()->void:
 var checks:=0;var neutral_checks:=0
 for frame in range(12):
  var source:Texture2D=load("res://art/player/walk_diag_down/frame_%02d.png"%frame);var raw:Image=source.get_image();var mask:Image=load("res://art/horse_masks/walk_diag_down/frame_%02d.png"%frame).get_image()
  if raw.is_compressed():raw.decompress()
  if mask.is_compressed():mask.decompress()
  for coat in range(20):
   for mane in range(6):
    var actual:=HorseAppearance.texture(source,"walk_diag_down",frame,{"coat":coat,"mane":mane,"pattern":1}).get_image()
    var clean:=HorseAppearance.texture(source,"walk_diag_down",frame,{"coat":coat,"mane":mane,"pattern":0}).get_image()
    for y in range(96):
     for x in range(96):
      var m:=mask.get_pixel(x,y);var c:=raw.get_pixel(x,y)
      if c.a<.5:continue
      if m.g>m.r:
       assert(actual.get_pixel(x,y)==clean.get_pixel(x,y));checks+=1
      if maxf(m.r,m.g)<.02:
       assert(actual.get_pixel(x,y)==c);neutral_checks+=1
 print("FRONTAL_PALETTE_PASS: hair_pattern_independence=%d neutral_pixels=%d"%[checks,neutral_checks]);quit()
