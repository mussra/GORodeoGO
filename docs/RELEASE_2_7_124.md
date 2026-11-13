# Rancho Prueba 2.7.124

## Campaña II: niveles21-40

Veinte retos nuevos con diez toros, dos o tres recintos y distintos grupos, enlaces de apertura, orientación y obstáculos. Los cronómetros van de4 a8minutos. Los cierres siguen pudiendo abrirse manualmente y los toros mensajeros recorren físicamente los enlaces, sin teletransportarse ni atravesar obstáculos.

El selector permite desplazarse hasta el nivel40 y abre la zona del siguiente reto disponible. Los niveles1-20 conservan su catálogo.

## Galaxy: una llave al20, otra al40

Superar el20 habilita una adquisición Galaxy; superar el40 habilita la segunda. Los puntos siguen siendo necesarios, pero no sustituyen a las llaves. Repetir una victoria, recargar o vender un caballo no devuelve la llave. Cada oferta Galaxy mantiene su aspecto mientras se completan más niveles.

Se conserva toda la colección. En partidas anteriores, los Galaxy adquiridos sin padres, incluidos los vendidos conservados en la genealogía, cuentan para las llaves ya ganadas. Los descendientes no gastan llaves adicionales. No se borra ningún caballo por superar el límite anterior.

En nuevos cruces, Galaxy con normal ya no produce Galaxy. Dos Galaxy producen una cría Galaxy puro, no un unicornio directo. No se modifican crías anteriores.

## Maestría sin perder lo conseguido

Campaña I y Campaña II se cuentan por separado, veinte niveles distintos cada una. La maestría muestra el mejor bloque completado: un caballo que ya tenía100% conserva100%; diez niveles de cada campaña no equivalen a completar una campaña. La ficha muestra ambos avances.

## Compatibilidad y comprobaciones

Mismo paquete y firma que2.7.123, versión interna383, Android arm64. Instalar encima conserva la partida; no desinstalar para actualizar.

Probado en simulación de escritorio: catálogo y geometría de los veinte niveles, recorridos físicos de mensajeros en todos ellos, llaves20/40, compra/recarga, repetición de victoria, venta, migración antigua, oferta manipulada y reversión de puntos/llave/caballo si falla el guardado. Revisados selector1280×720 y960×540, mercado, ficha de maestría antigua y arenas nuevas.

Los cronómetros son presupuestos de diseño, no horas medidas de juego humano. No hay prueba física en un dispositivo Android. El crecimiento normal y el ritual de la fuente siguen pendientes; esta versión no permite completar todavía toda la cadena del unicornio.

Resultado de pruebas:665/665unitarias (2.560.593aserciones),131/131integración dirigida, con una segunda pasada de los20recorridos físicos. Advertencias conocidas al cerrar las pruebas: recursos/objetos sin liberar. Una ampliación fuera de la batería dirigida encontró cuatro fallos antiguos (touch/escape/estación) que se reprodujeron con los mismos resultados en el commit2.7.123; no se consideran corregidos en esta entrega.

SHA256 del APK: `95530f03b9ea9123ef67a818d162ef6de0fbc0c3e55c174a6facfc46aa6ef8c9`.
