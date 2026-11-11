# Césped sin franjas, lazo tenso y Encargos

Preview en rama `feat/open-world-test-20261107`. Sin APK y sin main. La captura usa el mundo de prueba a 1598x720, proporción de la captura móvil aportada por Ant, no es una captura Android ni una copia de su partida.

## Césped

El anterior suelo superponía tres variantes con transparencia sobre una cuadrícula. La selección de variante cambiaba, pero los bordes y el sombreado de la hoja repetían líneas visibles. Se sustituye por una textura precalculada opaca, formada exclusivamente con las tres variantes del usuario: posiciones desplazadas, giros y reflejos deterministas, mezcla de pesos normalizada y luminosidad amplia igualada. Fondo claro con pequeñas zonas oscuras irregulares, sin filas de baldosas ni sombreado oscuro acumulado por alfa.

Se mantiene el detalle de hojas del original, algo más suave por la mezcla. La textura finita se repite cada 1024 unidades de mundo: no se afirma aleatoriedad infinita o ausencia de toda repetición. En las capturas generales y ampliadas inspeccionadas no se ven las antiguas franjas horizontales. Los UV globales atraviesan los límites de chunk sin reiniciarse. No hay escritura de partidas ni cambios de colisión o generación.

El suelo pasa a una textura compartida precalculada con un polígono por chunk. No se recalcula ni se mezclan cientos de capas durante el juego. Fuente y receta: `tools/derived_roads88/bake_grass91.py`.

## Lazo tenso

La cuerda antes acababa en la posición de suelo del jinete más 12 unidades. Ahora utiliza exactamente la misma mano transformada que el vuelo: escala del sprite, desplazamiento y espejo. Se comparte el trazo de cuerda claro con borde oscuro, marcas de torsión y aro ovalado entre vuelo y estado tenso. El aro tenso se coloca en el cuerpo del animal; los indicadores de progreso existentes se conservan.

El componente compartido se usa en caballos y cerdos del mundo y toros de los niveles. No se cambian captura, distancias, progreso, fatiga, ruptura, stun ni movimiento. Para jinetes clásicos sin el método de mano del mundo se conserva el anclaje de vuelo clásico (8,-12).

## Encargos

Botón dorado opaco, borde cálido y texto oscuro más grande. Misma posición (16,56), mismo tamaño (180x42), misma acción y panel. Estados hover/pulsado/foco mantienen contraste. No se añade arte raster al botón.

## Rendimiento controlado

Mismo proceso, mundo congelado, semilla 752026, nueve chunks, cámara fija 1280x720, llvmpipe por software. Dos tandas de 120 muestras tras 25 fotogramas de calentamiento por condición, alternando anterior/caché/verde liso:

| Suelo | Draw calls mediana | Mediana ms, 1 / 2 | P95 ms, 1 / 2 |
|---|---:|---:|---:|
| Anterior por capas | 671 | 40,25 / 40,15 | 46,27 / 44,04 |
| Caché nuevo | 586 | 23,07 / 23,71 | 25,15 / 26,53 |
| Verde liso control | 582 | 23,48 / 23,64 | 26,19 / 26,89 |

85 llamadas menos en toda esta escena; el coste del suelo se aproxima al control liso en esta prueba. Son tiempos de render por software, no FPS Android ni garantía de fluidez en móvil. Fixture: `tools/profile_grass91.tscn`; referencia anterior aislada en `tools/legacy_grass91.gd`, no utilizada por el juego.

## Verificación

- 507/507 pruebas unitarias, 58.993 aserciones.
- 8/8 integraciones focales (floristería, descubrimiento, vallas y velocidad/lazo), 214 aserciones.
- Casos nuevos: mano del lazo tenso idéntica a la de vuelo con desplazamiento y espejo; continuidad de UV en chunks positivos y negativos; botón con misma posición/tamaño y habilitado.
- Capturas antes/después con mismo fixture, cámara, semilla, posiciones, animal sujeto y HUD. Se revisaron generales, ampliación y recorte de lazo. Los dos PNG originales permiten comparar a escala 1:1; el comparativo apila sin alterar la escala original de sus imágenes.
- Sin errores de script en las capturas. Las suites conservan avisos conocidos y recursos huérfanos.
- No probado en Android. Hace falta nuevo OK para generar otro APK.
