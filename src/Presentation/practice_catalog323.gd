class_name PracticeCatalog323
extends RefCounted
# Each mechanic supplies one factory and unlock key. Menu replay and first-use
# guidance use the same factory; adding another demo needs no menu code.
static func entries323()->Array:
 return [{"id":"controls","title":"Mover y apuntar","hint":"Dedo izquierdo y lazo derecho"},{"id":"bull","title":"Mi primer toro","hint":"Acercarse, capturar, guiar y soltar"}]
static func create323(id:String)->Node:
 if id=="bull":return BullTutorial323.new()
 if id=="controls":
  var intro:=StoryIntro319.new();intro.persist319=false;intro.page319=6;intro.practice_only323=true;return intro
 return null
static func show323(parent:Node,id:String,after:Callable=Callable())->Node:
 var demo:=create323(id)
 if demo==null:return null
 if after.is_valid():demo.finished.connect(after)
 parent.add_child(demo);return demo
