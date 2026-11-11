# Prueba alternativa: hoja oscura

Nueva hoja de Ant (JPEG 1408x768), conservada intacta en `art/world/alternative92/source.jpg`. Comparación con el césped claro actual de las tres variantes. Rama de prueba, sin APK ni main.

## Diagnóstico y extracción

El cuadriculado está pintado, no es transparencia. Se ha retirado por luminosidad y neutralidad del color, conservando el contorno coloreado del camino. Se retiran tres píxeles de margen del panel JPEG antes del escalado para no arrastrar sus separadores blancos.

Las dos piezas centrales son cruces de cuatro brazos, no hay una T. No son exactamente la misma imagen, aunque comparten topología; la diferencia media entre las dos extracciones es 6,60/255 incluyendo alfa. Se ha preparado una T con la mitad superior de la recta y la mitad inferior de la primera cruz. El montaje de piezas muestra recta, curva, dos cruces, esa T derivada, final y punto. La prueba verifica que ambas cruces abren cuatro bocas y la T solo tres.

El césped original no tiene bordes idénticos: diferencia RGB media entre bordes izquierdo/derecho 31,24/255 y arriba/abajo 6,01/255. Repetir el recorte directamente puede mostrar empalmes. Para la prueba en mundo se utiliza una textura precalculada de fragmentos de ese mismo césped con posiciones, giros y reflejos irregulares, pesos normalizados y sombreado amplio igualado. Sin arte nuevo. Queda más oscuro y sobrio que la variante clara. En las vistas general y ampliada inspeccionadas no se ven las franjas horizontales anteriores. Mantiene matas reconocibles, algo suavizadas por la mezcla; la textura de 1024 unidades se repite, no es aleatoriedad infinita.

## Prueba en el mundo

El recorrido y anchos de caminos se conservan. La recta de esta nueva hoja forma la banda de las curvas suaves y accesos existentes; no se fuerzan las curvas cuadradas de la hoja sobre las curvas libres del mundo. La primera cruz extraída y la T derivada se dibujan explícitamente en las cuatro uniones ya identificadas. La segunda cruz, el final y el punto se muestran extraídos para revisión, pero no se inventan intersecciones ni finales nuevos para colocarlos. Se corrigieron líneas blancas de los extremos del recorte de recta usando solo su interior y un espejo continuo.

La selección alternativa está aislada en `WorldTerrainPreview92.alternative`, desactivada por defecto. `tools/qa_grass92.tscn` la activa para esta captura. El mundo normal sigue con el césped claro y la primera recta hasta que Ant elija. Se mantienen el lazo de mano y Encargos dorado en ambas alternativas.

El comparativo pone ambas capturas 1598x720 una junto a otra sin reescalar sus píxeles. Misma semilla, cámara, posición del jinete y animal sujeto; puede cambiar algún fotograma de animación o animal ambiental. No es captura Android ni réplica de la partida del móvil. La ampliación permite comprobar empalmes y contraste con edificios.

## Verificación y límites

- 509/509 pruebas unitarias, 59.003 aserciones, incluidos alfa de fondo y topología de cruces/T.
- Capturas general, ampliación y montaje de piezas inspeccionadas tras quitar separadores blancos.
- No se cambian colisiones, generadores, guardados, mecánica del lazo o edificios.
- Usa el mismo dibujo de suelo cacheado que la alternativa clara. No se ha hecho un nuevo benchmark específico de esta hoja ni se ha probado en Android.
- Persisten pequeños codos angulosos y diferencias de textura entre bandas y piezas. El resultado es una alternativa para elegir, no un cambio silencioso del acabado actual.

Receta reproducible: `python tools/alternative92.py`. Solo recorta y transforma píxeles de la hoja suministrada.
