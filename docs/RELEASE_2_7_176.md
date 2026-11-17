# Rancho Prueba 2.7.176: rendimiento, zoom amplio y mapa opaco

APK de prueba, código 435. Misma firma/paquete, instalar encima de 175. Sin main ni tienda.

## Cambios

- Zoom manual: 25, 35, 50, 65, 75, 85, 100, 125 y 150%. El porcentaje vuelve a 100%. Ya no recorta el mínimo por el ancho de la pantalla. No añade gestos que interfieran con el lazo.
- Al alejar más allá de la zona cargada, terreno/caminos/contornos lejanos son una vista simplificada compartida con la panorámica. Bajo 70% oculta decoración pequeña y restaura al volver. No crea más animales, sectores, colisiones, descubrimientos ni recompensas por el zoom. Los elementos no cargados no son una vista de simulación completa; acercarse mantiene las reglas existentes.
- Consulta de carreteras de pueblos indexada por zona: antes reconstruía y recorría toda la red para cada consulta del caballo/animal. Usa los mismos segmentos, anchos y márgenes; invalida al cambiar territorio. La física/camino permitidos no cambian.
- HUD de misiones se actualiza cuando cambia su estado, no se reconstruye el texto idéntico cada frame.
- Caché de animaciones salvajes limita la retención a 32 tipos, salvo los que sigan activos; nunca elimina el recurso de un animal vivo. Tipos expulsados se reconstruyen incrementalmente al necesitarlos. No altera genes/animación ni borra animales.
- Minimapa y mapa grande con fondo opaco. Ya no deja transparentar flores reales de debajo. Fuentes de flores vacías; decoraciones y polígonos de flores omitidos. Puntos rosados del mapa son corrales de cerdos, no flores. Las flores del mundo/encargos se conservan.
- OSD añade pasos físicos/frame, física muestreada/frame, CPU propia del mundo y cachés. Frame usa reloj real. Tiempo Motor se identifica como muestra, no como sumando de la media. GPU real sigue N/D; no se inventa utilización.

## Captura de 8 FPS: qué permite concluir

133 ms por frame es lentitud real. No se puede restar sin más 34 ms de Motor y 23 ms de física para atribuir el resto a GPU: eran muestras con bases distintas y puede haber varios pasos físicos por frame. 4.472 objetos no es coste medido ni prueba de fuga. 15 sectores muestra retención por desplazamiento, no demuestra que el mapa los cause. No se han reducido frecuencias de física ni eliminado animales/colisiones para ganar FPS.

Hay un coste CPU demostrado vinculado a los pueblos: consulta global de carreteras. En microprueba de 3.000 puntos tarda 652,8 ms antes y 18,5 ms después, mismos 59 aciertos. Pruebas de equivalencia incluyen bordes, márgenes y cambio de territorio.

## Medición y límites

Escritorio, Godot 4.7.2, Vulkan mobile/llvmpipe, semilla 752026 V6, 1280x720 en benchmark general. Media/p95 antes y después en ms: reposo 23,83/26,30 -> 22,84/25,33; desplazamiento 27,59/32,30 -> 26,18/30,42. No es su partida ni su teléfono.

A/B de pueblos: minimapa visible añade 8 draw calls y aproximadamente 0,3-0,8 ms en escritorio; no repinta terreno cada frame. En puerta, ocultar solo el dibujo de paredes cambia 24,83 a 24,53 ms (colisiones intactas). No se confirma que pintura/mapa expliquen los 133 ms móviles. Se mantiene su apariencia y se corrige el coste de consultas.

Zoom 100/50/25%: misma carga de 9 sectores, +3 nodos de vista simplificada; una muestra da 22,89/24,06/24,46 ms y 275/306/312 draw calls. Alejar no es gratis y no se promete rendimiento idéntico. Capturas verificadas también en formato 1600x720.

190/190 pruebas, 18.703 aserciones, 29 scripts dirigidos: carreteras equivalentes, caché, zoom/táctil, persistencia, misiones, mapa compartido/notas/fotos y equipo. Cuatro deprecaciones, sin fallos. Sin Android físico. Falta comprobar el mismo lugar con su OSD; no se declara corregido el atasco largo/Rodeo20.
