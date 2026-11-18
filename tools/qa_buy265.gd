extends Node
func _ready():
 SaveData.save_path="user://qa265buy.cfg";SaveData._load_valid=true;SaveData.trial_session_active=false;SaveData.equipment_points=1000;SaveData.equipment_owned=[];SaveData.equipment_equipped={}
 assert(SaveData.buy_equipment("scare_whip265"));assert(SaveData.equipment_points==750);assert(SaveData.equip_item("scare_whip265"));assert(SaveData.buy_equipment("scare_whip_plus265"));assert(SaveData.equipment_points==250);assert(SaveData.equip_item("scare_whip_plus265"))
 SaveData.equipment_owned=[];SaveData.equipment_equipped={};SaveData.equipment_points=0;SaveData.load_progress()
 assert(SaveData.equipment_owned.has("scare_whip265"));assert(SaveData.equipment_equipped.scare_whip=="scare_whip_plus265");assert(SaveData.equipment_points==250)
 print("BUY265 purchase/equip/upgrade/save/reload passed; 250+500 game points, independent slot")
 get_tree().quit()
