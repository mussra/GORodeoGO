# Rancho Prueba 2.7.107

## HECHO: país de prueba con progreso propio

- Nuevo acceso de prueba **Menú de Frontera → País guardado**. La maqueta anterior sigue disponible sin guardado.
- El país guarda su posición, terreno descubierto y sitios visitados por separado. Autoguardado cada cinco segundos y al pausar Android; el mapa ofrece **Guardar y menú**.
- Al regresar desde el menú principal a Frontera, se reabre el país donde se guardó. Al salir a Frontera se vuelve al origen enlazado, conservando ese mundo, sus encargos y sus animales.
- Entradas, siestas y salidas validan el lugar de llegada antes de guardar. Los fallos de guardado o una llegada bloqueada mantienen el mapa anterior; si falla la reapertura, se bloquea Frontera y se permite volver al menú sin reemplazar el progreso.
- Las colisiones del mundo congelado se activan solo para validar el regreso, sin ejecutar su juego.

## Comprobado

- 618 pruebas unitarias, 2.556.948 comprobaciones.
- 57 pruebas de integración centradas en viajes, países, guardado y regresiones relacionadas; 3.270 comprobaciones.
- Ruta de interfaz real en escritorio: entrar, explorar, guardar, menú principal, Frontera, reabrir el país y regresar al origen. Capturas revisadas a 1280 × 720 y mapa a 960 × 540.
- Incluye pruebas de guardado fallido, reanudación fallida, llegada bloqueada, doble transición y rechazo de sesiones temporales.

## Límites

- Sigue siendo una entrada explícita de prueba. No activa el rastro, la puerta normal ni el ritual, y no cobra recursos.
- Río y fuente mantienen el arte provisional. Se conserva el árbol original integrado en 2.7.106.
- Pruebas automáticas y revisión visual de escritorio no sustituyen una prueba física de esta APK en Android. Rendimiento, tacto y pausa del dispositivo quedan por comprobar allí.
- No cambia los precios, la adquisición ni las estadísticas de los acabados oro, cristal y hielo.

APK arm64, mismo paquete Rancho Prueba y misma firma que las versiones anteriores. versionCode 366.
