# Rancho: ideas futuras

Notas de Antonio del 4 de noviembre de 2026. Son ideas para explorar, no funciones incluidas en el APK 0.21.15 ni decisiones cerradas de diseño.

## Multijugador: vaquero contra toros

- Un jugador sería el vaquero y los demás controlarían los toros.
- Los toros también podrían usar regates siguiendo trazas dibujadas. La gracia estaría en intentar capturar al vaquero y adivinar el regate del rival.
- Giro cómico: los toros serían bandidos disfrazados de toro que intentan robarle el caballo al vaquero.
- Una pequeña animación mostraría a los bandidos poniéndose el disfraz.
- Ganar jugando como toro podría dar habilidades para el caballo propio, por ejemplo velocidad. La idea es incentivar jugar en ambos bandos.

Quedan por explorar las reglas, el equilibrio, las recompensas y la viabilidad de la conexión. No se ha definido una economía, compras, cantidades ni progresión definitiva.

## Separación con la versión actual

La versión actual es de un jugador. El regate del caballo por dibujo libre se prueba ahora; los toros controlados por jugadores, los disfraces y las recompensas entre bandos quedan para una fase futura.

## Desbloqueo progresivo de niveles

Antonio señaló el 4 de noviembre, a las 21:31, que los APK de prueba muestran todos los niveles habilitados. Corregirlo en una versión futura para que se desbloqueen al avanzar. No se cambia en el APK 0.21.15: mantiene el acceso de prueba actual.

## Nombres de caballos (6 de noviembre de 2026)

Petición de Antonio, nota de voz de las 12:53. Prioridad menor que la corrección del galope; pendiente, no implementada en esta entrega.

- Poder dar nombre a cada caballo.
- Proponer un nombre por defecto según sus colores y si tiene manchas: por ejemplo, "azul manchado" o "rubio liso".
- Si ya hay otro caballo con ese nombre, añadir un sufijo numérico: por ejemplo, "azul manchado 2".
- Poder editar libremente el nombre, por ejemplo "Pepe" o "azul bonito", y guardar el cambio.
- Poder cambiar el nombre en cualquier momento.

Fuente: mensaje de voz `wamid.HBgLMzQ2MDU5NDg3NzkVAgASGCBBQzhCQTE1MEE5QzVGQzk1RDc2RThFRUU1OUVFMjVBOAA=`.


### Actualización 2.0, 6 de noviembre de 2026
Los nombres editables y sugeridos pasan a implementados en esta versión. Se conservan los nombres anteriores y los elegidos por el jugador. Los nuevos caballos reciben un nombre por pelaje/patrón con sufijo numérico si ya existe. Las pruebas aisladas siguen sin guardar cambios en la colección real.

## Mundo abierto con misiones y doma (7 de noviembre de 2026)

Dirección confirmada por Antonio en conversación de WhatsApp. Es una dirección de diseño, no una función implementada ni un plan cerrado. No sustituye los niveles actuales: los corrales y retos existentes seguirían como desafíos dentro del mundo.

Confirmado por Antonio:

- Mundo abierto: el rancho como base y una comarca para recorrer a caballo, encontrar animales, entrenar y visitar mercados. Antonio: "podemos tener un mundo abierto?", "Ke encantaría".
- Mundo que se va autogenerando al explorar. Lo descubierto se conserva: el rancho, los caminos y los lugares conocidos no cambian al volver. Antonio: "Y poder ver un mundo que se va auto generando".
- Misiones por las dos vías: encargos que llegan al rancho y misiones que se descubren explorando. Antonio: "Que lleguen misiones por encargo o encontrarlas" y "Correcto" a la propuesta de combinarlas.
- Doma de caballos salvajes: encontrar un caballo nuevo y domarlo. Antonio: "Caballo nuevo y domarlo". La mecánica concreta (acercamiento, calma, temperamento) es una propuesta nuestra pendiente de su visto bueno.
- Nuevo atributo de los caballos: la velocidad con la que calman toros y otros caballos. Antonio: "un atributo de los caballos la velocidad con la que calma toros y otros caballos". Nombre propuesto por nosotros, "Serenidad", pendiente de confirmación. Sin valores ni números definidos.

Propuestas nuestras pendientes de confirmar:

- Primera prueba jugable en rama aparte: una zona pequeña conectada, salir del rancho, explorar, un reto de captura y volver. Antonio aún no ha respondido a prepararla.
- Mezclar terreno generado con lugares diseñados a mano, para que haya sorpresas sin que todo parezca aleatorio.
- La doma como pequeño reto de acercamiento y calma, con dificultad según el temperamento, distinta de comprar o criar.
- Serenidad separada de la velocidad de carrera, útil en capturas y domas, con un límite para que ayude sin volverlas instantáneas.

Sin definir: tamaño del mundo, generación concreta, estructura de misiones, economía y recompensas, y cómo se integra con la progresión actual. La pregunta abierta sobre rareza del linaje y herencia (3 niveles distintos del 5 en adelante) sigue sin respuesta y es independiente de esta dirección.

Fuentes: mensajes de WhatsApp del 7 de noviembre de 2026, 8:58 a 9:01 CET:
`wamid.HBgLMzQ2MDU5NDg3NzkVAgASGCBBQzU5OTQzMDcwREQ4RTZERDA2MzlDMEQ1QjQwQUMxNgA=` (mundo abierto),
`wamid.HBgLMzQ2MDU5NDg3NzkVAgASGCBBQzJBNjkzQTlGMjNCQTg2Njg4QTQ4NUY5MENCMkFFRgA=` (encantaría),
`wamid.HBgLMzQ2MDU5NDg3NzkVAgASGCBBQ0Q0MDUzMkU3ODdGM0YxOEQ5MDBCQUM0NTlCNzYzMwA=` (misiones por encargo o encontradas),
`wamid.HBgLMzQ2MDU5NDg3NzkVAgASGCBBQzZGRTQyMEQ3NTA0RDYzNDk5M0Q3Qjc5RDAyQzUxQgA=` (mundo autogenerado),
`wamid.HBgLMzQ2MDU5NDg3NzkVAgASGCBBQ0I4REI0MkQxNTk3NzRDQzBFRkZCOTU4MUQ1RjJBOQA=` (correcto a misiones),
`wamid.HBgLMzQ2MDU5NDg3NzkVAgASGCBBQzRBRjBDMjY5QjlBMkU1Q0MxQjQ0QjhGMTRFRDlBNwA=` (caballo nuevo y domarlo),
`wamid.HBgLMzQ2MDU5NDg3NzkVAgASGCBBQzRFRTQ2MjUyRTEyNkQxRkVERDI4QkM2NUQxMjE5RAA=` (atributo de calma).

### Autorización de implementación (7 de noviembre de 2026, 9:00-9:02 CET)

Antonio pidió implementarlo: "Impleméntalo, añádelo al menú principal" (`wamid.HBgLMzQ2MDU5NDg3NzkVAgASGCBBQ0IzRTFENUNFMDlGMjIzRDRCRDFDRDA3OTMzMjBBNwA=`) y confirmó el alcance con "Y crea un mundo para probarlo" (`wamid.HBgLMzQ2MDU5NDg3NzkVAgASGCBBQzU5OEQ3NUM3OUU4MTQ2QjEzNzdGNDg1ODQ5M0RENAA=`). Alcance autorizado: primera prueba jugable de mundo con entrada desde el menú principal, doma de caballos salvajes y el atributo de calma, en rama aparte, sin sustituir los niveles actuales ni perder progreso.
