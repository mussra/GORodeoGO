# Rancho Prueba 2.7.173: cámara con vista general

APK de prueba para Android. Mismo paquete y firma que 2.7.172, versión interna 432. Instalar encima conserva la partida. Sin merge a main ni publicación en tienda.

## Cómo se usa

En Mundo Libre/Frontera hay tres botones arriba a la derecha, debajo de Menú:

- **-** aleja: 100% -> 85% -> 75%.
- **+** acerca hasta la vista normal del 100%.
- **Porcentaje** vuelve al 100% con un toque.

A 75% se ve un 33% más de ancho y alto, alrededor de un 78% más de superficie. Se recuerda la elección en preferencias, separada del guardado de la partida. El HUD y los joysticks conservan su tamaño. El zoom del mapa sigue siendo independiente.

Decidí usar botones y no pellizco para no compartir dedos con movimiento, lazo y regate. El límite se ajusta en pantallas muy anchas para que no entren sectores sin cargar. En diálogos, mapa, encargos y menús los botones de cámara se ocultan.

## Rendimiento

No se amplía el radio de generación/carga por alejar la cámara. Solo se ocultan las flores pequeñas puramente decorativas al usar vista general; flores recogibles, árboles, obstáculos, animales, colisiones y objetivos se conservan. El OSD debug muestra el porcentaje y el nivel de detalle decorativo.

Comparación de escritorio, no de un teléfono: Godot 4.7.2, Vulkan mobile con llvmpipe, 1280x720, semilla 752026, generador V6, 400 sectores descubiertos. En cada sitio se alternó 100/75/100/75%, con 150 fotogramas por medición después de cargar y estabilizar. Tabla con la media de las dos pasadas:

| Lugar | 100%, ms/fotograma | 75%, ms/fotograma | Dibujo 100% / 75% |
| --- | ---: | ---: | ---: |
| Rancho | 22,41 | 22,50 | 275 / 282 |
| Borde de sector | 22,25 | 22,53 | 275 / 277 |
| Pueblo 1 | 29,95 | 29,59 | 297 / 294 |
| Pueblo 2 | 26,43 | 26,26 | 306 / 309 |

No hay una caída sostenida en estos escenarios y los nodos/sectores no crecen al cambiar zoom. No significa coste cero: los dibujos varían entre -3 y +7 y no se ha probado en un Android físico. Se conserva la variación y una segunda confirmación en los JSON adjuntos. Los FPS del OSD son muestras separadas de 0,5 s; no deben confundirse con estas medias. El monitor de tiempo del motor puede mostrar el coste de guardar una captura anterior.

No se da por corregido el atasco tras sesiones largas ni el rendimiento de Rodeo 20 con esta función.

## Pruebas

158/158 pruebas, 7.273 comprobaciones. Incluyen límites, preferencia guardada, LOD solo decorativo, tocar zoom mientras se mantiene el joystick, reset sin lanzar lazo ni mover, y el mismo contacto físico con un muro a 100% y 75%. Capturas revisadas con joystick, mapa y pantallas de 640x360, 1280x720 y formato ancho. Pruebas táctiles sintéticas de escritorio, no teléfono físico.

## Idea de Juanito, pendiente de OK

`docs/IDEAS_FUTURAS.md` recoge al guarnicionero como fabricante de fusta y otras piezas: montura, riendas, estribos, herraduras, cosméticos y alforjas futuras. Incluye precios y efectos candidatos para revisar. No se implementa equipo, puntos ni economía en esta APK.

Capturas y mediciones: `docs/review173`. Resumen técnico: `QA_2_7_173.json`.
