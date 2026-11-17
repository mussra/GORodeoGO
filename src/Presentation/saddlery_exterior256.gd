class_name SaddleryExterior256
extends Node2D
const DOOR=Vector2(1500,650)
func _ready():
 position=DOOR
 var art:=Sprite2D.new();art.texture=load("res://art/breeding256/saddlery-exterior.png");art.offset=Vector2(0,-art.texture.get_height()*.5);art.scale=Vector2.ONE*(350./art.texture.get_height());add_child(art)
 WorldPhysics.add_box(self,Rect2(Vector2(-175,-110),Vector2(350,85)))
 var sign_:=Label.new();sign_.text="Juanito · guarnicionería";sign_.position=Vector2(-120,16);sign_.add_theme_font_size_override("font_size",18);add_child(sign_)
static func definition()->Dictionary:return {"id":"workshop256","name":"Juanito · Entrar al taller","position":DOOR,"quests":[]}
