extends Node
var world:CountrySession152
func _ready():run.call_deferred()
func shot(id:String):
 await get_tree().process_frame;await RenderingServer.frame_post_draw;get_viewport().get_texture().get_image().save_png("/downloads/save158-"+id+".png")
func run():
 get_tree().root.size=Vector2i(1600,720);TranslationServer.set_locale("es");SaveData.save_path="user://save158-qa.cfg";SaveData._load_valid=true;SaveData.trial_session_active=false;SaveData.world_seed=752026;SaveData.world_generator_version=3;SaveData.horse_collection=HorseCollection.new();SaveData.horse_collection.seed_trial();SaveData.save_progress()
 world=CountrySession152.new();world.session_state=CountryLedger146.enter(CountryLedger146.fresh(752026,3),Vector2(100,100),752026);add_child(world);await get_tree().physics_frame;world.activate152();world.player.set_physics_process(false);world.set_process(false)
 for point in [world.data.sites.tree,world.data.sites.source]:world.player.position=point;world._process(0.)
 var poly:PackedVector2Array=world.data.island;var edge:Vector2=(poly[96]+poly[97])/2.;var inward:Vector2=(CountryRoute146.BOUNDS.get_center()-edge).normalized();world.player.position=edge+inward*100.;world.player.move_and_collide(-inward*300.);world.camera.reset_smoothing()
 SaveData._load_valid=false;world._process(5.1);assert(not world.save_error.is_empty());await shot("fallo-simulado")
 SaveData._load_valid=true;world._process(5.1);assert(world.save_error.is_empty());assert(SaveData.country_ledger146.maps.water146.position==world.player.position);await shot("reintento-guardado")
 world.player.position=Vector2(1300,12300);world.camera.reset_smoothing();world._process(0.);await shot("espuma-esquina");print("SAVE158_RETRY_AND_FOAM_OK");get_tree().quit()
