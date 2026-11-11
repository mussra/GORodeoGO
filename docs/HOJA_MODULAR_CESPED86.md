# Nueva hoja modular y césped: prueba aislada

Hoja aportada por Ant el 11 de noviembre. Original conservado sin cambios en `art/world/modular86/source/ant-road-sheet-20261111.png`. No hay arte nuevo generado. No modifica el mundo ni añade APK.

## Recorte directo

La hoja mide 2172×724 y ya tiene alfa fuera de las piezas. Dentro de cada cuadrado la hierba es opaca. Se separan sus seis piezas: recto, esquina, T, cruce, final y punto. El ejemplo enlaza 19 celdas y usa rotaciones de las seis piezas.

El montaje directo no es continuo: aparecen bordes cuadrados, pequeñas diferencias de centro y ancho, cambios de color y textura, además de las esquinas exteriores redondeadas.

## Ajuste por código, sin repintar originales

El script conserva los recortes directos y produce derivados:
- Recorta 12 píxeles interiores por cada lado para quitar esquinas exteriores y el fleco del corte.
- Remuestrea los extremos abiertos para un ancho y centro comunes, deformando suavemente los píxeles existentes hacia el interior.
- Iguala el perfil de textura en el borde usando muestras del recto.
- Desvanece la hierba exterior hacia la base para reducir los cuadrados.
- Recorta un parche de césped de la misma hoja y lo repite con espejo en ambos ejes como fondo.

Esto mejora las uniones, pero NO las hace invisibles. Quedan cambios de textura y algunas pequeñas irregularidades del contorno junto a ciertas curvas. El césped repite un patrón reconocible y franjas. El ajuste de geometría estira algo las hojas próximas al borde. Es un diagnóstico y una prueba de montaje, no un tileset final aprobado.

## Qué pedir a Ant para un resultado limpio

- Seis PNG de idéntico tamaño cuadrado y escala, por ejemplo 256×256, con borde exterior recto hasta el último píxel, sin margen ni esquinas exteriores redondeadas.
- Cada salida exactamente centrada en el lado, con el mismo ancho y perfil de borde en todas las piezas. Por ejemplo un camino de 96 píxeles centrado en el lado de 256, siempre de x=80 a x=176. Es una especificación propuesta, no una medida de la hoja recibida.
- Las franjas de los extremos que se van a unir deben ser copias exactas entre sí, incluida textura, iluminación y hojas. No basta con que se parezcan.
- Césped continuo separado, repetible en X e Y, sin bordes decorativos; idealmente unas pocas variantes compatibles para que no cante la repetición. Otra opción es caminos y bordes de hojas transparentes sobre ese césped separado.

Con ello se podría usar un único catálogo de conexiones para generar rutas extensas. Aún faltaría llevarlo al generador, resolver uniones entre zonas y comprobar accesos, elementos y distancias de camino. Esta prueba no cambia nada de eso.

## Reproducción

`python tools/modular_roads86/preview.py` (Pillow, NumPy, SciPy). Genera recortes, derivados y PNG de antes, ajustado y césped. Comprobación de conexiones/rotaciones en el script. Inspección visual de los tres PNG; no hay prueba Android.
