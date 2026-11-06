extends SceneTree
func _initialize()->void:call_deferred("run")
func run()->void:
 var mask:Image=load("res://art/foal/eyes.png").get_image()
 if mask.is_compressed():mask.decompress()
 var a:Image=HorseAppearance.texture(load("res://art/foal/base.png"),"foal",0,{"coat":18,"mane":1,"pattern":0,"eyes":7}).get_image()
 var b:Image=HorseAppearance.texture(load("res://art/foal/base.png"),"foal",0,{"coat":18,"mane":1,"pattern":0,"eyes":8}).get_image()
 var count:=0
 for y in range(a.get_height()):
  for x in range(a.get_width()):
   if mask.get_pixel(x,y).r<.01:assert(a.get_pixel(x,y)==b.get_pixel(x,y));count+=1
 print("FOAL_EYE_OUTSIDE_%d_PIXELS_UNCHANGED_PASS"%count);quit()
