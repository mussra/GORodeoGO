extends Node
var content:Control
func text(value:String,pos:Vector2,font:int=20):
 var l=Label.new();l.text=value;l.position=pos;l.add_theme_font_size_override("font_size",font);content.add_child(l)
func picture(tex:Texture2D,pos:Vector2,sz:Vector2):
 var r=TextureRect.new();r.texture=tex;r.position=pos;r.size=sz;r.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;r.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;content.add_child(r)
func shot(path:String):
 await get_tree().create_timer(.35).timeout;await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png(path)
func clear():
 if content!=null:remove_child(content);content.queue_free()
 content=Control.new();add_child(content);var bg=ColorRect.new();bg.color=Color("163139");bg.size=Vector2(1280,900);content.add_child(bg)
func _ready():run.call_deferred()
func run():
 get_tree().root.size=Vector2i(1280,900);TranslationServer.set_locale("es");SaveData.horse_collection.seed_trial();var t=SaveData.horse_collection.find(SaveData.horse_collection.selected).traits
 clear();text("Sombreros: marcha/galope nominal · canal nuevo separado, resto de máscaras intacto",Vector2(20,14),24)
 var views=["side","down","up","diag_down","diag_up"]
 for row in 3:
  SaveData.hat_color=["original","blue","sand"][row];text(HatAppearance.OPTIONS[SaveData.hat_color],Vector2(20,95+row*250))
  for col in 5:
   var p=Vector2(160+col*220,70+row*250);text(views[col],p,18);picture(PixelLabTrial.pose_texture("rider",views[col],4,t),p+Vector2(0,30),Vector2(195,195))
 text("Original / Azul noche / Arena · oro del adorno protegido · no se repintó pelaje/crin/ojos · sin APK",Vector2(20,860),20)
 await shot("/downloads/hats-nominal83.png")
 clear();text("Sombreros: reposo, salto, aturdido y beber · mismo recolor compartido",Vector2(20,14),25)
 var anims=["idle","jump_side","jump_up","jump_down","jump_diag_down","jump_diag_up","stunned","drink"]
 for row in 3:
  SaveData.hat_color=["original","blue","sand"][row];text(HatAppearance.OPTIONS[SaveData.hat_color],Vector2(20,95+row*250))
  for col in anims.size():
   var p=Vector2(140+col*141,70+row*250);text(anims[col].trim_prefix("jump_"),p,17)
   var tex:Texture2D
   if anims[col]=="drink":tex=HorseDrink.texture(1,t,SaveData.hat_color)
   else:
    var file="frame_0" if anims[col]=="stunned" else "frame_00";var source=load("res://art/player/%s/%s.png"%[anims[col],file]);tex=HatAppearance.tint(source,"res://art/hat_masks_v10/hat-classic-%s-%s.png"%[anims[col],file],SaveData.hat_color)
   picture(tex,p+Vector2(0,30),Vector2(138,180))
 text("Máscaras anteriores y sus303trazos intactos · capas95nuevas de sombrero editables en v10 · sin APK",Vector2(20,860),20)
 await shot("/downloads/hats-states83.png");get_tree().quit()
