class_name HornRig176
extends RefCounted
## Preparation only. No art is generated, no existing texture/mask is modified.
const VIEWS:Array[String]=["side","down","up","diag_down","diag_up"]
const RULE:int=1
static func view_for(spec:Dictionary)->String:
 if spec.get("kind","")=="portrait":return "diag_down"
 var view:String=str(spec.get("view","side"))
 if view.begins_with("jump_"):view=view.trim_prefix("jump_")
 return view if view in VIEWS else "side"
static func valid_asset(asset:Dictionary)->bool:
 if asset.get("approved",false)!=true or asset.get("view","") not in VIEWS:return false
 if not asset.get("path") is String or not str(asset.path).ends_with(".png"):return false
 if not asset.get("size") is Vector2 or not asset.get("base") is Vector2 or not asset.get("tip") is Vector2:return false
 if not asset.size.is_finite() or asset.size.x<=0 or asset.size.y<=0:return false
 if not asset.base.is_finite() or not asset.tip.is_finite() or asset.base.distance_to(asset.tip)<1.:return false
 var rect:=Rect2(Vector2.ZERO,asset.size)
 return rect.has_point(asset.base) and rect.has_point(asset.tip)
static func valid_anchor(anchor:Dictionary)->bool:
 if anchor.get("approved",false)!=true or not anchor.get("base") is Vector2 or not anchor.get("tip") is Vector2:return false
 if not anchor.base.is_finite() or not anchor.tip.is_finite() or anchor.base.distance_to(anchor.tip)<1.:return false
 # Occlusion is explicit even when none is needed. Never put a fixed horn over eyes/ears.
 if anchor.get("occlusion","") not in ["none","mask"]:return false
 if anchor.occlusion=="mask" and (not anchor.get("occlusion_path") is String or str(anchor.occlusion_path).is_empty()):return false
 return true
static func placement(asset:Dictionary,anchor:Dictionary)->Dictionary:
 if not valid_asset(asset) or not valid_anchor(anchor):return {}
 var source_axis:Vector2=asset.tip-asset.base;var target_axis:Vector2=anchor.tip-anchor.base
 var angle:float=target_axis.angle()-source_axis.angle();var scale_:float=target_axis.length()/source_axis.length()
 var transform:=Transform2D(angle,Vector2.ZERO).scaled_local(Vector2.ONE*scale_)
 transform.origin=anchor.base-transform.basis_xform(asset.base)
 return {"transform":transform,"source":asset.path,"view":asset.view,"occlusion":anchor.occlusion,"occlusion_path":anchor.get("occlusion_path",""),"mirror_with_host":true}
static func allowed(horse:Dictionary,assets:Dictionary,anchors:Dictionary,required:Array[String])->bool:
 if horse.get("species","")!="unicorn" or not UnicornAtlas.VARIANTS.has(horse.get("unicorn_variant","")):return false
 for view in VIEWS:
  if not assets.get(view) is Dictionary or not valid_asset(assets[view]) or assets[view].view!=view:return false
 for key in required:
  if not anchors.get(key) is Dictionary or not valid_anchor(anchors[key]):return false
 return not required.is_empty()
