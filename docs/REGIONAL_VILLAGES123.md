# Pueblos y encargos por región

## Propuesta

Cada pueblo tiene identidad estable, granjero, florista, perfil de bioma y estado independiente. Los IDs no dependen del nombre visible ni de cuándo se carga un chunk. Un pueblo terminado nunca vuelve a ofrecer sus encargos; otro pueblo puede tener otros. Un mensaje fijo deja claro el cierre: "Aquí hemos terminado. Gracias por tu ayuda. Ya no tengo más encargos para ti en este pueblo."

Ejemplos, no parámetros definitivos:

- Pradera: granjero pide tres cerdos, florista tres flores azules. Campos con una especie azul, no flores de todos los tipos dispersas.
- Montaña: granjero pide tres cabras, florista pide una especie regional. Diez tipos florales disponibles en campos separados. Tener diez especies no implica automáticamente diez encargos.

Perfil y catálogo separan tipo de animal, lista de especies florales, objetivos, cantidades, requisitos y textos. Reutilizan aceptar/contar/completar y eventos únicos del flujo actual, no otro sistema de captura. Las flores usan arte existente, sin nuevos sprites. Los campos tienen distribución estable por semilla/pueblo/versión y se dibujan sin actualización por frame.

## Implementado en esta preview

- En V3 actual, diálogo final constante para el granjero y florista cuando todos SUS encargos existentes están terminados. Desaparece aceptar nuevo encargo; la venta de cerdos sigue aparte. No se borran estados, capturas, flores ni recompensas.
- V1/V2 conservan su flujo de diálogo previo. No cambia el generador.
- Contrato RegionalVillages123 de perfiles, NPC, definiciones y serialización separada/versionada por ID de pueblo. Pruebas comprueban independencia y persistencia del estado terminado tras serializar/deserializar.
- Renderer de campos regionales con paleta de uno o diez tipos. Preview aislada de perfiles, campos, encargo y cierre real de diálogo compartido.

## Lo que NO está activado aún

El V3 actual contiene un núcleo de rancho, dos casas y florista, pero no un generador de pueblos repetidos. Esta preview NO añade pueblos ni campos a partidas existentes, NO mueve objetivos de encargos activos, NO añade estados a SaveData y NO migra misiones existentes. El contrato de guardado está listo y probado de forma aislada, no conectado al archivo de partida. La etiqueta "Guardado: pueblo" de la imagen indica la clave propuesta, no un guardado nuevo real del jugador.

Los dos encargos actuales del granjero (cerdos, luego cabras) y dos de la florista (azules, luego doradas) se mantienen íntegros. Transformar el primer granjero en solo cerdos en una partida existente sin perder su misión de cabras necesita una decisión de migración. Recomiendo marcar el núcleo como pueblo heredado y conservar su cadena; nuevos pueblos siguen nuevos perfiles.

Para activar pueblos: registro estable de asentamientos con colocación y acceso validados en carretera V3; campos fuera de puertas y rocas/montañas; objetivos por pueblo/bioma; guardar por pueblo en una sección nueva; eventos restringidos a ese pueblo para que una misma captura no complete todas las misiones del mapa; streaming/culling; minimapa; pruebas de save/load y de completar cadenas entre pueblos. Nueva distribución debe tener versión propia y aplicarse a mapa nuevo o regiones aún no exploradas, no recolocar silenciosamente progreso.

Pendiente elegir: nombres, distancia/frecuencia de pueblos, qué perfil asignar por región, cantidad y variedad de encargos por NPC, recompensas, si capturas previas cuentan (recomiendo no), reposición de flores, y si los campos decorativos siempre son recogibles o solo los objetivos activos.

No se han modificado Galaxy, receta de unicornios, fuente ni catálogo de niveles. No APK por esta propuesta aislada sin pueblos activados; el cierre V3 queda listo para el siguiente avance jugable comprobado.

## Campos extensos, continuación

Los ejemplos de la imagen son muestras de paleta, NO la extensión final. El campo real debe cubrir al menos un par de recuadros/chunks de mapa con la misma flor: grandes superficies de amapolas rojas, violetas/moradas, azules y otros tipos regionales. Un campo no es una docena de flores alrededor de un NPC. Debe percibirse como un campo al recorrerlo y como una mancha extensa de color en el mapa.

Propuesta de unidad: un descriptor de campo con ID, especie dominante, semilla y límites continuos, ocupando al menos dos chunks contiguos (chunk actual1024px de lado). Dos chunks adyacentes darían una extensión mínima orientativa2048×1024px, no un número de flores aprobado. Confirmar que "recuadros" se refiere a chunks y no a celdas de carretera antes de fijar ese mínimo en código. El descriptor se genera una vez por región, no se sortea de nuevo en cada chunk, para que los bordes enlacen y no cambie la especie al recargar.

El mapa y minimapa colorean solo el área descubierta del campo con su especie dominante, recortada a su límite real; no un icono pequeño ni revelar campos no visitados. A medida que se explora, aparece la gran mancha roja/morada/azul. Las carreteras, iconos y objetivos quedan legibles por encima. Un campo puede atravesar varios chunks pero respeta accesos, edificios, agua y roca. Los caminos pueden quedar despejados mientras sus bordes pasan entre flores.

Rendimiento: no crear un nodo/colisión por flor ni contar o dibujar todas las flores de varios chunks cada frame. Separar descripción del campo, dibujo y objetivos de recogida. Texturas compartidas existentes; lotes por especie en MultiMesh o renderer de chunk, visibles solo en cámara con un margen, sin animación/proceso individual. Determinismo por celda y cache con límite; construir por presupuesto de streaming, como la vegetación actual. No hornear una imagen gigante ni replicar sprites nuevos. El número total de flores del campo no debe multiplicar el número de objetos activos lejos de cámara.

