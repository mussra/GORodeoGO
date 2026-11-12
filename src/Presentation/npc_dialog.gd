class_name NpcDialog
extends Panel
signal pigs_sold104(count:int,unit_price:int)
signal acknowledged(quest_id:String)
signal closed
signal accepted(quest_id:String)
func setup(npc:Dictionary,states:Dictionary):
 add_theme_stylebox_override("panel",RanchTheme.box(Color("10252d"),Color("6d9b94"),12))
 position=Vector2(300,180);size=Vector2(680,460);z_index=100;mouse_filter=Control.MOUSE_FILTER_STOP
 if npc.id=="farmer":add_sale104()
 var id:String=NpcQuests.next_for(states,npc);var q:Dictionary=NpcQuests.QUESTS[id];var s:Dictionary=NpcQuests.state(states,id)
 var title=Label.new();title.text=npc.name+" · "+q.title;title.position=Vector2(24,20);title.add_theme_font_size_override("font_size",25);add_child(title)
 var portrait=Sprite2D.new();portrait.name="FarmerPortrait";portrait.texture=WorldNpc.PORTRAIT;portrait.position=Vector2(83,162);portrait.scale=Vector2.ONE*(195.0/1536.0);add_child(portrait)
 var body=Label.new();body.position=Vector2(170,85);body.size=Vector2(480,175);body.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;body.add_theme_font_size_override("font_size",22)
 body.name="QuestBody"
 body.text=q.text if s.status=="locked" else (q.done if s.status=="done" else q.active+" · %d/%d"%[s.count,q.goal]);add_child(body)
 var yes=Button.new();yes.position=Vector2(24,275);yes.size=Vector2(280,52);yes.text="Aceptar encargo";yes.visible=s.status=="locked";add_child(yes);yes.pressed.connect(func():accepted.emit(id))
 var back=Button.new();back.position=Vector2(355,275);back.size=Vector2(295,52);back.text="Ahora no" if s.status=="locked" else ("Gracias · continuar" if s.status=="done" else "Seguir explorando");add_child(back);back.pressed.connect(func():
  if s.status=="done":acknowledged.emit(id)
  closed.emit())

func add_sale104()->void:
 var count:int=SaveData.pig_inventory104();var quote:Dictionary=WorldLivestock104.quote(count)
 var price=Label.new();price.name="PigPrice104";price.text=tr("WORLD_PIG_PRICE104") % [quote.unit_price,count];price.position=Vector2(24,340);price.add_theme_font_size_override("font_size",20);add_child(price)
 var sell=Button.new();sell.name="SellPigs104";sell.position=Vector2(24,385);sell.size=Vector2(620,52);sell.text=tr("WORLD_PIG_SELL104") % [count,quote.total];sell.disabled=count<=0;add_child(sell)
 sell.pressed.connect(func():pigs_sold104.emit(count,quote.unit_price))
