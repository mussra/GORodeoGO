# Galaxy puro, fuente y red de primos

Diseño en curso, sin activar reglas, niveles, fuente ni personajes nuevos. Recoge la cadena pedida y separa propuestas pendientes. Sustituye la idea anterior de que el cruce producía directamente un unicornio.

## Cadena

Dos Galaxy adultos distintos → cría GALAXY PURO → adulto → maestría con ese caballo → fuente mágica → unicornio.

Puro: se guarda al nacer que ambos padres eran Galaxy, con versión de regla y snapshot de ascendencia. No basta heredar acabado de un único padre. Destacar "GALAXY PURO" en ficha y colección, con símbolo legible además del color, sin confundirlo con unicornio antes del ritual. Los otros rasgos siguen heredándose. El modelo actual no tiene alelos normales/recesivos del acabado: si "sin genes normales" significa toda la ascendencia exclusivamente Galaxy, hay que decidirlo aparte; dos progenitores Galaxy no demuestran eso.

Maestría: conservar el bloque actual de veinte niveles distintos con esa montura, 5% cada uno. Añadir niveles no debe reducir maestría de caballos antiguos. Falta crecimiento normal de crías, hoy solo hay un botón de prueba. Recomiendo progresión por juego y no esperar horas de reloj; cantidad de victorias o encargos por elegir.

La fuente verifica puro + adulto + maestría, explica cualquier requisito que falte y pide confirmar el ritual. No gastar padres, modificar al caballo ni transformarlo automáticamente al tocar agua. Identidad, nombre, padres y logros deberían conservarse al convertirse; mecánica final por elegir.

## Llaves, propuesta pendiente

Primera victoria20: una llave para adquirir un Galaxy adulto. Primera victoria40: segunda llave. Una adquisición por llave, no más por repetir victoria o recargar tienda. No elegir todavía esta regla sin confirmar. La oferta20actual es fija y de compra única, no una tienda de rerolls infinitos, pero hay dos vías alternativas a revisar: premio aleatorio de victoria20 y herencia de acabadoGalaxy con un solo padre. Si se quiere bloquear realmente el segundo antes de40, ambas deben encajar con llaves. Conservar todos los caballos ya conseguidos y aplicar nuevas reglas solo a adquisiciones/nacimientos futuros. Decidir cómo reconocer excepciones antiguas.

Niveles21-40: variar rutas y puertas enlazadas, orden de apertura, obstáculos y amenazas, no veinte copias con más toros. Propuesta de cronómetros4-8min:80-160min de presupuesto por pasada. Estimación preliminar de juego adicional rápido1,5-2,5h /normal2,5-5h; no contenido ni medición existente. Catálogo, recompensas, compras, desbloqueos y maestría requieren pruebas separadas.

## Primos en todos los pueblos

Cada pueblo tiene su granjero, florista y UN excéntrico. Todos los excéntricos son primos. Cada uno da UNA pista diferente; ninguno cuenta por sí solo toda la receta. La red se guarda por ID estable de pueblo/NPC, con pistas vistas y primos conocidos en diario. No depende del orden de visita ni de repetir el mismo diálogo para generar un NPC nuevo.

Primera conversación: su pista. Al insistir (propuesta: segunda o tercera pregunta distinta, no contar pulsaciones accidentales), pregunta qué primos conoce el jugador y ofrece dirección hacia un primo aún desconocido. No es necesario responder de memoria: el diario permite señalar nombres ya conocidos. Un primo no recomienda otro ya conocido salvo que no quede ninguno cercano pendiente; en ese caso admite que no conoce otro en esa zona, sin inventar destino.

El rumbo se calcula con coordenadas reales de origen/destino. El pueblo sabe desde qué lado llegó el jugador por su posición anterior y el acceso usado, no por orientación de la cámara. Por ejemplo: "¿Vienes del oeste? Mi primo de la montaña está al este, después del paso." Si el objetivo está al noreste, puede decir "hacia el este, luego al norte". El último acceso sirve para tono, pero la dirección al primo siempre procede de sus posiciones. Los pasos de montaña y caminos se validan antes de citar rutas. No prometer que una línea recta atraviesa una pared.

