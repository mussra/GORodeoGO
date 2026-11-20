extends Control
func _ready():run.call_deferred()
func shot322(name_:String):
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png('/downloads/'+name_+'.png')
func run():
 get_tree().root.size=Vector2i(1280,720);TranslationServer.set_locale('es');GameState.sound_enabled=false;GameState.brand_intro_played=true
 SaveData.save_path='user://qa322-only.cfg'
 var intro:=StoryIntro319.new();intro.persist319=false;add_child(intro)
 await get_tree().create_timer(.28).timeout;await shot322('pablo322-entering')
 await get_tree().create_timer(3.3).timeout;await shot322('pablo322-intro')
 intro.free()
 var npc:=NpcDialog.new();npc.setup(NpcQuests.NPCS[0],{});add_child(npc)
 await get_tree().create_timer(5.).timeout;await shot322('pablo322-farmer')
 npc.free();get_tree().quit()
