extends Node
func _ready()->void:call_deferred("run")
func run()->void:
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(1280,720)
 var background:=ColorRect.new();background.size=Vector2(1280,720);background.color=Color("2e5d33");add_child(background)
 var title:=Label.new();title.position=Vector2(100,80);title.text="FRONTERA · caballo adulto y cerdos a la misma escala";title.add_theme_font_size_override("font_size",28);add_child(title)
 var horse=load("res://src/Presentation/wild_horse.gd").new();horse.setup({"pos":Vector2(420,390),"traits":{"coat":10,"pattern":1,"mane":2,"eyes":0,"spots":3,"finish":"normal"}});add_child(horse);horse.set_physics_process(false)
 horse.scale=Vector2.ONE*2.5
 for i in range(2):
  var pig=load("res://src/Presentation/wild_pig.gd").new();pig.setup({"pos":Vector2(680+i*200,390)});add_child(pig);pig.scale=Vector2.ONE*2.5
  pig._art.variant="pink" if i==0 else "brown"
  var old:Node=pig._art;pig.remove_child(old);old.queue_free();pig._art=WildPigArt.new();pig._art.variant="pink" if i==0 else "brown";pig.add_child(pig._art)
 var text:=Label.new();text.position=Vector2(120,565);text.text="Cerdo:40% menor que antes · hitbox y captura sin cambios\nVista ampliada2,5x para comparar; misma ampliación en los tres";text.add_theme_font_size_override("font_size",23);add_child(text)
 for spec in [[320,"Caballo adulto"],[620,"Cerdo rosa"],[820,"Cerdo marrón"]]:
  var name_label:=Label.new();name_label.position=Vector2(spec[0],470);name_label.text=spec[1];name_label.add_theme_font_size_override("font_size",23);add_child(name_label)
 await get_tree().create_timer(.5).timeout;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/pigsize2751-comparison.png")
 get_tree().quit()
