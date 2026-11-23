# Rancho Prueba 3.0.34

## Partidas

Nuevo botón «Partidas» en el menú principal. Permite guardar la partida actual, crear una nueva con nombre, cambiar nombres y elegir una partida. Cada tarjeta muestra nombre, fecha y una miniatura del mundo tomada al volver de Frontera al menú, sin los controles. Hasta la primera vuelta muestra «Sin captura todavía».

La partida anterior se registra como «Partida actual», en su misma ruta para conservar sus fotos y referencias. Antes de registrarla se hace una copia única byte a byte y se comprueba por SHA256. Las partidas nuevas tienen archivos nuevos. Los modos Normal y DEBUG mantienen listas y selecciones separadas. El catálogo conserva revisiones anteriores, verifica cada revisión nueva y la activa de forma atómica; no se reinicializa silenciosamente si está dañado. Un fallo al guardar o validar impide cambiar de partida. No hay opción de borrar partidas ni se borra ninguna miniatura o copia anterior.

## Lucía y el huerto

Lucía y la parcela se ven desde el principio. Puedes hablar directamente con ella para iniciar la presentación y aceptar el huerto, o llegar por la opción de la florista. Son dos entradas a la misma misión: tras la presentación deja de ofrecerse esa opción en la florista. Las partidas que ya tenían el huerto conservan su estado.

El crecimiento sigue dependiendo de la distancia recorrida a caballo en Frontera, incluso al explorar otros pueblos. Cuando termina, Lucía envía automáticamente tres zanahorias y una semilla al inventario y aparece un aviso. No hay cesta que obligue a volver, nada se marchita ni se pierde. Si no hay espacio o falla el guardado, no se concede ni consume nada y se conserva el cultivo. Plantar otra vez sigue siendo una acción en la parcela. Los encargos de flores de cada personaje siguen separados; no hay canjes cruzados entre pueblos.

## Verificación

137 pruebas automatizadas, 60.367 aserciones, todas pasan. También pasa el barrido independiente de 58.031 comprobaciones. Pruebas de alta, nombres, creación, cambio, aislamiento Normal/DEBUG, miniaturas, catálogo corrupto, revisiones incompletas, conservación del original, acceso directo a Lucía y envío remoto de cosecha.

Revisión visual con imágenes reales a 1280 × 720 de menú, selector, entrada de nombre, miniatura del mundo y conversación de Lucía. No se ha probado en teléfono físico ni el teclado móvil. Las pruebas son archivos sintéticos aislados; no se ha abierto ni modificado la partida de Ant.

Mismo paquete `com.example.rancho.review`, nombre Rancho, versionCode 494 y misma firma. Instalar encima sin desinstalar ni borrar datos. Rama de prueba, main y tienda sin cambios.
