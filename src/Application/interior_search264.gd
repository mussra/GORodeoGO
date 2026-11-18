class_name InteriorSearch264
extends RefCounted
## Search and ownership are separate. Search never gives inventory or spends.
## One counter per authored site, not per touch coordinate. No random rewards.
const FIRST_HINT:int=4
const REPEAT_HINT:int=5
const EMPTY_HINT:String="Parece que no hay nada aquí."
const EXHAUSTED_HINT:String="Ya no queda nada más aquí."
var sites:Dictionary={}
func define(id:String,item_id:String="",ownership:String="owner"):
 assert(not id.is_empty())
 assert(ownership in ["owner","free"])
 if sites.has(id):return
 sites[id]={"item":item_id,"ownership":ownership,"found":false,"empty_taps":0}
func tap(id:String)->Dictionary:
 if not sites.has(id):return {"kind":"unknown","message":""}
 var site:Dictionary=sites[id]
 if not str(site.item).is_empty() and not site.found:
  site.found=true;site.empty_taps=0
  return {"kind":"found","item":site.item,"ownership":site.ownership,"message":""}
 site.empty_taps+=1
 var show_hint:bool=site.empty_taps>=FIRST_HINT and (site.empty_taps-FIRST_HINT)%REPEAT_HINT==0
 return {"kind":"empty","message":(EXHAUSTED_HINT if site.found else EMPTY_HINT) if show_hint else ""}
func export_state()->Dictionary:return sites.duplicate(true)
func restore_found(raw:Dictionary):
 # Authored definitions own item/ownership. Saved state can only mark an item
 # already defined here as found. Tap cadence deliberately resets on re-entry.
 for id in sites:
  if raw.has(id) and raw[id] is Dictionary and raw[id].get("found",false)==true and str(raw[id].get("item",""))==str(sites[id].item) and not str(sites[id].item).is_empty():
   sites[id].found=true;sites[id].empty_taps=0
