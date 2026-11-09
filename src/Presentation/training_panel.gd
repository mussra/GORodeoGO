class_name TrainingPanel
extends Control
var mentor:String=""
var learner:String=""
var skill:String="jump"
var content:Control
var canvas:Control
var note:String=""
func _ready()->void:
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
 label(tr("TRAIN_TITLE"),Vector2(35,24),30);button(tr("UI_009"),Vector2(880,24),queue_free)
 button(tr("TRAIN_JUMP") if skill=="jump" else tr("TRAIN_DODGE"),Vector2(35,90),func():skill="dodge" if skill=="jump" else "jump";mentor="";refresh())
 var c:HorseCollection=SaveData.horse_collection
 label(tr("TRAIN_MENTOR"),Vector2(35,155));label(tr("TRAIN_LEARNER"),Vector2(655,155))
 picker(true,Vector2(35,195));picker(false,Vector2(655,195))
 if not HorseTraining.valid(c,mentor,learner,skill):label(tr("TRAIN_PICK_VALID"),Vector2(35,290),22)
 if HorseTraining.valid(c,mentor,learner,skill):
  var m:Dictionary=c.find(mentor);var l:Dictionary=c.find(learner);var affinity:float=float(c.affinities.get(HorseTraining.pair_key(mentor,learner),0))
  label(tr("TRAIN_STATUS")%[m.name,HorseTraining.mastery(m,skill),l.name,HorseTraining.progress(l,skill),affinity],Vector2(35,270),23)
  label(tr("TRAIN_KNOWN") if HorseTraining.knows(l,skill) else tr("TRAIN_STUDY"),Vector2(35,400),21)
  button(tr("TRAIN_START"),Vector2(35,455),func():note=tr("TRAIN_SAVED") if SaveData.set_training_pair(mentor,learner,skill) else tr("MARKET_FAILED");refresh())
 button(tr("TRAIN_STOP"),Vector2(655,455),func():note=tr("TRAIN_STOPPED") if SaveData.clear_training_pair() else tr("MARKET_FAILED");refresh())
 var active:Dictionary=c.training_pair
 label(tr("TRAIN_ACTIVE")%[c.known_record(str(active.get("mentor",""))).get("name","-"),c.known_record(str(active.get("learner",""))).get("name","-")] if not active.is_empty() else tr("TRAIN_NONE"),Vector2(35,525),21)
 label(tr("TRAIN_RULES"),Vector2(35,570),19);label(note,Vector2(35,645),20)
func picker(is_mentor:bool,pos:Vector2)->void:
 var pick:=OptionButton.new();pick.position=pos;pick.size=Vector2(540,54);content.add_child(pick)
 for h in SaveData.horse_collection.horses:
  if not SaveData.horse_collection.is_adult(h.id) or (is_mentor and not HorseTraining.knows(h,skill)):continue
  pick.add_item(h.name);pick.set_item_metadata(pick.item_count-1,h.id)
  if (mentor if is_mentor else learner)==h.id:pick.select(pick.item_count-1)
 if pick.item_count>0 and (mentor if is_mentor else learner).is_empty():
  if is_mentor:mentor=str(pick.get_item_metadata(0))
  else:learner=str(pick.get_item_metadata(0))
  refresh()
 pick.item_selected.connect(func(i:int):
  if is_mentor:mentor=str(pick.get_item_metadata(i))
  else:learner=str(pick.get_item_metadata(i))
  refresh())
