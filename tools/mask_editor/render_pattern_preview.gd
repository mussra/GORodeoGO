extends Node
func _ready()->void:call_deferred("run")
func run()->void:
 var root:String=ProjectSettings.globalize_path("res://")
 for kind in ["rider","horse"]:
  for view in ["side","down","up","diag_down","diag_up"]:
   for frame in 9:
    var rel:String="%s/%s/frame_%02d.png"%[kind,view,frame]
    var source:=Image.load_from_file(root+"art/experimental/pixellab/"+rel)
    var mask:=Image.load_from_file(root+"art/experimental/pixellab_masks_review_v2/%s/%s/color_%02d.png"%[kind,view,frame])
    var eligible:=Image.load_from_file(root+"art/experimental/pixellab_masks_review_v2/%s/%s/spots_%02d.png"%[kind,view,frame])
    var uv:=Image.load_from_file(root+"art/experimental/pixellab_preview_uv/"+rel)
    for pattern in [2,10,11]:
     var image:Image=source.duplicate()
     var coat:=Color("e3c388") if pattern==2 else (Color("dda92c") if pattern==10 else Color("e9e2d3"))
     var marks:=Color("bd3e3e") if pattern==2 else Color("975936") if pattern==10 else Color("273440")
     for y in 96:
      for x in 96:
       var m:Color=mask.get_pixel(x,y)
       if maxf(m.r,m.g)<.1:continue
       var old:Color=source.get_pixel(x,y)
       var shade:float=clampf(maxf(old.r,maxf(old.g,old.b))*255.0/205.0,.25,1.18)
       var color:Color=Color("222c37") if m.g>m.r else coat
       if m.r>m.g and eligible.get_pixel(x,y).r>.5:
        var sample:Color=uv.get_pixel(x,y);var point:=Vector2(sample.r,sample.g)*127.5
        var coverage:float=HorseAppearance.natural_spot_coverage(point) if pattern==2 else HorsePatternMap.coverage(point,pattern)
        color=color.lerp(marks,coverage)
       image.set_pixel(x,y,Color(color.r*shade,color.g*shade,color.b*shade,old.a))
     var out:String="/downloads/pattern-preview-v2/%s/%s/%d"%[kind,view,pattern]
     DirAccess.make_dir_recursive_absolute(out)
     image.save_png(out+"/frame_%02d.png"%frame)
 print("PATTERN_PREVIEW 270 images, real game coverage functions, experimental pose UV, no gameplay integration")
 get_tree().quit()
