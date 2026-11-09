extends Node
func _ready()->void:call_deferred("run")
func run()->void:
 get_tree().root.size=Vector2i(1280,720)
 var bg:=ColorRect.new();bg.size=Vector2(1280,720);bg.color=Color("10262f");add_child(bg)
 var animations=["idle","walk_side","walk_down","walk_up","walk_diag_down","walk_diag_up","jump_side","jump_down","jump_up","jump_diag_down","jump_diag_up","stunned"]
 for i in range(animations.size()):
  var anim:String=animations[i];var label:=Label.new();label.text=anim;label.position=Vector2(i%6*205+5,int(i/6)*340+5);add_child(label)
  for j in range(3):
   var frame:int=[0,5,11][j];var path:String="res://art/player/%s/frame_%02d.png"%[anim,frame]
   if not ResourceLoader.exists(path):path="res://art/player/%s/frame_0.png"%anim;frame=0
   if not ResourceLoader.exists(path):path="res://art/player/%s/frame_00.png"%anim;frame=0
   var view:=TextureRect.new();view.position=Vector2(i%6*205+5,int(i/6)*340+30+j*100);view.size=Vector2(100,100);view.texture_filter=CanvasItem.TEXTURE_FILTER_NEAREST;view.texture=HorseAppearance.texture(load(path),anim,frame,{"coat":10,"mane":0,"pattern":0,"legs":3});add_child(view)
 await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/legs2745-directions.png")
 get_tree().quit()
