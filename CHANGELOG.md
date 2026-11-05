# CHANGELOG — GO Rodeo GO

## v0.21.16 - Seguimiento por detrás
- El toro enlazado recorre el camino del vaquero con separación, incluidos giros y regates, en vez de copiar velocidad en paralelo. Sin teletransporte; la incorporación desde una captura por delante sigue siendo gradual.
- Misma firma y paquete que 0.21.15: instalar encima, sin desinstalar. Dos variantes de menú con idéntica lógica.
- 267 tests / 4062 aserciones pasan; preview real en Godot aprobado. Sin prueba en teléfono de esta corrección.
- Sin mapas ampliados ni cambios a IA libre o regla golpe-suelta.

## v0.21.15 - Prueba: regate libre y banjo
- Regate por dibujo libre: toque breve en movimiento, segundo toque mantenido para dibujar, soltar para recorrer. Recarga visible de 2,5 s; no hay invulnerabilidad. Forma libre, longitud limitada a 260 px, hasta 120 puntos; las vallas detienen el regate.
- Frenada final breve y suave (0,18 s), sin la larga deriva inicial. El movimiento normal recupera el control.
- Cascos/tierra y derrape sintetizados originales, con el mismo interruptor Sonido.
- Música banjo02 aprobada: bucles menú/partida, transición, continuidad entre niveles, pausa y silencio.
- Perseguidores salvajes anticipan movimiento y corrigen con retraso e inercia. Los enlazados mantienen seguimiento cercano.
- Capacidad del lazo bloquea lanzamientos sin hueco; doble toque de apuntado libera. Explicación animada del lazo doble y entrada progresiva Zumbel.
- Contacto sigue aturdiendo y soltando captura. Sin impulso20% de comida ni multijugador ni firma sonora Zumbel.
- 265 tests / 4049 aserciones pasan. Probado con Godot Linux y eventos táctiles simulados, no en teléfono real. Queda aviso de dos recursos de audio sin liberar al cerrar la suite, sin fallo durante partida.
- Dos menús con la misma lógica, mismo identificador y firma: se sustituyen entre sí. Cambio de firma respecto a 0.21.14: hay que desinstalar la anterior, perdiendo su progreso local, aceptado por Antonio el 4 de noviembre a las 21:31. Las futuras actualizaciones deben conservar la nueva firma guardada.

## v0.20.0 — "Lazo Sin Muros" (esta versión)
184 tests (unitarios + integración) en verde; el test del obstáculo se comprobó con una mutación (fallaba al restaurar el bloqueo). NO se ha probado con el dedo. Incluye todo lo de 0.17.0 a 0.19.0.
- Los obstáculos ya no bloquean el lazo: lanzar sobre un toro lo captura aunque haya algo en medio (D038, revoca esa parte de D012).
- Doble toque en el stick de apuntado suelta el toro capturado más recientemente; un toque sigue cancelando (D038).
- Un toro soltado a propósito no puede aturdir al jugador durante 1 s.

## v0.19.0 — "Dedo Suelto"
168 tests (unitarios + integración) en verde, 3 ejecuciones seguidas. NO se ha probado con el dedo en un dispositivo. Incluye todo lo de 0.17.0 y 0.18.0.
- Sticks de movimiento y apuntado en modo `FOLLOWING`: la base sigue al dedo, ya no hay que volver desde lejos para cambiar de dirección o acortar el lanzamiento (D037).
- Soltar el stick de apuntado cerca del centro (o un toque sin arrastrar) cancela el lanzamiento en vez de lanzar el lazo a tus pies (`LassoAim`, D037).
- Corregido: las líneas del lazo se colgaban de `current_scene` (null si el nivel va dentro de otro árbol); ahora del nodo padre del jugador.

