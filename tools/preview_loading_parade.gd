extends Node2D
var parade:LoadingParade
var age:float=0
var world:Sprite2D
func _ready():
 get_tree().root.size=Vector2i(1280,720)
 parade=LoadingParade.new();add_child(parade)
 world=Sprite2D.new();world.centered=false;world.texture=ImageTexture.create_from_image(Image.load_from_file("res://tools/preview_assets/loading-exit-world.jpg"));world.modulate.a=0;add_child(world)
func _process(delta:float):
 if not is_instance_valid(parade) or not parade.prepared:return
 age+=delta
 if age>=18:
  parade.finish();world.modulate.a=clampf((age-18)/.5,0,1)
 if age>19.5:get_tree().quit()
