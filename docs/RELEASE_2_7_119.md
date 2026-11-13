# Rancho Prueba 2.7.119

## La siesta dentro de la historia

- La transición normal dice «Tomando una siesta...», con puntos animados. Se elimina la segunda línea técnica. Mantiene el ojo de borde difuminado y la caminata automática inicial.
- El paso al otro país dice «Siguiendo el rastro...», no un mensaje técnico de carga.
- No se puede encadenar siestas continuamente. Después de una siesta completada hacen falta cinco minutos cabalgando antes de la siguiente. No cuentan menús, mapa abierto, quedarse quieto, la propia siesta ni cerrar el juego.
- Si se intenta antes, el ojo se cierra solo parcialmente y vuelve a abrirse: «No puedo estar durmiendo todo el día, ¿sabes?». No carga destino, no mueve al caballo ni guarda cambios por ese intento.
- El descanso se comparte entre Frontera y país guardado y queda en la partida. Cambiar de mapa, salir al menú o cambiar el reloj no lo elimina. Una siesta fallida no consume el descanso. La maqueta de prueba mantiene su límite aislado del progreso real.
- Caminar, entrar o salir por el acceso entre países no gasta siestas ni se bloquea por este límite. No cambia los puntos ni los caballos conseguidos.

## Comprobado

- 634/634 pruebas unitarias, 2.557.138 comprobaciones.
- 98/98 pruebas de integración, 5.407 comprobaciones.
- Vídeo de interfaz real en escritorio: siesta normal e intento rechazado en Frontera y país guardado. Se comprueba que el rechazo no cambia posición ni archivo guardado. Capturas inspeccionadas a 1280×720.
- APK arm64 con el mismo paquete y firma de Rancho Prueba, versionCode378.

## Límites

- No probado en Android físico. El tamaño de texto y el rendimiento táctil se deben comprobar allí.
- El ritmo se cuenta mientras se cabalga, no mediante hora del dispositivo. Un cierre forzado antes de un guardado posterior puede perder parte del tiempo cabalgado desde el último guardado, pero no permite acortar la espera.
- Los puntos animados pueden detenerse durante un tramo síncrono de preparación; no se presenta un porcentaje ficticio.
- Incluye una base matemática de progresión aún sin activar. No se han abierto compras de acabados/adornos ni aplicado nuevos premios, llaves o encargos repetibles. Ese trabajo sigue pendiente.
