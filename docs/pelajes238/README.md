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
