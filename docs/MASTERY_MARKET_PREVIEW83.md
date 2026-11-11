# Maestría por caballo y oferta Galaxy en nivel 20

11 de noviembre de 2026. Rama de prueba, preview sin APK.

## Mercado

El catálogo de nivel 20 garantiza una oferta Galaxy normal. Se conserva exactamente el sorteo anterior de las otras cinco ofertas. La sexta mantiene ID, genes restantes y capacidad de salto; solo cambia acabado a Galaxy. Precio calculado por las reglas habituales: 1.400 puntos del juego. Se comparó el catálogo ejecutando el código anterior y el nuevo: primeras cinco idénticas, sexta solo acabado cambiado. No dinero real, compras automáticas ni regalo de unicornio.

## Registro y porcentaje

Cada victoria acredita el nivel a la montura capturada al inicio del nivel, independientemente de selecciones posteriores. Niveles distintos completados / 20 = porcentaje general de maestría. Repetir un nivel no lo infla. La lista se guarda dentro del registro del caballo y permanece al venderlo como antepasado.

No se inventan registros retroactivos desde el avance global: un caballo antiguo sin datos indica “Sin registro por caballo”. La carga antigua sigue siendo legible. Un fallo de guardado revierte tanto premios como registro de niveles. Modo ensayo no acredita nada.

“Galaxy maestro” requiere adulto, acabado Galaxy y 100% de maestría general (20/20 niveles). Umbral configurable con valor actual 100, como pidió Ant. Serenidad y barras de salto/regate no se usan como atajo; estas barras mantienen su comportamiento anterior.

## Ficha y visual

Lista de niveles y porcentaje al principio de la ficha, antes de genes. Al 100%, el retrato de Galaxy maestro usa nebulosas/estrellas en azul como preview de color recomendada. No añade cuerno, rastro ni especie unicornio. Al 95%, conserva el Galaxy normal anterior. Misma base de retrato y máscaras; solo shader. No convierte un caballo ni implementa una receta.

Limitación explícita: este cambio de nebulosas está en retratos de colección/Atlas/Ficha que usan HorsePortrait.apply_horse. Todavía falta llevar el shader a todos los sprites de gameplay/animaciones con sus máscaras y UV. No afirmar que todo el juego cambia ya. Las nuevas paletas de unicornio y regla de color siguen en revisión.

Nuevas habilidades exclusivas de unicornio: aún no hay catálogo/reglas implementadas, así que no se muestran barras falsas de Nadar. Los caballos normales y Galaxy maestro no muestran barras exclusivas de unicornio. Salto/regate se conservan.

## QA

485/485 unitarias, 57.573 aserciones, con casos 95%-100%, duplicados, adulto/cría, Galaxy/Normal, Serenidad/maestría de técnicas sin atajo, carga, guardado fallido, modo ensayo y catálogo20. Integraciones dirigidas con nueva prueba real de arranque de nivel, montura capturada, atribución y ficha. Capturas95%/100% revisadas. Avisos auxiliares de fixtures/leaks conocidos. No prueba Android física.

Fuente mágica y loco del pueblo: Ant confirmó que se crearán juntos más adelante. No se implementan. Receta de N generaciones Galaxy, rastro y río por mapa siguen pendientes; no hay conversión automática en unicornio.

## Revisión visual de las 13:36: aura e intensidad

- Peticiones de Ant: aura o brillo para el maestro; bajar moderadamente la intensidad del normal.
- Retratos: normal con nebulosas/estrellas moradas a intensidad parametrizada 0,65. Maestro azul a 1,0 con halo suave de silueta del caballo, excluyendo jinete y sombrero.
- Solo shader: no hay cambios de PNG, cuerno ni rastro arcoíris.
- `galaxy_intensity` y `mastery_aura` son parámetros independientes, no alteran progreso ni genética.
- Gameplay pendiente: compartir parámetros desde HorseMastery y adaptar muestreo a máscaras/UV de cada pose (montado, libre y beber). No aplicar halo sobre cuadros de atlas sin margen porque podría contaminar poses vecinas. Requiere comprobación visual de todas las vistas y coste real en Android antes de cerrar.
- Preview comparada: `galaxy-aura-comparison83.png`. No APK.

## Revisión final de retrato (13:39-13:41)

La versión anterior con mezcla hacia negro se veía más intensa. Se corrige mezclando hacia lavanda neutro claro a intensidad0,30, bajando saturación/contraste sin apagar las nubes. Un solo color fijo para el normal: lavanda, misma familia que el Galaxy anterior. No hay paletas por afinidad ni variantes elegibles. Azul es el estado maestro del mismo caballo.

Petición posterior: estrellas progresivas por maestría. `galaxy_star_density` es independiente de intensidad y de `mastery_aura_strength`. Densidad=0,04+0,96×maestría/100: pocos puntos a0%,52% del campo a50%,95,2% a95%,100% a100%. Campo determinista: crecen los puntos sin cambiar posiciones. El maestro recibe aura1,8 (antes1,0), además del azul y la intensidad1.

