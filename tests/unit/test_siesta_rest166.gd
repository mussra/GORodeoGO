extends GutTest
func test_only_active_riding_counts_not_waiting_or_clock_skips():
 assert_eq(SiestaRest166.tick(300.,10000.,false),300.)
 assert_eq(SiestaRest166.tick(300.,10000.,true),299.75)
 assert_eq(SiestaRest166.tick(1.,.2,true),.8)
 assert_eq(SiestaRest166.tick(.1,.2,true),0.)
 assert_eq(SiestaRest166.clean(NAN),0.);assert_eq(SiestaRest166.clean("300"),0.)
 assert_eq(SiestaRest166.clean(999999.),300.)
func test_rest_survives_save_reload():
 var path:String=SaveData.save_path;var rest:float=SaveData.siesta_rest166
 SaveData.save_path="user://rest166.dat";SaveData._load_valid=true;SaveData.siesta_rest166=249.5
 assert_true(SaveData.save_progress());SaveData.siesta_rest166=0.;SaveData.load_progress();assert_eq(SaveData.siesta_rest166,249.5)
 SaveData.save_path=path;SaveData.siesta_rest166=rest;DirAccess.remove_absolute("user://rest166.dat")
