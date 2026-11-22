# Rancho Prueba 3.0.30

## Cerdo bloqueado y sonido repetido

Reproducido: si la partida rechaza el guardado al terminar la persecución, el cerdo queda en estado de captura y el sonido de éxito se repetía cada fotograma. Ahora solo suena después de confirmar el guardado. Si falla, el animal se libera y conserva el cansancio, no se suman puntos y no se repite el intento automáticamente. Se puede volver a enlazar cuando el guardado funcione. Una entidad ya registrada tampoco da premios ni sonidos duplicados.

## Diagnóstico sin borrar partidas

En Ajustes > Ver diagnóstico de guardado se muestra si la partida está protegida por validación, qué registro no se reconoce o qué error de escritura aparece. Esta consulta no modifica archivos. Si el móvil sigue rechazando la captura, hace falta una captura de esa pantalla para reparar la causa concreta sin arriesgar su progreso.

Esta versión corrige el bloqueo y la campanita, pero no afirma haber reparado el archivo de la partida del móvil, cuya causa exacta aún no se conoce. No desinstalar, reiniciar progreso ni borrar datos.

28 pruebas relacionadas, 198 aserciones. Incluyen captura completa con guardado correcto, fallo protegido sin modificar sus bytes, reintento tras recuperar el guardado, ausencia de sonidos y premios duplicados y regresión de tiempo bala. Las capturas de pantalla se prepararon en una escena de prueba; el ejemplo G21 es simulado, no un diagnóstico de la partida de Ant. Sin prueba en Android físico ni regresión completa nueva.

Mismo paquete, nombre Rancho y certificado de prueba. VersionCode 490. Sin cambios en main ni publicación en tienda.