Propuesta visual por distancia: flores individuales cerca, grupo más simple a media distancia y cobertura de color coherente en mapa. El mapa usa el polígono del descriptor, no consulta cada flor. Las flores decorativas no necesitan hitboxes. Solo objetivos activos tienen unos pocos puntos de recogida con ID estable y señal visual para distinguirlos del campo entero. Si se quiere recoger cualquier flor del campo, habrá que decidir inventario/reposición y diseñarlo por celdas, no guardar cada tallo.

Riesgo principal: transparencia superpuesta/fill rate en móvil, no solo CPU o cantidad de nodos. Capar densidad dibujada por pantalla, recortar bajo HUD y medir en Android antes de aprobar. El diseño no puede garantizar todavía FPS ni memoria. Preview futura debe mostrar una pantalla dentro del campo y mapa alejado con dos chunks, seguida de perfil de dibujo/streaming. No se ha activado esta extensión ni cambiado los campos de la partida.

## Consecuencias persistentes de las entregas

Idea pedida: tras entregar amapolas a una florista, al volver a ese pueblo se encuentra un campo de amapolas creado gracias a la misión. Al preguntar reconoce: "Mira el campo de amapolas que he conseguido por fertilización gracias a tu ayuda." No sustituye el cierre de encargos: después sigue sin pedir más si su cadena terminó, pero su agradecimiento menciona el cambio visible.

Propuesta de estado: evento único de entrega/completado por pueblo y quest_id, con un efecto versionado field_created, especie, campo_id, semilla y límites reservados. Guardar el cambio junto con la misión en una misma transacción, o revertir ambos si falla. Idempotente: volver a hablar o cargar no genera un campo adicional ni entrega premios otra vez. Mantener sin tocar world_quests heredado; usar una sección nueva por pueblo para efectos regionales. No inferir retroactivamente qué flor se entregó si el registro antiguo no lo prueba.

El campo puede estar en una parcela ya reservada para crecimiento, no encima de rutas, casas o animales atrapados. El cambio aparece al volver o tras una transición breve; no ocultar una espera de días no acordada. Decidir si nace pequeño y crece o aparece extenso, y si cuenta como nuevo destino del mapa al descubrirlo. El mapa muestra el campo cambiado cuando se revisita, sin revelar el resto de la región. Recoger después sus flores, reposición y nuevas misiones siguen pendientes.

Sin implementación ni nuevos estados escritos en partidas actuales. El efecto sería evidencia visible de haber ayudado, no solo texto genérico.

## Revisión visual: silvestres, no cultivos

Los campos grandes del mundo son SILVESTRES. Conservan la densidad que gustó al cabalgar, con variación de posición/tamaño y límite irregular estable por semilla. Los chunks interiores se llenan, pero el perímetro atraviesa celdas y forma lóbulos redondeados, sin acabar justo en líneas rectas de recuadro. Mapa y flores usan el mismo contorno, no dos formas distintas.

El mapa reduce saturación/contraste y cantidad de puntos, sin reducir la abundancia a escala de jinete. Debe seguir diferenciando rojo y morado, pero no parecer dos paneles de color plano intenso. La escala de mapa es una representación simplificada, no un recuento de tallos.

Solo el campo creado por la florista tras su misión puede verse cultivado/ordenado. No aplicar cuadrículas, hileras ni formas rectangulares a los campos silvestres por reutilizar el mismo renderer. Mantener un atributo de origen del campo, silvestre o creado_por_florista, y su perfil de forma/distribución. Esta diferencia sigue como diseño, no hay campos insertados en partidas.

## Encargos entre floristas y árboles dispersos

Las floristas pueden pedir una especie que NO existe en su poblado/región y enviar al jugador a otro pueblo. Dos vías válidas: pedir una flor directamente a la florista del destino, o que esta indique el campo donde recogerla. Se reconoce la especie y el origen de la muestra; volver a entregar al NPC inicial completa el encargo, no solo hablar con el segundo.

Diseño de estado: quest_id, pueblo_origen, pueblo_destino, especie requerida, muestra_obtenida y muestra_entregada. La muestra de misión tiene ID único y no se duplica al volver a preguntar; no se vende/consume como flor decorativa por accidente. Guardar entrega y efecto de campo en una misma transacción. La disponibilidad de destino debe verificarse en el registro de pueblos antes de ofrecer la misión, sin escoger una florista que no existe o que quedó tras una barrera imposible. El diario guarda nombre y rumbo del pueblo, y si ya se conoce permite el viaje rápido de siesta. Si el jugador consiguió la muestra por la otra vía, la misión reconoce igualmente el mismo objetivo y no obliga a repetir la conversación.

Ejemplo: "Aquí no crecen amapolas. Mi compañera del pueblo del este sí las conoce. Pregúntale si puede darte una, o dónde encontrarlas." Respuesta de destino: "Tengo una muestra para ella" o "Buscamos las del campo que queda al sur del camino". Nombres, direcciones reales, cantidades y si siempre se permiten ambas vías por decidir. La misión puede crear el campo de amapolas al regreso como consecuencia visible, sin alterar los campos silvestres ni reiniciar cadenas terminadas.

Los campos silvestres también incluyen pocos árboles sueltos, sin convertirse en bosque. La preview revisada muestra seis árboles por campo de dos chunks, como muestra visual y no densidad final aprobada. Respetar pies/troncos, cobertura y carretera con el mismo sistema de árboles; claros y flores dominan el paisaje. El concepto de bosque queda anotado para futuro, sin generación ni reglas nuevas ahora.
