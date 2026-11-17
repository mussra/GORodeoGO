# Rancho Prueba 2.7.181: victorias, propiedades y linajes

APK de prueba, código 440. Mismo paquete y firma para instalar encima. Solo rama de pruebas, sin main ni tienda.

## Modos bloqueados

Los modos pendientes siguen visibles para enseñar el camino, pero sus tarjetas están sombreadas, con icono y texto atenuados y la marca BLOQUEADO. Coronas y victorias conserva su aspecto activo. El requisito permanece visible. Tocar una tarjeta pendiente explica lo que falta sin entrar al juego ni reabrir la hoja, ahora sin el aviso dorado de la versión anterior.

## Cada victoria mejora una propiedad concreta

| Prueba ganada | Propiedad |
| --- | --- |
| Toros | Fuerza |
| Carreras | Velocidad |
| Duelo de lazos | Manejo |
| Justa con lazos | Agilidad |
| Hípica de memoria | Serenidad |
| Premio final de Copa | Velocidad, además de sus premios anteriores |

No hay tirada de probabilidad ni alternancia entre victorias premiadas y sin premio. Cada victoria válida añade progreso al caballo que participó, identificado al empezar, aunque se cambie la selección antes de guardar. Una derrota no concede mejora. Duelo y Justa exigen ganar la prueba completa, no una manga. Hípica exige completar su partida, no cada salto o ronda intermedia.

El equilibrio usa rendimientos decrecientes, no un corte en el antiguo máximo. El bonus acumulado es el 2% de la amplitud base de esa propiedad multiplicado por la raíz cuadrada de sus victorias. Ejemplo de velocidad: +1,2 en la primera victoria; +3,79 acumulados con diez; +12 con cien. Cada nueva victoria sigue sumando, pero cada incremento es menor. La mejora no salta a otra propiedad cuando se supera el antiguo máximo.

Las barras dejan margen visual por encima de la antigua escala y crecen de forma continua, sin reescalarse hacia atrás al superar el máximo anterior. No muestran números de simulación. La carrera usa ahora la velocidad del caballo del jugador; los rivales mantienen su ritmo base, en lugar de igualar a todos a 260. Es un cambio de equilibrio de prueba.

Los ensayos aislados no conceden premios ni progreso. El modo DEBUG conserva su contexto separado de victorias que ya tenía; no se ha cambiado la política previa de guardado de DEBUG.

## Ficha de mejora animada

Tras guardar la victoria aparece una ficha con la imagen y el nombre del caballo participante, sus cinco propiedades y la propiedad premiada resaltada. Su barra crece durante 1,5 segundos, con un pequeño brillo de estrellas. Continuar permite cerrar la ficha, incluso antes de terminar la animación. El premio ya está guardado; cerrar o saltar la animación no lo pierde ni lo vuelve a conceder.

La ficha indica también el caballo nuevo y el linaje exclusivo cuando corresponde. No se muestra una mejora ficticia si ha fallado el guardado.

## Cada carrera ganada da un caballo nuevo

Una victoria guardada en Carreras añade siempre un caballo adulto nuevo a la cuadra, también al repetir un circuito. El caballo tiene identidad propia, un aspecto determinado por el registro de esa victoria y salto disponible. No sustituye al caballo montado ni lo selecciona automáticamente. No es una cría y no se le inventan padres.

La misma victoria no se puede cobrar dos veces. Un fallo al guardar revierte juntos la victoria, el incremento de propiedades, el circuito registrado y los caballos concedidos. Reintentar usa el mismo registro y no duplica premios. Esta regla también cubre una carrera ganada dentro de Copa.

## Maestría compartida por familia

Una familia es el patrón, como Jirafa, Tigre o Cebra, con la especie separada. No se exige repetir todo el contenido con cada caballo. Cualquier caballo de la familia puede aportar:

- Seis niveles distintos de toros.
- Dos circuitos distintos ganados.
- Una victoria completa en Duelo, otra en Justa y otra en Hípica.

Son once pruebas mínimas ganadas. Repetir el mismo nivel o circuito mejora al caballo y conserva el premio normal, pero no rellena otra casilla distinta de maestría. También se conserva la aportación de caballos vendidos, para no perder el progreso familiar.

