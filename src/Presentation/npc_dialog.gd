class_name NpcDialog
extends Panel
signal acknowledged(quest_id:String)
signal closed
signal accepted(quest_id:String)
func setup(npc:Dictionary,states:Dictionary):
 add_theme_stylebox_override("panel",RanchTheme.box(Color("10252d"),Color("6d9b94"),12))
 position=Vector2(300,180);size=Vector2(680,350);z_index=100;mouse_filter=Control.MOUSE_FILTER_STOP
 var id:String=NpcQuests.next_for(states,npc);var q:Dictionary=NpcQuests.QUESTS[id];var s:Dictionary=NpcQuests.state(states,id)
 var title=Label.new();title.text=npc.name+" · "+q.title;title.position=Vector2(24,20);title.add_theme_font_size_override("font_size",25);add_child(title)
 var placeholder=Label.new();placeholder.text="PNJ provisional · arte de granjero pendiente de Ant";placeholder.position=Vector2(24,60);placeholder.add_theme_font_size_override("font_size",16);add_child(placeholder)
 var body=Label.new();body.position=Vector2(24,100);body.size=Vector2(630,155);body.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;body.add_theme_font_size_override("font_size",22)
 body.name="QuestBody"
 body.text=q.text if s.status=="locked" else (q.done if s.status=="done" else q.active+" · %d/%d"%[s.count,q.goal]);add_child(body)
 var yes=Button.new();yes.position=Vector2(24,275);yes.size=Vector2(280,52);yes.text="Aceptar encargo";yes.visible=s.status=="locked";add_child(yes);yes.pressed.connect(func():accepted.emit(id))
 var back=Button.new();back.position=Vector2(355,275);back.size=Vector2(295,52);back.text="Ahora no" if s.status=="locked" else ("Gracias · continuar" if s.status=="done" else "Seguir explorando");add_child(back);back.pressed.connect(func():
  if s.status=="done":acknowledged.emit(id)
  closed.emit())
