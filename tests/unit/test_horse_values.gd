extends GutTest
func test_explicit_all_traits()->void:
 var lines=HorseValues.visual({"coat":1,"pattern":10,"mane":5,"spots":18})
 assert_eq(lines.size(),8);assert_has(lines,"Tipo de manchas: Jirafa");assert_has(lines,"Color de manchas: Celeste");assert_has(lines,"Acabado: Normal");assert_has(lines,"Emblema: Ninguno")
func test_unowned_never_invents_stats()->void:
 var lines=HorseValues.performance({"traits":{"coat":1,"pattern":0,"mane":1}},false)
 assert_true(" ".join(lines).contains("no definidos"))
func test_actual_stats_include_calm()->void:
 var lines=HorseValues.performance({"stats":{"calm":1.75}},true)
 assert_has(lines,"Serenidad: 1.75");assert_eq(lines.size(),5)
func test_incremental_pixellab_specs_are_exact_46()->void:
 var specs=PixelLabTrial.frame_specs("horse");assert_eq(specs.size(),46);assert_eq(specs[-1][2],"idle")