Estimación de diseño: unos 25-45 minutos de pruebas ganadas, más reintentos, cuando los modos ya están disponibles. No es una duración medida y no incluye el recorrido inicial para desbloquear los juegos. El contenido actual tiene 40 niveles de toros y cuatro variantes de circuito, no veinte carreras distintas.

Al cerrar el hito familiar se añade una sola vez un caballo de Linaje maestro del mismo patrón y se activa un brillo suave en los caballos de esa familia que ya están en la cuadra. El caballo exclusivo supera cada una de las cinco propiedades efectivas que tenía el mejor conjunto de esa familia al concederlo. No queda garantizado como el mejor para siempre: otro caballo puede superarlo entrenando. No se vuelve a conceder por venderlo o por completar el hito con otro miembro.

La ficha muestra el progreso compartido, qué otros juegos faltan, el mejor caballo actual de tu cuadra por promedio de propiedades de su familia y, en el premio exclusivo, con qué caballo se consiguió. El vínculo de logro no se presenta como una pareja de padres biológicos.

Como prestigio opcional, completar con una misma montura los 40 niveles de toros, los cuatro circuitos y los otros tres juegos da un brillo más marcado y otra mejora al premio de linaje ya existente. No crea otro caballo exclusivo ni se exige para conseguir el premio familiar.

## Brillo sin borrar el patrón

El brillo recorre el cuerpo conservando colores y manchas, tanto montado como sin jinete y en la ficha. Un Tigre sigue siendo Tigre y una Jirafa sigue mostrando su dibujo. Se reutilizan las máscaras y materiales compartidos de las poses existentes. No se convierte el caballo en Galaxy y no se cambian sus genes ni su especie. El brillo se combina con los acabados y adornos ya equipados, sin sustituirlos.

La ruta anterior del Galaxy y del unicornio no se modifica: las llaves siguen en 20 y 40, la pureza sigue exigiendo dos padres Galaxy, y el ritual de conversión a unicornio continúa desactivado. Esta versión da a todas las familias una salida especial propia, no una conversión general a unicornio.

## Rendimiento

La animación usa una sola ficha, una interpolación corta y doce destellos dibujados, sin simulación física ni emisores de partículas. Termina a los 1,85 segundos incluyendo la pequeña espera inicial. No hay búsquedas familiares cada frame; se hacen al ganar o abrir la ficha. Al cerrar se elimina la vista.

Arnés de escritorio con renderizado por software a 1280x720, 120 frames por fase: escena vacía 13 nodos; ficha 47; tras cerrar vuelve a 13. Memoria 40,46 MiB antes, 42,23 con ficha y 41,73 después, con recursos de interfaz ya almacenados en caché. Frame medio de la ficha animándose 30,04 ms frente a 29,67 estática; son unos 0,36 ms de diferencia en ese arnés, no una medición aislada de CPU. El coste total de dibujar la ficha no es cero. No son medidas de Android ni una garantía de FPS móvil.

## Validación y límites

263/263 pruebas, 44.103 aserciones, 45 scripts y cuatro deprecaciones. Batería adicional de compatibilidad: 37/37 pruebas, 1.134 aserciones y nueve scripts de barras, promedio, acabados, pureza Galaxy y ritual. Las pruebas incluyen cien mejoras por modo por encima del máximo anterior, caballo participante, caballo nuevo por carrera, doble cobro, reversión de guardado, progreso familiar compartido, contenido distinto, premio exclusivo, persistencia y barras que no retroceden.

La última batería principal no muestra aviso de objetos vivos al cerrar; una anterior y el arnés visual sí avisaron de dos objetos. Persisten los avisos de UID de fuentes de GUT y errores de guardado intencionados en las pruebas de reversión. No se afirma ausencia total de avisos.

Capturas y vídeos inspeccionados: menú sombreado, ficha antes/durante/después de la mejora, ficha familiar y Tigre normal/brillante. El botón Continuar se comprobó mediante eventos táctiles por la entrada del juego en una ventana de escritorio. Sin prueba física en Android. Quedan por validar en el teléfono la sensación de la animación, su coste y el nuevo equilibrio de carreras.