## v0.18.0 — "Hueco en el Corral"
Mismo entorno de comprobación que 0.17.0: 158 tests (unitarios + integración) en verde, ejecutados 3 veces seguidas. NO se ha jugado en dispositivo. Incluye todo lo de 0.17.0.
- Corregido: los toros entregados ocupaban sitio sólido en el corral y en el nivel 20 no cabían los 10. Los toros sostenidos y los ya entregados ya no colisionan con otros toros (capa `BULL_PASSIVE`, D036).
- Nuevo: si el perseguidor designado se queda bloqueado (>1s sin avanzar), el rol pasa al instante a otro toro salvaje aleatorio (`BlockedDetector` + `ChaserDirector.hand_over_randomly`, D036).
- `runTests.bat` ejecuta `--import` antes de los tests (sin ello, una clase nueva como `BlockedDetector` no está registrada y los tests de integración fallan con "Nonexistent function 'deactivate'").
- Tests de integración del perseguidor hechos deterministas (simulan el tiempo en vez de esperar frames).

## v0.17.0 — "Orden en el Rancho"
Primera versión comprobada con Godot 4.7.2 + GUT 9.7.1 en headless: 138 tests (unitarios + integración) en verde y menú/niveles arrancando sin errores. NO se ha jugado en dispositivo.
- Corregido: los toros que un nivel no usa seguían siendo muros invisibles tras D029; ahora se desactivan de verdad (D034).
- Corregido: obstáculos de los niveles 7, 8, 9, 10 y 15 que tapaban el spawn del jugador, el corral o un toro; nuevo test de geometría para todos los niveles (D034).
- Corregido: `test_save_data.gd` no se ejecutaba por un error de parseo real (la hipótesis de D020 era errónea); ahora corre.
- Niveles bloqueados hasta completar el anterior; en builds de depuración están todos abiertos (D031).
- Android: pausa automática al ir a segundo plano, panel de pausa, botón atrás (pausa en nivel / salir en menú), el lazo no aterriza en pausa (D033).
- Guardado validado (tipo/rango), atómico y versionado (D033).
- Lógica extraída a Application con tests: `ChaserDirector`, `RandomChaseRoller`, `FleeSteering`, `PlayerUpgrades`, `LevelProgression` (D032). Sin cambios de comportamiento esperados salvo lo anotado arriba.
- Documentación: D021 marcada como parcialmente revisada y nueva D030 (persecución probabilística recuperada); versión unificada (`project.godot` 0.17.0); docs del Project actualizados de C# a GDScript.
- Eliminado código muerto: `LevelConfig` (+ su test), `BullTuning.aggression_chance`, `BullController.go_pursued()` (D035). `GameState.selected_bull_count` -> `selected_level`.
- `.gitignore`: BIN/, *.apk, *.idsig, *.aab.

## v0.16.0 — "Nervios a la Vista" (PENDIENTE DE VALIDAR)
- Un toro huye más despacio cuanto menos nervioso estaba al soltarse (D027) — a nervios máximos, la velocidad es la misma de siempre.
- El color de los toros ahora es un degradado continuo según sus nervios (verde=calmado, naranja=agitado), no colores fijos por estado (D028). Se actualiza en tiempo real, no solo al cambiar de estado.
- Dos toros ya nunca pueden solaparse entre sí, en ningún estado (D029).

## v0.15.0 — "Puertas por Toda la Granja" (PENDIENTE DE VALIDAR)
- Niveles 12-14: se revierten los enlaces de puertas añadidos en v0.14.0 — vuelven a no tener ninguno (D026).
- Nivel 15 rediseñado: 4 puertas cerca de las esquinas, una relación unidireccional entre dos de ellas.
- Niveles nuevos 16-20: 4, 5, 6, 6 y 8 puertas respectivamente, con enlaces maestro/encadenado/mutuo variados (D026). Menú ampliado a 20 niveles.
- La línea rosa de enlace ahora es una flecha, para mostrar la dirección de cada enlace — una pareja mutua (nivel 18+) se ve como dos flechas opuestas.

## v0.14.0 — "Puertas Maestras" (PENDIENTE DE VALIDAR)
- Enlaces entre puertas en niveles con varios recintos: puerta maestra (abre todas), puerta encadenada (abre además otra concreta) y puerta normal (solo la suya). Ver DECISIONS.md D025.
- Niveles 12-15 actualizados: 12 y 13 con una maestra; 14 y 15 con una puerta de cada tipo, dispuestas de forma distinta.
- Línea rosa de validación desde cada puerta enlazada hacia las puertas que abrirá; desaparece al abrirse cualquiera de los dos extremos. Provisional hasta el arte del vertical slice.
- Lógica nueva y testeada aparte (`PenLinkResolver`); los enlaces no son en cascada.

