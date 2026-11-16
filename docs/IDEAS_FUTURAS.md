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

## PNJ, encargos y objetos de historia (10-nov-2026)

Petición de Antonio: más personajes y misiones, empezando por un granjero que pide capturar cerdos salvajes para su negocio. Después cabras. Lucía quiere explorar y capturar cosas silvestres: un personaje puede pedir encontrar una flor concreta.

Primer prototipo: registro de PNJ y encargos por datos, un motor para aceptar/progresar/completar y guardar. Tipos `capture_animal` y `find_object`. Cerdos bloqueados para captura hasta aceptar el encargo. Tras tres cerdos, el mismo granjero ofrece tres cabras. Sin premios nuevos añadidos: siguen los puntos existentes por cerdo. El objetivo cuenta solo desde la aceptación y los eventos no se duplican.

Historia no aleatoria: reglas configurables por dirección/distancia desde el rancho y umbral en bloques (un bloque es un chunk de1024px). Ejemplo jugable: al superar15 bloques hacia el este aparece cerca una flor del arte existente, la historia avisa y se puede recoger. La posición queda guardada: no cambia al regresar ni se duplica. Las flores decorativas aleatorias no cuentan como esa flor.

Arte pendiente de Antonio/ChatGPT: granjero con gorro de granjero, sin ojos visibles, mismo estilo que el vaquero. Se usa un marcador rotulado “PNJ provisional”, no arte nuevo ni personaje terminado. No generar sin aprobación.

Ideas propuestas, no aprobadas como contenido final:
- Botánica: pide una flor azul concreta; enseña a explorar sin capturar animales.
- Pastora: cabras alejadas del camino; encargo posterior al granjero.
- Guardabosques: encontrar una arboleda o una planta; sin consumo ni recompensa económica definidos.
- Mensajera: visitar dos PNJ para abrir una ruta, con condiciones de historia no aleatorias.
- Herrero: misiones de materiales y herramientas, sin fijar precios/recompensas aún.

Por decidir: nombres e ilustraciones, diálogos definitivos, cantidad final de objetivos, premios y si algunos encargos se repiten. El prototipo no implica aprobaciones de arte o economía.

## Juanito, guarnicionero: fabricar y mejorar equipo (16 noviembre 2026)

Antonio propone que el guarnicionero ayude a crear mejores equipos, como la fusta, y pide otros equipamientos. Se une al trabajo de equipo/personalización y tienda de complementos. Propuesta para su OK: no está implementada en 2.7.173 y no modifica puntos, catálogo ni reglas.

La fusta básica y mejorada ya figuran en el catálogo candidato con 1.000/2.000 puntos y trazos de 260/420 unidades. Se toman como referencia de precios, no como economía definitiva ni recompensa aprobada.

| Equipo | Fabricar | Mejorar (coste adicional) | Efecto propuesto |
| --- | ---: | ---: | --- |
| Fusta | 1.000 puntos | 2.000 puntos | Trazo de regate 260 -> 420 unidades; sin más velocidad. Mantener lo que ya posea el jugador. |
| Montura de viaje | 800 | 1.600 | Reduce gasto de resistencia al correr 5% -> 10%. No aumenta velocidad máxima. |
| Riendas de precisión | 600 | 1.200 | Reduce tiempo de recarga del regate 5% -> 10%; no cambia el gesto ni el alcance. |
| Estribos de equilibrio | 700 | 1.400 | Reduce duración del aturdimiento tras golpe 5% -> 10%; el golpe sigue soltando las capturas. |
| Herraduras de camino | 900 | 1.800 | Reduce penalización de terreno difícil 10% -> 20%; no elimina obstáculos ni colisiones. |
| Alforjas | 500 | 1.000 | Añade 2 -> 4 huecos a un futuro inventario de recolección. Bloqueadas hasta que exista un inventario con límite definido. |
| Sombrero y manta de montura | 300 cada uno | 600 por variante elaborada | Solo apariencia, sin ventaja de juego. Permite gastar puntos sin alterar el equilibrio. |

Las espuelas se añaden por petición posterior de Antonio (21:28), con impulso breve y coste de resistencia, según la propuesta siguiente. El equipo no concede Serenidad genética ni sustituye la crianza.

Reglas propuestas: un objeto por ranura, sin apilar copias; compra única que después se equipa sin pagar; mejora requiere la versión básica; precio total y diferencia de efecto visibles antes de confirmar; sin dinero real, desgaste ni reparaciones periódicas. Las reducciones se limitan al 10% por efecto y no se suman entre objetos del mismo efecto. Los objetos ya obtenidos se conservan, sin recomprarlos al trasladar la tienda a Juanito. La fusta no debe retirar un regate ya desbloqueado.

Primera entrega sugerida si Antonio da su OK: Juanito con fusta, montura, riendas y estribos; cosméticos después, alforjas cuando exista inventario. Los precios y porcentajes son valores de prueba pendientes de aprobar y ajustar jugando, no compromisos de implementación.

Fuentes: WhatsApp 16nov 21:18 "El guarnicionero te puede ayudar a crear mejores equipos como la fusta" (`wamid.HBgLMzQ2MDU5NDg3NzkVAgASGCBBQzMwNDc4OTdGRUQ3NjkxNzFCNzlGRTZBNDI3QzIzNwA=`) y 21:19 "Y añade otros equipamientos como la fusta" (`wamid.HBgLMzQ2MDU5NDg3NzkVAgASGCBBQ0FEQjdFOEU5MTU2MTMwQzBFRTdCMUY2RTZCNjJFRQA=`). Para este bloque se mantiene revisión previa de la economía.


### Espuelas: impulso breve, no velocidad permanente (21:28)

Antonio pregunta "Espuelas?" (`wamid.HBgLMzQ2MDU5NDg3NzkVAgASGCBBQzkxNkNFOUQzMDBGQzIwNUVFODFFNjFBOThFNkM5MQA=`). Se incorporan a la propuesta, sin implementarlas ni cobrarlas.

- Fabricación candidata: **900 puntos**. Impulso de **+10% de velocidad durante 1 segundo**, recarga de **8 segundos** y coste de **15 puntos porcentuales de resistencia máxima** por uso.
- Mejora candidata: **1.800 puntos adicionales**. Mantiene +10%, dura **1,3 segundos**, recarga **7 segundos**, mismo coste de resistencia. Sin aumentar la velocidad ordinaria fuera del impulso.
- Solo al cabalgar voluntariamente: no se activa sin resistencia suficiente, con el caballo agotado, aturdido, saltando o dibujando/ejecutando un regate. No recarga el regate ni se suma al sprint u otros impulsos; prevalece una única velocidad temporal.
- Un botón explícito mostraría recarga y coste antes de usar; no añadir otro gesto al joystick. Animación breve de señal al caballo, sin golpe ni pérdida de vida.
- Diferencia clara: fusta amplía el trazo de regate; espuelas dan un arranque corto a cambio de energía. Probar primero fuera de carreras competitivas y ajustar equilibrio antes de llevarlo a todos los modos.

Todos los valores son candidatos para su OK. La APK 2.7.173 no contiene estas mejoras ni una economía nueva.
