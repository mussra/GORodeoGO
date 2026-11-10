extends GutTest
func test_pig_uses_shared_sprite_frames_and_keeps_capture_geometry()->void:
 var pig=load("res://src/Presentation/wild_pig.gd").new();pig.setup({"pos":Vector2(17,35)});add_child_autofree(pig)
 await wait_process_frames(2)
 assert_true(pig._art is AnimatedSprite2D)
 assert_eq(pig.BODY_RADIUS,28.0)
 assert_almost_eq(pig._art.scale.x,.36,.001)
 assert_eq(pig._art.offset,Vector2(-80,-128))
 assert_eq(pig._art.sprite_frames.get_frame_count("run"),9)
 assert_eq(pig._art.sprite_frames.get_frame_count("idle"),1)
 assert_eq(pig._art.sprite_frames.get_frame_count("tired"),1)
 assert_eq(pig._art.sprite_frames.get_frame_texture("run",0).get_size(),Vector2(160,144))
 pig.state["flee"]=true;await wait_process_frames(2);assert_eq(pig._art.animation,"run")
 pig.state["tired"]=true;await wait_process_frames(2);assert_eq(pig._art.animation,"tired")
 pig.state["flee"]=false;pig.state["tired"]=false;pig.flip_h=true;await wait_process_frames(2)
 assert_eq(pig._art.animation,"idle");assert_true(pig._art.flip_h)
 assert_true(pig.try_capture(pig.position));assert_false(pig.try_capture(pig.position+Vector2(500,0)))
func test_variants_share_fixed_small_caches()->void:
 for kind in ["pink","brown"]:
  var a:=WildPigArt.new();a.variant=kind;add_child_autofree(a)
  var b:=WildPigArt.new();b.variant=kind;add_child_autofree(b)
  assert_eq(a.sprite_frames,b.sprite_frames)
 assert_eq(WildPigArt.frame_cache.size(),2)
