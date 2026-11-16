# Rancho Prueba 2.7.174: llegadas y equipo de Juanito

APK de prueba Android, versión interna 433. Mismo paquete y firma que 2.7.173, instalar encima. Sin merge a main ni tienda. Conserva la partida y las compras de fusta existentes.

## Llegada a pueblos

La primera aproximación a cada pueblo aleja la cámara hasta mostrar su contorno completo, espera un segundo y vuelve al zoom manual anterior. Salida/vuelta de 0,65 segundos cada una. El jugador sigue activo. Se recuerda por partida, semilla, versión del mundo y pueblo al completar la secuencia. Un mapa, diálogo, lazo, regate o toque de zoom la interrumpe; no insiste durante esa sesión. El OSD muestra el zoom real y el tiempo de la panorámica.

No se cargan más sectores para la vista. Un dibujo temporal del terreno y contorno usa la misma geometría y material. A mucha distancia se simplifica la decoración, sin cambiar objetivos, colisiones ni simulación.

## Equipo de Juanito

Compra y equipamiento separados con puntos del juego, nunca dinero real. Una mejora requiere el básico. La confirmación muestra coste y saldo posterior; si el guardado falla se deshace la compra.

| Equipo | Básico / mejora adicional | Efecto |
| --- | ---: | --- |
| Fusta | 1.000 / +2.000 | Trazo de regate 260 / 420 px, no alcance del lazo |
| Montura | 800 / +1.600 | Gasto de resistencia al trotar/galopar -5% / -10% |
| Riendas | 600 / +1.200 | Recarga del regate -5% / -10% |
| Estribos | 700 / +1.400 | Aturdimiento -5% / -10%; sigue soltando capturas |
| Espuelas | 900 / +1.800 | +10% de velocidad durante 1 / 1,3 s, recarga 8 / 7 s, coste 15% de resistencia máxima |
| Sombrero o manta | 300 / +600 cada familia | Solo apariencia, se pueden quitar |

Las espuelas tienen botón propio, solo en mundos con resistencia, sin apilar con regate/salto/golpe ni funcionar agotado. Herraduras visibles pero bloqueadas: todavía no existe penalización de terreno difícil sobre la que aplicar el descuento. Alforjas aplazadas hasta inventario limitado. No se han inventado esas dependencias para vender artículos sin efecto.

## Suposiciones

- Primera vez significa por pueblo y partida/semilla, no cada sesión.
- El jugador mantiene el control durante la panorámica; tocar zoom la cancela.
- Correr para la montura incluye trote y galope, no caminar ni reposo.
- La fusta no retira un regate ya aprendido. Fusta no es alcance del lazo.
- Espuelas se limitan al mundo con resistencia, no Rodeo/carreras/duelos/justas.
- Paletas cosméticas elegidas: sombrero negro o azul/dorado, manta roja o azul/dorada.

## Validación y límites

224/224 pruebas, 17.927 aserciones, 35 scripts: cámara, paredes de seis pueblos, persistencia y cancelación, controles táctiles sintéticos, puntos, compra, rollback, efectos y cosméticos. Capturas revisadas del catálogo a 1280x720 y 960x540, compra, HUD y seis panorámicas. No es una partida completa ni una prueba de teléfono físico.

Medición conjunta en escritorio: Godot 4.7.2, Vulkan mobile/llvmpipe, 1280x720. Con equipo equipado y nueve sectores cargados, no se añaden sectores por la panorámica. El promedio baja en las seis muestras. La primera batería tuvo un p95 de 33,88 frente a 30,46 ms en town6; la repetición conjunta da 30,03 frente a 31,40 ms. Se conserva la variación, no se promete coste cero universal ni se certifica rendimiento Android. Persisten avisos de limpieza al salir del arnés y deprecaciones, sin fallo de aserciones.

No se dan por corregidos los atascos de sesiones largas ni Rodeo 20. Coronas de prueba e Instinto no se cambian. Detalle: ARRIVAL_244_QA.md, JUANITO_EQUIPMENT_243.md y JSON/capturas de review174.
