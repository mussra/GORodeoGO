class_name TrainingPanel
extends Control
var mentor:String=""
var learner:String=""
var skill:String="jump"
var content:Control
var canvas:Control
var note:String=""
func _ready()->void:
 var active:Dictionary=SaveData.horse_collection.training_pair
 if not active.is_empty():
  mentor=str(active.get("mentor",""));learner=str(active.get("learner",""));skill=str(active.get("skill","jump"))
 MenuInputGuard.install(self)
 set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);z_index=90
 var bg:=ColorRect.new();bg.color=Color("10252d");bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(bg)
 canvas=Control.new();canvas.size=Vector2(1280,720);add_child(canvas);resized.connect(layout);layout();refresh()
func layout()->void:
 var k:float=minf(size.x/1280,size.y/720);canvas.scale=Vector2.ONE*k;canvas.position=(size-Vector2(1280,720)*k)/2
func label(text:String,pos:Vector2,font:int=22)->void:
 var l:=Label.new();l.text=text;l.position=pos;l.add_theme_font_size_override("font_size",font);content.add_child(l)
func button(text:String,pos:Vector2,cb:Callable)->void:
 var b:=Button.new();b.text=text;b.position=pos;b.size=Vector2(360,48);b.pressed.connect(cb);content.add_child(b)
func refresh()->void:call_deferred("build")
func build()->void:
 if content!=null:canvas.remove_child(content);content.queue_free()
 content=Control.new();canvas.add_child(content)
 MenuNavigation.header(content,tr("TRAIN_TITLE"),queue_free)
 button(tr("TRAIN_JUMP") if skill=="jump" else tr("TRAIN_DODGE"),Vector2(35,90),func():skill="dodge" if skill=="jump" else "jump";save_selection();refresh())
 button(tr("TRAIN_EQUIP_LEARNER"),Vector2(655,90),func():note=tr("TRAIN_EQUIPPED") if SaveData.select_horse(learner) else tr("MARKET_FAILED");refresh())
 var c:HorseCollection=SaveData.horse_collection
 label(tr("TRAIN_MENTOR"),Vector2(35,155));label(tr("TRAIN_LEARNER"),Vector2(655,155))
 picker(true,Vector2(35,195));picker(false,Vector2(655,195))
 HorsePicker.preview(content,c.find(mentor),Vector2(435,110),140)
 HorsePicker.preview(content,c.find(learner),Vector2(1055,110),140)
 label(tr("TRAIN_MOUNTED")%c.find(c.selected).get("name","-"),Vector2(35,278),17)
 if not HorseTraining.valid(c,mentor,learner,skill):label(tr("TRAIN_PICK_VALID"),Vector2(35,315),22)
 if HorseTraining.valid(c,mentor,learner,skill):
  var m:Dictionary=c.find(mentor);var l:Dictionary=c.find(learner);var affinity:float=float(c.affinities.get(HorseTraining.pair_key(mentor,learner),0))
  label(tr("TRAIN_STATUS")%[m.name,HorseTraining.mastery(m,skill),l.name,HorseTraining.progress(l,skill),HorseTraining.mastery(l,skill),affinity],Vector2(35,310),22)
  label(tr("TRAIN_KNOWN") if HorseTraining.knows(l,skill) else tr("TRAIN_STUDY"),Vector2(35,420),20)

 button(tr("TRAIN_STOP"),Vector2(655,455),func():note=tr("TRAIN_STOPPED") if SaveData.clear_training_pair() else tr("MARKET_FAILED");refresh())
 var active:Dictionary=c.training_pair
 label(tr("TRAIN_ACTIVE")%[c.known_record(str(active.get("mentor",""))).get("name","-"),c.known_record(str(active.get("learner",""))).get("name","-")] if not active.is_empty() else tr("TRAIN_NONE"),Vector2(35,525),21)
 label(tr("TRAIN_RULES"),Vector2(35,570),18);label(note,Vector2(35,650),20)
func save_selection()->void:
 var c:HorseCollection=SaveData.horse_collection
 if not HorseTraining.valid(c,mentor,learner,skill):note=tr("TRAIN_AUTO_INVALID");return
 if SaveData.set_training_pair(mentor,learner,skill):note=tr("TRAIN_AUTO_SAVED");return
 var active:Dictionary=c.training_pair
 if not active.is_empty():mentor=active.mentor;learner=active.learner;skill=active.skill
 note=tr("MARKET_FAILED")
func picker(is_mentor:bool,pos:Vector2)->void:
 var horses:Array=SaveData.horse_collection.horses.filter(func(h):return SaveData.horse_collection.is_adult(h.id) and (not is_mentor or HorseTraining.knows(h,skill)))
 var current:String=mentor if is_mentor else learner
 if not horses.is_empty() and not horses.any(func(h):return h.id==current):
  if is_mentor:mentor=horses[0].id
  else:learner=horses[0].id
  current=horses[0].id
 HorsePicker.create(content,horses,current,pos,395,func(selected:String):
  if is_mentor:mentor=selected
  else:learner=selected
  save_selection();refresh())