### Primeras cuatro pistas pedidas

1. Atlas: "En elAtlas hay caballos ultrarraros todavía por descubrir. Nadie sabe qué son, pero la genética dice que deben existir. ¡Y yo nunca discuto con un árbol genealógico!"
2. Ambigua: "Cuidado con los cuernos... ¿Toros? Yo no he dicho toros. ¿O sí?"
3. Cuerno raro: "Encontré un cuerno recto y simétrico. No parecía de toro. Si solo había uno, igual no le faltaba el otro."
4. Fuente: "Dicen que hay un agua que devuelve estrellas aunque sea de día. Más allá del paso del este... Mi primo asegura que bebió allí. Mi primo también asegura que habla con las piedras."

El rumbo de la cuarta frase es un ejemplo. No activarlo hasta fijar una fuente real en ese rumbo. Pistas posteriores pueden hablar de dos Galaxy, pureza y maestría, una por primo adicional. No limitar la red a cuatro personajes si hay más pueblos. Los primeros cuatro no deben revelar la receta completa.

Pendiente Atlas: el usuario dijo "Ultra raro". Hoy las cinco siluetas de unicornio se muestran como Legendario (tier4); Ultra raro es tier3 de caballos normales. Elegir categoría o término antes de activar el diálogo; no se ha cambiado el filtro.

## Recorrido de descubrimiento, actualizado con la continuación

Rastro de un unicornio misterioso → acceso a una zona/país nuevo, en mapa separado → explorar y encontrar árbol gigantesco → río que entra misteriosamente en sus raíces → remontar el río → fuente mágica.

Esto sustituye la propuesta anterior de estela directa a la fuente y de fuente4-8chunks al este del núcleo. No fijar coordenadas en el mapa actual: primero elegir el acceso y diseñar el mapa de destino. El lugar de entrada sí puede estar al este u otro rumbo real, según pueblo y ruta. Los primos orientan a la zona, no dan coordenadas exactas de la fuente. La cuarta pista puede ser: "Mi primo vio un rastro hacia el paso del este. Más allá, hasta la hierba parece de otro país. Lo de la fuente... eso ya tendrás que preguntárselo al agua." El rumbo queda condicionado al emplazamiento definitivo.

La nueva zona tiene césped y camino de otro color y una entrada marcada en el mapa. El paso es una transición explícita, no continuidad falsa entre coordenadas. Guardar world_id/zone_id, semilla/versiones, posición de entrada/salida y progreso de cada mapa por separado. Volver restaura el lugar anterior, no mezcla chunks ni borra notas, pueblos, caballos o encargos. Mantener el mapa de origen V1/V2/V3. Definir si se permiten varios accesos o solo uno antes de implementarlo.

La estela pertenece a un unicornio misterioso que habría pasado por allí, NO exige poseer previamente unicornio para conseguir el primero. Revela o acelera el camino hasta la entrada de la zona, no toda la ruta hasta la fuente. Propuesta de activación: pista correspondiente y Galaxy PURO maestro cerca del acceso. El usuario aún debe elegir si la zona puede explorarse antes con otro caballo y si solo el ritual está bloqueado por pureza/maestría. No imponer esa puerta de acceso por inferencia.

La estela puede dar una bonificación moderada de velocidad sobre camino transitable, sin saltarse paredes, agua o requisitos. Potencia, energía y duración por decidir; no convertirla en obligación de gasto. Reencontrar la senda con notas del diario si se pierde, sin revelar de golpe todo el mapa.

El árbol gigantesco es un hito de investigación en la nueva zona, no otra escala aleatoria de los árboles normales. Puede haber otros gigantes raros en el futuro, pero el árbol conectado a la fuente necesita ID y ubicación de misión estables. Su nombre no está confirmado. El río lleva agua desde la fuente al árbol y desaparece en las raíces. Se puede recorrer la orilla río arriba para llegar al nacimiento; no exige nadar antes de conseguir el unicornio salvo decisión explícita y ruta alternativa.

