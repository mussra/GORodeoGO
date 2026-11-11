# Rancho Prueba 2.7.85

APK de revisión, package `com.example.rancho.review`, versionCode 344. Rama de prueba, sin merge a main.

## Incluye
- Relojes de Ant para energía, regate y salto en el componente compartido por niveles y Frontera. PNG originales conservados; solo recorte y escala de copias UI.
- Cara y marco de madera apagados al 0%, encendido progresivo desde las 12 en sentido horario, plenamente encendidos al 100%. Overlay dinámico con el alfa del propio reloj, sin repintar el arte.
- Curvas, T, cruce y finales del camino reutilizados desde los sprites anteriores de Ant. Se usan en los accesos locales y cruce del rancho; las curvas suaves generadas conservan el recto rotado. Sin cambios de colisiones o geometría. Algunas juntas rectas siguen visibles.
- Optimización de preparación de caballos: búsqueda espacial de manchas en el código común, sin bajar resolución ni cambiar sus píxeles.
- Optimización del minimapa incluida en 2.7.84: el terreno conserva sus comandos de dibujo y se invalida cuando cambian sus datos. Marcador del jugador animado cada frame.
- Floristería, muchas flores y camino hasta la entrada; florista desplazada a la derecha. Arte original sin retoques, ojos ocultos, cartel español pendiente de revisar.
- Cambios previos de la rama de prueba, incluidos los Galaxy de 2.7.83.

## Medición de CPU de preparación de caballos
Mismo recorrido headless de escritorio, 1200 frames, misma semilla, antes/después:

| Métrica | Antes | Después |
| --- | ---: | ---: |
| CPU streaming p95 | 10,537 ms | 6,855 ms |
| CPU streaming máximo | 27,049 ms | 8,406 ms |
| Paso de textura p95 | 14,205 ms | 6,827 ms |
| Paso de textura máximo | 26,945 ms | 8,301 ms |
| Preparación inicial tras precalentado | 1661,725 ms | 1036,923 ms |
| Frames sin zona actual | 0 | 0 |

Los 360 frames de referencia comparados antes/después son idénticos por SHA-256 de sus bytes RGBA. La optimización no cambia los colores ni las manchas. El presupuesto nominal de 3 ms todavía puede superarse en una textura.

## Medición previa del minimapa
Escritorio 1280x720, render software llvmpipe, mundo congelado, 60 muestras: mediana con 100 zonas descubiertas 47,76 → 36,26 ms/frame; con 400 zonas 106,86 → 55,74 ms/frame. Con 9 zonas no se demostró mejora fuera del ruido. Los draw calls no bajan; reduce trabajo CPU, no todo el coste gráfico. Estos datos sintéticos no son FPS esperados de Android.

## Verificado
- 496/496 pruebas unitarias, 58.528 aserciones.
- 7/7 pruebas de integración focalizadas, 194 aserciones: acceso de floristería, invalidación del minimapa, vallas y salto.
- Relojes 0/25/50/75/100 a 76 px, transparencia y marco incluidos, inspeccionados en capturas.
- Curvas y uniones inspeccionadas en el mundo y en cuatro orientaciones.
- Firma, package/versionCode y descarga anónima comprobados después de exportar.

## Límites
No se ha ejecutado en dispositivo o emulador Android. Sin medición de GPU, temperatura, memoria o fluidez del móvil de Ant; sin certificación de controles ni legibilidad en su pantalla. No se ha terminado el barrido de integración general.

El fixture sintético del mapa ampliado no visualiza el botón +, también con el código anterior sin la caché; pendiente de comprobar en uso normal. No se presenta como corregido.

Florista sin conversación ni encargos nuevos. Sin río ni historia nueva implementada. No modifica el progreso o los objetivos guardados.
