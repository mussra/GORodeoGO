# level_0.tscn — estado actual y cómo probar

`main_menu.tscn` es la escena principal. Elegir un nivel (1-20) fija `GameState.selected_level` y carga `level_0.tscn`. Es UNA sola escena para todos los niveles: `LevelCatalog.get_level(n)` define toros, obstáculos, puertas y tiempo; los obstáculos y puertas se crean por código al arrancar.

## Qué contiene la escena
- **Player**, **10 toros** (`Bull`..`Bull10`, posiciones de aparición fijas: son la única fuente de verdad, `test_level_geometry.gd` las lee), **Pen** + **PenBarrier**, **Fence** (4 muros físicos), **HUD** (contador, tiempo, 2 barras de nervios, tranquilizante, panel de fin de partida; el panel de pausa se crea por código) y **TouchControls** (2 `VirtualJoystick` nativos).
- Capas: jugador 1, toro 2, valla/obstáculos 4, barrera del corral 8, toro pasivo (sostenido o entregado) 16 (`CollisionLayers`, D036).
- Los toros que un nivel no usa se desactivan con `Bull.deactivate()` (ocultos, sin física y sin colisión).

## Controles
- **Táctil (principal):** mitad izquierda = joystick de movimiento; mitad derecha = joystick de apuntado. Ambos en modo `FOLLOWING` (la base sigue al dedo, D037). Apuntado: arrastrar apunta y fija la distancia, soltar lanza; soltar cerca del centro cancela el lanzamiento; doble toque rápido suelta el toro capturado más reciente (D038). Los obstáculos no bloquean el lazo.
- **Teclado (pruebas en escritorio):** flechas para moverse, Espacio para cargar/soltar el lazo. `emulate_touch_from_mouse=true` permite probar los joysticks con el ratón.
- **Android:** al pasar a segundo plano o pulsar atrás en un nivel se abre la pausa; atrás en el menú cierra la app.

## Victoria / derrota
Victoria: todos los toros en el corral antes de que acabe el tiempo. Derrota: el tiempo llega a 0. Ambas congelan el juego y muestran "Reiniciar partida" / "Menú principal".

## Arte (opcional)
Dejar PNG en `res://art/<entidad>/<animación>/frame_0.png...` según `ART_PROMPTS.md`; `SpriteSwap` los recoge solo. Sin arte, se ven las cajas de color.

## Tests
`runTests.bat` o `godot --headless -s addons/gut/gut_cmdln.gd -gdir=res://tests/unit,res://tests/integration -gexit` (requiere el addon GUT 9.7.1 en `addons/gut`, no incluido en el zip).
**Importante:** tras añadir o renombrar cualquier script con `class_name`, ejecutar antes `godot --headless --import` (o abrir el proyecto en el editor una vez); si no, la caché de clases globales queda desfasada y los tests fallan con "Nonexistent function ... in base 'CharacterBody2D'" y faltan scripts de test en el total. `runTests.bat` ya lo hace.

## Huecos conocidos
Arte de valla/fondo, audio, firma y release de Android, validación en dispositivo (ver PROJECT_STATE.md).
