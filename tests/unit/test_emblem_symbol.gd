extends GutTest
## Player-editable symbol placement inside the shield (Ant, 7-nov-2026):
## bounded X/Y offset and scale, safe defaults, saved with the shield config,
## backward compatible with shields saved before the keys existed.

func test_defaults_keep_symbol_clear_of_initials():
 assert_eq(HorseEmblem.symbol_dx({}),0)
 assert_eq(HorseEmblem.symbol_dy({}),5)
 assert_almost_eq(HorseEmblem.symbol_scale({}),0.85,0.001)

func test_extremes_are_clamped():
 assert_eq(HorseEmblem.symbol_dx({"symbol_dx":999}),HorseEmblem.SYMBOL_DX_RANGE)
 assert_eq(HorseEmblem.symbol_dx({"symbol_dx":-999}),-HorseEmblem.SYMBOL_DX_RANGE)
 assert_eq(HorseEmblem.symbol_dy({"symbol_dy":999}),HorseEmblem.SYMBOL_DY_MAX)
 assert_eq(HorseEmblem.symbol_dy({"symbol_dy":-999}),HorseEmblem.SYMBOL_DY_MIN)
 assert_almost_eq(HorseEmblem.symbol_scale({"symbol_scale":9.9}),1.0,0.001)
 assert_almost_eq(HorseEmblem.symbol_scale({"symbol_scale":0.0}),HorseEmblem.SYMBOL_SCALE_MIN,0.001)

func test_offset_changes_the_render():
 var a:Image=HorseEmblem.mask({"shape":0,"division":0,"left":0,"right":1,"color":0}).get_image()
 var b:Image=HorseEmblem.mask({"shape":0,"division":0,"left":0,"right":1,"color":0,"symbol_dx":-8,"symbol_dy":10}).get_image()
 assert_true(a.get_data()!=b.get_data())

func test_clamped_extremes_render_identically():
 var a:Image=HorseEmblem.mask({"shape":0,"division":0,"left":0,"right":1,"color":0,"symbol_dx":12}).get_image()
 var b:Image=HorseEmblem.mask({"shape":0,"division":0,"left":0,"right":1,"color":0,"symbol_dx":999}).get_image()
 assert_eq(a.get_data(),b.get_data())

func test_old_shields_still_valid():
 assert_true(HorseEmblem.valid(HorseEmblem.DEFAULT.duplicate()))
 assert_true(HorseEmblem.valid({"shape":2,"division":1,"left":3,"right":0,"color":4}))
 var with_keys:Dictionary=HorseEmblem.DEFAULT.duplicate()
 with_keys["symbol_dx"]=-6;with_keys["symbol_dy"]=9;with_keys["symbol_scale"]=0.7
 with_keys["letters"]="MWW";with_keys["letters_font"]=1
 assert_true(HorseEmblem.valid(with_keys))

func test_stamp_respects_body_exclusion():
 var image:=Image.create(96,96,false,Image.FORMAT_RGBA8);image.fill(Color("3366cc"))
 var zone:=Image.create(96,96,false,Image.FORMAT_RGBA8);zone.fill(Color.TRANSPARENT)
 zone.fill_rect(Rect2i(20,20,40,40),Color.WHITE)
 var body:=Image.create(96,96,false,Image.FORMAT_RGBA8);body.fill(Color.RED)
 body.fill_rect(Rect2i(35,20,15,40),Color.BLACK)  # "saddle" stripe through the zone
 HorseEmblem.stamp(image,zone,{"shape":0,"division":0,"left":0,"right":1,"color":0},body)
 for y in range(20,60):
  for x in range(35,50):
   assert_eq(image.get_pixel(x,y),Color("3366cc"),"ink on excluded pixel %d,%d"%[x,y])
