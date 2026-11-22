# Rancho Prueba 3.0.31

## Guardado protegido G25 y captura de cerdos

Corregida una incompatibilidad del propio juego: los pueblos pueden usar el nuevo rosa claro en las manchas de sus manadas, pero el lector de partidas seguía admitiendo solo la paleta antigua. Tras guardar ese color, volver a abrir la partida producía G25 y bloqueaba el guardado de capturas y demás progreso.

Ahora reconoce todos los colores que ya existen en el juego. No borra, reinicia, recolorea ni reconstruye nada de la partida. No modifica el archivo al cargarlo. Mantiene las validaciones para datos realmente inválidos.

Reproducido con un mundo generado por el juego: falla antes de la corrección; después carga, conserva registros y puntos, captura un cerdo en Frontera y conserva la captura al volver a cargar. Pasan 31 pruebas relacionadas, 225 aserciones. También pasan las pruebas que evitan campanitas e intentos de captura repetidos cuando falla un guardado. No se ha probado en Android físico ni repetido la regresión completa.

Instalar encima sin desinstalar ni borrar datos. Después abrir Ajustes > Ver diagnóstico de guardado: debería desaparecer G25 y aparecer G00. Si persiste G25, compartir una captura para investigar otra causa; no reiniciar progreso.

Mismo paquete y certificado, nombre Rancho, versionCode 491. Sin cambios en main ni publicación en tienda.
