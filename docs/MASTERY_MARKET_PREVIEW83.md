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
