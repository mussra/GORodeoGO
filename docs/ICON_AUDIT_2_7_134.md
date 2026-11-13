# Auditoría de la hoja de Ant:72celdas

Archivo recibido1182×1330RGBA. La cuadrícula generada NO es uniforme: se recorta por límites detectados y revisados, no por dividir ancho/8 a ciegas. Se eliminan números y motas de alfa; se conserva la transparencia real, sin rellenar fondo. No se amplía para fingir más resolución. Todos los recortes conservados, incluidos los no integrados.

24celdas integradas: 1, 2, 3, 4, 5, 6, 7, 9, 10, 11, 12, 13, 14, 21, 22, 23, 48, 57, 58, 59, 60, 61, 62, 63.

|Celda|Estado|Motivo / uso|
|---|---|---|
|1|USADA|Reemplaza imagen estática: habilidades1-4, menú5-7/9-12, paginación13-14, mapa21-23/48, casilla57-60, sonido61-62, desplegable63.|
|2|USADA|Reemplaza imagen estática: habilidades1-4, menú5-7/9-12, paginación13-14, mapa21-23/48, casilla57-60, sonido61-62, desplegable63.|
|3|USADA|Reemplaza imagen estática: habilidades1-4, menú5-7/9-12, paginación13-14, mapa21-23/48, casilla57-60, sonido61-62, desplegable63.|
|4|USADA|Reemplaza imagen estática: habilidades1-4, menú5-7/9-12, paginación13-14, mapa21-23/48, casilla57-60, sonido61-62, desplegable63.|
|5|USADA|Reemplaza imagen estática: habilidades1-4, menú5-7/9-12, paginación13-14, mapa21-23/48, casilla57-60, sonido61-62, desplegable63.|
|6|USADA|Reemplaza imagen estática: habilidades1-4, menú5-7/9-12, paginación13-14, mapa21-23/48, casilla57-60, sonido61-62, desplegable63.|
|7|USADA|Reemplaza imagen estática: habilidades1-4, menú5-7/9-12, paginación13-14, mapa21-23/48, casilla57-60, sonido61-62, desplegable63.|
|8|NO USADA, REGENERAR|Moneda cortada por el borde derecho del archivo fuente. No se reconstruye inventando píxeles.|
|9|USADA|Reemplaza imagen estática: habilidades1-4, menú5-7/9-12, paginación13-14, mapa21-23/48, casilla57-60, sonido61-62, desplegable63.|
|10|USADA|Reemplaza imagen estática: habilidades1-4, menú5-7/9-12, paginación13-14, mapa21-23/48, casilla57-60, sonido61-62, desplegable63.|
|11|USADA|Reemplaza imagen estática: habilidades1-4, menú5-7/9-12, paginación13-14, mapa21-23/48, casilla57-60, sonido61-62, desplegable63.|
|12|USADA|Reemplaza imagen estática: habilidades1-4, menú5-7/9-12, paginación13-14, mapa21-23/48, casilla57-60, sonido61-62, desplegable63.|
|13|USADA|Reemplaza imagen estática: habilidades1-4, menú5-7/9-12, paginación13-14, mapa21-23/48, casilla57-60, sonido61-62, desplegable63.|
|14|USADA|Reemplaza imagen estática: habilidades1-4, menú5-7/9-12, paginación13-14, mapa21-23/48, casilla57-60, sonido61-62, desplegable63.|
|15|RESERVA, NO USADA|Flecha arriba disponible; se conserva texto/ruta direccional dinámica.|
|16|RESERVA, NO USADA|Flecha abajo disponible; se conserva texto/ruta direccional dinámica.|
|17|RESERVA, NO USADA|Diagonal arriba-derecha disponible; no aplicada al rumbo dinámico.|
|18|RESERVA, NO USADA|Diagonal abajo-derecha disponible; no aplicada al rumbo dinámico.|
|19|RESERVA, NO USADA|Diagonal abajo-izquierda disponible; no aplicada al rumbo dinámico.|
|20|RESERVA, NO USADA|Diagonal arriba-izquierda disponible; no aplicada al rumbo dinámico.|
|21|USADA|Reemplaza imagen estática: habilidades1-4, menú5-7/9-12, paginación13-14, mapa21-23/48, casilla57-60, sonido61-62, desplegable63.|
|22|USADA|Reemplaza imagen estática: habilidades1-4, menú5-7/9-12, paginación13-14, mapa21-23/48, casilla57-60, sonido61-62, desplegable63.|
|23|USADA|Reemplaza imagen estática: habilidades1-4, menú5-7/9-12, paginación13-14, mapa21-23/48, casilla57-60, sonido61-62, desplegable63.|
|24|RESERVA, NO USADA|Triángulo derecho válido, reservado para no alterar texto de Encargos.|
|25|RESERVA, NO USADA|Triángulo abajo válido, reservado para no alterar texto de Encargos.|
|26|RESERVA, NO USADA|Corazón gris válido; el actual es de10px y conserva lectura simple.|
|27|RESERVA, NO USADA|Corazón oro válido; conservado el indicador diminuto actual.|
|28|RESERVA, NO USADA|Corazón brillante válido; conservado el indicador diminuto actual.|
|29|RESERVA, NO USADA|Corazón+estrella válido; conservado el indicador diminuto actual.|
|30|RESERVA, NO USADA|Corona válida; conservado el indicador diminuto actual.|
|31|RESERVA, NO USADA|Check válido; no se sustituye el trazo diminuto y estado dinámico.|
|32|RESERVA, NO USADA|Exclamación válida, incluido punto separado; se conserva tipografía de NPC/mapa.|
|33|RESERVA, NO USADA|Interrogación válida, incluido punto separado; se conserva tipografía de caballo/mapa.|
|34|NO USADA, REGENERAR|Pin de mapa sin flecha orientable; no sustituye el marcador del jugador.|
|35|RESERVA, NO USADA|Cuadrado válido; el de mapa mide8px y no necesita relieve.|
|36|NO USADA, REGENERAR|Broche cerrado: casi la misma silueta que37.|
|37|NO USADA, REGENERAR|No está abierto; solo cambia de color respecto a36. Necesita hueco visible.|
|38|RESERVA, NO USADA|Medallón válido; sitio visitado conserva su anillo dinámico.|
|39|RESERVA, NO USADA|Medallón con punto válido; nota conserva halo de selección dinámico.|
|40|NO USADA, REGENERAR|Flor de5pétalos, no6; borde derecho de fuente ajustado. No sustituye el glifo específico.|
|41|NO USADA, REGENERAR|Casa detallada casi duplicada de9; no pictograma compacto para mapa.|
|42|RESERVA, NO USADA|Árbol válido, reservado para futura escala adecuada de mapa.|
|43|RESERVA, NO USADA|Pino válido, reservado para futura escala adecuada de mapa.|
|44|RESERVA, NO USADA|Roca válida, reservada para futura escala adecuada de mapa.|
|45|RESERVA, NO USADA|Arbusto válido, reservado para futura escala adecuada de mapa.|
|46|RESERVA, NO USADA|Cactus válido, reservado para futura escala adecuada de mapa.|
|47|NO USADA, REGENERAR|Aros/eslabones con patas, sin colas de cuerda; no se lee inequívocamente doble lazo.|
|48|USADA|Reemplaza imagen estática: habilidades1-4, menú5-7/9-12, paginación13-14, mapa21-23/48, casilla57-60, sonido61-62, desplegable63.|
|49|RESERVA, NO USADA|Escudo válido, no aplicado: contorno, divisiones, colores e iniciales son editables.|
|50|RESERVA, NO USADA|Círculo válido, no aplicado por composición heráldica editable.|
|51|RESERVA, NO USADA|Escudo recto válido, no aplicado por composición heráldica editable.|
|52|RESERVA, NO USADA|Sol aproximado de4puntas, válido como pieza suelta, no aplicado a heráldica editable.|
|53|RESERVA, NO USADA|Sierra válida, no aplicada a heráldica editable.|
|54|RESERVA, NO USADA|Rombo válido, no aplicado a heráldica editable.|
|55|RESERVA, NO USADA|Cruz válida, no aplicada a heráldica editable.|
|56|RESERVA, NO USADA|Onda válida, no aplicada a heráldica editable.|
|57|USADA|Reemplaza imagen estática: habilidades1-4, menú5-7/9-12, paginación13-14, mapa21-23/48, casilla57-60, sonido61-62, desplegable63.|
|58|USADA|Reemplaza imagen estática: habilidades1-4, menú5-7/9-12, paginación13-14, mapa21-23/48, casilla57-60, sonido61-62, desplegable63.|
|59|USADA|Reemplaza imagen estática: habilidades1-4, menú5-7/9-12, paginación13-14, mapa21-23/48, casilla57-60, sonido61-62, desplegable63.|
|60|USADA|Reemplaza imagen estática: habilidades1-4, menú5-7/9-12, paginación13-14, mapa21-23/48, casilla57-60, sonido61-62, desplegable63.|
|61|USADA|Reemplaza imagen estática: habilidades1-4, menú5-7/9-12, paginación13-14, mapa21-23/48, casilla57-60, sonido61-62, desplegable63.|
|62|USADA|Reemplaza imagen estática: habilidades1-4, menú5-7/9-12, paginación13-14, mapa21-23/48, casilla57-60, sonido61-62, desplegable63.|
|63|USADA|Reemplaza imagen estática: habilidades1-4, menú5-7/9-12, paginación13-14, mapa21-23/48, casilla57-60, sonido61-62, desplegable63.|
|64|NO USADA, REGENERAR|Aro de joystick gris opaco, no translucidez solicitada; borde derecho pegado al límite.|
|65|RESERVA, NO USADA|Pomo válido, no aplicado: VirtualJoystick nativo usa colores, no textura de pomo.|
|66|NO USADA, REGENERAR|Placa demasiado alta/corta frente a384×112 solicitado; no sirve de nueve parches tal cual.|
|67|NO USADA, REGENERAR|Mismo problema de proporción y geometría de66.|
|68|NO USADA, REGENERAR|Mismo problema de proporción y geometría de66.|
|69|NO USADA, REGENERAR|Mismo problema de proporción y geometría de66.|
|70|RESERVA, NO USADA|Luna+zetas, propuesta opcional; no crea botón ni sustituye transición de siesta.|
|71|RESERVA, NO USADA|Rayo válido como propuesta; NO sustituye arte de los relojes del HUD.|
|72|RESERVA, NO USADA|Ojo cerrado válido como propuesta; no sustituye transición de párpado calculada.|

## Se conserva
Tres relojes originales del HUD, su relleno y disponibilidad; barras/progreso/animación; formas de mapa pequeñas, rumbo y selección; guardados, entrenamiento, estadística y colección. No se han sustituido todos los elementos de la app indiscriminadamente.

## Comprobación visual
Menú antes/después, Vista por propiedades antes/después, Vista de colección antes/después, ayuda abierta con caballo visible, paginación, casillas, desplegable/sonido y mapa/nota reales a960×540. Los números no aparecen en los iconos integrados. Sin Android físico.
