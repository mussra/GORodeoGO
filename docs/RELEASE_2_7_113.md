# Rancho Prueba 2.7.113

## Capturas en las notas: selección visible

La casilla anterior era demasiado oscura. No se marcaba automáticamente y la foto no se previsualizaba hasta guardar y reabrir la nota.

- Ahora "Adjuntar captura de pantalla" es una fila amarilla, como los botones, con un recuadro grande de 36 píxeles y una marca oscura evidente.
- Al tocarla aparece "Captura activada · se adjuntará al guardar" y se muestra inmediatamente la imagen que se va a adjuntar.
- Pulsa Guardar para conservar texto y foto. Al reabrir, la miniatura confirma la foto guardada. No hace falta activar otra captura para conservar una foto que ya estaba guardada.
- La imagen corresponde a la vista del mundo justo antes de abrir el mapa, no al editor de notas ni a una imagen de la galería.
- Si no hay captura disponible, ya no se guarda solo el texto sin avisar cuando se había pedido foto: se mantiene abierto el editor y se explica que hay que cerrar y reabrir el mapa.

Se modifica el mismo editor y controlador compartidos por Frontera y el país. No hay una segunda implementación ni cambios en el formato de guardado. Sin migración ni borrado del progreso. No cambia la siesta ni añade viajes a notas.

## Verificación

La versión anterior también guarda fotos con la casilla marcada en las pruebas táctiles sintetizadas. No se ha reproducido un fallo de escritura específico de Android.

622 pruebas unitarias (2.556.805 comprobaciones), 87 de integración dirigidas (5.312). Pulsaciones reales del sistema de entrada sintetizadas en Frontera y en el país a 1600×720 y 960×540: activar la casilla, guardar, comprobar el PNG, recargar desde disco y reabrir la miniatura. Capturas inspeccionadas antes de marcar, marcadas y tras reabrir.

Validación de escritorio, no en Android físico. APK arm64, mismo paquete y firma, versionCode 372. Rama de prueba; no se publica en tienda.