## v0.13.0 — "Persecución Compartida" (PENDIENTE DE VALIDAR)
- El perseguidor designado (pilla-pilla, v0.10.0) tarda ahora 1s en engancharse tras una captura, en vez de al instante.
- Nuevo: el resto de toros salvajes reevalúan cada 5s si también persiguen al jugador, con probabilidad 5%-50% según el nivel (`LevelData.chase_probability`, rampa `nivel × 5%`) — ver DECISIONS.md D024 (revisa y corrige la descripción de D021).
- Corrección sobre la primera versión de este cambio: la persecución secundaria solo se activa mientras el jugador tiene al menos un toro capturado — sin captura activa, todos huyen, sin excepción, igual que el perseguidor designado.
- Corrección: el techo de probabilidad se bajó de 100% a 50% — en los niveles más difíciles ronda la mitad de los toros salvajes persiguiendo, no todos.

## v0.12.0 — "El Rancho Completo" (PENDIENTE DE VALIDAR)
- Niveles 12-15: rampa de 2 a 3 puertas, de 5 a 10 toros. Nivel 15 usa los 10 toros existentes repartidos en 3 recintos + obstáculos.
- Menú ampliado de 10 a 15 niveles.

## v0.11.0 — "Recintos y Decisión" (PENDIENTE DE VALIDAR)
- Modo puzzle de recintos: toros agrupados en pens cerrados con puerta (`PenDoor`) que se abre quedándose quieto junto a ella (hold-to-open, 1.2s).
- Nivel 11: primer nivel puzzle — 1 pen, 3 toros, introduce la mecánica sin decisión de orden todavía.
- `LevelData.pens`: mismo estilo plano que `obstacle_rects`, sin clase `Resource` nueva. Nivel 10 sin cambios.

## v0.10.0 — "Pilla-Pilla"
- Sustituido el sistema de agresividad probabilística (cada toro tirando su propia moneda cada 1.5s — en la práctica el 100% de los toros sueltos perseguían siempre, de forma simultánea y determinista, no una fracción variable) por un único "perseguidor" designado — exactamente un toro te persigue sin parar mientras lleves algo capturado, nunca más, nunca menos. Se mantiene el mismo perseguidor hasta que deja de estar suelto (lo capturas, etc.), momento en que el toro salvaje más cercano toma el relevo.
- Quitado `BullTuning.aggression_chance`, ya sin uso.

## v0.9.5 — "Nada de Secretos" (pendiente de confirmar)
- El aviso de GUT en `test_save_data.gd` seguía siendo un error de parseo real, no algo cosmético. Hipótesis principal: llamar a un método "privado" por convención (con guion bajo, `_is_new_record`) desde fuera de su clase, algo que GUT trata más estrictamente que un `load()` normal. Renombrado a público (`is_new_record`), sin guion bajo. Sin certeza absoluta — pendiente de confirmación real.

## v0.9.4 — "Menú Sin Scroll" (pendiente de confirmar)
- Menú rediseñado: rejilla de 5×2 que muestra los 10 niveles sin necesidad de scroll — evita el problema de que arrastrar sobre un botón nunca se detectaba como gesto de scroll. Botón "Salir" movido a la esquina superior derecha, convención habitual en este tipo de juegos. Sigue siendo un layout funcional, sin arte — el rediseño visual profesional queda para más adelante.
- `SaveData.record_level_completed` separado en una comprobación pura (`_is_new_record`) sin efectos secundarios — el test correspondiente escribía sin querer en tu archivo de guardado real cada vez que corrías la suite. Posible causa (no confirmada del todo) del aviso "does not extend GutTest" que reportaste.

