# Rancho Prueba 2.7.172

APK de prueba Android. Misma aplicación y firma que 2.7.171, versión interna 431. Se instala encima y conserva el guardado de prueba. Sin cambios en main ni publicación en tienda.

## Cambios

- OSD solo en modo debug: FPS, tiempo medio y pico de fotograma, tiempos del motor/física, memoria, llamadas de dibujo, nodos/objetos y duración/fallos/tamaño de los guardados. CPU del hilo principal y E/S cuando el dispositivo permite leerlos. CPU/GPU del sistema y porcentaje GPU figuran como N/D, sin inventar medidas.
- Mapa sin puntos decorativos, glifos ni manchas de flores. Las flores y objetivos del mundo siguen existiendo. El terreno del mapa se rasteriza en una textura al cambiar, en vez de reenviar miles de dibujos por fotograma. Conserva zoom, arrastre, notas y marcadores de sitios.
- Lista de PNJ reutilizada mientras no cambian la semilla o zona de la red de pueblos, en vez de reconstruirla cada fotograma.
- Muros de pueblo con un contorno continuo y esquinas redondeadas, respetando geometría de colisión y pasos existentes. Conservan colores y materiales de cada pueblo.
- Caminos dibujados por capas: primero todos los bordes y después todos los interiores. Los cruces T/X/Y ya no muestran un borde atravesando el camino.
- Cartel de pueblo en pantalla, debajo de la barra superior, para que los nombres largos no se corten con la cámara.
- TIEMPO BALA en una capa de pantalla compartida, fuera de los sprites del jinete.
- Cactus de silueta redondeada. Joystick más pequeño (160 frente a 220; centro 48 frente a 80) y centro claro/translúcido; mismo sistema de entrada.
- El APK excluye documentos, pruebas y utilidades de desarrollo.

## Medición antes/después

Escritorio Linux, Godot 4.7.2, Vulkan mobile con llvmpipe, 1280x720, 400 sectores descubiertos y 9 activos, semilla 752026, generador V6. OSD apagado para medir. No son FPS de un teléfono.

| Escenario | Antes, media ms | Después, media ms | Dibujo antes/después |
| --- | ---: | ---: | ---: |
| Frontera quieto | 25,56 | 23,00-23,04 | 448 / 269 |
| Desplazamiento corto ida/vuelta | 25,93 | 22,62-22,82 | 469 / 276 |
| Mapa ampliado | 65,03 | 27,95-29,28 | 4.522 / 288 |
| Rodeo nivel 20 | 35,34 | 33,84-34,12 | 441 / 441 |

Se conservan dos mediciones finales para no ocultar la variación. El mapa reduce aproximadamente un 94% las llamadas de dibujo. Rodeo 20 no queda resuelto por este cambio: la diferencia observada es pequeña y conserva las mismas llamadas de dibujo.

## Pruebas y límites

- 139/139 pruebas y 7.193 comprobaciones, incluidas caché, guardados, gestos, carreteras, seis formas de muro, progreso y pérdidas de toque. Ventana de escritorio con entrada táctil sintética.
- Prueba de 60 segundos saltando al segundo pueblo y volviendo, con guardado aislado real: 380 nodos estables, 20 guardados, 0 fallos, máximo 1,231 ms por guardado. No reproduce toda una partida ni descarta un problema prolongado en Android.
- Revisión visual de mapa, zoom/arrastre, OSD, muros, caminos, cartel, tiempo bala, cactus y joystick. Capturas en `docs/review172`.
- APK exportado y firma verificada. No probado en un teléfono físico. Dos avisos de ObjectDB al cerrar la batería de escritorio siguen pendientes de aislar.
- Si la partida vuelve a atascarse en el móvil, el OSD permite distinguir caídas de FPS, crecimiento de nodos/objetos y guardados lentos. Los contadores no disponibles se muestran como N/D.

Datos completos: `QA_2_7_172.json` y los JSON de `docs/review172`. No se da por corregido el atasco largo de la partida ni el rendimiento móvil del nivel 20 hasta comprobarlos en dispositivo.
