extends Node
func _ready():run.call_deferred()
func run():
 var output={};var total=Time.get_ticks_usec();var count=0
 for kind in ["horse","rider"]:
  for pattern in [0,1,2,3,4,5,6,7,8,9,10,11]:
   var t={"coat":3,"mane":1,"pattern":pattern,"finish":"normal"}
   var start=Time.get_ticks_usec()
   for view in ["side","down","up","diag_down","diag_up"]:
    for frame in [0,4,8]:
     var image=PixelLabTrial.pose_texture(kind,view,frame,t).get_image()
     if kind=="horse" and view=="side" and frame==0:image.save_png("/downloads/pattern84-"+str(pattern)+".png")
     var hash=HashingContext.new();hash.start(HashingContext.HASH_SHA256);hash.update(image.get_data());output[kind+view+str(frame)+str(pattern)]=hash.finish().hex_encode();count+=1
   print("PATTERN84 ",kind," pattern=",pattern," total_ms=",(Time.get_ticks_usec()-start)/1000.)
 var file=FileAccess.open("/tmp/pattern-signatures-"+OS.get_environment("PERF_LABEL")+".json",FileAccess.WRITE);file.store_string(JSON.stringify(output));file.close()
 print("PATTERN84 total_ms=",(Time.get_ticks_usec()-total)/1000.," frames=",count)
 get_tree().quit()
