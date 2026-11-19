class_name DialogueLabel319
extends Label
## The full text stays intact for fitting and localization; only glyph visibility changes.
const SPEED:float=45.
const MAX_SECONDS:float=9.5
var characters_per_second319:float=SPEED
var elapsed319:float=0.
var duration319:float=0.
var previous319:String=""
func _ready()->void:
 visible_characters_behavior=TextServer.VC_CHARS_AFTER_SHAPING
 process_mode=Node.PROCESS_MODE_ALWAYS
 mouse_filter=Control.MOUSE_FILTER_PASS
 restart319()
func restart319()->void:
 previous319=text;elapsed319=0.;duration319=seconds319(text.length(),characters_per_second319);visible_characters=0
func _process(delta:float)->void:
 if text!=previous319:restart319()
 elapsed319+=delta
 if elapsed319>=duration319:visible_characters=-1
 else:visible_characters=int(floor(text.length()*elapsed319/maxf(duration319,.001)))
static func seconds319(count_:int,speed_:float=SPEED)->float:
 return minf(MAX_SECONDS,float(count_)/maxf(speed_,1.))
func finish319()->void:
 elapsed319=duration319;visible_characters=-1
func _gui_input(event:InputEvent)->void:
 if (event is InputEventMouseButton and event.pressed and event.button_index==MOUSE_BUTTON_LEFT) or (event is InputEventScreenTouch and event.pressed):
  finish319();accept_event()
