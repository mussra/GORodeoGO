extends Node2D
class MapStub:
 var expanded:bool=false
var _loading_world:bool=false
var _map_overlay=MapStub.new()
var _navigation=null
var _npc_dialog=null
var _journal140=null
var _note_dialog106=null
var _board_panel=null
var _quest_panel:Control
var _edit_mode:bool=false
var _travel144=null
var _arrival244:TownArrival244
var _camera_controls243:WorldCamera243
var player:CharacterBody2D
func _ready():
 _quest_panel=Control.new();_quest_panel.hide();add_child(_quest_panel)
 player=load('res://src/Presentation/world_player.gd').new();add_child(player)
 var camera:=Camera2D.new();player.add_child(camera);camera.make_current()
 _camera_controls243=WorldCamera243.new();_camera_controls243.world=self;_camera_controls243.camera=camera
 var layer:=CanvasLayer.new();add_child(layer);layer.add_child(_camera_controls243)
 _arrival244=TownArrival244.new();_arrival244.world=self;add_child(_arrival244)
 _arrival244.set_process(false);_arrival244.seen={}