## v0.9.3 — "El Dedo Izquierdo No Lanza Lazos" (pendiente de confirmar)
- v0.9.2 quedó confirmada como validada — gracias por la aclaración.
- Bug real encontrado: el clic izquierdo del ratón estaba vinculado globalmente a la acción `throw_lasso`, sin restricción de zona de pantalla. Con la emulación táctil, tocar la mitad IZQUIERDA (pensada solo para mover) también disparaba un lanzamiento de lazo. Quitado ese vínculo — `throw_lasso` ahora solo responde a Espacio (teclado) o al joystick de apuntado (táctil/ratón dentro de su propia zona).
- Segunda defensa: `emulate_mouse_from_touch=false` — un toque real en móvil ya no genera un clic de ratón sintético que pueda disparar acciones globales por su cuenta.
- Reactivado un diagnóstico ligero (solo en fallos, solo en builds de depuración) para seguir investigando la precisión del lazo — sigue reportada como inconsistente, y es posible que el bug del clic izquierdo explicara parte de esos casos.

## v0.9.2 — "Limpieza de Casa" (validada)
- Quitado el `print` de depuración temporal que llevaba 7 versiones sin retirarse.
- `BullController.is_held()`/`is_wild()` centralizan una comprobación de estado que estaba duplicada a mano en 3 sitios distintos (`level_0.gd`, `bull.gd` ×2).
- `CollisionLayers`: constantes con nombre para las capas de colisión (antes literales sueltos 1/2/4/8) en el código que las usa en tiempo de ejecución. Las escenas `.tscn` siguen con números literales — es una limitación del formato de Godot, no algo que se pueda evitar.
- +5 tests nuevos para `is_held()`/`is_wild()`. Sin cambios de jugabilidad — es refactorización pura.

## v0.9.1 — "Contrarreloj Justa" (PENDIENTE DE VALIDAR)
- Captura doble ahora se desbloquea en el Nivel 5 (antes Nivel 10).
- Tiempo límite por nivel, en vez de un único valor fijo de 150s para todos — de 80s (Nivel 1) a 300s (Nivel 10). Estimado, no cronometrado en partida real.

## v0.9.0 — "El Corral Es Sagrado" (PENDIENTE DE VALIDAR)
- Los toros salvajes ya NO pueden entrar ni atravesar la zona del corral (barrera física nueva, capa de colisión propia) — corrige que te robaran el toro tranquilo por detrás.
- IA de huida corregida: el margen de evasión de bordes era demasiado ancho (70) y demasiado dominante (peso ×1.5) — nunca dejaba acorralar a un toro contra el perímetro. Reducido a margen 30 / peso ×0.8, y la zona del corral entra en la misma evasión mientras el toro está suelto.

## v0.8.0 — "El Rancho Tiene Obstáculos" (PENDIENTE DE VALIDAR)
- Arquitectura de niveles rediseñada: `LevelCatalog`/`LevelData` sustituyen al `LevelConfig` plano — cada nivel (1-10) tiene ahora su propio diseño, no solo su número de toros.
- Obstáculos por nivel: bloquean físicamente el movimiento (jugador y toros). (Bloquearon también el lazo hasta v0.19.0; revocado en D038.)
- IA de huida evita obstáculos, mismo patrón que ya usaba para no quedarse pegada a la valla exterior.
- **Sin validar** — generada sin haber podido probar v0.7.0.

## v0.7.0 — "El Lazo Doble" (PENDIENTE DE VALIDAR)
- Captura doble simultánea desbloqueada al completar el Nivel 10.
- Penalización de velocidad del jugador mientras remolca 2 toros a la vez.
- HUD con dos barras de nervios independientes (una por toro sostenido).
- Tranquilizante ahora afecta a los dos toros capturados a la vez, no solo al primero.

## v0.6.0 — "Progresión Persistente"
- Sistema de guardado persistente (`SaveData`, `user://save.dat`).
- Mejoras desbloqueables permanentemente por nivel completado: velocidad del caballo (Nivel 2), resistencia a aturdimiento (Nivel 4), tiempo de vuelo del lazo (Nivel 6), alcance de lanzamiento (Nivel 8).
- Objeto tranquilizante: calma instantánea, 1 uso por partida, se repone automáticamente si está desbloqueado (Nivel 1).

