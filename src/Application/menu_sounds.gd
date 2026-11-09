extends Node
## PROVISIONAL original synthesized markers. Final files must come from a free
## library with documented redistribution/commercial rights. See ASSET_REGISTER.md.
const FILES:Dictionary={"tap":"res://audio/ui/tap.wav","open":"res://audio/ui/open.wav","back":"res://audio/ui/back.wav"}
var voices:Array[AudioStreamPlayer]=[]
var sounds:Dictionary={}
var next:int=0
var last_msec:int=-1000
func _ready()->void:
 process_mode=Node.PROCESS_MODE_ALWAYS
 var maker:=RanchAudio.new()
 sounds={"tap":maker._make_cue([600.0],.025),"open":maker._make_cue([390.0,520.0],.035),"back":maker._make_cue([520.0,390.0],.035)}
 maker.free()
 for cue in FILES:
  if ResourceLoader.exists(FILES[cue]):sounds[cue]=load(FILES[cue])
 for i in range(3):
  var voice:=AudioStreamPlayer.new();voice.volume_db=-26.0;add_child(voice);voices.append(voice)
func play(cue:String)->void:
 if not GameState.sound_enabled or not sounds.has(cue) or voices.is_empty():return
 var now:int=Time.get_ticks_msec()
 if now-last_msec<45:return
 last_msec=now
 var voice:AudioStreamPlayer=voices[next];next=(next+1)%voices.size()
 voice.stream=sounds[cue];voice.play()
