# GO Rodeo GO - revisión autónoma

Base preservada: `7336ebb` (main). Cambios en `improve/autonomous-review`.

## Primer incremento (0.21.0)

- Lazo de teclado: mantener Espacio carga alcance, soltar lanza. Antes se sobrescribía a cero sin el stick.
- Pausa: Esc y botón visible. Cancela cargas y oculta controles táctiles para no dejar gestos atascados.
- Corral: un toro que termina de calmarse dentro se entrega sin salir y volver a entrar.
- Fin de partida: las puertas dejan de avanzar.
- 60 fotogramas nuevos: 6 por cada una de 5 direcciones, para caballo/vaquero y toro. Las otras 3 direcciones se reflejan. Diagonal abajo rehecha en 3/4.
- Sprite loader: orden numérico natural; reposo deliberado del toro en vez de última pose congelada de carrera.
- Arena dibujada con suelo, valla y cajas; sin cambiar colisiones ni geometría de niveles.
- Corral marcado, anillo de alcance antes de lanzar, cuerda persistente y barra local al calmar, marca de toro controlado y alerta del perseguidor.
- Puertas con anillo de progreso. Menú/HUD con estilo común e instrucciones.
- Cámara ajustada al viewport, reservando banda de HUD y ayuda.

## Pruebas reproducibles

Godot 4.7.2 oficial, GUT incluido en el repo:

```
godot --headless --editor --import --quit
godot --headless -s addons/gut/gut_cmdln.gd
```

Base: 193 tests. Primer incremento: 200 tests, todos pasan.
Siete pruebas nuevas cubren carga de teclado/stick, cancelación en pausa, entrega dentro del corral, puertas detenidas y assets de animación.

`tools/capture_review.gd` genera capturas reales con un servidor gráfico. `tools/import_sprite_sheet.py` prepara sheets 3x2 (Pillow, solo herramienta de desarrollo). Los PNG runtime no necesitan Python.

## Límites de lo comprobado

- Pruebas automatizadas y render real de Godot en Linux mediante OpenGL por software.
- Animaciones de 6 dibujos a 8 fps. No son animación esquelética ni prueban rendimiento Android.
- No se ha jugado en un teléfono: multitáctil, tacto, pausa/segundo plano y rendimiento siguen pendientes de dispositivo real.
- Se conservan las reglas/progresión y los 20 niveles. Tiempos de niveles siguen necesitando sesiones de juego, no se han retocado a ciegas.
- Sin merge a main ni despliegue de tienda. Prereleases autorizadas por el usuario; a partir de0.21.5 hay variante de prueba con ID separado para coexistir con el original.
- El APK antiguo `BIN/Rancho.apk` del historial no representa esta rama. Se ha creado aparte `GO-Rodeo-GO-review.apk` desde f195add; ver segundo incremento. Abrir `project.godot` con Godot 4.7.2 para probar el código.

## Historial revisado

Los tres commits originales son `8d0e502` (inicio), `b3cc737` (vertical slice) y `7336ebb` (estabilidad de orientación). Se conserva SpriteFacing y sus tests para no reintroducir parpadeo cerca de vallas.
La documentación original describía 184 tests y ausencia de arte: al comprobar el repo real había 193 tests y sprites estáticos. Esta revisión registra lo comprobado, no replica esas afirmaciones antiguas.

## Segundo incremento (0.21.0)

- Reposo animado (12 frames adicionales, total 72) y parpadeo.
- Siguiente nivel tras victoria (salvo último nivel), conservando menú y reinicio.
- 8 señales sonoras originales sintetizadas, volumen moderado y opción de silenciar en pausa.
- Icono de prueba basado en el personaje original. No cambia el identificador `com.example.rancho` ni prepara publicación.
- Export Android excluye tests, GUT, herramientas, masters y documentación. APK debug arm64 generado y firma v2/v3 verificada. Sin prueba en teléfono.
- 204 tests pasan. El vídeo de revisión usa Godot real con entradas y posiciones guionadas, no una partida humana. La captura fija de 30 fps no es una medición de rendimiento.

## Tercer incremento

