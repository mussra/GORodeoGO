# Rancho Prueba 3.0.6

Pre-release para Android, código 466. Rama de pruebas; sin merge a main, sin tienda de aplicaciones ni gasto.

## Propiedades sin cifras técnicas

Un componente común presenta las propiedades en cinco sectores, de Peor a Mejor, sin unidades, cifras ni porcentajes de atributos. La marca blanca conserva la posición actual y el tramo verde muestra la mejora; el dorado muestra el valor del objeto o caballo. Los costes y saldos conservan sus puntos.

Aplicado a tienda de equipo, látigos, fustas, lazo, monturas, riendas, estribos, espuelas, confirmaciones y comparación con lo equipado; resumen de colección, ficha de caballo, habilidades, maestría, linaje, confirmación de venta, entrenamiento, HUD y resultado de entrenamiento y mejora tras victoria. Los cosméticos no reciben ventajas inventadas y las herraduras bloqueadas siguen sin efecto. Las propiedades de caballos no adquiridos siguen por descubrir.

## Rangos por defecto

La tabla única `AttributeRanges306` fija límites internos de representación, no cambios de balance. Un rango se comparte en todas las vistas del mismo atributo. El valor se conserva con precisión dentro del sector, no se redondea a cinco calidades.

| Atributo interno | Peor | Mejor |
|---|---:|---:|
| Velocidad del caballo | 240 | 300 |
| Manejo | 600 | 1500 |
| Fuerza | 0,5 | 0,9 |
| Agilidad | 0,75 | 1 |
| Serenidad | 0,5 | 2 |
| Aprendizaje, dominio, afinidad, maestría, linaje y resumen | 0 | 100 |
| Alcance de ruido | 0 | 310 |
| Duración de ruido | 0 | 1,4 |
| Rapidez de recarga de ruido (5 menos espera) | 0 | 1 |
| Alcance de fusta | 0 | 420 |
| Alcance del lazo (multiplicador) | 1 | 1,5 |
| Facilidad de captura | 58 | 80 |
| Ahorro de esfuerzo, rapidez de riendas, recuperación de estribos | 0 | 0,1 |
| Impulso de espuelas | 0 | 0,1 |
| Duración del impulso | 0 | 1,3 |
| Rapidez de recarga de espuelas (8 menos espera) | 0 | 1 |
| Ahorro de resistencia de espuelas | 0 | 0,15 |
| Beneficio del temple de cruce | 0 | 0,13 |

Los límites incluyen ausencia de beneficio donde existe. Para esperas se presenta rapidez, de modo que mejor siempre queda a la derecha. La recarga básica puede estar en el extremo peor sin significar que no funciona. No se cambian efectos, precios, recompensas ni datos guardados. Estos números son documentación técnica, no texto de la interfaz.

## Validación

456/456 pruebas, 55.482 comprobaciones, 76 scripts, en dos grupos para limitar memoria. Capturas de cada tipo de pantalla afectada, inspeccionadas visualmente. APK firmado verificado, paquete `com.example.rancho.review`, misma firma de pruebas, código creciente 466.

Pruebas en Godot de escritorio, no en Android físico. No se certifican con ello el rendimiento ni la sensación táctil en móvil. Quedan advertencias conocidas del entorno de pruebas: APIs antiguas y dos instancias ObjectDB al salir en algunas ejecuciones.
