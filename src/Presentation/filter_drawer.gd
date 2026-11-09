class_name FilterDrawer
extends Control
signal changed(key:String,value:Variant)
signal cleared
var canvas:Control
var fields:VBoxContainer
var count:int=0
var title:String="Filtros"
var show_clear:bool=true
var confirm_text:String="Ver resultados"
func _ready()->void:
 MenuInputGuard.install(self);set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);z_index=150
 var shade:=ColorRect.new();shade.color=Color("10252d");shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(shade)
 canvas=Control.new();canvas.size=Vector2(1280,720);add_child(canvas);resized.connect(layout);layout()
 var bg:=ColorRect.new();bg.color=Color("15343e");bg.position=Vector2(220,85);bg.size=Vector2(840,590);canvas.add_child(bg)
 MenuNavigation.header(canvas,title,queue_free)
 var scroll:=ScrollContainer.new();scroll.position=Vector2(250,115);scroll.size=Vector2(780,465);canvas.add_child(scroll)
 fields=VBoxContainer.new();fields.custom_minimum_size.x=750;fields.add_theme_constant_override("separation",12);scroll.add_child(fields)
 var clear:=Button.new();clear.name="ClearFilters";clear.visible=show_clear;clear.text="Limpiar filtros";clear.position=Vector2(250,605);clear.size=Vector2(300,50);canvas.add_child(clear);clear.pressed.connect(func():cleared.emit();queue_free())
 var done:=Button.new();done.name="ApplyFilters";done.text=confirm_text;done.position=Vector2(710,605);done.size=Vector2(320,50);canvas.add_child(done);done.pressed.connect(queue_free)
func layout()->void:
 var k:float=minf(size.x/1280,size.y/720);canvas.scale=Vector2.ONE*k;canvas.position=(size-Vector2(1280,720)*k)/2
func add_choice(key:String,title:String,options:Array,current:Variant=null,include_all:bool=true)->OptionButton:
 var row:=HBoxContainer.new();row.custom_minimum_size.y=56;fields.add_child(row)
 var label:=Label.new();label.text=title;label.custom_minimum_size.x=250;label.add_theme_font_size_override("font_size",22);row.add_child(label)
 var pick:=OptionButton.new();pick.name="Filter_"+key;pick.custom_minimum_size=Vector2(460,56);row.add_child(pick)
 if include_all:pick.add_item("Todos");pick.set_item_metadata(0,null)
 for option in options:
  pick.add_item(str(option.label));pick.set_item_metadata(pick.item_count-1,option.value)
  if current==option.value:pick.select(pick.item_count-1)
 pick.item_selected.connect(func(i:int):changed.emit(key,pick.get_item_metadata(i)))
 count+=1;return pick
static func button(host:Control,pos:Vector2,active:int,open:Callable)->Button:
 var button:=Button.new();button.name="OpenFilters";button.text="Filtros"+(" · %d"%active if active>0 else "");button.position=pos;button.size=Vector2(210,52);button.pressed.connect(open);host.add_child(button);return button

func _unhandled_input(event:InputEvent)->void:
 if event.is_action_pressed("ui_cancel"):
  queue_free();get_viewport().set_input_as_handled()
