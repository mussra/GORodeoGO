# Rancho Prueba 2.7.84

APK de revisión: optimización acotada del minimapa de Frontera. No es una certificación de fluidez en todos los móviles.

## Incluye
- El terreno del minimapa conserva sus comandos de dibujo. Ya no se vuelve a generar y recorrer cada zona descubierta en cada frame.
- El marcador del jugador sigue actualizándose cada frame, con su pulso y dirección.
- La caché se invalida al cambiar semilla, exploración, ediciones del mundo, cerdos, misiones, capturas, tamaño, zoom o desplazamiento. Detecta también cambios dentro de las listas, no solo su tamaño.
- Floristería y florista con los PNG originales de Ant, flores ornamentales y camino conectado. La florista está 40 píxeles más a la derecha para verla mejor. El cartel sigue sin retocar.
- Todos los cambios previos de 2.7.83 presentes en esta rama.

## Medición controlada de escritorio
Godot 4.7.2, render OpenGL con llvmpipe (software), 1280x720, semilla 752026, mundo y animales congelados, 60 muestras tras 5 de calentamiento. Datos sintéticos de exploración; no se conoce cuántas zonas tiene Ant guardadas.

| Zonas descubiertas | Antes, mediana ms/frame | Después, mediana ms/frame |
| --- | ---: | ---: |
| 9 | 28,37 | 28,90 |
| 100 | 47,76 | 36,26 |
| 400 | 106,86 | 55,74 |

Con pocas zonas no hay mejora demostrada fuera del ruido. Con 100/400 zonas esta prueba mide aproximadamente 24%/48% menos tiempo por frame. No convertir estos datos en FPS esperados de Android. Los draw calls no bajan: 279 / 1416 / 4893 en ambos casos; esta mejora reduce trabajo CPU, no todo el coste gráfico. La memoria de texturas medida permanece en 85,66 MiB. No se ha reducido calidad de texturas, flores, colisiones ni distancia visible.

## Verificación
- 491 pruebas unitarias, 58.119 aserciones.
- Caché del minimapa: 13 aserciones, incluida invalidación de cambios in situ y estabilidad de su pulso.
- Floristería: 158 aserciones sobre el mundo real y acceso despejado.
- Inspección visual del minimapa pequeño y ampliado y de la florista desplazada. Comparación del minimapa pequeño antes/después: diferencias limitadas al marcador animado, no al terreno.
- Paquete Android, versión y firma comprobados tras exportar.

## Pendiente
- Sin prueba en un dispositivo o emulador Android. No están medidas la GPU, térmicas, memoria, controles ni fluidez en el móvil de Ant.
- No se ha completado el barrido de integración general ni el nuevo perfil de cruces de zona. La carga inicial y el streaming pueden tener otros costes.
- Curvas, cruces, T y finales del camino todavía no activados: la APK no espera ese cambio.
- Florista sin diálogo o misiones nuevas. Historia/río sin cambios de implementación.
- Rama de prueba, sin merge a main. Esta APK consume la aprobación explícita para este envío.
