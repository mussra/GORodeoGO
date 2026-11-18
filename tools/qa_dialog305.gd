extends Node
var menu:Node
var shot_index:int=0
func _ready():run.call_deferred()
func shot(id:String):
 for i in 12:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png('/downloads/305-'+id+'.png')
func capture_window(host:Node,id:String,keep:bool=false):
 await shot(id)
 for c in host.get_children():
  if c is AcceptDialog:
   c.hide()
   if not keep:c.free()
func run():
 get_tree().root.size=Vector2i(1600,720);TranslationServer.set_locale('es');GameState.sound_enabled=false;GameState.brand_intro_played=true
 SaveData.save_path='user://qa_dialog305.cfg';SaveData._load_valid=true;SaveData.horse_collection.seed_trial();SaveData.trial_session_active=false;SaveData.equipment_points=10000
 menu=load('res://src/Presentation/main_menu.tscn').instantiate();add_child(menu);await get_tree().create_timer(.8).timeout
 await shot('principal')
 for extent in [Vector2i(960,540),Vector2i(1280,800)]:
  get_tree().root.size=extent;await get_tree().create_timer(.2).timeout;await shot('principal-'+str(extent.x)+'x'+str(extent.y))
 get_tree().root.size=Vector2i(1600,720);await get_tree().create_timer(.2).timeout
 GameState.confirm_exit();await shot('salir');GameState._exit_dialog.hide();GameState._exit_dialog.free();GameState._exit_dialog=null
 for skill in ['jump','dodge']:
  var badge:=JumpBadge.new();badge.skill=skill;menu.add_child(badge);badge.show_explanation();await capture_window(badge,skill);badge.free()
 var horse:Dictionary=SaveData.horse_collection.find(SaveData.horse_collection.selected)
 var summary:=HorseSummaryBar185.create(menu,horse,500);summary.get_child(0).pressed.emit();await capture_window(summary,'propiedades');summary.free()
 var equipment=menu._equipment_panel;equipment.show();await get_tree().create_timer(.3).timeout
 await shot('tienda-latigos')
 equipment._confirm_purchase('whip_basic');await capture_window(equipment,'equipo',true)
 equipment._confirm_purchase('scare_whip265');await capture_window(equipment,'latigo-basico',true)
 SaveData.equipment_owned.append('scare_whip265');equipment.refresh()
 equipment._confirm_purchase('scare_whip_plus265');await capture_window(equipment,'latigo-mejorado',true);equipment.hide()
 var horses:=HorsePanel.new();menu.add_child(horses);await get_tree().create_timer(.2).timeout
 horses.confirm_trade(horse,false);await capture_window(horses,'comprar-caballo')
 horses.confirm_trade(horse,true);await capture_window(horses,'vender-caballo');horses.free()
 var emblem:=EmblemPanel.new();emblem.horse_id=horse.id;menu.add_child(emblem);await get_tree().create_timer(.2).timeout
 emblem.dirty=true;emblem.request_close();await capture_window(emblem,'descartar-emblema')
 for b in emblem.content.get_children():
  if b is Button and b.text==tr('EMBLEM_REMOVE'):b.pressed.emit();break
 await capture_window(emblem,'quitar-emblema');emblem.free()
 var npc:=NpcDialog.new();npc.setup_story('Granjero','El rancho','Los toros que vuelven al rancho están a salvo. Puedes seguir explorando.');menu.add_child(npc);await shot('npc');npc.free()
 var florist:=FloristDialog138.new();florist.setup_journey(false);menu.add_child(florist);await shot('florista');florist.free()
 var cousin:=CousinDialog140.new();cousin.setup('east138',SaveData.world_cousins140,false);menu.add_child(cousin);await shot('primo');cousin.free()
 var note:=MapNoteDialog106.new();note.setup({},'Caballo de prueba');menu.add_child(note);await shot('nota');note.free()
 var service:=TownServicePanel231.new();service.town_id='west140';menu.add_child(service);await shot('servicio');service.free()
 var town:=TownDialog234.new();town.town='home';town.role='farmer';menu.add_child(town);await shot('pueblo');town.free()
 menu.hide()
 var world=load('res://src/Presentation/frontier_world.tscn').instantiate();add_child(world)
 for i in 3600:
  if not world._loading_world and not get_tree().root.has_node('FrontierTransition'):break
  await get_tree().process_frame
 var garden:Node
 for c in world.get_children():
  if c is GardenWorld212:garden=c;break
 assert(garden!=null)
 garden.open();await shot('huerto');garden.close();world.free()
 menu.free();get_tree().quit()
