# Llegada automática a pueblos: validación

Primera aproximación a cada pueblo, por archivo de partida, semilla y versión del mundo. Sale en 0,65 s, se queda 1 s y vuelve en 0,65 s al zoom elegido. No pausa al jugador. Se considera visto al terminar; si se interrumpe no repite durante esa sesión, pero sí puede repetir al entrar de nuevo. Los botones de zoom interrumpen la secuencia. También se interrumpe al abrir mapa/diálogo o empezar lazo/regate.

Para encuadrar contornos mayores que el área simulada, se dibuja temporalmente el terreno y el contorno completo con la misma geometría y material. No se generan más sectores ni colisiones. Los edificios y PNJ mantienen sus componentes compartidos. Al alejar mucho se oculta dibujo decorativo y se restaura después. No se descubren sectores ni se dan recompensas por la vista.

## Medición de escritorio

Godot 4.7.2, renderizador Vulkan mobile/llvmpipe, 1280x720, semilla 752026, generador V6. 100 fotogramas por muestra tras estabilizar. Cámara y jugador fijos para comparar el dibujo. 9 sectores cargados en ambas vistas; tres nodos temporales del contorno/terreno. No es una prueba de Android físico.

| Pueblo | Normal, media ms | Panorámica, media ms | p95 normal / panorámica ms |
| --- | ---: | ---: | ---: |
| home | 27.62 | 26.39 | 30.93 / 30.97 |
| town1 | 29.99 | 29.07 | 32.89 / 31.30 |
| town2 | 26.48 | 25.40 | 28.20 / 27.39 |
| town4 | 30.13 | 29.42 | 32.87 / 32.32 |
| town5 | 27.43 | 26.55 | 29.03 / 28.29 |
| town6 | 28.41 | 27.89 | 30.46 / 33.88 |

Las medias no empeoran en estas muestras. Hay variación: town6 registra p95 33,88 frente a 30,46 ms. No se afirma coste cero garantizado ni se dan por resueltos los atascos de sesiones largas o Rodeo 20.

## Pruebas y revisión

Se probaron todas las paredes de los seis pueblos, encaje matemático para 640x360/1280x720/1600x720, persistencia, cancelación, cámara quieta con jugador en movimiento, restauración de zoom/visibilidad y colisión sin cambios. Capturas de los seis contornos revisadas a 1280x720. La secuencia completa se ejecutó y se capturaron salida, pausa, vuelta y final; `arrival244-timeline.json` conserva zoom, tiempo, sectores y nodos. El OSD muestra el zoom real y tiempo de llegada.

No se ha probado el tacto ni el rendimiento en un teléfono físico. Dos avisos de objetos retenidos al salir y una deprecación siguen presentes en el conjunto de pruebas, sin fallos de aserciones.