La topología fuente→río→raíces debe generarse/validarse como una sola estructura. El río no puede subir lógicamente desde el árbol hacia otra cuenca por un sorteo independiente. Reservar corredores accesibles, evitar misiones imposibles al otro lado y validar regreso. No copiar un río por chunk ni una fuente por árbol. El marcador de entrada se ve al descubrirla; árbol y fuente solo después de explorarlos. Los primos y pistas del agua sostienen el descubrimiento sin marcador exacto inicial.

En la fuente se valida el Galaxy PURO adulto maestro y se confirma su transformación; identidad y ascendencia deberían mantenerse. Sigue siendo propuesta pendiente en sus detalles, no código activo.

## Pendiente antes de implementar

Llaves20/40; herenciaGalaxy×normal; significado preciso de pureza más allá de dos padres; crecimiento de cría; detalles de transformación/variante; maestría por bloque; nombres y red de pueblos; Ultra raro/Legendario; lugar de fuente y ruta; activación y potencia de estela; compatibilidad con propietarios anteriores. Ningún punto pendiente se toma como regla ya aprobada.

## Volver a casa por capas y viaje rápido, continuación

Regla pedida para el nuevo país: "Volver a casa" lleva al rastro arcoíris que dio entrada a ESE mapa, no directamente al rancho del país anterior. Cruzar ese rastro devuelve al país anterior, en su acceso enlazado. Una vez allí, "Volver a casa" lleva al inicio donde empezó la partida. Cada mapa guarda su punto de retorno e ID del acceso de procedencia, de modo que entrar por otro portal no pierda la salida. No implementar todavía.

Viaje rápido pedido: desde el mapa se selecciona un SITIO ya visitado y se pulsa "Ir a este sitio". El jinete se echa una siesta, el caballo viaja en piloto automático y aparece en destino tras una animación. No una caminata real obligatoria de veinte minutos ni simulación acelerada que dispare encuentros/capturas fuera de cámara.

Propuesta de UX: lugares descubiertos, no cualquier píxel de terreno que se haya visto. Rancho, entrada arcoíris, pueblos, árbol y fuente una vez encontrados pueden tener destino accesible guardado. Al tocar el icono aparece nombre y "Ir a este sitio". Lugares sin descubrir no se muestran ni se usan como coordenada de teletransporte. Una animación breve de dormir/despertar oculta la carga y muestra el nombre del destino; el jugador conserva un botón de cancelar antes de comenzar. No costes de puntos, energía o castigos por inferencia.

Cómo encaja: "Volver a casa" es un atajo a la entrada arcoíris del mapa nuevo con la misma transición de siesta, sin tener que caminar a ella. Cruzarla vuelve al país anterior. Allí se puede viajar rápido a pueblos visitados o volver al inicio con el mismo mecanismo. Propuesta inicial de no saltar directamente entre países desde el selector: pasar por acceso enlazado preserva la regla por capas. Si se desea selector global entre países, debe decidirse explícitamente, no contradecir silenciosamente la regla anterior.

Seguridad de juego: fijar un punto de llegada libre y transitable por lugar, validar que su mapa existe, hacer snapshot de montura y posición antes de la transición y guardar el nuevo destino solo cuando la carga finaliza. Un fallo devuelve al origen, no a un país equivocado ni a una posición dentro de tronco/agua. No completar encargos, domesticar ni descubrir pueblos atravesados por el viaje. Decidir cómo tratar un animal atado, persecución o diálogo activo: recomiendo terminar/cancelar viaje antes de iniciarlo, sin soltar capturas ni inventario sin avisar. Evitar más de una transición concurrente. Verificar ambas direcciones y carga de partida en cada país.

Pendiente de elegir: lista de destinos, longitud de animación, si el tiempo del mundo avanza durante la siesta, condiciones durante persecución/captura, regreso entre países por selector o solo por rastro. La intención de evitar largas caminatas de regreso queda fijada; estos detalles no están activos.