El color se mantiene lavanda hasta completar los20 niveles; solo las estrellas progresan. Se recomienda conservar el salto de color y aura como recompensa del100%. Un cambio gradual de color no está aplicado y requeriría cambiar la regla de color único del normal.

`galaxy-mastery-progress83.png`: misma Ficha real a0/50/95/100%, sin raster nuevo. Gameplay/beber sigue pendiente de adaptación de máscaras/UV y revisión de rendimiento Android. Sin APK, sin merge.

## Astro rey (13:42)

Disco luminoso y12rayos suaves en pecho del maestro, con resplandor azul. Parámetro `mastery_sun` exclusivo maestro y centro UV de esta pose de retrato. No toca escudos, emblemas, genes ni máscaras fuente. Gameplay pendiente de centros por pose y visibilidad de pecho recortada al pelaje. No equivale a arte completo para otras poses.

## Luna y propuesta Alfa/Omega (13:43-13:46)

La luna creciente ocupa el lugar del emblema en el muslo. Decisión posterior de Ant: manda la luna. El shader oculta el emblema solo mientras se cumplen las condiciones de maestro y luna, sin borrar ni modificar el emblema guardado. Si deja de ser maestro, vuelve a verse. No se modifican archivos de máscaras ni el sistema de genes/emblemas.

Sol=principio y luna=final, tema Alfa y Omega. Dos láminas de propuesta: sin letras y con Α/Ω procedurales bajo cada astro. Letras desactivadas por defecto. Cinco colores candidatos (azul, rosa con azul, verde, rojo con azul, negro), cada uno a70/100/140% del tamaño actual. No se desbloquean cinco variantes de maestro; esperando elección. Normal conserva un lavanda. Tamaño por defecto1, letras apagadas. Gameplay aún pendiente.

## Selección de Ant (13:47)

TamañoS70% para sol y luna, SIN letras. Aplicado como valor de Galaxy maestro en HorsePortrait. Colores aún no elegidos, se conserva azul provisional; las otras paletas siguen siendo propuestas. La opción de letras queda solo en el generador de propuesta, explícitamente apagada en la configuración de juego.

## Aclaraciones y trabajo en curso (13:48-13:53)

Azul/S70/sin letras confirmado para maestro. Gris y marrón se aclararon después como candidatos de Galaxy NO maestro: las primeras capturas con aura de esos colores quedan descartadas para esa elección. No se ha cambiado aún el normal activo lavanda. El marrón revisado conserva la base real de `adult_hd.png` (pelaje naranja/castaño y crin/cola marfil), no una reinterpretación oscura. Shader de propuesta `galaxy_original_base` apagado por defecto. La lámina compara original real con candidato al20%.

El aura de maestros toma ahora el color base (`galaxy_light`), no azul fijo para todas las paletas. Las cinco paletas siguen propuestas, no variantes activadas.

WIP gameplay: HorseGalaxyLook transporta maestría de un caballo concreto fuera de los genes y las claves de caché incluyen el estado. Adaptados provisionalmente PixelLab montado/libre, clásico, beber, miniaturas y precarga seleccionada. Nebulosas/estrellas se calculan una vez por textura, no en cada fotograma. Anclajes de sol/luna por vista con UV y halo fuera de píxeles transparentes del caballo. No toca máscaras fuente. AÚN NO cerrado: revisar todos los frames, anclajes y coste de carga/Android, así como resolver elección de color normal. No se presenta como terminado. El trabajo de anclajes queda en pausa tras la aclaración del13:50. Sin APK.

## Nebulosa normal en tono original (14:00)

Ant aclara que busca más Galaxy, no una copia casi plana del original: nebulosa y estrellas con el naranja/castaño del primer caballo. Nueva propuesta solo en generador: paleta oscura#351707/luz#d0742f, base neutra cálida, intensidad0,72 (maestro1,0). Nubes visibles incluso a0%, estrellas progresivas0/50/95%. Sin aura, astros ni letras. No cambia la paleta activa ni las máscaras. `galaxy-original-nebula-progress83.png` sustituye la propuesta casi original para esta decisión.

## Marrón más claro (14:15)

Revisión solo de propuesta: base oscura#5a2c10 y luz#e99a4c, neutro cálido más claro. Mantiene intensidad0,72, nebulosa desde0% y mismas estrellas progresivas. Comparativa anterior/nueva a0/50/95%. Sin aura, astros ni letras. No cambia colores activos ni máscaras. `galaxy-brown-lighter-comparison83.png`.

## Segundo aclarado de propuesta (14:18)

Un paso adicional: oscura#78401a/luz#f3b065/neutro(.58,.39,.23). Misma intensidad0,72, nubes y estrellas0/50/95%. Comparativa con el paso c01e07a. Solo preview, sin cambio de paletas activas ni máscaras. `galaxy-brown-lighter2-comparison83.png`.