## v0.21.0 - rama de revisión, no main
Ver `REVIEW.md`: controles de teclado/pausa, entrega del toro calmado dentro del corral, fin de puertas, 60 frames de animación integrados, arena/HUD y feedback. 200 tests pasando en Godot 4.7.2. Android no probado en dispositivo.

## v0.21.1 - revisión incremental, no main
- Reposo comienza de verdad; test temporal de frame.
- Campaña completa comprobada en 20 niveles con posiciones deterministas.
- Controles protegidos frente a aturdimiento y sueltas obsoletas tras pausa.
- Puertas y toros numerados, maestra 1M, enlaces detrás de personajes.
- Mute conservado en la sesión y registro alpha de reposo corregido.
- 210 tests, 3094 aserciones pasan. Pruebas en Linux, no en dispositivo Android.

## v0.21.2 - pausa táctil y persistencia
Reset de acciones nativas al pausar con dedos apoyados; harness multitáctil sintético de Godot real. Regresiones de guardado en rutas aisladas. 214 tests/3106 aserciones. No probado en teléfono.

## v0.21.3 - pausa y panel final
Esc reanuda con HUD always-processing. Cancelación del lazo en vuelo al terminar. Tranquilizante bloqueado en pausa. Toques sintéticos de botones de pausa/derrota/victoria verificados en viewport real. 217 tests/3115 aserciones.

## v0.21.4 - guía de captura y cierre coherente
R para liberar en teclado, ayuda contextual por estado, controles de juego ocultos al finalizar. Victoria real con contador/estado reconciliados. Regresión lazo/pausa. 221tests/3132aserciones. PCM sin clipping comprobado, audio no evaluado por oído humano.

## 0.21.5
- Bloqueo de entregas tardías tras derrota; regresión física.
- Pruebas de remolque, apertura física y conectividad de20niveles.
- versionCode215 y preset Android Review para Rancho Prueba separado del original, sin migrar progreso.

## 0.21.6
- Prototipo funcional de abrevadero/heno para distraer perseguidores3s, cooldown y feedback.
- Pruebas motor de parada física/captura sin stun; versionCode216.

## 0.21.7
- Prototipo de recintos físicos cerrados para11-20, puerta70px con apertura maestra/cadena.
- Nuevo layout/spawns para puzzle, sustituye cajas anteriores;1-10 sin cambios.
- Meta diferenciada, cierres exteriores pequeños y dependencias visibles despejando el destino.
- versionCode217, misma identidad/firma de Rancho Prueba.

## 0.21.8
- Corrige atasco de salida AI inicial de corrales con gate120px, guía y escalonado.
- Mantiene colisiones/posiciones físicas, captura cancela guía. Regresión liberación11/13/20.
- versionCode218, misma firma/identidad.

## 0.21.9
- Conserva fase de marcha al girar; cadencia según velocidad física, reposo normal.
- ProfundidadY al cruzarse toro/caballo; mismos72frames, sin promesa3D.
- versionCode219, misma identidad/firma.

## 0.21.10
- Toro distraído no agita al capturado cercano; recupera efecto al terminar.
- Regresiones de pausa/fin/distracción y captura/espera de salida.
- versionCode220, misma identidad/firma.

## 0.21.11
-6poses nuevas cabeza toro para beber/comer,10framesping-pong, volumen pintado.
-6poses renovadas diagonalabajo caballo/vaquero, misma identidad.
- Otrosángulosno renovados, sinmodelos3D;code221.

## 0.21.12
- Acercamiento físico corto para alinear gesto de beber/comer con objeto, sinteleport.
- Captura tardía de revisión y regresión del punto de parada;code222.

## 0.21.13
-6poses trote diagonalabajo toro con volumen pintado, conservando identidad.
- Registro máximo opcional de sheets para gestos de altura variable.
- code223; sinmodelos3D, otrosángulosprevios.

