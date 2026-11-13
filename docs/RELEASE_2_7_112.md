# Rancho Prueba 2.7.112

## Un único mapa para Frontera y el país

- El minimapa permanece superpuesto durante la partida. Tócalo o usa Mapa local para abrirlo; X, Atrás o el mismo botón lo cierran.
- Ambos mundos usan el mismo componente de mapa: arrastrar, pellizcar, deslizador, botones de zoom, Encontrar mi caballo, marcadores y selección de sitios visitados.
- Mantén pulsado el terreno para crear una nota, o una nota existente para editarla o eliminarla. El editor, las fotos locales, los límites de texto y la recuperación ante fallos de guardado también son compartidos.
- El país conserva su propio terreno, exploración, sitios y notas. No se mezclan las notas con Frontera. La vista temporal no escribe sobre la partida guardada.
- El mapa se reajusta y redibuja inmediatamente al cerrarlo o cambiar el tamaño. El editor se adapta también con la nota abierta.

No se ha hecho otro mapa parecido: se ha extraído el de Frontera para usarlo en ambos mundos. El país solo adapta el terreno y sus datos. Las llegadas físicas, la siesta, las transacciones de viaje, los controles táctiles y los indicadores del caballo siguen utilizando sus componentes compartidos existentes. Permanecen separados los adaptadores de sesión y persistencia específicos de cada mundo; no se presenta todo el juego como una única implementación.

## Progreso y límites

Sin cambios de formato ni migración. Conserva la partida, la posición, los sitios visitados, la exploración y los caballos. Incluye las correcciones de guardado en la costa y espuma continua de 2.7.111. No instala el ritual ni completa la progresión del unicornio.

## Verificación

622 pruebas unitarias: 2.556.805 comprobaciones. 85 pruebas de integración dirigidas: 5.301 comprobaciones, con regresiones de Frontera, notas, país, costa, visitas y viajes. Pruebas de pulsaciones táctiles sintetizadas para abrir/cerrar el mapa y salir, movimiento y entrada desde Frontera. Prueba visual con foto de nota, reapertura y recarga desde disco. Capturas inspeccionadas a 1600×720 y 960×540.

Validación de escritorio, no en un móvil físico. APK arm64, mismo paquete y firma, versionCode 371. Se publica como prueba en GitHub, no en una tienda.
