# Rancho Prueba 2.7.180: iconos y respuesta del menú Juegos

APK de prueba, código 439. Mismo paquete y firma: instalar encima. Solo rama de pruebas, sin main ni tienda.

## Seis tarjetas con imagen

Los cinco modos ya tenían imágenes, pero el menú las quitaba cuando el modo estaba bloqueado por progresión. El icono alternativo tampoco dibujaba esos identificadores. Coronas y victorias no tenía imagen asignada.

Ahora las seis tarjetas muestran imagen a la izquierda, tanto bloqueadas como disponibles. Se reutilizan los dibujos de toro, carrera, duelo, justa e hípica y la corona de rosas del propio juego. Los títulos y los requisitos siguen visibles, sin cambiar el orden de las tarjetas ni sus destinos.

## Toques y requisitos

En la captura, los cinco modos de juego están pendientes de desbloqueo. Antes, tocar uno destruía el menú y abría otro igual: recibía el toque, pero no daba una respuesta nueva que explicase qué faltaba.

Ahora el menú permanece abierto y muestra en dorado el requisito concreto de la tarjeta tocada. No se eliminan los requisitos ni se conceden victorias. Coronas abre los resultados y Volver cierra el menú. Los modos disponibles conservan sus destinos.

La prueba con eventos táctiles a través de la entrada del juego comprobó:

- Las cinco tarjetas bloqueadas conservan el mismo menú y muestran su requisito específico.
- Coronas abre los resultados y su Volver regresa al menú principal.
- Volver de Juegos cierra la hoja.
- Con los modos disponibles, Rodeo abre los niveles y Carreras, Duelo, Justa e Hípica abren su escena correspondiente.

Volver y Coronas respondían también en la reproducción anterior al cambio. No se ha reproducido un fallo general que impida todos los botones. Si persiste en el teléfono, queda pendiente comprobar esa secuencia concreta allí.

## Validación

252/252 pruebas, 41.845 aserciones, 44 scripts y cuatro deprecaciones. Se conserva la batería de 2.7.179. Las nuevas comprobaciones cubren seis imágenes, títulos, requisitos, límites de las tarjetas y respuesta sin cerrar el menú bloqueado. Hay avisos de UID de fuentes de GUT y errores de guardado intencionados de las pruebas de reversión. El arnés táctil deja un aviso de dos objetos vivos al cerrar; la batería completa no lo muestra.

Tres capturas inspeccionadas: modos bloqueados, requisito tras tocar Hípica y modos disponibles. Textos e imágenes dentro de las tarjetas, sin solaparse. APK firmada y verificada. No hay teléfono ni emulador Android conectado: las pruebas táctiles son de escritorio y no certifican el comportamiento físico de esta APK en el móvil.