## 0.21.14 - two separate animated menu alternatives
- Futurist lobby: staggered lateral button entrance, ranch horizon, animated rings/grid/particles, existing animated rider and bull, separate 20-level drawer.
- Cartoon lobby: new high-resolution 2D rider illustration with stylized 3D volume, central podium, margin controls, thick rounded outlines and relief, yellow action button and scale/back-eased entrance. This is not an articulated 3D model or a new pose cycle.
- Separate scenes preserved; default remains futurist. Return from a level remembers the menu used for this process only. Gameplay/save progression unchanged.
- 243 tests / 3950 assertions pass. Actual engine movies and functional menu > level 11 > matching menu checks for both variants. No on-device Android or tactile/performance claim.
- Both APK alternatives share com.example.rancho.review and signing identity, versionCode224: installing one replaces the other, not side-by-side. Do not uninstall or clear data to switch. Android normally preserves this app's data for a same-signature update; backup is still advisable. Main unchanged.

## Review candidate - 2026-11-04 (not an APK release)
- Keep captured bulls close while matching rider movement, with catch-up speed outside the leash.
- Refuse throws when all capture slots are occupied; double-tap release frees the latest capture.
- One-time animated dual-lasso unlock explanation, paused while reading, persisted compatibly.
- Progressive Zumbel reveal before both menu variants, plus staggered animal entrance. No new audio approved or included.
- Rider contact still stuns and drops captures, explicitly retained by Antonio on 4 November.
- Verified existing next-level/menu navigation, including final level without level 21.

## 0.21.23 - Level20 grouped herd and destination corral
- Level20: ten bulls grouped4/3/3 in three corrals instead of eight small pockets. Same timer/map size/count.
- Couriers and exiting bulls no longer consume designated pursuit role. Courier visits other latches while free companions can chase captures.
- Destination corral gets ranch wood/gold horseshoe styling, unchanged80x80delivery physics.
- Directed live-herd and courier tests plus preview. Levels11-19balance remains a separate pass; no main merge.

## 0.21.24 - Grouped herd progression15-19
-15one-way4/6;16fork4/3/3;17reciprocal5/5;18linkedpair+independent4/3/3;19master4/3/3mirrored.
- Same total10bulls and clocks.11-14unchanged after physical goal/latch accessibility repro;20keeps0.21.23.
- Live-herd input/capture/evasion/calming/delivery checks, no frozen pursuers or forced nerves. First-bull delivery is not complete human balance certification.
- Full309tests302pass7fail; clock/input tests covered real-window; existing11-14proximity warnings documented. No main merge.

##0.21.25 - Sequence puzzle and persistent opener
-Level20:2/3/5with small→large consequence, same10bulls/450s; expandedmapshowscountsandlinks.
-Capture pauses opener task; release resumes physical route from actual position. Manual opening/secure delivery retire it.
-Released wild bulls keep partial calm but ordinary full speed, no nerve reset/global speed increase.
-15-19preserved. Logo proposal not included while awaiting aesthetic feedback. No main merge.

## 0.21.26 - Selected flat Zumbel splash
- Uses the second supplied Zumbel logo with its full text, selected on 2026-11-05.
- Original source retained in brand/zumbel_source.png. Only empty background edges feathered for the splash; artwork and words unchanged.
- Boot image scaled to fit landscape; reveal hold extended to 1.8 seconds for subtitle reading.
- Gameplay, campaign and controls unchanged from 0.21.25. No main merge.

## Source update after 0.21.26 - Shared splash asset (next build)
- Uses common 1080 square splash supplied for all four games, full text intact, with #041940 background.
- Landscape layout keeps subtitle readable. Gameplay unchanged.

## 0.21.27 - Stable offscreen indicators
- Per-target visibility hysteresis and dwell prevent rapid boundary flicker.
- Tests cover exact thresholds, epsilon offsets, corners and 30/60/120 FPS.
- Controlled visual repro: ±1.5 px border oscillation, old rule toggles rapidly, fixed rule stays stable.
- Includes shared square splash normalization already committed to main. No gameplay motion/speed changes.

## 0.21.28 - Cowboy gallop trial
- Uses the approved lateral painted rig with moderately longer leg chains.
- Twelve phases in all five base movement views, mirrored to eight directions.
- Frontal/rear/diagonal motion is a perspective interpretation of the lateral guide, not an exact multi-view reference.
- Existing game rules, bull art, stun animation, phase-preserving steering and speed scaling unchanged.
- Five focused asset/transition tests, 231 assertions. Scripted desktop visual review, not Android device validation.
