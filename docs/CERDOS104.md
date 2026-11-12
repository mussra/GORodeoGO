# Captura individual y venta opcional de cerdos

Preview de código, sin APK ni main. Pendiente integrar en el APK conjunto 2.7.89 aprobado por Ant.

## Cambios

El contador anterior contaba grupos/zonas completamente capturadas, no cerdos individuales. Además, una captura parcial de un grupo no tenía un ID persistido, por lo que podía reaparecer al cargar la zona. Ahora cada cerdo capturado registra su ID individual, actualiza el inventario y no vuelve a aparecer. Se conserva aparte la lista antigua de grupos completados para no romper el guardado ni hacerlos reaparecer.

Al capturar: mensaje en español con total acumulado, cerdos que llevas y la recompensa existente de 40 puntos. El HUD muestra los animales que llevas, no los grupos. Esa recompensa ya existía; no se elimina al añadir venta.

El granjero ofrece vender los cerdos de tu inventario, solo si pulsas el botón. El precio se muestra ANTES: propuesta parametrizable de 40 puntos por cerdo. También se muestra la cantidad y el total. Puedes cerrar y guardarlos. No se vende nada al abrir el diálogo. Los puntos son la moneda existente del equipo, no dinero real.

Venta y captura guardan conjuntamente inventario, puntos y estado de misión. Ante fallo de guardado revierten cambios; no anuncian un pago que no se ha guardado. La venta no borra el histórico de captura, ni vuelve a generar animales vendidos. IDs duplicados no premian dos veces.

Se añade registro individual de cabras capturadas. No hay un cupo de almacenamiento para caballos, cerdos o cabras. Los tres ejemplares de cabra del prototipo no son una población ilimitada: no confundir ausencia de cupo con nuevos rebaños regionales de cabras, que todavía no están implementados.

## Guardados anteriores

V1/V2 conservan semilla, generador, grupos ya capturados, colección, misiones y puntos. Los campos nuevos faltantes parten vacíos. No se inventa un número de animales anteriores ni se acreditan pagos retroactivos: el formato antiguo no registraba capturas individuales parciales. Las misiones antiguas conservan su progreso. No hay aún múltiples slots: estos campos pertenecen al mismo archivo de progreso existente.

## Pruebas

Cuatro pruebas unitarias específicas, 45 aserciones: IDs individuales, duplicados, quest, recompensa, venta opcional y precio esperado, recarga V2, rollback de captura/venta/cabra ante fallo de guardado, 10.000 cerdos y 10.000 cabras guardados y leídos sin cupo artificial, precio previo en el diálogo sin mutación del inventario. Las pruebas de fallo provocan intencionadamente tres errores de escritura y los verifican.

Capturas de render reales en escritorio, español: mensaje de captura, precio antes de venta y mensaje tras venta. Caso simulado de tres IDs de QA: recompensa inicial 120 puntos y venta adicional 120; saldo 240, inventario 0, histórico 3. No es una persecución manual en Android.

## Idioma y decisiones pendientes

Los textos citados por Ant ya tenían traducción española en catálogo: "Misión descubierta: manada salvaje", "Paso", "Misiones" y "Tablón de encargos". La prueba inglesa procedía de selección automática según idioma del sistema. Se mantiene la opción de idioma; capturas de esta entrega en español. Los mensajes nuevos están en español/inglés.

Pendiente confirmar precio final y si en el futuro varía entre pueblos, si se venden cantidades parciales en un selector (ahora se vende todo el inventario mostrado), si la recompensa inmediata de captura se mantiene además de la venta, y cómo acreditar animales de una partida anterior sin historial individual. No se presupone ninguna de esas decisiones.

Integración adicional: una prueba real de Frontera (7 aserciones) captura un cerdo por el tick de persecución, verifica inventario 1 y +40 puntos, reconstruye el mundo y comprueba que el ID capturado no reaparece mientras los otros cerdos del grupo siguen presentes.
