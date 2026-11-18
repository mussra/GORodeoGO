extends Node
var menu:Node
func _ready():run.call_deferred()
func shot(id:String):
 for i in 15:await get_tree().process_frame
 await RenderingServer.frame_post_draw
 get_viewport().get_texture().get_image().save_png('/downloads/307-'+id+'.png')
func run():
 get_tree().root.size=Vector2i(1600,900);TranslationServer.set_locale('es');GameState.sound_enabled=false;GameState.brand_intro_played=true
 SaveData.save_path='user://qa307.cfg';SaveData._load_valid=true;SaveData.horse_collection.seed_trial();SaveData.trial_session_active=false;SaveData.equipment_points=10000
 SaveData.equipment_owned.clear();SaveData.equipment_equipped.clear()
 menu=load('res://src/Presentation/main_menu.tscn').instantiate();add_child(menu);await get_tree().create_timer(.7).timeout
 var equipment=menu._equipment_panel;equipment.show();await shot('tienda-latigos')
 equipment._confirm_purchase('scare_whip265');await shot('confirmacion-basico');equipment._confirm.hide()
 SaveData.equipment_owned.append('scare_whip265');SaveData.equipment_equipped.scare_whip='scare_whip265';equipment.refresh()
 equipment._confirm_purchase('scare_whip_plus265');await shot('confirmacion-mejora');equipment._confirm.hide()
 var scroll:ScrollContainer=equipment._canvas.get_node('EquipmentList257')
 scroll.scroll_vertical=560;await shot('lazos-fustas')
 scroll.scroll_vertical=1100;await shot('monturas-riendas')
 scroll.scroll_vertical=1700;await shot('estribos-herraduras')
 scroll.scroll_vertical=2300;await shot('espuelas')
 scroll.scroll_vertical=2950;await shot('cosmeticos')
 equipment._confirm_purchase('spurs_basic');await shot('confirmacion-espuelas');equipment._confirm.hide();equipment.hide()
 var horses:=HorsePanel.new();menu.add_child(horses);horses.show_page('collection');await shot('caballos-lista')
 var horse:Dictionary=SaveData.horse_collection.find(SaveData.horse_collection.selected)
 horses.focus_id=horse.id;horses.focus_preview=horse;horses.show_page('detail');await shot('caballo-ficha')
 for child in horses.content.get_children():
  if child is ScrollContainer:child.scroll_vertical=580
 await shot('caballo-atributos')
 horses.confirm_trade(horse,true);await shot('vender-caballo');
 for child in horses.get_children():
  if child is AcceptDialog:child.hide();child.free()
 var training:=TrainingPanel.new();menu.add_child(training);await shot('entrenamiento')
 var pair:Dictionary={'mentor':training.mentor,'learner':training.learner,'skill':training.skill}
 training.free();horses.show_page('market');await shot('mercado');horses.free()
 var change:=VictoryGrowth251.apply(SaveData.horse_collection,horse.id,'bulls')
 if not change.is_empty():
  var victory:=HorseVictory251.new();victory.reward=change;menu.add_child(victory);await get_tree().create_timer(1.1).timeout;await shot('victoria');victory.free()
 menu.free();get_tree().quit()
