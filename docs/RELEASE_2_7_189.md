# Rancho Prueba 2.7.189

## Scroll compartido
- Arrastre táctil con inercia, rueda y barra de desplazamiento visible y arrastrable.
- Ficha, colección, rancho, equipo, genealogía, filtros, notas, encargos, conversación, ajustes, campaña, copa, tablón y diario usan el mismo comportamiento.
- Arrastrar no debe activar botones ni mover ajustes horizontales por accidente. Soltar, ocultar la vista o perder el foco cancela el gesto.

## Atlas
- Patas claras deja de repetir 22 veces el mismo aspecto por el color de manchas que su shader no utiliza.
- Los resultados filtrados vuelven a agruparse por pelaje/patrón/crin. Dentro de cada familia se ven las variantes de manchas realmente distintas, con el color nombrado.
- Se conserva el número de combinaciones equivalentes, los genes y todos los registros del jugador. No se han cambiado crianza ni desbloqueos.
- Se cachean los datos y se construyen solo las seis tarjetas de la página actual.
- Medición local comparable, página filtrada tras calentamiento: 188, 551/564/573 ms; 189, 106/116/114 ms. Primera carga sigue más costosa. No es una medición en Android.

## Recuento para futuras comunicaciones
47.250 combinaciones base generan 41.706 claves de apariencia normalizadas. No equivale al total del juego ni a una comparación exhaustiva de píxeles. El método, alcance y exclusiones quedan en `docs/ATLAS_VARIANTES_METODO_261.md` y `tools/count_atlas261.gd`.

## Validación y límites
- Regresión seleccionada: 340/340 pruebas, 53.950 aserciones, 54 scripts.
- 14 vistas de scroll comprobadas con eventos de arrastre simulados, rueda y barra. Las vistas sin contenido suficiente usaron un bloque temporal alto, sin guardarlo.
- Capturas revisadas de ficha y atlas. APK exportada y firmada como Rancho Prueba, versionCode 448.
- No probado todavía en Android físico. Persisten avisos del entorno GUT (uno general, siete deprecados y dos objetos al cerrar).
- La suite histórica completa no está certificada: una ejecución genérica encontró errores de fixtures antiguos del mundo y se detuvo. La regresión seleccionada sí pasa.
- Rama de prueba solamente. Sin cambios en main, tienda ni gastos.
