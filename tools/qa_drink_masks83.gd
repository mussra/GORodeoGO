extends SceneTree
func _initialize():run.call_deferred()
func run():
 var traits=[{"coat":3,"mane":2,"pattern":0,"eyes":4},{"coat":12,"mane":0,"pattern":2,"eyes":3},{"coat":1,"mane":0,"pattern":10,"eyes":3},{"coat":1,"mane":4,"pattern":11,"eyes":5}]
 DirAccess.make_dir_recursive_absolute("/downloads/drink-genes83")
 for i in 2:
  var base="res://art/experimental/drink_preview83/"
  var source=load(base+"pose_%d.png"%i);var mask=load(base+"color_%d.png"%i).get_image();var uv=load(base+"uv_%d.png"%i).get_image();var eyes=load(base+"eyes_%d.png"%i).get_image()
  for k in traits.size():
   var t=traits[k];t["finish"]="normal"
   var output=HorseAppearance.texture(source,"walk_side",i,t,mask,uv).get_image()
   for y in 96:
    for x in 112:
     if eyes.get_pixel(x,y).r>.5:
      var old=output.get_pixel(x,y);var c=HorseAppearance.eye_color_at(t.eyes,Vector2(x/112.0,y/96.0));output.set_pixel(x,y,Color(c.r,c.g,c.b,old.a))
   output.save_png("/downloads/drink-genes83/variant_%d_pose_%d.png"%[k,i])
 print("DRINK83 real HorseAppearance and pattern coverage used; draft masks/UV; no gameplay")
 quit()
