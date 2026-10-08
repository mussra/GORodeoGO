# PROJECT STATE

## Status
VERTICAL SLICE — código completo (20 niveles: 10 clásicos + 10 puzzle de recintos), versión 0.20.0. Arte y audio pendientes. Lógica comprobada en headless; jugabilidad y Android sin validar en dispositivo.

## Current phase
Bucle completo, victoria/derrota, HUD, reinicio/menú tras fin de partida, pausa, progresión persistente con niveles bloqueados, captura doble, obstáculos, corral con barrera, persecución (perseguidor único + secundaria probabilística, D021/D024/D030), modo puzzle con puertas enlazadas (niveles 11-20) y controles táctiles (VirtualJoystick nativo) implementados. Bloqueantes para un vertical slice real: arte y audio, y una pasada de validación en dispositivo.

## Verified in the working environment (v0.20.0)
- Godot 4.7.2 + GUT 9.7.1 headless: 184 tests (unitarios + integración sobre la escena real) pasando; menú y niveles de muestra arrancan sin errores de script.
- NO verificado: sensación de juego, doble stick multitáctil, pausa/botón atrás/segundo plano en Android, rendimiento, todo lo de "Pendiente de verificar".

## Completed
- Toolchain: Godot 4.7.2 + GDScript + GUT (D002, D006). Config de export Android en `export_presets.cfg` (arm64, APK).
- Domain: BullStateMachine, BullState (PURSUED reservado, D035), NervesValue, CaptureResolver, CaptureAttempt.
- Application: BlockedDetector, LassoAim, DoubleTapDetector, BullController, BullTuning, LevelData/LevelCatalog (20 niveles, `MAX_LEVEL`), PenLinkResolver, ChaserDirector, RandomChaseRoller, FleeSteering, PlayerUpgrades, LevelProgression, SaveData (validado, atómico, D033), GameState (`selected_level`).
- Presentation: Player, Bull (con `deactivate()`), Pen + PenBarrier, PenDoor, PenLinkOverlay (flechas), HUD (con panel de pausa), MainMenu (rejilla de 20 niveles, bloqueo D031), Level0 (solo cableado), SpriteSwap (arte con fallback a cajas de color).
- Modo puzzle (11-20, D022-D026): pens con puerta hold-to-open; enlaces maestra/encadenada/mutua con flecha rosa provisional.
- Toros: velocidad y color por nervios (D027/D028), sin solape entre toros salvajes (D029) pero toros sostenidos/entregados sin colisión con toros (D036), toros sobrantes de un nivel realmente inertes (D034).
- Geometría de niveles validada por tests (D034); obstáculos de niveles 7-10 y 15 corregidos.
- Persecución: ver D021 (parcialmente revisada), D030 y D036 (relevo aleatorio si el perseguidor se bloquea).
- Android: pausa automática, botón atrás, lazo no aterriza en pausa (D033).
- ART_PROMPTS.md: convención de carpetas/animaciones + prompts para IA generativa.

## Not started
- Arte real (carpetas vacías; todo corre sobre cajas de color), arte de valla y de fondo.
- Audio (música + SFX): las señales existen (state_changed, soltar lazo, devolver al corral, aturdimiento, rotura de cuerda); faltan AudioStreamPlayer y llamadas.
- Identidad de la app: `package/unique_name` sigue en `com.example.$genname`, sin iconos, sin firma de release (decisión del propietario: el id no puede cambiarse tras publicar).
- Pipeline de release firmado y CI.
- Adaptación completa a varias relaciones de aspecto en dispositivos reales.

## Pendiente de verificar en partida real
- Ver plan de pruebas manuales v27 a v30 (casos AE, AF, AG y AH) y los casos AC/AD de v25/v26 que siguen sin marcar: enlaces de puertas (niveles 15-20), nervios/color/sin solape, posiciones de puertas y tiempos límite de los niveles 11-20, ~50% de persecución en niveles 10-15.
- Los obstáculos movidos en v0.17.0 (niveles 7, 8, 9, 10, 15) cumplen los tests geométricos pero no se han visto jugando.
- `BIN/Rancho.apk` es anterior a v0.20.0: hay que re-exportar.

## Current priority
Re-exportar el APK de v0.20.0 y pasar el plan manual v27 a v30 en dispositivo; en paralelo, arte (ART_PROMPTS.md) y ganchos de audio. Decidir identidad de la app (package id, nombre, iconos) antes de cualquier distribución.

## Rule
This file must describe the actual repository state, not planned work as if it were completed.
