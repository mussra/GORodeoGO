extends Node
func _ready():call_deferred("run")
func run():
 var c=HorseCollection.new();c.seed_trial();var h=c.find("original");h.traits.finish="galaxy"
 for n in range(1,21):HorseMastery.record(c,h.id,n)
 for master in [false,true]:
  h.completed_levels=range(1,21) if master else range(1,20)
  var start=Time.get_ticks_usec()
  for view in ["side","down","up","diag_down","diag_up"]:
   for frame in 9:PixelLabTrial.pose_texture("rider",view,frame,h.traits,h)
  print("GALAXY cold45 master=",master," ms=",(Time.get_ticks_usec()-start)/1000.)
  start=Time.get_ticks_usec()
  for repeat in 100:
   for view in ["side","down","up","diag_down","diag_up"]:
    for frame in 9:PixelLabTrial.pose_texture("rider",view,frame,h.traits,h)
  print("GALAXY cached4500 master=",master," ms=",(Time.get_ticks_usec()-start)/1000.)
 for view in ["side","down","up","diag_down","diag_up"]:
  var counts=[]
  for frame in 9:
   var mask:Image=load("res://art/experimental/pixellab_masks_review_v5/rider/%s/color_%02d.png"%[view,frame]).get_image()
   var uv:Image=load("res://art/experimental/pixellab_preview_uv/rider/%s/frame_%02d.png"%[view,frame]).get_image()
   var sun=0;var moon=0
   for y in mask.get_height():
    for x in mask.get_width():
     if mask.get_pixel(x,y).r<.5:continue
     var ink=HorseGalaxyLook.marks(HorseAppearance.body_point(uv,x,y,0),view)
     if ink.x>.15:sun+=1
     if ink.y>.15:moon+=1
   counts.append([sun,moon])
  print("GALAXY marks ",view," sun/moon pixels=",counts)
 get_tree().quit()
