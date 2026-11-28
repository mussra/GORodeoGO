extends GutTest
## 3.0.43: el nombre del pueblo usa la forma real del recinto, no el dibujo de la muralla ("Estrella").
func test_town_name_starts_with_the_real_enclosure_shape()->void:
	var old_version:int=SaveData.world_generator_version
	SaveData.world_generator_version=6
	var seed_:int=752026
	var plans:Dictionary=TownEnclosures227.plans(seed_)
	var checked:int=0
	for id in TownIdentity215.ids234(seed_):
		if not plans.has(id):continue
		var look:Dictionary=TownIdentity215.look236(seed_,id)
		var shape_word:String=String(plans[id].shape_name)
		var expected:String=shape_word.substr(0,1).to_upper()+shape_word.substr(1)
		assert_true(String(look.name).begins_with(expected+" "),"%s debe empezar por %s"%[look.name,expected])
		checked+=1
	assert_gt(checked,0)
	SaveData.world_generator_version=old_version
