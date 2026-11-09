extends Node
var panel:EmblemPanel
func wait_ui()->void:await get_tree().create_timer(.3).timeout
func shot(label:String)->void:
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/qa2741-"+label+".png")
func _ready()->void:
 call_deferred("run")
func run()->void:
 TranslationServer.set_locale("es");get_tree().root.size=Vector2i(1600,720);get_tree().root.theme=RanchTheme.create()
 var c:=SaveData.horse_collection;c.seed_trial()
 var h:Dictionary=c.find("original");h.traits={"coat":6,"pattern":0,"mane":4,"finish":"normal"}
 panel=EmblemPanel.new();get_tree().root.add_child(panel);await wait_ui()
 panel.config={"shape":1,"division":0,"left":1,"right":1,"color":1,"letters":"ALV","letters_font":0};panel.build();await wait_ui();await shot("cobre-letras")
 panel.config.color=2;panel.config.shape=0;panel.config.division=1;panel.config.left=0;panel.config.right=2;panel.config.letters_font=1
 panel.build();await wait_ui();await shot("azul-dividido")
 panel.config.color=4;panel.config.shape=2;panel.config.division=2;panel.config.left=3;panel.config.right=4
 panel.build();await wait_ui();await shot("dorado-diagonal")
 get_tree().quit()
