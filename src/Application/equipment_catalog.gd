class_name EquipmentCatalog
extends RefCounted

## Candidate balance for review, NOT connected to live rewards or legacy migration.
## The user's 1/5/10 examples anchor the candidate. Remaining numbers are tuning.
const REWARDS:Dictionary={1:10,2:25,3:60,4:110,5:200,6:320,7:470,8:650,9:820,10:1000,11:1300,12:1700,13:2200,14:2800,15:3500,16:4300,17:5200,18:6200,19:7300,20:8500,21:8600,22:8700,23:8800,24:8900,25:9000,26:9100,27:9200,28:9300,29:9400,30:9500,31:9600,32:9700,33:9800,34:9900,35:10000,36:10100,37:10200,38:10300,39:10400,40:10500}
const ITEMS:Dictionary={
	"whip_basic":{"name":"Fusta","slot":"whip","price":1000,"reach":260.0,"description":"Habilita el regate con trazo de hasta 260 px"},
	"whip_long":{"name":"Fusta mejorada","slot":"whip","price":2000,"requires":"whip_basic","reach":420.0,"description":"Amplía el trazo hasta 420 px; no aumenta la velocidad"},
}
