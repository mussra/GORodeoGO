extends SceneTree
func _initialize():run.call_deferred()
func run():
 DirAccess.make_dir_recursive_absolute("/downloads/drink-hats83")
 for i in 2:
  var base="res://art/experimental/drink_preview83/";var source=load(base+"pose_%d.png"%i);var mask=load(base+"color_%d.png"%i).get_image();var uv=load(base+"uv_%d.png"%i).get_image()
  var t={"coat":3,"mane":2,"pattern":0,"eyes":4,"finish":"normal"}
  for hat in ["original","blue","sand"]:
   var image=HorseAppearance.texture(source,"walk_side",i,t,mask,uv).get_image();var raw=source.get_image()
   for y in 96:
    for x in 112:
     if mask.get_pixel(x,y).b>.5:
      var old=raw.get_pixel(x,y)
      if hat=="original":image.set_pixel(x,y,old)
      else:
       var c=Color("415c81") if hat=="blue" else Color("c8b994");var shade=clampf(maxf(old.r,maxf(old.g,old.b))/.65,.25,1.18);image.set_pixel(x,y,Color(c.r*shade,c.g*shade,c.b*shade,old.a))
   image.save_png("/downloads/drink-hats83/%s_%d.png"%[hat,i])
 quit()
