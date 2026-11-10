extends Node
var elapsed:float=0
func _ready()->void:
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(1280,720)

 var bg=ColorRect.new();bg.color=Color("e7e3de");bg.size=Vector2(1280,720);add_child(bg)
 var title=Label.new();title.text="2.7.68 · sombrero limpio · 9 frames por vista · máscaras v5 intactas";title.position=Vector2(25,15);title.add_theme_color_override("font_color",Color("251f21"));title.add_theme_font_size_override("font_size",25);add_child(title)
 var vs=["up","diag_up","side","diag_down","down"]
 for i in 5:
  var label=Label.new();label.text=vs[i];label.position=Vector2(45+i*250,60);label.add_theme_color_override("font_color",Color("251f21"));add_child(label)
  for row in 2:
   var sprite=AnimatedSprite2D.new();sprite.position=Vector2(125+i*250,220+row*300);sprite.scale=Vector2(3,3);sprite.texture_filter=CanvasItem.TEXTURE_FILTER_NEAREST;sprite.sprite_frames=SpriteFrames.new();sprite.sprite_frames.add_animation("run");sprite.sprite_frames.set_animation_speed("run",9)
   var traits={} if row==0 else {"coat":1,"pattern":9,"spots":5,"mane":5,"finish":"matte"}
   for frame in 9:sprite.sprite_frames.add_frame("run",PixelLabTrial.pose_texture("rider",vs[i],frame,traits))
   add_child(sprite);sprite.play("run")
 var bottom=Label.new();bottom.text="Arriba: original · Abajo: pelaje/manchas/crin aplicados · Sin cambiar el caballo ni las máscaras";bottom.position=Vector2(25,680);bottom.add_theme_color_override("font_color",Color("251f21"));add_child(bottom)
func _process(delta:float)->void:
 elapsed+=delta
 if elapsed>2.9:
  get_viewport().get_texture().get_image().save_png("/downloads/hat-game68.png");get_tree().quit()
