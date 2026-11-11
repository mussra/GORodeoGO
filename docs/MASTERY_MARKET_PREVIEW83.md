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
