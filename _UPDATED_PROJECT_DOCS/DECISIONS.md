# DECISIONS

Record important technical decisions here.

## D001 — Engine
Decision: Godot 4.x.
Reason: suitable for a small 2D Android project with rapid iteration and AI-assisted development.

## D002 — Language
Decision: GDScript (superseded; was C#).
Reason: C# via Godot.NET.Sdk required MSBuild/NuGet/.NET SDK-runtime matching as a second toolchain layer on top of Godot itself, causing repeated cross-machine build friction (SDK/runtime version mismatches, restore issues when referencing Godot.NET.Sdk projects from plain test projects) before any gameplay code existed. GDScript is the engine's native path: no external toolchain, simpler Android export (no .NET export templates), fewer version-compatibility failure points for solo AI-first iteration. GDScript 4.x supports static typing, covering most of the original strong-typing rationale.
Consequences: CONVENTIONS.md C# section replaced with GDScript conventions. Domain layer (BullStateMachine, NervesValue, CaptureResolver) rewritten in GDScript as plain RefCounted classes with no Godot node dependencies, preserving the ARCHITECTURE.md dependency rule. Testing moved from xUnit to GUT (Godot Unit Testing addon), run via `godot --headless -s addons/gut/gut_cmdln.gd`.
Alternatives considered: keep C#, pin exact SDK/runtime versions in a global.json/README to reduce friction. Rejected for MVP stage — adds process overhead disproportionate to project size; can be revisited post-MVP if performance or tooling needs change.

## D003 — Rendering
Decision: 2D top-down.
Reason: lower production complexity and faster prototyping than 3D for the current concept.

## D004 — Multiplayer
Decision: excluded from MVP.
Reason: unnecessary complexity before core gameplay is validated.

## D005 — AI-first
Decision: AI is the primary production assistant for code, assets, documentation and testing.
Reason: maximise iteration speed while enforcing strict validation and architectural contracts.

## D006 — Testing framework
Decision: GUT (Godot Unit Testing addon) for GDScript unit/integration tests.
Reason: runs inside Godot's own script runtime, no external test host/runtime matching required; supports headless CLI execution for reproducible validation.

## D007 — Preferir clases nativas del motor sobre implementación propia
Decisión: antes de implementar cualquier componente propio (especialmente UI/input), comprobar primero si la versión exacta del motor en uso (Godot 4.7.2 en este proyecto) ya incluye una clase nativa equivalente.
Razón: motivado por colisiones de nombre reales en este proyecto (`VirtualJoystick` nativo de Godot 4.7 chocando con un nombre de clase custom). Además de evitar colisiones, una clase nativa ya está probada por el equipo del motor contra casos reales (ej. multitouch), algo que una implementación propia no puede garantizarse sin dispositivo de prueba real.
Ejemplo aplicado: `VirtualJoystick` nativo (Godot 4.7) sustituyó por completo una implementación propia de joystick táctil — cubre modo fijo/flotante (`joystick_mode`), y alimenta acciones de Input estándar (`action_left/right/up/down`) leíbles con `Input.get_vector()`, igual que teclado.
Consecuencia práctica: al añadir cualquier componente de UI/input/utilidad genérica, buscar primero en la documentación de la versión exacta del motor antes de escribir código propio.

## D008 — Nombre de archivo debe coincidir con la clase que contiene
Decisión: cuando un script declara `class_name`, el nombre del archivo (en snake_case) debe corresponder exactamente al nombre de la clase (en PascalCase). Ejemplo: `class_name BullController` → `bull_controller.gd`.
Razón: evita la confusión de tener un archivo con nombre distinto al tipo que representa; ya ocurrió con `virtual_joystick.gd` conteniendo `class_name TouchJoystick` tras un renombrado por colisión, sin corregir el archivo en su momento.
Consecuencia: si una clase se renombra (por ejemplo, por una colisión con el motor — ver D007), el archivo debe renombrarse en el mismo cambio. No aplica a scripts sin `class_name` (los scripts adjuntos a nodos de escena como `player.gd`, `bull.gd`, `level_0.gd` se nombran por el nodo/rol que representan, no por una clase global).

## D009 — Progresión del jugador: persistente y sin economía
Decisión: las mejoras del jugador (velocidad del caballo, resistencia a aturdimiento, tiempo de vuelo del lazo, alcance, objeto tranquilizante) se desbloquean de forma permanente al completar un nivel por primera vez, guardado en disco (`SaveData`, `user://save.dat`). Un único valor (`highest_level_completed`) determina qué está desbloqueado — sin moneda, sin tienda, sin elección del jugador.
Razón: PROJECT_SPEC.md excluye explícitamente una economía compleja del MVP; el objetivo declarado es diversión y destreza ojo-mano-dedo, no monetización. Un desbloqueo lineal por progreso es la implementación más simple que aún cumple "persistente".
Consecuencia narrativa: el tamaño del corral y otros elementos de nivel NO son mejoras del jugador — pertenecen al diseño del rancho/nivel, no al equipo del vaquero contratado. Las mejoras que sí aplican son las que un profesional llevaría consigo (caballo, lazo, herramientas), no cambios al escenario.
Pendiente: captura doble simultánea (recompensa de Nivel 5, ajustado desde Nivel 10 — ver D015) — deliberadamente no implementada todavía; requiere relajar la regla de "un solo lazo" y rediseñar el HUD de nervios (hoy solo muestra un toro), coste mayor que el resto de mejoras.

## D010 — Captura doble implementada sin validación previa de D009
Decisión: se implementó la captura doble (Nivel 10) sin haber podido probar primero la v0.6.0 (progresión/tranquilizante), a petición explícita del usuario ("no quiero bloquear").
Riesgo aceptado: si D009 tiene bugs no detectados, esta versión los hereda y los combina con los propios de la captura doble — el diagnóstico de un fallo puede requerir aislar cuál de las dos capas lo causa.
Cambios: HUD con dos barras de nervios independientes (slots 0/1); `Player.dual_capture_speed_multiplier` penaliza la velocidad mientras se remolcan 2 toros; `_on_lasso_thrown` ahora compara contra `_max_simultaneous_captures` en vez de un booleano.
Nota de diseño no resuelta: un toro salvaje que te toca libera TODOS los toros que llevas (no solo uno), incluso con captura doble — comportamiento heredado sin cambios, no confirmado como el deseado para este caso.

## D011 — Tranquilizante afecta a todos los toros capturados a la vez
Decisión: con captura doble activa, el tranquilizante calma instantáneamente a TODOS los toros en `CAPTURED`/`CALMING` en el momento de usarlo (antes solo afectaba al primero que encontraba). Sigue siendo un único uso por partida, independientemente de a cuántos toros afecte.
Razón: pedido explícito — coherente con que sea un recurso valioso de un solo uso, más útil cuanto más lo necesitas (con captura doble activa).

## D012 — Niveles con diseño propio: LevelCatalog sustituye a LevelConfig
Decisión: se elimina `LevelConfig` (un único recurso plano compartido por todos los niveles) y se sustituye por `LevelData` + `LevelCatalog` — un catálogo estático que define, por número de nivel, el conteo de toros Y el diseño de obstáculos. Sigue siendo una sola escena (`level_0.tscn`), no 10 escenas separadas — los obstáculos se generan en tiempo de ejecución como nodos `StaticBody2D` a partir de los datos del catálogo.
Razón: pedido explícito de romper con "un único nivel al que solo le añadimos toros". Generar obstáculos por código desde datos, en vez de 10 escenas hechas a mano, evita 10x el riesgo de autoría manual de `.tscn` y mantiene una sola fuente de verdad (ARCHITECTURE.md).
Mecanismo: los obstáculos reutilizan la MISMA capa de colisión que la valla perimetral (capa 4) — sólidos para jugador y toro, invisibles para la detección del corral. [REVOCADO por D038: los obstáculos YA NO bloquean el lazo.] Bloquean también el lazo: un raycast entre el origen del lanzamiento y el punto de caída debe estar despejado, o el lanzamiento falla automáticamente — así esconderse detrás de un obstáculo protege de verdad a un toro, no es solo un obstáculo de movimiento.
Alcance NO cubierto todavía: los toros no buscan activamente refugiarse tras un obstáculo (solo lo EVITAN al huir, mismo patrón que ya usaban con la valla exterior) — no hay IA de "ocultación" propiamente dicha. Las posiciones de aparición de los toros siguen siendo fijas, no varían por nivel todavía, solo los obstáculos.
Riesgo aceptado: colocación de obstáculos sin verificación visual — calculada para evitar los puntos de spawn conocidos y las zonas de jugador/corral con margen, pero no confirmada sobre el juego en ejecución.

## D013 — Barrera física del corral para toros salvajes
Decisión: el corral (`Pen`) gana una barrera física nueva (`PenBarrier`, `StaticBody2D`, capa de colisión 8) que bloquea únicamente a toros en estado "salvaje" (no `CAPTURED`/`CALMING`/`CONTROLLED`/`SAFE`). El jugador y un toro ya sostenido nunca tienen esa capa en su máscara, así que entran sin problema.
Razón: bug real reportado — un toro salvaje podía atravesar la zona del corral y tocar al jugador mientras este intentaba depositar un toro ya calmado, robándoselo vía `_release_any_held_peer()`.
Mecanismo: `bull.gd` cambia su propia `collision_mask` dinámicamente en cada transición de estado (`_update_pen_collision`), no es un valor fijo — según el estado, incluye o no el bit de la barrera.

## D014 — Margen y peso de evasión de bordes reducidos
Decisión: `boundary_avoid_margin` baja de 70 a 30, y el peso de la evasión combinada (bordes + obstáculos + corral) baja de ×1.5 a ×0.8 en `_compute_flee_direction`.
Razón: bug real reportado — con el margen y peso anteriores, un jugador persiguiendo a un toro justo por el perímetro nunca lograba alcanzarlo; la evasión dominaba por completo la dirección de huida en toda la franja de 70 unidades junto a cualquier borde, convirtiéndola en una "zona segura" permanente para el toro.
Riesgo aceptado: ajuste de números sin validación visual — si sigue sin sentirse bien (demasiado fácil acorralar, o toros pegándose a obstáculos), es un ajuste de estos dos valores, no un rediseño.

## D015 — Captura doble movida a Nivel 5; tiempo límite por nivel
Decisión: el umbral de desbloqueo de la captura doble baja de Nivel 10 a Nivel 5. `LevelData.time_limit_seconds` deja de ser un valor único (150s) compartido por todos los niveles — cada nivel en `LevelCatalog` define el suyo, de 80s (Nivel 1) a 300s (Nivel 10).
Razón: reportado que el límite de tiempo fijo hacía imposible completar el Nivel 10 (10 toros) en la práctica.
Riesgo aceptado: los tiempos son una estimación calculada, no cronometrada en una partida real — mismo patrón de riesgo que la colocación de obstáculos (D012).

## D016 — Refactor de limpieza: is_held()/is_wild() y CollisionLayers
Decisión: tres correcciones de calidad de bajo riesgo, sin cambios de comportamiento: (1) eliminado el `print` de depuración temporal de `level_0.gd`; (2) `BullController.is_held()`/`is_wild()` sustituyen comparaciones de estado duplicadas a mano en 3 sitios; (3) `CollisionLayers` nombra las capas de colisión (1/2/4/8) en el código que las usa en tiempo de ejecución.
Razón: identificado en una revisión de calidad explícita contra `AI_DEVELOPMENT_RULES.md` (evitar código duplicado, evitar números mágicos, no dejar "parches temporales" sin resolver).
Alcance NO cubierto: refactors de mayor riesgo identificados en la misma revisión (extraer lógica de `level_0.gd` a servicios de Application, tipar los `Array` genéricos, evitar la duplicación de posición/tamaño entre `Pen` y `PenBarrier`) se dejaron pendientes a propósito — se acordó esperar a validar la acumulación de versiones sin probar antes de tocar estructura más profunda.

## D017 — Clic izquierdo global eliminado de throw_lasso
Decisión: la acción de Input `throw_lasso` deja de estar vinculada al clic izquierdo del ratón; solo responde a la tecla Espacio (teclado) y al `VirtualJoystick` de apuntado (que ya gestiona su propia zona de pantalla mediante señales `pressed`/`released`, no mediante esta acción global).
Razón: bug real reportado — tocar la mitad izquierda de la pantalla (pensada para el joystick de movimiento) también disparaba un lanzamiento de lazo, porque `Input.is_action_just_pressed("throw_lasso")` no tiene noción de posición en pantalla, solo de si el botón vinculado se pulsó en cualquier parte.
Mitigación adicional: `pointing/emulate_mouse_from_touch=false` en `project.godot` — evita que un toque táctil real sintetice también un evento de ratón que pudiera disparar acciones globales por su cuenta.
Nota: se reactivó temporalmente un `print` de diagnóstico (solo fallos, solo en builds de depuración) en `level_0.gd` para seguir investigando si queda algún caso real de precisión de captura tras este arreglo.

## D018 — Menú sin scroll: rejilla en vez de lista con ScrollContainer
Decisión: el menú de niveles pasa de una lista vertical dentro de un `ScrollContainer` a una rejilla (`GridContainer`, 5×2) que muestra los 10 niveles sin necesidad de desplazamiento. El botón "Salir" se mueve a la esquina superior derecha.
Razón: bug real reportado — arrastrar sobre los botones nunca se detectaba como gesto de scroll (los `Button` consumen el gesto de arrastre antes de que el `ScrollContainer` lo vea), dejando solo la barra de scroll como forma de desplazarse, poco usable en táctil.
Nota explícita del usuario: este layout es una solución funcional/provisional — el rediseño visual profesional del menú queda pendiente para una fase posterior.

## D019 — SaveData: separación de lógica pura y efecto secundario
Decisión: `SaveData.record_level_completed` delega la decisión de "¿es esto una marca nueva?" a un método puro (`_is_new_record`) sin escritura a disco. Los tests pasan a verificar solo ese método puro.
Razón: el test anterior de `record_level_completed` llamaba al método completo, incluyendo `save_progress()` — escribía de verdad en `user://save.dat` cada vez que se ejecutaba la suite, pudiendo sobrescribir el progreso real del usuario con datos de prueba. Posible causa (no confirmada con certeza) del aviso de GUT "does not extend GutTest" reportado — no se pudo aislar la causa exacta sin poder ejecutar el editor directamente.

## D020 — Método de comprobación renombrado a público tras error de parseo real confirmado
Decisión: `_is_new_record` (D019) pasa a llamarse `is_new_record`, sin guion bajo.
Razón: el "aviso" de GUT resultó ser un error de parseo real ("Failed to load script... Parse error"), no cosmético. Hipótesis principal (no verificada con certeza): el analizador de advertencias propio de GUT (`warnings_manager.gd`) trata el acceso desde fuera de la clase a un método "privado" por convención (prefijo `_`) de forma más estricta que una carga normal de script, posiblemente como error bloqueante en vez de advertencia.
Riesgo aceptado: no puedo confirmar esta hipótesis sin ejecutar el editor. Si el error persiste tras este cambio, la causa es otra y hay que descartar esta explicación.
CORRECCIÓN (v0.17.0, ejecutando Godot 4.7.2 + GUT 9.7.1 headless): la hipótesis era FALSA. La causa real era `var sut := load(...).new()` en `test_save_data.gd`: GDScript no puede inferir el tipo ("Cannot infer the type of sut"), error de parseo que hacía que GUT ignorase el script entero (sus 2 tests NO se ejecutaban desde D019). Arreglado con `var sut: Node = ...`. `is_new_record` se queda público (inocuo), pero no por la razón que se dio aquí.

## D021 — Mecánica "pilla-pilla": un único perseguidor, no agresividad probabilística
ESTADO: parcialmente revisada por D024 y D030. Se mantiene el perseguidor único obligatorio; la eliminación de la persecución probabilística por toro quedó REVERTIDA durante las validaciones (ver D030).
Decisión: se elimina el sistema en el que cada toro suelto tiraba su propia moneda (`aggression_chance`) cada 1.5s para decidir si perseguía al jugador. En su lugar, `level_0.gd` designa exactamente UN toro salvaje como perseguidor mientras el jugador lleve algo capturado — se mantiene fijo hasta que deja de estar suelto, y entonces el toro salvaje más cercano toma el relevo.
Razón: pedido explícito — corrección 2026-09-25: el sistema anterior NO era "varios podían acabar persiguiendo a veces"; con muchos toros (8-10) el 100% de los toros sueltos perseguían siempre al jugador de forma simultánea y determinista, sin ninguna fracción quedándose a huir. Era literalmente imposible rescatar ningún toro con más de 2-3 sueltos a la vez. El jugador pidió explícitamente que se pareciera a un "pilla-pilla": siempre exactamente uno, nunca todos.
Consecuencia (histórica): `BullTuning.aggression_chance` debía eliminarse (en realidad el campo seguía en el código hasta v0.17.0, D035). La coordinación vive en `level_0.gd` (tiene visión de todos los toros activos), no en cada `bull.gd` de forma independiente — necesario para poder garantizar "exactamente uno", algo que ninguna decisión puramente local por-toro podía asegurar.

## D022 — Modo puzzle de recintos (Nivel 11+)
Decisión: los niveles 11+ pueden agrupar toros en "pens" cerrados con una puerta (`PenDoor`, `Area2D` instanciada por código, igual que los obstáculos) que se abre si el jugador se queda quieto junto a ella `DEFAULT_DOOR_HOLD_SECONDS` (1.2s). `LevelData.pens` es un `Array` de `Dictionary` (`bull_indices`, `door_position`, `door_hold_seconds`) — mismo estilo plano que `obstacle_rects`, sin clase `Resource` nueva. Un toro referenciado por un pen se queda en `SAFE` (inerte, sin huida ni amenaza) hasta que se abre su puerta. `bull.gd` deja de lanzar su intro automáticamente en `_ready()` — ahora `Level0.begin_active()` decide cuándo, inmediato para niveles sin pens (comportamiento idéntico al anterior).
Razón: pedido explícito — gestión de riesgo (varios órdenes de apertura válidos, sin solución única a descubrir), no una secuencia fija. El Nivel 10 se mantiene sin cambios; el modo puzzle empieza en el 11 a propósito.
Riesgo aceptado: posiciones de puerta calculadas a mano (centroides de las posiciones fijas de los toros en `level_0.tscn`) — sin verificar en partida real.

## D023 — Rampa de niveles puzzle 12-15 (2 y 3 pens, hasta 10 toros)
Decisión: Nivel 12 (5 toros, 2 pens), 13 (7 toros, 2 pens + obstáculos), 14 (9 toros, 3 pens), 15 (10 toros, 3 pens + obstáculos de densidad similar al Nivel 10). Reutiliza el mecanismo genérico de D022 sin tocar `level_0.gd` de nuevo — solo datos en `LevelCatalog`.
Razón: pedido explícito — introducir la decisión de orden progresivamente (2 pens primero, 3 después) hasta usar los 10 toros ya existentes en el Nivel 15.
Riesgo aceptado: igual que D022 — agrupaciones y posiciones sin verificar en partida real.

## D024 — Persecución probabilística por-toro reintroducida, ahora dependiente del nivel
Decisión: se añade `LevelData.chase_probability` (5%-50%, rampa lineal `level_number * 0.05` con techo en 0.5, por tanto techo también en los niveles puzzle 11-15). Cada toro salvaje que NO es el perseguidor designado (D021), Y solo mientras el jugador tenga al menos un toro capturado (`capture_held`, propagado por `level_0.gd` cada frame), reevalúa cada 5s si también persigue al jugador, con `randf() < chase_probability`. Sin ninguna captura activa, todos los toros huyen, sin excepción — igual que el perseguidor designado, del que esta condición ya era cierta desde D021 pero no se había aplicado a la persecución secundaria hasta esta corrección. El perseguidor designado sigue siendo obligatorio y ajeno a esta tirada; además tarda `CHASER_ENGAGE_DELAY_SECONDS` (1.0s) en engancharse tras la captura, en vez de al instante.
Razón: pedido explícito, corregido/aclarado 2026-09-25 en dos puntos sobre la versión inicial: (1) la persecución secundaria debía estar apagada por completo mientras no hay ninguna captura activa, no solo el perseguidor designado; (2) el techo debía bajarse de 100% a un ~50% de toros persiguiendo en los niveles más difíciles, no la totalidad. Nota: esto reintroduce el patrón general que D021 eliminó (persecución por-toro, no coordinada centralmente), pero no es la misma situación — D021 corregido (ver arriba) describía un sistema previo al 100% fijo y determinista, sin depender de si había o no captura activa; aquí la probabilidad empieza baja (5% en el Nivel 1), solo se evalúa con captura activa, y su techo (50%) es la mitad de lo que llegó a ser el sistema original.
Riesgo aceptado: con el techo ya en 50% y el gating por captura, el escenario de D021 (100% persiguiendo siempre) queda evitado por diseño. Sigue sin haber límite explícito de N perseguidores simultáneos — si en partida real 50% sigue sintiéndose demasiado, es la primera palanca a tocar.

New decisions must record:
- ID;
- decision;
- reason;
- alternatives considered when relevant;
- consequences.

## D025 — Enlaces entre puertas: maestra, encadenada y normal (niveles 12-15)
Decisión: en niveles con varios pens, cada puerta puede llevar `is_master` (al abrirla se abren TODAS las demás) y/o `opens_pen_indices` (al abrirla se abren además esos pens concretos). Sin ninguno de los dos es una puerta normal: solo abre su propio pen. Un mismo nivel puede mezclar los tres tipos. La resolución vive en `PenLinkResolver` (Application, lógica pura sin nodos, testeable con GUT); `level_0.gd` solo aplica el resultado y `PenLinkOverlay` (Presentation) dibuja una línea rosa entre cada puerta cerrada y las puertas cerradas que abrirá, como ayuda de validación. La línea desaparece cuando cualquiera de sus dos extremos se abre. Los enlaces NO son en cascada: una puerta abierta por enlace solo libera su propio pen; solo la puerta que abre el jugador dispara sus enlaces. `PenDoor.force_open()` abre por enlace sin emitir `opened`, para que el handler no reentre.
Asignación por nivel: 12 → pen 1 maestra; 13 → pen 0 maestra (el pen pequeño); 14 → pen 0 encadenada a pen 1, pen 1 normal, pen 2 maestra; 15 → pen 0 normal, pen 1 maestra, pen 2 encadenada a pen 0. El nivel 11 (un solo pen) no cambia.
Razón: pedido explícito — añadir una capa de gestión de riesgo (la puerta que parece más barata puede soltar todos los toros a la vez). La línea rosa es provisional: en el vertical slice se sustituye por arte (caminos que siguen los toros y abren las otras puertas), sin tocar `PenLinkResolver`.
Interpretación a confirmar: "todos los niveles desde el 15" se aplicó a todos los niveles con varios pens (12-15), no solo al 15.
Riesgo aceptado: sin verificar en partida real; los enlaces de un nivel se cambian editando solo `LevelCatalog`.

## D026 — Niveles 11-20: 11-14 sin enlaces, 15-20 con enlaces nuevos y flecha direccional
Decisión: se revierte D025 en los niveles 12-14 (vuelven a no tener `is_master`/`opens_pen_indices`, igual que D023 los definió — pedido explícito: "del 11 al 14 las dejas como están pero sin enlazar entre ellas"). El nivel 15 se rediseña por completo: 4 puertas cerca de cada esquina del mapa (mismos 10 toros fijos, reagrupados), con un enlace unidireccional (NE abre también NW). Se añaden 6 niveles nuevos, todos con `bull_count = 10` (se reutilizan los mismos 10 toros fijos existentes, repartidos en más puertas en vez de añadir más toros):
- 16: 4 puertas, una relacionada unidireccionalmente con 2 de ellas.
- 17: 5 puertas (4 esquinas + 1 centro); la del centro relacionada unidireccionalmente con 3 de las 4 esquinas.
- 18: 6 puertas en posiciones dispersas ("aleatorias"); relacionadas dos a dos — a diferencia de todos los demás niveles, cada pareja es MUTUA (cada puerta abre a la otra), no solo unidireccional.
- 19: igual que el 18, más una puerta adicionalmente maestra (abre las 6).
- 20: 8 puertas dispersas, mezcla deliberada de los tres tipos (maestra, encadenada, normal).
`PenLinkOverlay` pasa de dibujar una línea a dibujar una FLECHA (línea + triángulo en la punta) apuntando hacia la puerta que se abre, para representar la dirección — pedido explícito ("representa la dirección con una flecha"). Una pareja mutua (nivel 18+) se ve como dos flechas opuestas sobre la misma línea, sin código adicional: es la superposición natural de dos enlaces unidireccionales en sentidos opuestos.
Razón: pedido explícito, con la reinterpretación anotada en D025 aplicada aquí también ("desde el 15" se toma como 15 en adelante, no un reemplazo de 12-14).
Riesgo aceptado: posiciones y asignación de enlaces de los niveles 15-20 son elección propia dentro de lo pedido (p. ej. qué puerta exacta es la maestra en el nivel 20) — sin verificar en partida real. `MAX_LEVEL` en `main_menu.gd` sube a 20.

## D027 — Velocidad de huida proporcional al nerviosismo con el que un toro se soltó
Decisión: al entrar en ESCAPED, `bull.gd` calcula `_effective_flee_speed = flee_speed * max(nerves/100, MIN_FLEE_SPEED_FACTOR)` una vez (no se recalcula mientras sigue huyendo) y la usa en vez de `flee_speed` fijo. `MIN_FLEE_SPEED_FACTOR = 0.15` evita que un toro soltado a nervios ≈0 (posible vía `force_escape` sobre un toro CONTROLLED) se quede completamente inmóvil.
Razón: pedido explícito — un toro casi calmado que se suelta (por ejemplo, otro toro salvaje golpea al jugador y le hace soltar lo que llevaba) debe ser fácil de volver a capturar. La velocidad máxima (nervios=100, el caso de siempre) no cambia — mismo `flee_speed` de antes.
Consecuencia de diseño (confirmada en v0.17.0, no se cambia): los nervios de un toro NO se regeneran mientras está suelto, así que un toro soltado a nervios bajos se queda lento y verde hasta que se recaptura, y al recapturarlo se calma casi al instante. Es lo pedido ("no acelerar después", plan de pruebas AD); si en partida real resulta demasiado fácil, la palanca sería regenerar nervios en ESCAPED.
Riesgo aceptado: `MIN_FLEE_SPEED_FACTOR` es una elección propia (no pedida explícitamente) para evitar un toro visualmente "congelado"; es una constante de una línea si se prefiere 0.0 (parón literal) tras probarlo.

## D028 — Color de los toros: degradado continuo por nervios, no colores fijos por estado
Decisión: se sustituye `_color_for_state` (colores discretos por estado: amarillo=CAPTURED, ámbar=CALMING, verde=CONTROLLED, naranja=ESCAPED) por `_color_for_nerves`, que interpola `LIGHT_GREEN` (nervios 0) a `ORANGE_RED` (nervios 100) según `controller.current_nerves()`. Se refresca cada frame mientras CALMING (antes solo cambiaba en las transiciones de estado) y también se aplica a los toros sueltos (ESCAPED/PURSUED), no solo a los capturados. SAFE sigue siendo blanco (aún sin nervios significativos).
Razón: pedido explícito — un toro casi calmado o recién soltado a bajos nervios era indistinguible del resto a simple vista. Junto con D027 (más lento) y D029 (sin solaparse), un toro de bajos nervios ahora se distingue en velocidad, color y no puede esconderse superpuesto sobre otro.
Riesgo aceptado: sin verificar en partida real; solo aplica cuando no hay arte real cargado (fallback de color, igual que antes).

## D029 — Los toros nunca se solapan entre sí
Decisión: `_update_pen_collision` añade `CollisionLayers.BULL` a la máscara de colisión de todo toro, en todo estado (antes solo llevaba FENCE y, condicionalmente, PEN_BARRIER). Como cada toro ya lleva `collision_layer = BULL` de forma permanente, esto hace que `move_and_slide()` (huida, remolque) resuelva colisiones también contra otros toros, incluidos los que están quietos (SAFE/encerrados), sin lógica adicional.
Razón: pedido explícito.
Riesgo aceptado: un toro salvaje podría notarse "empujado" al pasar cerca de un grupo de toros encerrados en un pen (D022) — no probado en partida real; si se nota mal, es un cambio de una línea revertir a la máscara anterior.

## D030 — Persecución probabilística por toro recuperada (corrige la documentación de D021)
Decisión: la persecución probabilística por toro que D021 había eliminado se RECUPERA, ahora como `LevelData.chase_probability` (D024, 5%-50% según nivel, solo con captura activa), conviviendo con el perseguidor único designado de D021.
Razón (confirmada por el usuario el 2026-10-01): durante las validaciones se decidió volver a ella porque que TODOS los toros te persigan a la vez rompía la jugabilidad; la tirada probabilística acotada evita ese caso a la vez que mantiene variedad. D021 y su changelog no reflejaban esta vuelta atrás, y D024 la describía como "reintroducción" sin registrar la decisión como tal.
Consecuencias: D021 queda marcada como parcialmente revisada. El campo `BullTuning.aggression_chance` sigue eliminado (la probabilidad vive en `LevelData`; el campo muerto se borró de verdad en v0.17.0). Palanca principal si 50% sigue siendo demasiado: bajar el techo en `LevelCatalog.get_level`.

## D031 — Niveles bloqueados por progresión (con desbloqueo total en builds de depuración)
Decisión: un nivel N solo se puede jugar si N <= `highest_level_completed + 1` (`LevelProgression.is_unlocked`, Application, pura y testeada). En builds de depuración (`OS.is_debug_build()`) todos los niveles quedan desbloqueados. El menú muestra "Nivel N (bloqueado)" y deshabilita el botón.
Razón: sin bloqueo se podía completar el nivel 20 sin haber jugado nada y obtener todas las mejoras permanentes de D009. El desbloqueo en depuración evita que el desarrollo/QA (APK de depuración incluido) dependa de rejugar 19 niveles.
Alternativas: bloquear también en depuración (descartada: impide probar niveles altos); botón secreto de trucos (descartada: más código sin beneficio).
Consecuencia: un export de RELEASE sí bloquea. `LevelCatalog.MAX_LEVEL` es ahora la única fuente del número de niveles (antes duplicado en el menú).

## D032 — Lógica extraída de level_0.gd y bull.gd a Application (cierra lo pendiente de D016)
Decisión: se extraen a clases puras con tests: `ChaserDirector` (regla del perseguidor único + retardo, D021/D024), `RandomChaseRoller` (tirada de persecución secundaria con fuente aleatoria inyectable), `FleeSteering` (dirección de huida: bordes, obstáculos, corral; constante `AVOIDANCE_WEIGHT`), `PlayerUpgrades` (calendario de mejoras de D009, antes números sueltos en `level_0.gd`) y `LevelProgression` (D031 + validación de guardado). `level_0.gd`/`bull.gd` solo cablean. `GameState.selected_bull_count` pasa a llamarse `selected_level` (contenía el número de nivel, no de toros). Los niveles 18 y 19 comparten sus 6 puertas vía `LevelCatalog._scattered_pairs_pens()` en vez de duplicarlas.
Razón: D016 dejó estos refactors pendientes "hasta validar". Con Godot y GUT ejecutables en el entorno de trabajo pudieron validarse (138 tests en verde) y la lógica de persecución, antes sin ningún test, ahora los tiene.
Alcance NO cubierto: tipar `Array` genéricos, extraer posición/tamaño duplicados entre `Pen` y `PenBarrier`, y convertir `LevelData.pens` en un tipo propio (sigue siendo `Array` de `Dictionary`, D022).

## D033 — Ciclo de vida Android, pausa y guardado validado
Decisión: (1) `NOTIFICATION_APPLICATION_PAUSED` y `WM_WINDOW_FOCUS_OUT` pausan el nivel (`get_tree().paused`) con un panel "Pausa" (Continuar / Menú principal) construido por código en `hud.gd` (el HUD usa `PROCESS_MODE_ALWAYS`). (2) `project.godot` pone `quit_on_go_back=false`: en el nivel el botón atrás alterna la pausa; en el menú sale de la app. (3) El temporizador de vuelo del lazo ya no es `process_always`, para que no aterrice mientras está en pausa. (4) `SaveData` valida lo leído (`LevelProgression.sanitize_highest_completed`: tipo y rango), guarda atómicamente (archivo temporal + rename), comprueba el error de escritura y añade `meta/version`.
Razón: ANDROID_REQUIREMENTS.md (pausa/reanudación, botón atrás, integridad del guardado) estaba sin abordar; sin pausa, el contador saltaría al volver de segundo plano.
Riesgo aceptado: solo verificado en headless (pausa/reanudación por código). El comportamiento real con el botón atrás, notificaciones del sistema y multitáctil requiere dispositivo.

## D034 — Geometría de niveles validada por tests; obstáculos corregidos
Decisión: `tests/unit/test_level_geometry.gd` comprueba para todos los niveles que obstáculos y puertas caben en la arena, no tapan el spawn del jugador, el corral ni el spawn de ningún toro (leído de `level_0.tscn`), que las puertas son alcanzables y no se solapan entre sí. Al introducirlo salieron defectos reales, corregidos moviendo obstáculos (no los spawns, que viven en la escena): niveles 7 y 9 (pilares laterales encima del corral y de un toro) -> `Rect2(±, 60, 90, 130)`; niveles 8, 10 y 15 (obstáculo inferior izquierdo sobre el toro 3) -> `Rect2(-160, 70, 120, 50)`; nivel 10 (obstáculo central sobre el spawn del jugador) -> `Rect2(-40, -90, 80, 60)`.
Además, los toros que un nivel no usa ahora se desactivan de verdad (`Bull.deactivate()`: capa y máscara de colisión a 0): desde D029 todos los toros chocan entre sí y los ocultos seguían siendo muros invisibles.
Riesgo aceptado: las nuevas posiciones cumplen las comprobaciones geométricas pero no se han visto en partida real.

## D035 — Limpieza de código muerto
Decisión: eliminados `LevelConfig` y su test (sustituidos por `LevelData`/`LevelCatalog` desde D012), `BullTuning.aggression_chance` y `BullController.go_pursued()` (sin llamadas). El estado PURSUED se conserva en Domain (GAMEPLAY_SPEC.md lo define y sus transiciones están testeadas) como estado RESERVADO: ningún flujo de juego lo alcanza hoy; `bull.gd` ya lo trata igual que ESCAPED.
Razón: AI_DEVELOPMENT_RULES.md (sin abstracciones ni código sin uso); las contradicciones con D021/D012 confundían a futuras sesiones.

## D036 — Toros capturados o entregados no colisionan con otros toros; relevo del perseguidor bloqueado
Decisión (pedido explícito, 2026-10-04): (1) Un toro sostenido por el jugador (CAPTURED/CALMING/CONTROLLED) y un toro ya entregado al corral (SAFE tras `return_to_pen`) pasan a la capa `CollisionLayers.BULL_PASSIVE` (16), que no está en la máscara de ningún toro: ni bloquean a otros toros ni son bloqueados por ellos. Su máscara es solo FENCE (siguen chocando con vallas y obstáculos). `Pen` añade la capa 16 a su propia máscara en `_ready` para seguir detectando entregas. `Bull._update_collision` (antes `_update_pen_collision`) centraliza el cálculo; un toro entregado se reconoce por la transición CONTROLLED -> SAFE (`_delivered`). Un toro soltado (force_escape) vuelve a la capa BULL, y los toros salvajes y los SAFE iniciales (puzzle) siguen sin solaparse entre sí (D029).
(2) Si el perseguidor designado (D021) no avanza durante `CHASER_BLOCKED_SECONDS` (1s) —se mueve menos del 25% (`CHASER_BLOCKED_PROGRESS_RATIO`) de lo que debería—, `Bull` emite `chaser_blocked` y `Level0` llama a `ChaserDirector.hand_over_randomly`: el rol pasa AL INSTANTE (sin el retardo de 1s de D024) a otro toro salvaje elegido al azar. Si no hay otro toro salvaje, conserva el rol. La detección vive en `BlockedDetector` (Application, pura, testeada); solo se vigila al perseguidor, no a los toros que huyen.
Razón: (1) los toros entregados quedaban como obstáculos sólidos dentro del corral (efecto de D029) y llenaban el espacio, haciendo imposible meter los 10 toros en el nivel 20. (2) un perseguidor atascado contra un obstáculo, esquina u otro toro dejaba al jugador sin presión.
Consecuencias: D029 se relaja para toros sostenidos y entregados (pueden solaparse visualmente con otros dentro del corral o al remolcarlos). Los toros salvajes ya no empujan/bloquean al toro que llevas.
Riesgo aceptado: los umbrales de bloqueo (1s, 25%) son elección propia; el comportamiento real de colisiones y relevo solo está verificado headless. Si hay relevos espurios (p. ej. deslizándose por un borde), subir el umbral de tiempo o bajar el ratio.

## D037 — Sticks táctiles en modo FOLLOWING y cancelación del lanzamiento
Decisión (pedido explícito, 2026-10-04): (1) `MoveJoystick` y `AimJoystick` pasan de `JOYSTICK_DYNAMIC` a `JOYSTICK_FOLLOWING` (`joystick_mode = 2` en `level_0.tscn`): la base del stick sigue al dedo cuando sale del aro, de modo que el dedo nunca queda a más de un radio del centro. (2) Soltar el stick de apuntado con un vector menor que `LassoAim.CANCEL_THRESHOLD` (0.2, igual que el deadzone de las acciones `aim_*`) CANCELA el lanzamiento en vez de lanzar el lazo a distancia 0 (a los pies del jugador, gastando el lanzamiento). Un toque sin arrastrar también cancela. La lógica pura (cancelación y mapeo vector -> distancia) vive en `LassoAim` (Application, con tests); `player.gd` solo la aplica. El camino de teclado (Espacio) no cambia.
Razón: con DYNAMIC el vector se satura en el aro pero el dedo puede seguir alejándose; para cambiar de dirección o acortar el lanzamiento había que recorrer de vuelta todo el exceso. En movimiento solo importa la dirección (la velocidad es siempre `max_speed`), así que FOLLOWING no pierde información; en apuntado la distancia pasa a ser relativa a la posición actual de la base: empujar = lejos, retroceder un poco = más corto.
Alternativas consideradas: stick propio con seguimiento suavizado (rechazada por D007; solo si FOLLOWING resulta rígido), aro más pequeño y `clampzone_ratio` menor (ajuste posterior tras probar en móvil), autoajuste de distancia al toro más cercano (rechazada: cambia la destreza que D009 declara como objetivo), tocar para ir a un punto (rechazada: choca con el esquema de dos pulgares).
Consecuencias: `joystick_size`, `tip_size`, `clampzone_ratio` y `deadzone_ratio` de ambos sticks siguen en `level_0.tscn` (sin tocar: 220/80/1.0/0.0) y son la palanca de ajuste. Corrección colateral: las líneas del lazo (vuelo y marcador de aterrizaje) se cuelgan de `get_parent()` en vez de `get_tree().current_scene` (era null al instanciar el nivel dentro de otro árbol, p. ej. en tests).
Riesgo aceptado: la sensación real solo puede juzgarse con el dedo en un dispositivo; los valores de tamaño y zona no se han tocado y probablemente necesiten un ajuste.

## D038 — El lazo ya no lo bloquean los obstáculos; doble toque para soltar un toro
Decisión (pedido explícito, 2026-10-04): (1) Se elimina la comprobación de línea de visión de D012 (`_is_path_blocked`, raycast contra la capa FENCE entre el origen y el punto de caída): el lazo captura lo que haya en su punto de aterrizaje aunque haya un obstáculo entre el jugador y el toro. Los obstáculos siguen bloqueando el movimiento de jugador y toros. (2) Dos toques rápidos en el stick de apuntado (pulsar y soltar cerca del centro, `LassoAim.is_tap`: <= 0.3 s; segundo toque a <= 0.4 s del primero, `DoubleTapDetector`) emiten `Player.release_requested`; `Level0` suelta UN toro: el capturado más recientemente (`Bull.capture_order`), de modo que con captura doble el jugador conserva el más antiguo. Soltar usa `Bull.release_by_player()`: misma transición que perder el toro por un golpe (a ESCAPED, conservando los nervios, D027), más `RELEASE_TOUCH_GRACE_SECONDS` (1 s) durante el que ese toro no puede aturdir al jugador (queda a una distancia de correa, ~50, casi dentro del radio de contacto de 46). Un toque simple sigue siendo "cancelar" (D037); un arrastre entre dos toques rompe el par.
Razón: (1) con un obstáculo en medio, lanzar el lazo justo encima de un toro no lo capturaba, algo que el jugador percibía como un fallo. (2) hacía falta una forma de soltar un toro sin añadir botones; el doble toque no interfiere con lanzar (arrastrar+soltar) ni con cancelar (un toque).
Alternativas consideradas para soltar: mantener pulsado sin arrastrar (riesgo de soltar por accidente al dudar apuntando), botón en el HUD (más UI, otro pulgar), soltar todos los toros a la vez (impredecible con captura doble).
Consecuencias: esconderse detrás de un obstáculo ya no protege a un toro del lazo; la defensa pasa a ser solo el movimiento. El texto de D012 queda marcado como revocado en esa parte. Un toro soltado a nervios bajos es lento y fácil de recapturar (D027): soltar es una acción casi gratuita; si resulta un exploit, la palanca es regenerar nervios en ESCAPED o añadir un coste.
Riesgo aceptado: la ventana de doble toque (0.4 s) y el máximo de toque (0.3 s) son elección propia, sin probar con el dedo. No hay equivalente de teclado para soltar (los tests llaman a las funciones del stick directamente).

