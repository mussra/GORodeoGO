# Pelajes animales y arcoíris suave

Propuesta visual aprobada por Ant el 15 noviembre 2026 a las 13:23. Nombres confirmados a las 13:24: nombre del animal.

## Documentación visual

- 01-patrones-natural.png: seis patrones nuevos en paletas naturales de ejemplo.
- 02-patrones-color.png: colores alternativos.
- 03-patrones-arcoiris.png: arcoíris suave.
- 04-colores-naturales-animal-real.png: nueve patrones animales con paletas naturales de ejemplo junto a fotografías reales; incluye los existentes Cebra, Jirafa y Vaca sin sustituirlos.
- atlas-1 a atlas-6: 441 combinaciones por patrón, 21 bases × 21 tintas, contando arcoíris suave en cada eje. La matriz es documentación de apariencia, no una tabla de probabilidades de aparición o precios. Conserva las parejas iguales, en las que el patrón no se distingue.
- FUENTES.md: fotografías, autores, licencias y cambios, fuera de la lámina.
- INSTINTO_PROPUESTA.md: diseño pendiente, no código de juego.

## Compatibilidad

Patrones 0..11 conservados. Nuevos 12..17: Leopardo, Guepardo, Tigre, Jaguar, Hiena, Cebra de montaña. Base y manchas guardan su ID plano anterior. Dos estilos opcionales (`coat_style238`, `spots_style238`) añaden arcoíris suave sin cambiar los IDs de color antiguos. Ausente equivale a plano.

La cría copia estilo y color de cada rasgo desde el progenitor elegido. No añade estadísticas ni modifica el mecanismo de selección de genes. El editor de prueba ofrece arcoíris suave como entrada adicional en Pelaje y Color de manchas. Los nombres de cada animal aparecen en Tipo de manchas.

Los sombreros anteriores v1/v2 y acabados 13/14 se conservan. Los nuevos patrones usan 20..25 dentro del formato de sombrero; v3 permite la base/tinta arcoíris. El armario sigue guardando el diseño para siempre una vez tenido el caballo, incluso tras venderlo.

Imágenes de propuesta y comparación no prueban Android físico ni aparición aleatoria de cada combinación. Las recetas de Instinto aún no existen: elegir una paleta natural no desbloquea habilidades en esta versión.

## Ajuste de paleta natural, 15 noviembre 2026, 16:32

Ant confirma que se refería al color de base: Guepardo y Tigre usan Crema, como Leopardo, manteniendo respectivamente puntos y rayas. Las láminas naturales se han regenerado. Es una selección de ejemplo, no una restricción de colores ni un cambio de caballos existentes. El APK 2.7.168 ya permite estas combinaciones; no requiere 2.7.169.

## Guepardo, 15 noviembre 2026, 19:37

Se precisa la máscara de Guepardo con puntos sólidos circulares simples sobre base Crema, sin anillos ni huecos. Se ajustan tamaño y circularidad para que se lean en la comparación. Solo cambia el segundo segmento del atlas compartido de máscaras; los otros cinco patrones permanecen iguales. Imagen cercana con el animal real en `guepardo-puntos-redondos-comparacion.png`. Cambio preparado en la rama y documentado, sin generar otro APK. El APK publicado 2.7.168 no incluye este ajuste posterior de circularidad/tamaño.

## Leopardo con relleno, 15 noviembre 2026, 19:50

A petición de Ant, rosetas más gruesas, irregulares y abiertas con centro cálido más oscuro. El canal rojo del primer segmento del atlas dibuja el borde y el verde el relleno. El relleno deriva de la base elegida (RGB × 0,76/0,61/0,48), conservando todas las bases y tintas, incluido arcoíris suave. Compartido por retrato, poses del mundo, potrillo y sombrero; no añade genes ni cambia IDs de guardados. Los otros cinco segmentos, incluido Guepardo redondo, se conservan byte por byte.

`leopardo-relleno-comparacion239.png` compara el retrato anterior Crema con el ajuste Dorado y el fotograma enviado por Ant. Dorado es solo un ejemplo para aproximar el vídeo, no sustituye automáticamente la base de caballos guardados ni fuerza una paleta. No se reproduce la textura de purpurina. Cambio local en rama, sin APK ni publicación. El APK 2.7.168 no incluye este ajuste.

## Paleta de bases, 15 noviembre 2026, 19:58

`paleta-pelajes239.png`: los 20 colores exactos de HorseAppearance.COLORS con los nombres de HorseCollection.COATS, más el degradado Arcoíris suave exportado del motor. `leopardo-varias-bases239.png`: seis retratos actuales del motor con el Leopardo relleno sobre Crema, Dorado, Blanco, Cobre, Azul y Arcoíris suave. La tinta es Negro en todos ellos. Son documentación visual; no generan otro APK.
