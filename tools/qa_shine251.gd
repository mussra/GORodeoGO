extends Node
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(1280,720);GameState.sound_enabled=false
 var bg:=ColorRect.new();bg.color=Color("15303a");bg.size=Vector2(1280,720);add_child(bg)
 var h:Dictionary={"id":"shine-demo","name":"Tigre","parents":[],"traits":{"coat":13,"pattern":14,"mane":0,"finish":"normal"}}
 for i in 2:
  var record:=h.duplicate(true)
  if i==1:record.master251=true
  var title:=Label.new();title.text="Tigre · antes" if i==0 else "Tigre · linaje maestro";title.position=Vector2(80+640*i,70);title.add_theme_font_size_override("font_size",32);add_child(title)
  var portrait:=TextureRect.new();portrait.position=Vector2(50+640*i,145);portrait.size=Vector2(540,480);portrait.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;portrait.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED
  portrait.texture=PixelLabTrial.pose_texture("horse","side",0,record.traits,record)
  if i==1:portrait.material=HorseAdorn169.material(record,HorseFinish168.selected_spec("walk","horse"),0)
  add_child(portrait)
 for i in 36:
  await get_tree().create_timer(.065).timeout;await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png("/downloads/shine251-%02d.png"%i)
 get_tree().quit()
