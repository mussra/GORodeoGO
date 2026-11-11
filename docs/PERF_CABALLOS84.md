# Búsqueda espacial de manchas: optimización posterior a 2.7.84

Solo en la rama de prueba. No hay APK nueva de este cambio.

## Qué cambia
La función compartida de apariencia mantiene los mismos colores y la misma matemática de manchas. Antes buscaba entre las 128 manchas para cada píxel. Ahora una tabla espacial de celdas de 8 unidades descarta solo manchas que no pueden alcanzar el punto. El radio conservador de cada mancha conserva todos los candidatos posibles y su orden. Se mantiene el cálculo original sobre los candidatos. No se baja resolución, se cambian máscaras ni se pinta arte nuevo.

## Exactitud
360 texturas con SHA-256 RGBA idéntico al código anterior: 12 patrones, cinco vistas, tres fases por vista, jinete y caballo. La referencia incluye los patrones no afectados. La prueba automática conserva esas firmas y valida la búsqueda fuera del cuerpo. Las muestras visuales se han inspeccionado.

## Medición
Godot 4.7.2, escritorio, headless. Perfil de CPU, no FPS ni GPU. Misma semilla 752026, 1200 frames de recorrido a 500 unidades/segundo simulado; el perfil llama a las mismas funciones de construcción del mundo. Un wrapper de medición hereda del mundo, sin copiar su código.

| Métrica | Antes | Después |
| --- | ---: | ---: |
| CPU streaming p95 | 10,537 ms | 6,855 ms |
| CPU streaming máximo | 27,049 ms | 8,406 ms |
| Paso de textura p95 | 14,205 ms | 6,827 ms |
| Paso de textura máximo | 26,945 ms | 8,301 ms |
| Preparación inicial de zonas, tras precalentado | 1661,725 ms | 1036,923 ms |
| Precalentado de caballos de prueba | 1199,202 ms | 750,604 ms |
| Frames sin zona actual | 0 | 0 |

Las colisiones/decoración no eran el paso costoso: máximo 0,09 ms por paso en esa prueba. El presupuesto de 3ms de construcción todavía puede superarse en una textura; no se presenta como resuelto. El coste GPU, texturas grandes, mapa guardado y móvil de Ant pueden añadir otros límites.

495 pruebas unitarias, 58.513 aserciones. Sin certificación Android ni cambio de gameplay. Las métricas crudas se guardan junto a este documento.
