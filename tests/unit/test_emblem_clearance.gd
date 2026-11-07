extends GutTest
## Hard rule (Ant, 7-nov-2026): the emblem never overlaps saddle, tack or rider,
## in any animation frame or in the portrait. Horse masks mark horse-only pixels
## (r/g > 0.5); the stamp must stay inside them.

const EMBLEM:Dictionary={"shape":0,"division":0,"left":0,"right":1,"color":0}
const FAMILIES:Array[String]=["idle","walk_side","walk_down","walk_up","walk_diag_down","walk_diag_up","jump_side","jump_down","jump_up","jump_diag_down","jump_diag_up","stunned"]

func _frame_files(dir_path:String)->Array[String]:
 var out:Array[String]=[]
 var dir:=DirAccess.open(dir_path)
 if dir==null:return out
 dir.list_dir_begin()
 var f:=dir.get_next()
 while f!="":
  if not dir.current_is_dir() and f.begins_with("frame_") and f.ends_with(".png"):out.append(f)
  f=dir.get_next()
 dir.list_dir_end()
 out.sort()
 return out

func _img(path:String)->Image:
 var im:Image=load(path).get_image()
 if im.is_compressed():im.decompress()
 return im

func test_every_frame_stays_on_the_horse():
 for anim in FAMILIES:
  var frames:=_frame_files("res://art/player/"+anim)
  assert_true(frames.size()>0,"sprite frames for "+anim)
  for f in frames:
   var zone_path:String="res://art/lineage_masks/%s/%s"%[anim,f]
   if not ResourceLoader.exists(zone_path):continue
   var body_path:String="res://art/horse_masks/%s/%s"%[anim,f]
   assert_true(ResourceLoader.exists(body_path),"horse mask for %s/%s"%[anim,f])
   if not ResourceLoader.exists(body_path):continue
   var sprite:Image=_img("res://art/player/%s/%s"%[anim,f])
   var zone:Image=_img(zone_path)
   var body:Image=_img(body_path)
   var before:Image=sprite.duplicate()
   HorseEmblem.stamp(sprite,zone,EMBLEM,body)
   var bad:=0
   for y in sprite.get_height():
    for x in sprite.get_width():
     if sprite.get_pixel(x,y)==before.get_pixel(x,y):continue
     var bm:=body.get_pixel(x,y)
     if maxf(bm.r,bm.g)<.5:bad+=1
   assert_eq(bad,0,"emblem on saddle/rider in %s/%s"%[anim,f])

func test_portrait_stays_on_the_horse():
 var ink:Image=HorseEmblem.portrait_mask(EMBLEM).get_image()
 if ink.is_compressed():ink.decompress()
 var body:Image=_img("res://art/portraits/adult_hd_mask.png")
 var bad:=0
 for y in ink.get_height():
  for x in ink.get_width():
   if ink.get_pixel(x,y).a<.05:continue
   var bm:=body.get_pixel(x,y)
   if maxf(bm.r,bm.g)<.5:bad+=1
 assert_eq(bad,0,"portrait emblem on saddle/rider")
