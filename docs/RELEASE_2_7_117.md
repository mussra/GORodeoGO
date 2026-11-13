# Rancho Prueba 2.7.117

## Siesta: borde suave y carga visible

- El ojo que cierra y abre la siesta ahora tiene un borde difuminado, sin corte duro.
- Durante la espera con el ojo cerrado aparece «Cargando el camino... / Espera un momento». Los puntos cambian para señalar que sigue trabajando; no es un porcentaje ficticio ni una promesa de tiempo.
- Misma transición compartida para Frontera, país guardado y maqueta. Se mantienen el segundo de cierre/apertura, el inicio del paso automático y el bloqueo de controles.
- No cambia la ruta, la distancia avanzada, los guardados ni la economía.

## Comprobado

- 628 pruebas unitarias, 2.557.049 comprobaciones.
- Regresión de 95 pruebas de integración sobre viajes, país, guardado y mapa.
- Vídeo real de escritorio de ambas siestas y capturas inspeccionadas: borde suave y texto legible durante la carga. Sin errores de script en esa ejecución.
- APK arm64, paquete Rancho Prueba y firma conservados, versionCode 376.

## Límites

- Verificado en escritorio, no en dispositivo Android físico. El rendimiento y la lectura a tamaño de móvil siguen pendientes de prueba allí.
- Si la carga ocupa el hilo principal, los puntos pueden quedarse quietos unos instantes. El texto permanece visible: no se añade un progreso falso ni se oculta la espera.
- Acabados, adornos, llaves y calibración económica siguen siendo otro bloque y no están incluidos en esta versión.
