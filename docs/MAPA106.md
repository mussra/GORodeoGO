# Notas, fotos y zoom del mapa

Preview de código, sin APK ni main. Incluido en el APK conjunto 2.7.89 cuando se publique.

## Uso

Abre el mapa pequeño. Mantén pulsado unos 0,6 segundos en el mapa grande para añadir una nota. Si lo haces sobre una marca existente, la abre para editar o eliminar. Texto hasta 240 caracteres, sin cupo artificial de número de notas. La marca dorada se ve en mini/mapa. Ya no se cierra el mapa al dar un toque corto dentro: usa X o volver. Arrastra para desplazarlo.

Una nota cercana a un caballo activo incluye su ID y propone color/crin en el texto. Puedes cambiar el texto. Opcionalmente guarda una foto local de la vista del mundo tomada al abrir el mapa. La foto incluye lo visible, no es un retrato recortado o una cámara libre. Para hacer otra foto, cierra el mapa, encuadra al caballo y vuelve a abrirlo. Al reabrir la nota se ve su miniatura.

Las notas se agrupan por regiones de 16x16 chunks en el guardado actual. Fotos en archivos separados y privados del juego, nunca se suben. Borrar nota borra su foto. Cambiar la foto no sobreescribe la anterior hasta que el guardado nuevo ha funcionado. No se implementan aún slots múltiples ni un nuevo motor de guardado incremental.

El caballo sin capturar se vuelve a generar en su zona con el mismo ID/rasgos por semilla, aunque salgas y cargues la partida. Una nota no lo congela ni conserva exactamente dónde terminó su último paso: se mueve con su manada. Una captura posterior elimina al salvaje normalmente; borrar una nota no borra al caballo. No se garantiza persistir la posición exacta tras una huida.

## Zoom y arrastre

- Botones dorados +/- más legibles, slider de cantidad de zoom entre ellos y valor numérico sincronizado. Rango 0,5x-32x para poder acercarse a una huella extensa.
- Entrada explícita ScreenTouch/ScreenDrag y ratón. Ignora el ratón emulado cuando procesa toque, evitando acciones dobles.
- El desplazamiento se limita según ancho/alto del contenido descubierto y un margen de 12 unidades de interfaz. Si el contenido cabe en un eje no permite perderlo arrastrando ese eje.
- Franja de controles separada y terreno recortado a la zona del mapa. La X permanece fuera del dibujo retenido.
- Arrastrar desplaza el dibujo ya retenido en vez de regenerar todo por evento. Renueva contenido al desplazarse más de 250 unidades o acabar. A zoom bajo usa LOD, agrupa fondo en píxeles y omite detalle de decoración/manadas que no sería legible, conservando montaña y marcas. Al acercar recupera detalle visible.
- El marcador del jinete mantiene su tamaño de pantalla anterior; no escala con zoom ni con tamaño del mundo.

## Medición y alcance

Huella sintética de 10.000 chunks (100x100), escritorio llvmpipe, no Android: antes del LOD el render del mapa de 10.000 no completó en la prueba de auditoría. Ahora reconstruye/renderiza sin atascar el proceso. Se midieron ~59 ms antes de añadir montañas en LOD; con montañas la primera prueba de 896x414 dio ~409 ms. Se añadió caché regional acotada de montaña para evitar recrear RNG/descriptores repetidos. Ver log y notas del APK para la medición final con caché, no comparar estas cifras como si fueran la misma configuración.

120 eventos de arrastre sobre dibujo retenido: ~0,14 ms de CPU total y cero reconstrucciones durante ese tramo corto. Eso NO es FPS de una sesión Android ni incluye toda la latencia de pantalla. Al finalizar un arrastre todavía puede haber coste de reconstrucción. La solución reduce mucho el tirón de cada movimiento, pero no termina toda la arquitectura de mapas enormes: aún se recorren metadatos de descubierto, hash de estado cada 0,3 segundos cuando no arrastras y guardado completo. LOD/indexado/tiles persistentes siguen siendo trabajo de escala posterior, no un límite al tamaño del mundo.

## Validación

- 3 unitarias nuevas, 16 aserciones: notas por región, edición, borrado, Unicode, rechazo de campos corruptos, rollback de guardado, clamp y 50 movimientos sin reconstrucción.
- Integración real de Frontera: 1/1, 11 aserciones. Evento táctil de pulsación larga abre nota, no cierra mapa, texto y vínculo a caballo guardados, recarga y mismo miembro/rasgos sin capturar, borrar nota.
- Caché previa conserva invalidación por cambios in situ: 1/1, 14 aserciones.
- Regresión unitaria global: 535/535, 1.586.228 aserciones antes de la última caché de descriptores.
- Regresión pertinente de Frontera: 11 pruebas de nominal, huida, floristería anterior, NPC, caché, montañas, cerdos, flores y notas pasan. Entrada de pantalla del mapa de arena y bullet time: 6 pruebas pasan con render real. Esas dos fallaban sin render en el intento headless; no se atribuye a una corrección que no se hizo.
- Capturas de escritorio a 1598x720 y 896x414. Se detectó y corrigió foto excediendo el cuadro y terreno invadiendo botones; inspección final con miniatura encajada y franja libre. 896x414 sigue siendo escritorio redimensionado, NO teléfono físico ni prueba de teclado Android.

Pendiente decidir: foto con recorte/cámara propia, etiquetas visibles siempre, otros iconos seleccionables, pose exacta de animal, migración de fotos cuando existan slots y presupuestos de caché por dispositivo. La implementación actual tiene icono de lugar o caballo asignado automáticamente, no un catálogo de iconos manual.
