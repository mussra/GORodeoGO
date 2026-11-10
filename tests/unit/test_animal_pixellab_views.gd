extends GutTest
func test_supplied_views_only_and_reversible_goat_geometry()->void:
 PixelLabTrial.initialized=true;PixelLabTrial.goat_enabled=true;PixelLabTrial.pig_enabled=true
 assert_eq(PixelLabTrial.animal_views("pig"),["side","down","up"])
 assert_eq(PixelLabTrial.animal_views("goat"),["side","down","up"])
 var goat=load("res://src/Presentation/wild_goat.gd").new();goat.setup({"pos":Vector2.ZERO});add_child_autofree(goat)
 for dir in [Vector2.RIGHT,Vector2.LEFT,Vector2.DOWN,Vector2.UP,Vector2(1,1),Vector2(-1,-1)]:
  goat.movement=dir;goat._process(0)
  var expected:String="run_down" if dir==Vector2.DOWN else ("run_up" if dir==Vector2.UP else "run")
  assert_eq(goat.goat_art.animation,expected)
  assert_eq(goat.goat_art.flip_h,dir.x<0)
 assert_eq(goat.goat_art.sprite_frames.get_frame_count("run"),9)
 assert_eq(goat.goat_art.sprite_frames.get_animation_speed("run"),9.0)
 assert_eq(goat.goat_art.offset,Vector2(-80,-144));assert_eq(goat.goat_art.scale,Vector2.ONE*.40)
 PixelLabTrial.goat_enabled=false
 var legacy=load("res://src/Presentation/wild_goat.gd").new();legacy.setup({"pos":Vector2.ZERO});add_child_autofree(legacy)
 assert_false(legacy.goat_art.sprite_frames.has_animation("run"));assert_eq(legacy.goat_art.sprite_frames.get_frame_count("up"),10)
 PixelLabTrial.goat_enabled=true
func test_pig_cardinals_and_diagonal_fallback()->void:
 PixelLabTrial.initialized=true;PixelLabTrial.pig_enabled=true
 var art=WildPigArt.new();add_child_autofree(art)
 for dir in [Vector2.RIGHT,Vector2.LEFT,Vector2.UP,Vector2.DOWN,Vector2(1,1),Vector2(-1,-1)]:
  art.update_state(true,false,dir.x<0,dir)
  assert_eq(art.animation,"run_up" if dir==Vector2.UP else ("run_down" if dir==Vector2.DOWN else "run"))
  assert_eq(art.flip_h,dir.x<0)
 assert_eq(art.offset,Vector2(-80,-128));assert_eq(art.scale,Vector2.ONE*.36)
 art.update_state(true,true,false,Vector2.UP);assert_eq(art.animation,"tired")
 art.update_state(false,false,false);assert_eq(art.animation,"idle")
func after_all()->void:
 # Release texture-heavy static frame caches before the dummy renderer exits.
 WildPigArt.frame_cache.clear()
 load("res://src/Presentation/wild_goat.gd").frames_cache.clear()
func test_bull_five_real_views_and_legacy_states_reversible()->void:
 PixelLabTrial.initialized=true;PixelLabTrial.bull_enabled=true
 var bull=_bull_node();add_child_autofree(bull)
 assert_eq(PixelLabTrial.animal_views("bull"),["side","down","up","diag_down","diag_up"])
 for v in ["side","down","up","diag_down","diag_up"]:
  assert_eq(bull._sprite_swap._frames.get_frame_count("flee_"+v),9)
  assert_eq(bull._sprite_swap._frames.get_animation_speed("flee_"+v),9.0)
  assert_true(bull._sprite_swap._frames.get_frame_texture("flee_"+v,0).resource_path.contains("pixellab/bull"))
 assert_true(bull._sprite_swap._frames.get_frame_texture("idle",0).resource_path.begins_with("res://art/bull/"))
 PixelLabTrial.bull_enabled=false
 var legacy=_bull_node();add_child_autofree(legacy)
 assert_true(legacy._sprite_swap._frames.get_frame_texture("flee_side",0).resource_path.begins_with("res://art/bull/"))
 PixelLabTrial.bull_enabled=true

func _bull_node()->Node:
 var bull=load("res://src/Presentation/bull.gd").new()
 var polygon=Polygon2D.new();polygon.name="Polygon2D";bull.add_child(polygon)
 var collision=CollisionShape2D.new();collision.name="CollisionShape2D";collision.shape=CircleShape2D.new();bull.add_child(collision)
 return bull
