# Rancho Prueba 2.7.168

Pelajes animales y arcoíris suave aprobados por Ant. Rama de pruebas, sin main, tiendas ni gastos.

## Añadido

- Seis patrones con el nombre del animal: Leopardo, Guepardo, Tigre, Jaguar, Hiena y Cebra de montaña.
- Se conservan los doce patrones anteriores y sus IDs. Cebra, Jirafa y Vaca ya existían y no se sustituyen.
- Arcoíris suave independiente en Pelaje y Color de manchas. No tiñe jinete, crin/cola, ojos, equipo ni fondo.
- Los estilos de base y manchas se heredan con el color del progenitor elegido en cría. Se conservan las reglas de selección y estadísticas.
- Editor de prueba y ficha con nombres de animal y opción Arcoíris suave en los dos colores.
- Sombreros con los nuevos patrones y colores, conservando diseños históricos v1/v2, acabados anteriores y desbloqueos permanentes al vender el caballo.
- Atlas visuales completos guardados en `docs/pelajes238`: seis matrices de 21 × 21, tres láminas de ejemplos y una comparación con nueve animales reales. La fila/columna 21 es el arcoíris suave; 2.646 combinaciones documentadas.
- Instinto guardado como propuesta de diseño pendiente. No cambia IA ni captura en esta versión.

## Compatibilidad

Mismo paquete y firma. Instalar encima, sin desinstalar. No se cambian caballos guardados ni generadores de mundos anteriores. Los estilos ausentes equivalen a color plano. No se han alterado los precios; los nuevos patrones usan el peso de los patrones animales existentes para evitar índices fuera de rango.

Las matrices muestran combinaciones visuales, no una promesa de aparición aleatoria de cada combinación. Los estilos nuevos están disponibles en el editor de prueba y se transmiten por cría. No se rediseñan las reglas de adquisición ni las ofertas ya guardadas.

## Verificación

- 78/78 unitarias dirigidas, 109.862 aserciones, 18 scripts.
- 127/127 integración, 1.419 aserciones, 28 scripts, ejecutadas en cuatro grupos.
- Comprobadas cría, validación, guardado/recarga, venta, armario histórico, filtros/atlas y compatibilidad de patrones.
- 90 fotogramas de caballo montado/salvaje sin cambios fuera de las regiones de caballo permitidas. Cinco vistas cubren las ocho direcciones mediante espejo. Se generan los seis patrones en todas las vistas y se comprueban ambas poses de beber con arcoíris en base o manchas.
- Inspección visual real del motor: adulto, cría, las cinco vistas, beber, ficha/editor desplazado y sombrero desbloqueado. Comparación natural con fotos inspeccionada.
- No es la batería unitaria completa del repositorio. Sin prueba en Android físico: tacto, legibilidad y rendimiento en móvil siguen pendientes.
- Persisten avisos de recursos al cerrar algunos tests: hasta 25 CanvasItem, 28 ObjectDB y 2 recursos retenidos. No son pruebas fallidas, pero tampoco se ocultan.

Las fotos de la comparación son documentación, no arte del juego. Atribuciones y licencias en `docs/pelajes238/FUENTES.md`, fuera de la imagen, como pidió Ant.