- Prueba de ciclo completo para los 20 niveles: abrir/liberar, capturar, calmar, entregar mediante overlap físico y ganar. Posiciones controladas: no sustituye una partida humana ni prueba el equilibrio de dificultad.
- Corregido idle que no comenzaba a reproducirse si la animación por defecto ya se llamaba `idle`.
- Entrada táctil ignorada durante aturdimiento; una suelta arrastrada desde antes de pausar ya no dispara al volver.
- Puertas/toros con números coincidentes, maestra marcada M; enlaces finos discontinuos detrás de personajes en vez de líneas rosas sobre sus caras.
- Se mantienen las 20 geometrías, probabilidades y límites de tiempo originales.
- 210 tests pasan en la última revisión, 3094 aserciones.

- El ajuste de sonido se conserva al cambiar de nivel durante la sesión.
- Registro del reposo del toro corregido usando alpha significativo, descartando ruido casi transparente.

## Cuarto incremento (0.21.2)

- Corregido: pausa/focus loss con dedos apoyados conservaba acciones activas del joystick nativo aunque se ocultase; reset explícito y verificado con dos contactos inyectados en Godot/Linux.
- Harness `tools/touch_review.gd`: mover con dedo0, apuntar/soltar con dedo1, interrumpir con pausa y comprobar ambos vectores a cero. Resultado true. Es prueba sintética, no validación con dedos en un teléfono.
- Guardado probado en rutas temporales aisladas: roundtrip atómico, fichero corrupto/ausente y rechazo de niveles fuera de campaña. Ruta de producción sin cambios.
- 214 tests pasan, 3106 aserciones.

## Quinto incremento (0.21.3)

- Esc vuelve a funcionar para reanudar: lo recibe HUD, que sigue procesando en pausa, no el nivel pausado.
- El lazo ya en vuelo se cancela al terminar partida; antes emitía aterrizaje detrás del panel final.
- Pausa desactiva Pausa/Tranquilizante de la cabecera, y la lógica rechaza usar el objeto durante pausa.
- Harness UI con toques en viewport real/Linux: Pausa, Continuar, Menú tras derrota y Siguiente tras victoria; todos recibidos. Esc pausa/reanuda comprobado. Posiciones son guionadas, no dedos de teléfono.
- 217 tests pasan, 3115 aserciones. Los fallos nuevos se reprodujeron antes de corregirlos.

## Sexto incremento (0.21.4)

- R libera captura en teclado, igual que doble toque en stick; no cambia la regla de soltar el toro más reciente.
- Ayuda contextual indica capturar, esperar mientras se calma o llevar al corral según estado real.
- Panel final oculta barras/objeto/pausa. Victoria real capturada con contador1/1 y toro SAFE dentro del overlap del corral; no confundir con el harness UI que solo mostraba el panel para probar su botón.
- Lazo en vuelo comprobado: se congela al pausar y aterriza al reanudar, pero se cancela si termina partida.
- Señales sonoras generadas: PCM revisado sin clipping (picos <0.5 de escala), finales cero y volumen por voz -15dB. No hay evaluación auditiva humana: calidad y mezcla final pendientes de escuchar en el dispositivo.
- 221 tests pasan, 3132 aserciones.

## Séptimo incremento (0.21.5)

- Cierre de partida inmutable: el corral ya no puede entregar al frame siguiente y cambiar una derrota por tiempo a victoria. Regresión reproducida antes de la corrección.
- Remolque físico completo hasta victoria sin teletransportar toro al corral; apertura por overlap real y quietud; rutas estáticas conectadas a toros, puertas y corral en los20niveles con margen24px. Son escenarios guionados, no equilibrio ni juego humano.
- 225 tests / 3348 aserciones pasan.
- Android normal conserva com.example.rancho; versionCode215 (anteriores pruebas1), sin presumir código/certificado de la app instalada del usuario.
- Variante Android Review: com.example.rancho.review, nombre Rancho Prueba, versionCode215. Instalación separada, no reemplaza Rancho ni importa su progreso. Mismo juego/código, ambos APK debug arm64/minSdk24. No se ha instalado en dispositivo. No evita ni debe eludir controles Play Protect.
- APK anterior local BIN/Rancho.apk no está rastreado en historial original ni entre releases anteriores; no se puede comparar su certificado con el actual. Diagnóstico exacto de Aplicación no instalada pendiente de APK original/error de sistema.
