# Prueba cinematográfica del vaquero

24,17 s, 1280 × 720 a 24 fps. Cuatro planos con el jinete y caballo reales del juego, marcha lateral y frontal, travelling y zoom, transiciones breves, capa de primer plano tomada del pino existente, subtítulos y la misma narración provisional de la animática anterior. No hay música ni arte raster nuevo.

La escena congela el mundo para montar rutas deterministas y retira HUD, etiquetas y animales de prueba. Usa una partida aislada y no cambia la lógica del juego. El jinete animado se separa del nodo del jugador para evitar sus indicadores gráficos.

Limitaciones: animación montada, sin boca o brazos separados. No hay sincronía labial ni saludo articulado. Para interpretar al narrador a pie harían falta poses o piezas de cabeza/sombrero, torso, brazos y manos aportadas por Ant. Se mantienen los ojos ocultos.

Generación:

```sh
XDG_DATA_HOME=/tmp/cinematic85 godot --path . --rendering-method gl_compatibility res://tools/story_preview/cinematic85.tscn
python tools/story_preview/compose_cinematic85.py
```

El compositor espera la narración WAV original fuera del repositorio. Las rutas absolutas son las de la sesión de producción. Las imágenes intermedias y el MP4 no se guardan en git. Solo rama de prueba; sin APK.
