# Seis piezas derivadas de una única recta de Ant

Se elige la recta horizontal de la PRIMERA hoja del 11 de noviembre (`modular86/source/ant-road-sheet-20261111.png`), por ser más ancha en resolución y no llevar las hojas grandes del césped de la segunda. No se utiliza ninguna curva/T/cruce/final de las otras piezas.

El recorte utilizado se conserva como `art/world/derived88/straight-source.png`. El script remuestrea únicamente sus píxeles para producir recta, curva de cuarto de círculo, T, cruce, final redondo y punto. Todo queda en fondo transparente.

## Cómo se construye

Una distancia a ejes rectos y arcos define el mismo ancho en todas las piezas. De la recta original se toma un perfil de tierra y borde de hojas; se remuestrea ese perfil a lo largo de las formas. Las intersecciones son uniones geométricas de esos ejes, no superposiciones de cuadrados con hierba. Las puntas y el punto usan el mismo radio. La textura longitudinal se espeja para poder repetirse.

Cada tile mide 192×192; la tierra tiene 72px de ancho y centro 95,5px en los extremos abiertos, comprobado en los 12 puertos de las cinco piezas con salida. El punto no tiene salidas. El borde de hojas rodea esa banda; el alfa cae gradualmente hacia fuera. No se genera ilustración nueva, se deforman y repiten los píxeles de Ant. Los originales no cambian.

## Resultado visual

El montaje de 16 celdas muestra las seis piezas con rotaciones, curvas, bifurcación y cruce. La geometría ya conecta sin saltos de ancho ni cuadrados verdes alrededor. Aun se aprecia un cambio de dirección y fase del grano de la tierra en algunas uniones, y las hojas quedan estiradas/diagonales al remuestrear el borde. Por eso no se presenta como arte final de uniones totalmente invisibles. Es más consistente geométricamente que las hojas de piezas generadas por separado.

Para mejorar el acabado sin rehacer todas las piezas basta aportar una recta con textura de tierra más uniforme y repetible longitudinalmente, y un borde de hojas menos direccional, o una tira de tierra y otra de borde separadas. Con la recta actual se puede seguir, aceptando ese efecto visual.

Inspección visual del PNG final. No se toca el mundo, colisiones, guardado o generador; sin APK ni main. Script: `python tools/derived_roads88/preview.py` (Pillow, NumPy, SciPy).
