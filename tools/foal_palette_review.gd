extends SceneTree
func _initialize()->void:call_deferred("run")
func run()->void:
 var out:=Image.create(900,370,false,Image.FORMAT_RGBA8);out.fill(Color("10252d"))
 var i:int=0
 for c in [0,3,6]:
  var t:Dictionary={"coat":c,"pattern":1,"mane":5,"finish":"normal"}
  var im:Image=HorseAppearance.texture(load("res://art/foal/base.png"),"foal",0,t).get_image();out.blit_rect(im,Rect2i(0,0,299,346),Vector2i(i*300,12));i+=1
 out.save_png("/downloads/foal-three-coats.png");quit()
