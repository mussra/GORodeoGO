class_name HatPanel
extends Control
var _canvas:Control
var _message:Label
var _preview:TextureRect
var _color:OptionButton
var _finish:OptionButton
var _ids:Array[String]=["original"]
var _ink:OptionButton
var _finish_ids:Array[int]=[0,1,2,3,4,5,6,7,8,9,10,11,13,14]
var _apply:Button
var _pending:String="original"
func _ready()->void:
 MenuInputGuard.install(self);set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);z_index=60
 var bg=ColorRect.new();bg.color=Color("10252d");bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(bg)
 _canvas=Control.new();_canvas.size=Vector2(1280,720);add_child(_canvas)
 _label("Sombrero del vaquero",Vector2(40,30),32)
 var back=Button.new();back.text="Volver";back.position=Vector2(1030,25);back.size=Vector2(210,50);QuestButtonStyle.apply(back);back.pressed.connect(hide);_canvas.add_child(back)
 _label("Color",Vector2(70,115),26);_color=OptionButton.new();_color.position=Vector2(70,152);_color.size=Vector2(460,62);_color.add_theme_font_size_override("font_size",25);_canvas.add_child(_color)
 for name_ in ["Original"]:_color.add_item(name_)
 for i in HorseCollection.COATS.size():_ids.append(HatAppearance.encode(i,0));_color.add_item(HorseCollection.COATS[i])
 _label("Acabado / patrón",Vector2(70,235),26);_finish=OptionButton.new();_finish.position=Vector2(70,272);_finish.size=Vector2(460,62);_finish.add_theme_font_size_override("font_size",25);_canvas.add_child(_finish)
 for name_ in HorseCollection.PATTERNS:_finish.add_item(name_)
 _finish.add_item("Arcoíris");_finish.add_item("Galaxia")
 _label("Color del patrón",Vector2(70,355),26)
 _ink=OptionButton.new();_ink.position=Vector2(70,392);_ink.size=Vector2(460,62);_ink.add_theme_font_size_override("font_size",25);_canvas.add_child(_ink)
 for color_name in HorseCollection.COATS:_ink.add_item(color_name)
 _ink.item_selected.connect(func(_i):_update_preview())
 _preview=TextureRect.new();_preview.position=Vector2(650,115);_preview.size=Vector2(470,475);_canvas.add_child(_preview)
 var apply=Button.new();_apply=apply;apply.text="Equipar sombrero";apply.position=Vector2(70,485);apply.size=Vector2(460,65);QuestButtonStyle.apply(apply);apply.pressed.connect(func():
  _message.text="Sombrero equipado" if SaveData.select_hat(_pending) else "No se ha podido guardar"
 );_canvas.add_child(apply)
 _message=_label("",Vector2(70,570),20)
 _label("Cada caballo que has tenido deja su diseño para siempre. Venderlo no lo borra.",Vector2(70,640),22)
 _color.item_selected.connect(func(_i):_update_preview())
 _finish.item_selected.connect(func(_i):_update_preview())
 resized.connect(_layout);_layout();refresh()
func _label(text_:String,pos:Vector2,font:int)->Label:
 var label=Label.new();label.text=text_;label.position=pos;label.add_theme_font_size_override("font_size",font);_canvas.add_child(label);return label
func _layout()->void:
 if _canvas==null:return
 var k:float=minf(size.x/1280,size.y/720);_canvas.scale=Vector2.ONE*k;_canvas.position=(size-Vector2(1280,720)*k)/2
func refresh()->void:
 var settings=HatAppearance.decode(SaveData.hat_color)
 _color.select(1+int(settings.coat) if int(settings.coat)>=0 else maxi(0,_ids.find(SaveData.hat_color)))
 _ink.select(int(settings.get("spots",0)))
 _finish.select(maxi(0,_finish_ids.find(int(settings.finish))));_update_preview()
func _update_preview()->void:
 var index:int=_color.selected
 _finish.disabled=index<1;_ink.disabled=index<1 or _finish.selected==0
 _pending=HatAppearance.encode235(index-1,_finish_ids[_finish.selected],0 if _finish_ids[_finish.selected] in [0,13,14] else _ink.selected) if index>=1 else _ids[index]
 var horse:Dictionary=SaveData.horse_collection.find(SaveData.horse_collection.selected).duplicate(true)
 if horse.get("stage","")=="foal":horse.stage="adult"
 HorsePortrait.apply_horse(_preview,horse,_pending)
 var unlocked:bool=not _pending.begins_with("hat:") or HatDesigns235.collect(SaveData.hat_designs235,SaveData.horse_collection).has(_pending)
 _apply.disabled=not unlocked
 _message.text="Diseño desbloqueado · se conserva al vender" if unlocked else "Bloqueado · consigue un caballo con este color y patrón"
