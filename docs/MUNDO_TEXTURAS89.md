# Mundo de prueba: caminos y tres céspedes

Preparación visual en `feat/open-world-test-20261107`. Sin APK y sin merge a main.

## Cambio

- Su recta se convierte en una banda continua sobre los caminos existentes. No se desplazan casas, decoraciones ni recorridos generados.
- Los accesos siguen sus puntos originales. Se redondean solo tramos con longitud suficiente; los pequeños codos siguen angulosos.
- Se mezclan las tres variantes superiores de la última hoja mediante selección determinista por coordenada global y semilla. Los bordes transparentes solapados evitan la cuadrícula de baldosas. No cambia al volver a cargar.
- Solo presentación. No se cambia WorldMap, WorldPaths, colisiones, código de guardado ni formato de partida. La captura utiliza un guardado aislado.

## Resultado y límites

En escala de juego se reconocen hojas repetidas: la mezcla reduce la cuadrícula, no elimina el motivo repetido. El césped es luminoso y tiene más detalle que el fondo verde anterior. Los pequeños empalmes de accesos aún muestran cambios de textura y codos angulosos. No se han aplicado las piezas cuadradas a la fuerza, porque encajaban mal con los accesos existentes.

Las dos capturas del mapa comparativo tienen la misma semilla 752026, posición y cámara, zoom 1. Las ampliaciones utilizan zoom 1,6. Las capturas se obtienen del mundo real de prueba, no de una ilustración.

## Comprobación

- 502/502 pruebas unitarias, 58.914 aserciones.
- 7/7 integraciones focales de floristería, vallas y descubrimiento, 194 aserciones.
- Inspección de capturas generales y ampliadas: caminos conectados, entrada de floristería libre, edificios y personajes conservados. Sin cuadrícula dura visible en los límites de chunks que cruzan el tramo capturado. No es una comprobación exhaustiva de todos los chunks.
- Importación y carga sin errores de script. Hay avisos y huérfanos preexistentes en las suites.
- No se ha medido rendimiento comparativo ni ejecutado en Android. El solapado del césped añade dibujado y necesita revisión en móvil antes de darlo por definitivo.

## Reproducir

`python tools/derived_roads88/prepare_world.py` extrae de las imágenes del usuario el suelo de la recta y las tres variantes de hierba. No genera arte nuevo. `tools/qa_world_texture89.tscn` captura el estado preparado. Para antes, usar el mismo fixture sobre la revisión anterior a esta integración. `TEXTURE_LABEL` solo controla el nombre de salida.

Reversión: revertir el commit de esta integración restaura la presentación anterior sin migrar partidas.
