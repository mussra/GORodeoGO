extends Control
var page:Control
func _ready():run.call_deferred()
func label_(text_:String,pos:Vector2,font_size:int=22)->void:
 var l=Label.new();l.text=text_;l.position=pos;l.add_theme_font_size_override("font_size",font_size);page.add_child(l)
func clear_()->void:
 if page:remove_child(page);page.queue_free()
 page=Control.new();add_child(page)
 var bg=ColorRect.new();bg.size=Vector2(1280,720);bg.color=Color("10252d");page.add_child(bg)
func shot(name_:String)->void:
 await get_tree().process_frame;await get_tree().process_frame;await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png("/downloads/regiones123-"+name_+".png")
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale("es");SaveData.world_pig_captures=[];SaveData.world_pigs_sold=0
 clear_();label_("Pueblos y campos regionales · propuesta aislada",Vector2(28,22),30)
 for index in 2:
  var profile:String="meadow" if index==0 else "mountain";var town_id:String="first" if index==0 else "second";var left:float=20+index*630
  var panel=Panel.new();panel.position=Vector2(left,90);panel.size=Vector2(610,550);panel.add_theme_stylebox_override("panel",RanchTheme.box(Color("244436"),Color("75a578"),8));page.add_child(panel)
  label_(RegionalVillages123.PROFILES[profile].label,Vector2(left+18,108),24)
  label_("1 tipo: flores azules" if index==0 else "10 tipos: campos separados por especie",Vector2(left+18,148),22)
  var grass=Node2D.new();grass.position=Vector2(left+12,195);var tex:Texture2D=load("res://art/world/derived88/grass-cache91.png");grass.draw.connect(func():grass.draw_texture_rect(tex,Rect2(0,0,586,300),false));page.add_child(grass)
  var field=RegionalFlowerField123.new();field.flowers=RegionalFlowerField123.plan(town_id,profile,752026,Vector2(left+305,365));page.add_child(field)
  label_("Granjero: 3 cerdos" if index==0 else "Granjero: 3 cabras",Vector2(left+18,520),23)
  label_("Florista: 3 azules" if index==0 else "Florista: 3 violetas (ejemplo)",Vector2(left+18,556),23)
  label_("Guardado: pueblo first" if index==0 else "Guardado: pueblo second",Vector2(left+18,600),18)
 label_("Preview · nombres, encargos y cantidades de ejemplo · no insertado en partidas",Vector2(28,675),21)
 await shot("campos")
 for role in ["farmer","florist"]:
  clear_();label_("V3 actual · todos los encargos terminados",Vector2(28,32),29)
  var npc:Dictionary=NpcQuests.NPCS[0 if role=="farmer" else 1].duplicate(true);npc.regional_close123=true
  var states:Dictionary={}
  for id in npc.quests:
   states[id]={"status":"done","count":3,"events":["a","b","c"],"thanked":true}
  var dialog=NpcDialog.new();dialog.setup(npc,states);page.add_child(dialog)
  label_("Mismo mensaje en cada visita. Sin botón para pedir nuevos encargos.",Vector2(40,670),23)
  await shot("gracias-"+role)
 clear_();label_("Montaña · encargo propio de la florista",Vector2(28,32),29)
 var npc=RegionalVillages123.npc("second","mountain","florist");var dialog=NpcDialog.new();dialog.setup(npc,{});page.add_child(dialog);await shot("encargo-montana")
 get_tree().quit()
