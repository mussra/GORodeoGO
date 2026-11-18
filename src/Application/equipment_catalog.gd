class_name EquipmentCatalog
extends RefCounted

## Juanito's saddlery catalog (Ant OK 16-nov-2026 21:46, "Implementa y válida todo").
## Prices/effects from IDEAS_FUTURAS-rev2 (guarnicionero table + spurs 21:28).
## One item per slot, buy once then equip free, upgrade requires the basic item.
## No real money, no wear, no repairs. Alforjas stay blocked until a limited
## inventory exists. Points rewards below unchanged.
const REWARDS:Dictionary={1:10,2:25,3:60,4:110,5:200,6:320,7:470,8:650,9:820,10:1000,11:1300,12:1700,13:2200,14:2800,15:3500,16:4300,17:5200,18:6200,19:7300,20:8500,21:8600,22:8700,23:8800,24:8900,25:9000,26:9100,27:9200,28:9300,29:9400,30:9500,31:9600,32:9700,33:9800,34:9900,35:10000,36:10100,37:10200,38:10300,39:10400,40:10500}
const ITEMS:Dictionary={
 "scare_whip265":{"name":"Látigo de chasquido","slot":"scare_whip","price":250,"scare_level265":1,"icon":"whip","description":"Ruido sin daño; consulta sus barras de alcance y duración."},
 "scare_whip_plus265":{"name":"Látigo de chasquido mejorado","slot":"scare_whip","price":500,"requires":"scare_whip265","scare_level265":2,"icon":"long","description":"Mayor alcance y duración del ruido. Sin golpes ni daño."},
 "lasso_small257":{"name":"Lazo largo de captura","slot":"lasso","price":200,"small_lasso_range":1.5,"icon":"reins","description":"Mayor alcance y facilidad de captura para cerdos y cabras; toros sin cambios."},
	"whip_basic":{"name":"Fusta","slot":"whip","price":1000,"reach":260.0,"icon":"whip","description":"Habilita el regate; consulta su barra de alcance."},
	"whip_long":{"name":"Fusta mejorada","slot":"whip","price":2000,"requires":"whip_basic","reach":420.0,"icon":"long","description":"Mayor alcance de regate; no aumenta la velocidad."},
	"saddle_basic":{"name":"Montura de viaje","slot":"saddle","price":800,"running_drain_mult":0.95,"icon":"saddle","description":"Consulta las barras de propiedades; mejor valor hacia la derecha."},
	"saddle_improved":{"name":"Montura reforzada","slot":"saddle","price":1600,"requires":"saddle_basic","running_drain_mult":0.90,"icon":"saddle","description":"Consulta las barras de propiedades; mejor valor hacia la derecha."},
	"reins_basic":{"name":"Riendas de precisión","slot":"reins","price":600,"dodge_recharge_mult":0.95,"icon":"reins","description":"Consulta las barras de propiedades; mejor valor hacia la derecha."},
	"reins_improved":{"name":"Riendas maestras","slot":"reins","price":1200,"requires":"reins_basic","dodge_recharge_mult":0.90,"icon":"reins","description":"Consulta las barras de propiedades; mejor valor hacia la derecha."},
	"stirrups_basic":{"name":"Estribos de equilibrio","slot":"stirrups","price":700,"stun_mult":0.95,"icon":"stirrups","description":"Consulta las barras de propiedades; mejor valor hacia la derecha."},
	"stirrups_improved":{"name":"Estribos anclados","slot":"stirrups","price":1400,"requires":"stirrups_basic","stun_mult":0.90,"icon":"stirrups","description":"Consulta las barras de propiedades; mejor valor hacia la derecha."},
	"shoes_basic":{"name":"Herraduras de camino","slot":"shoes","price":900,"blocked":true,"blocked_reason":"Pendiente de terreno difícil","icon":"shoes","description":"Pendiente de terreno difícil; sin efecto disponible."},
	"shoes_improved":{"name":"Herraduras de herrero","slot":"shoes","price":1800,"requires":"shoes_basic","blocked":true,"blocked_reason":"Pendiente de terreno difícil","icon":"shoes","description":"Pendiente de terreno difícil; sin efecto disponible."},
	"spurs_basic":{"name":"Espuelas","slot":"spurs","price":900,"spur_boost":0.10,"spur_seconds":1.0,"spur_cooldown":8.0,"spur_stamina_cost":0.15,"icon":"spurs","description":"Consulta las barras de propiedades; mejor valor hacia la derecha."},
	"spurs_improved":{"name":"Espuelas finas","slot":"spurs","price":1800,"requires":"spurs_basic","spur_boost":0.10,"spur_seconds":1.3,"spur_cooldown":7.0,"spur_stamina_cost":0.15,"icon":"spurs","description":"Consulta las barras de propiedades; mejor valor hacia la derecha."},
	"cosmetic_hat":{"name":"Sombrero de gala","slot":"cosmetic_hat","price":300,"cosmetic":true,"icon":"hat_gala","description":"Solo apariencia, sin ventaja de juego"},
	"cosmetic_hat_deluxe":{"name":"Sombrero bordado","slot":"cosmetic_hat","price":600,"requires":"cosmetic_hat","cosmetic":true,"icon":"hat_gala","description":"Variante elaborada; solo apariencia"},
	"cosmetic_blanket":{"name":"Manta de montura","slot":"cosmetic_blanket","price":300,"cosmetic":true,"icon":"blanket","description":"Solo apariencia, sin ventaja de juego"},
	"cosmetic_blanket_deluxe":{"name":"Manta bordada","slot":"cosmetic_blanket","price":600,"requires":"cosmetic_blanket","cosmetic":true,"icon":"blanket","description":"Variante elaborada; solo apariencia"},
}
## Display order for Juanito's panel.
const ORDER:Array[String]=["scare_whip265","scare_whip_plus265","lasso_small257","whip_basic","whip_long","saddle_basic","saddle_improved","reins_basic","reins_improved","stirrups_basic","stirrups_improved","shoes_basic","shoes_improved","spurs_basic","spurs_improved","cosmetic_hat","cosmetic_hat_deluxe","cosmetic_blanket","cosmetic_blanket_deluxe"]

static func effect_value(id:String,key:String,fallback:float=1.0)->float:
	var item:Variant=ITEMS.get(id,null)
	if typeof(item)!=TYPE_DICTIONARY:return fallback
	return float(item.get(key,fallback))
