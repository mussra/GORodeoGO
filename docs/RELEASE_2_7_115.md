# Rancho Prueba 2.7.115

## Listado de notas en el mapa compartido

Abre el mapa y pulsa Notas. La lista muestra una foto pequeña, el texto y la fecha de creación de cada nota. Toca una fila para volver al mapa centrado en ese marcador y resaltarlo con un aro claro. El caballo no se mueve: no es un viaje ni una siesta.

- Una única lista en el controlador de notas y mapa que comparten Frontera y el país. Cada mundo conserva sus propias notas.
- Lista desplazable, notas más recientes primero. Las notas sin foto muestran "Sin foto"; el texto largo se resume en dos líneas.
- Las nuevas notas guardan la fecha de creación, que se conserva al editarlas. La fecha se muestra en UTC, indicado en la lista.
- Las notas antiguas no registraban ese dato de forma explícita. Muestran "Sin fecha registrada"; no se inventa ni se sustituye por la fecha de hoy.
- Botón Volver al mapa y Atrás cierran la lista sin mover al jinete ni escribir en la partida. Si no hay notas, explica cómo crear una.
- Mantener pulsado el marcador sigue abriendo el editor compartido. Se conserva el bloqueo de capturas tomadas desde otro lugar de 2.7.114.

Fecha añadida como campo opcional a las nuevas notas, sin migrar ni borrar las existentes. No cambia el formato general del guardado ni modifica viajes, misiones, caballos o progreso.

## Verificación

623 pruebas unitarias (2.556.809 comprobaciones), 92 integraciones dirigidas (5.359): fecha y orden, notas antiguas, lista vacía, desplazamiento, cerrar sin escribir, centrado preciso sin mover al caballo y fecha conservada tras recargar desde disco. Se mantienen las pruebas de foto y edición remota.

Pulsaciones táctiles sintetizadas en ambos mundos a 1600×720 y 960×540: abrir lista, desplazamiento con 13 notas, seleccionar, centrar. Capturas inspeccionadas de lista, final del desplazamiento y mapa centrado.

Validación de escritorio, no Android físico. APK arm64, mismo paquete y firma, versionCode 374. Rama de prueba, no publicación en tienda.
