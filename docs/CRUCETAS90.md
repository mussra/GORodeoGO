# Crucetas y T en el mundo de prueba

Corregido sobre la integración de texturas anterior. Rama `feat/open-world-test-20261107`, sin APK y sin main.

## Lo que faltaba

La versión anterior seguía el recorrido con bandas y rellenaba el interior de las uniones con tierra. Tenía las texturas derivadas de cruz y T disponibles, pero no las dibujaba en el mundo. La observación de Ant era correcta.

## Uniones localizadas y corregidas

- Cruce de las dos vías principales: pieza cruz.
- Entrada del rancho desde la vía horizontal: pieza T orientada hacia arriba.
- Los dos accesos a casas, que salen a izquierda y derecha desde el mismo punto de la vía vertical: pieza cruz.
- Acceso a floristería hacia la derecha desde la vía vertical: pieza T orientada a la derecha.

Las piezas son las derivadas de la recta de Ant, no arte nuevo. Se utiliza su zona central para no superponer una baldosa cuadrada entera. Las bandas se recortan bajo cada unión con un pequeño solapado que evita huecos; cada pieza se orienta según la tangente local y ajusta sus bocas a los anchos de vía principal y acceso. No se añaden ramas donde no existen caminos. Los codos de los accesos siguen siendo bandas, no cruces.

Las dos uniones inferiores están separadas por 50 unidades: las zonas centrales recortadas caben sin pisarse. Cada pieza tiene un único chunk propietario. La selección se calcula desde las funciones originales del camino, no con coordenadas fijas del ejemplo.

## Comprobación

- 504/504 pruebas unitarias, 58.965 aserciones.
- Nuevos casos para las dos cruces y dos T, coincidencia con los accesos reales, solución del cruce principal en cuatro semillas, separación de piezas próximas y recortado de bandas.
- Capturas generales y ampliadas del mundo real, semilla 752026, misma cámara que el ejemplo anterior. Inspección visual: las cuatro uniones están conectadas, no queda hierba atravesando su interior y la puerta de la floristería sigue libre.
- No se cambian WorldMap, WorldPaths, colisiones, edificios, guardados ni césped. Persisten cambios de fase de textura en las uniones y codos angulosos pequeños. Sin prueba Android ni medición de rendimiento.
- La suite conserva avisos y recursos huérfanos preexistentes; no hubo errores de script en la captura.
