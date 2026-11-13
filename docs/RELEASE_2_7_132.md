# Rancho Prueba 2.7.132

## Dos vistas de la colección
- La lista actual se llama Vista por propiedades. La vista visual se llama Vista de colección. Sigue habiendo un solo acceso a Colección y se puede alternar entre ambas.
- Las habilidades Salto y Esquiva aprendidas se resaltan en dorado en las dos vistas; las no aprendidas mantienen su icono apagado/tachado.
- Cada caballo tiene una única barra resumen, también disponible en su ficha. El valor es el promedio con igual peso de8 propiedades: Velocidad, Manejo, Fuerza, Agilidad, Serenidad, aprendizaje de Salto, aprendizaje de Esquiva y Maestría.
- Las cinco propiedades de rendimiento se convierten a0-100 con los mismos mínimos/máximos de las barras de la ficha. Habilidad aprendida aporta100; si no, su progreso de aprendizaje. Maestría usa la regla vigente36-40, preservando la ganada anteriormente.
- No se promedian pelaje, rareza, genes ni equipo. El resumen no cambia la simulación ni el guardado. Pulsar Promedio abre una explicación del cálculo.
- Colección numerosa: tarjetas dentro de un área desplazable, sin tapar filtros, selector o paginación; mantiene12caballos por página.
- Corregido el singular/plural:1caballo,1apariencia;0/varios usan plural. También en el contador del modo visual.

## Comprobaciones
- 692/692 pruebas unitarias completas, en grupos de368 y324.
- 45/45 integraciones dirigidas con renderizado GL, incluidas9 del rancho.
- Cálculo probado con todos los valores al0%, todos al100%, intermedios, habilidad aprendida sin regalar maestría y lectura sin modificar datos.
- Misma barra/valor en ambas vistas. Navegar, filtrar, ver ficha y alternar no modifica la colección.
- Capturas inspeccionadas a960×540: las dos vistas, ficha, habilidades resaltadas, explicación del promedio, singular, potrillo, familia,18caballos y desplazamiento de la primera página. Barras dentro de las tarjetas.
- No probado en Android físico. Falta validar tacto, legibilidad y rendimiento en teléfono. Persisten avisos conocidos de recursos al cerrar las pruebas.

## APK
- Rancho Prueba2.7.132, código391, paquete com.example.rancho.review, arm64.
- Misma firma de prueba que131. Instalar encima; no desinstalar para conservar guardado local.
- Tamaño:71415236bytes. SHA-256:df70aa425b3de8ef00c64f19d954abb3a8471dfe27bd9a95a0550243525d215d.
- Rama feat/open-world-test-20261107, main intacta, sin tiendas ni gastos.
- Web no publicada. Windows sigue125. Sin cambios en guardados/progreso.
