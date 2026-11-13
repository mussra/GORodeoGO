class_name UnicornAtlasPanel
extends Control
## Shadow is a reversible existing horse outline + provisional horn polygon.
## No invented full-colour unicorn is shown before its art/palette is approved.
const BASE=preload("res://art/experimental/pixellab/horse/side/frame_00.png")
const SHADE=Color("263b49")
var canvas:Control
var catalog:Array[Dictionary]=[]
func _ready()->void:
 MenuInputGuard.install(self)
 set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 var bg=ColorRect.new();bg.color=Color("10252d");bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT);add_child(bg)
 canvas=Control.new();canvas.size=Vector2(1280,720);add_child(canvas);resized.connect(_layout);_layout()
 MenuNavigation.header(canvas,"ATLAS · UNICORNIOS",queue_free)
 catalog=UnicornAtlas.entries(HorseGenealogy.records(SaveData.horse_collection))
 var note=Label.new();note.position=Vector2(36,98);note.text="Solo silueta hasta conseguirlo · cinco variantes Galaxy";note.add_theme_font_size_override("font_size",22);canvas.add_child(note)
 for i in catalog.size():
  var e=catalog[i];var at=Vector2(26+(i%3)*420,145+int(i/3)*265)
  var panel=Panel.new();panel.position=at;panel.size=Vector2(402,245);panel.add_theme_stylebox_override("panel",MapAppearance.frame());canvas.add_child(panel)
  var view=TextureRect.new();view.position=Vector2(20,12);view.size=Vector2(200,200);view.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;view.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;view.texture=BASE;panel.add_child(view)
  if e.silhouette:
   var shader=Shader.new();shader.code="shader_type canvas_item; void fragment(){vec4 c=texture(TEXTURE,UV);COLOR=vec4(.149,.231,.286,c.a);}"
   var material=ShaderMaterial.new();material.shader=shader;view.material=material
  else:
   # Full rendering hook: normal collection portrait until approved unicorn art lands.
   HorsePortrait.apply_horse(view,e.horse,SaveData.hat_color)
  if e.silhouette:
   var horn=Polygon2D.new();horn.color=SHADE;horn.polygon=PackedVector2Array([Vector2(20+68*200.0/96,12+37*200.0/96),Vector2(20+71*200.0/96,12+21*200.0/96),Vector2(20+75*200.0/96,12+37*200.0/96)]);panel.add_child(horn)
  var title=Label.new();title.position=Vector2(222,58);title.text=e.name;title.add_theme_font_size_override("font_size",20);panel.add_child(title);TextFit181.fixed(title,Vector2(166,44),20,18,2)
  var state=Label.new();state.position=Vector2(222,105);state.text="No conseguido" if e.silhouette else "Conseguido";state.add_theme_font_size_override("font_size",16);panel.add_child(state);TextFit181.fixed(state,Vector2(166,30),16,16)
 var caveat=Label.new();caveat.position=Vector2(36,688);caveat.text="Preview: contorno reutilizado. Diseño/color final de unicornio aún por aprobar.";caveat.add_theme_font_size_override("font_size",18);canvas.add_child(caveat)
func _layout()->void:
 if canvas==null:return
 var k=minf(size.x/1280,size.y/720);canvas.scale=Vector2.ONE*k;canvas.position=(size-Vector2(1280,720)*k)/2
