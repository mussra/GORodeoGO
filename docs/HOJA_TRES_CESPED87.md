# Segunda hoja: tres céspedes y seis caminos

Prueba aislada, rama de prueba, sin APK ni cambios al mundo. Original RGBA 1774×887 conservado sin cambios. Recortes y derivados separados en `art/world/modular87`. No hay ilustraciones nuevas.

## Anchos y centros

Ant tiene razón: no coinciden. Medición aproximada de tierra naranja en los extremos abiertos del recorte nativo, promediando cinco filas/columnas; umbral R>1,05G y R>1,4B para excluir hojas verdes. No es una medición manual de cada hoja. Los tamaños de los recortes tampoco son idénticos, por eso se incluye porcentaje del lado.

| Pieza | Tierra en salidas | Ancho relativo | Centro relativo |
| --- | --- | --- | --- |
| Recto | 109 px | 42,6% | 46,9-47,3% |
| Curva | 101-103 px | 39,0-39,5% | 41,4% y 70,1% |
| T | 90-93 px | 34,4-36,3% | 43,9-49,0% |
| Cruce | 88-94 px | 33,7-36,9% | 45,7-50,0% |
| Final | 104 px | 40,8% | 47,3% |
| Punto | 167×155 px internos | sin salidas | centro 126,132 px |

El recto es aproximadamente un cuarto más ancho que la salida estrecha del cruce, proporcionalmente al tamaño de sus piezas. La curva tiene además una salida muy desplazada. Tabla por extremo y dimensiones exactas en `MEASUREMENTS.txt`.

El código remuestrea los extremos abiertos a una banda común centrada del 32% al 68% del lado. Conserva el interior mediante deformación gradual, por lo que algunas hojas se estiran y aún quedan irregularidades de contorno. Iguala el perfil de textura del corte y elimina por alfa la mayor parte de la hierba opaca alrededor del camino, conservando tierra y hojas cercanas. Los originales no cambian.

## Césped

Las tres variantes originales NO tienen bordes coincidentes en X/Y. Diferencia RGB media entre el primer/último borde (escala 0-255), tras recorte y escala a 192×192:

| Variante | X | Y |
| --- | ---: | ---: |
| 1 | 7,20 | 12,18 |
| 2 | 7,27 | 14,84 |
| 3 | 9,31 | 11,40 |

Se usa un perfil común de bordes calculado de las tres texturas y se mezcla una franja de 28 píxeles. Después los bordes extremos coinciden exactamente en X/Y, tanto consigo mismos como entre variantes. El script comprueba la igualdad de píxeles.

Eso NO equivale a continuidad visual perfecta: aparecen franjas suavizadas en la cuadrícula y se reconocen hojas/repetición. Las tres imágenes son muy parecidas. La prueba de fondo solo permite ver ese defecto sin que lo tapen los caminos.

## Qué falta

Para un resultado limpio conviene una base de césped menos contrastada, con borde realmente pintado para repetirse, y variantes cuyas franjas exteriores sean copias de una plantilla común. Pedir caminos con tierra y hojas sobre fondo transparente, salidas copiadas exactamente de una plantilla con ancho y centro fijos; no basta con generarlos por separado diciendo que sean iguales. Comprobar un montaje 3×3 antes de entregar la hoja. Si solo se dispone de esta hoja, puede usarse el ajuste, aceptando sus bandas e irregularidades; no es un resultado final invisible.

Se inspeccionaron los PNG finales de antes, ajustado y césped. Grafo: 16 celdas, 14 conexiones, seis tipos, rotaciones verificadas. No se ejecutaron pruebas del juego porque el mundo no se modifica. Reproducción: `python tools/modular_roads87/preview.py` con Pillow, NumPy y SciPy.
