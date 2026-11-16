extends Label
## One screen-space town placard, not a long world-space line cut by the camera.
var world:Node2D
var clock:float=1.
func _ready():
 mouse_filter=Control.MOUSE_FILTER_IGNORE
 horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
 vertical_alignment=VERTICAL_ALIGNMENT_CENTER
 autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
 add_theme_font_size_override('font_size',19)
 add_theme_color_override('font_color',Color('fff1cd'))
 var box:=RanchTheme.box(Color('4e3827',.93),Color('dab66d'),6)
 box.content_margin_left=12;box.content_margin_right=12;box.content_margin_top=7;box.content_margin_bottom=7
 add_theme_stylebox_override('normal',box);hide()
func _process(delta:float):
 clock+=delta
 if clock<.25:return
 clock=0.
 if not is_instance_valid(world) or not is_instance_valid(world.player):hide();return
 if world.get("_arrival244")!=null and world._arrival244.active:hide();return
 if world._loading_world or world._map_overlay.expanded or is_instance_valid(world._navigation):hide();return
 var best:Dictionary={};var distance:float=900.
 for plan in TownEnclosures227.plans(SaveData.world_seed).values():
  var gap:float=world.player.position.distance_to(plan.gate)
  if gap<distance:best=plan;distance=gap
 if best.is_empty():hide();return
 text=TownIdentity215.title(SaveData.world_cousins140,best.id)+'\n'+TownEnclosures227.role231(best.id)
 var extent:Vector2=get_viewport_rect().size
 var k:float=minf(extent.x/1280.,extent.y/720.)
 scale=Vector2.ONE*k;size=Vector2(minf(580.,extent.x/k-270.),0)
 position=Vector2(maxf(220.*k,(extent.x-size.x*k)*.5),60.*k)
 show()
