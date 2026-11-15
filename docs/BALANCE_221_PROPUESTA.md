# Equilibrio: opciones medidas, sin aplicar

15 de noviembre de 2026. Base: Rancho 2.7.158, commit e1fd85e. Ningún ajuste de equilibrio de este informe está en la APK.

## Recomendación

Para la afinidad regional, probaría 50/40 en una APK posterior solo si Ant lo elige: mantiene identidad local y reduce la ventaja de doma frente al 70/60 actual. Para los niveles 15-19 no cambiaría aún la dificultad: el fallo que motivó la alerta era en buena parte del conductor de la prueba, que enlazaba mientras estaba aturdido. Al respetar la restricción real, la configuración actual logra la primera entrega en 15 de 15 recorridos. Esto no certifica completar los niveles ni sustituye jugar en el teléfono.

## 1. Afinidad regional

Mismos 2500 grupos y 9976 caballos, mismo generador y semillas, hasta 1000 unidades del Pueblo Estrella Lavanda. Montura con capa y patrón del pueblo y crin 0. Cambian solo las probabilidades de patrón/capa de la copia de análisis, no las del juego. El 25% adicional de capas cercanas y los demás rasgos se conservan.

Los segundos son el tiempo teórico de llenado desde cero con lazo ya aterrizado, Serenidad 1 y temperamento de cada ejemplar. No incluyen acercarse, apuntar, vuelo ni fallos. Se calcula la media del tiempo individual, no el inverso del multiplicador medio.

| Opción | Patrón/capa local | Multiplicador medio | Tiempo medio de llenado | Frente a población original | Dos o más rasgos iguales |
| --- | --- | ---: | ---: | ---: | ---: |
| Referencia aleatoria | Sin afinidad regional | 1,0749 | 2,012 s | - | 2,78% |
| A. Mantener | 70% / 60% | 1,3748 | 1,585 s | 21,3% menos tiempo | 52,04% |
| B. Intermedia | 50% / 40% | 1,2811 | 1,707 s | 15,2% menos tiempo | 30,99% |
| C. Suave | 35% / 30% | 1,2216 | 1,791 s | 11,0% menos tiempo | 20,66% |

Las coincidencias observadas son algo mayores que las probabilidades forzadas porque el resto también puede coincidir por azar. A hace más útil elegir la montura según el pueblo, B es un punto medio y C deja más diversidad local pero debilita la lectura visual del pueblo.

No se ha cambiado el +25% por rasgo de la doma: ese mecanismo fue una decisión anterior y tocarlo afectaría toda la población, no solo los pueblos. A más de 3000 unidades de cualquier pueblo sigue intacta la población aleatoria original. Los caballos existentes y la colección no se recolorean con ninguna de estas propuestas.

## 2. Qué estaba mal en la prueba de los niveles 15-19

La prueba llamaba directamente a `resolve_capture` sin comprobar si el jugador podía lanzar. Así recapturaba durante el aturdimiento, cuando los controles del jugador no lo permiten. El resultado anterior de cero entregas tras 150 segundos y muchos golpes no justificaba concluir que el juego fuera imposible o necesitara bajar dificultad.

Se repitió la prueba con el mismo conductor y reglas, añadiendo la comprobación real de si puede lanzar. El contacto sigue aturdiendo y soltando capturas. En la semilla original ahora hay primera entrega en 9,45 / 33,42 / 12,48 / 22,37 / 21,43 segundos para los niveles 15 / 16 / 17 / 18 / 19.

La prueba corregida sigue siendo una aproximación: usa la resolución directa de captura cuando el objetivo está a alcance, no puntería humana ni vuelo completo. Sirve para comparar movimiento/persecución/arrastre, no para certificar la experiencia completa. Se ha corregido el conductor de la prueba; ninguna regla del juego se cambió para hacerla pasar.

## 3. Alternativas numéricas para 15-19

Cinco niveles por tres semillas: 20261105, 20261106 y 20261107. 15 recorridos por opción. Ventana de 150 segundos simulados hasta la primera entrega. Misma montura, conductor y colocación inicial. Las variantes solo se inyectan en la escena de análisis y no se guardan. Se conservan el golpe, el aturdimiento y que suelte la captura.

| Opción | Ajuste de análisis | Recorridos con primera entrega | Mediana hasta entrega o corte | Rango observado | Golpes que inician aturdimiento | Pérdidas de captura |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| A. Actual | Perseguidor tras 1 s; velocidad salvaje 180 | 15/15 | 22,37 s | 8,17-115,12 s | 62 | 61 |
| B. Más margen | Perseguidor tras 2,5 s | 14/15 | 17,92 s | 8,18-150 s (corte) | 44 | 44 |
| C. Salvajes más lentos | Velocidad 153 (-15%) | 15/15 | 13,93 s | 11,55-29,90 s | 85 | 85 |

B reduce golpes pero no mejora de forma consistente: un recorrido no entrega en la ventana. C acelera las primeras entregas en este conductor, pero aumenta los golpes y también cambia la huida de todos los toros salvajes, no solo la persecución. Ninguna merece aplicarse a ciegas. A es mi elección provisional hasta jugar de verdad en móvil y probar completar los diez animales, no solo uno.

No propongo aumentar el reloj con estos datos. Los niveles tienen límites de 320, 340, 360, 390 y 410 segundos; la prueba corta a 150 y no intentaba completar todo el nivel. Multiplicar el tiempo de primera entrega por diez tampoco sería una estimación válida: puertas, posiciones y población cambian durante la partida.

## Decisiones para Ant

- Afinidad: A (70/60), B (50/40, mi propuesta de prueba) o C (35/30).
- Niveles 15-19: mantener A mientras se juega en móvil (mi propuesta), o preparar una APK separada con B o C para compararla. Ninguna elimina "que suelte".

## Evidencia y límites

Fuentes primarias: `src/Application/herd_town217.gd`, `src/Application/world_taming.gd`, `src/Application/chaser_director.gd`, `src/Application/bull_tuning.gd`, `src/Presentation/player.gd`, `src/Presentation/bull.gd`, `src/Presentation/level_0.gd` y el conductor `tests/integration/test_campaign_live_tow.gd`.

Datos: `BALANCE_221_afinidad.json` y `BALANCE_221_niveles.json`. Instrumentación: `tools/measure_affinity221.gd` y `tools/test_balance_levels221.gd`. Ejecuciones locales a 60 pasos fijos; sin Android físico. Tres semillas permiten detectar diferencias grandes, no estimar con precisión el éxito humano. No se han aplicado cambios de equilibrio ni de huertos.
