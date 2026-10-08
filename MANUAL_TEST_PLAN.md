# MANUAL TEST PLAN — GO Rodeo GO

Cubre todo lo que **no** puedo validar yo mismo: sensación de juego, input táctil, casos
límite, interacción entre sistemas. Todo lo automatizable ya vive en `tests/unit/` (GUT).

Uso las categorías y prioridades de `QA_PLAN.md`:
**P0** = crash/bloqueo/pérdida de progreso · **P1** = defecto mayor de jugabilidad ·
**P2** = defecto menor · **P3** = cosmético.

Este documento se actualiza con cada versión que añada funcionalidad nueva. Marca `[x]`
lo que pruebes y anota el resultado si algo falla — así sé exactamente qué re-verificar
tras un cambio.

---

## v1 — Vertical slice (lazo carga/suelta, 4 toros, valla física, HUD, victoria/derrota, joysticks táctiles)

### A. Lanzamiento del lazo — límites y casos raros
- [ ] **(P1)** Suelta el lazo apuntando fuera del área jugable (más allá de la valla). Esperado: no crashea, simplemente falla (ningún toro en ese radio) — el punto de caída puede caer "dentro" de la valla en coordenadas aunque visualmente esté detrás.
- [ ] **(P2)** Suelta el lazo con el punto de caída exactamente sobre la línea de la valla (borde del `world_bounds`). Esperado: falla limpio, sin comportamiento raro.
- [ ] **(P1)** Con un toro ya `CAPTURED`/`CALMING`/`CONTROLLED`, intenta lanzar el lazo contra otro toro. Esperado: el lanzamiento se ignora por completo (ni siquiera se resuelve el disparo) — confirmar que ni el segundo toro reacciona ni se descarga el primero.
- [ ] **(P2)** Suelta el lazo sin arrastrar nada (carga = 0). Esperado: el punto de caída es tu propia posición; solo captura si un toro está literalmente encima tuyo.
- [ ] **(P2)** Carga el lazo hasta el máximo (`max_throw_distance`) y mantenlo ahí varios segundos antes de soltar. Esperado: no sigue creciendo más allá del tope, se lanza correctamente al soltar.
- [ ] **(P1)** Dos toros muy próximos entre sí, lanza el lazo entre ambos. Esperado: captura el más cercano al punto de caída, no ambos, no el más lejano.
- [ ] **(P0)** Lanza el lazo repetidamente muy rápido (spam del botón/joystick). Esperado: no se acumulan lanzamientos ni se rompe el estado de carga.

### B. Aturdimiento y pérdida de captura
- [ ] **(P1)** Con un toro capturado, deja que un toro salvaje te toque. Esperado: pierdes el toro (`force_escape`) Y te aturdes, ambos efectos, no solo uno.
- [ ] **(P2)** Quédate aturdido y dentro del rango de contacto de otro toro salvaje al mismo tiempo. Esperado: no se dispara un segundo aturdimiento encadenado infinito (revisar si `_touching_player` se resetea correctamente durante el aturdimiento).
- [ ] **(P2)** Intenta cargar el lazo justo cuando te aturden. Esperado: la carga se cancela (`_cancel_charge()` ya está en `stun()`) — confirmar que no se queda una línea de carga "fantasma" en pantalla.
- [ ] **(P1)** Un toro agresivo (con otro capturado) te alcanza y choca. Esperado: mismo comportamiento que contacto normal — aturdimiento + pérdida de captura.

### C. Interacción entre toros
- [ ] **(P2)** Calma un toro cerca de 1, 2 y 3 toros alterados simultáneamente. Esperado: cuantos más cerca, más lento baja el nervio (o no baja) — verificar que se nota la diferencia entre 1 y 3.
- [ ] **(P3)** Con los 4 toros sueltos a la vez, observa si alguno se queda "pegado" en una esquina a pesar de la IA de evasión de bordes.
- [ ] **(P2)** Verifica que los toros nunca colisionan físicamente entre sí (deberían poder superponerse) — confirmar que esto no se ve raro visualmente incluso sin arte.

### D. Remolque y valla física
- [ ] **(P1)** Con un toro capturado/calmándose, camina directamente hacia la valla. Esperado: tú te detienes en la valla (colisión física), el toro remolcado también, sin atravesarla ni quedar fuera.
- [ ] **(P2)** Con un toro `CONTROLLED`, llévalo hasta el corral pero pasando muy pegado a la valla en el trayecto. Esperado: sin bloqueos raros por la geometría de las 4 vallas en las esquinas (revisa las 4 esquinas del rectángulo, no solo el centro de cada lado).
- [ ] **(P1)** Lleva un toro `CALMING` (aún no `CONTROLLED`) hasta la zona del corral. Esperado: NO se marca como devuelto — solo `CONTROLLED` cuenta.
- [ ] **(P2)** Rompe la cuerda a propósito (aléjate más de `max_rope_distance`) justo en el borde de la zona del corral. Esperado: el toro vuelve a `ESCAPED` limpiamente, no queda en un estado raro por estar cerca del Area2D del corral.

### E. Victoria / Derrota
- [ ] **(P0)** Deja que el temporizador llegue a 0 mientras metes el último toro casi al mismo tiempo. Esperado: solo se dispara UN resultado (victoria o derrota), no ambos ni ninguno.
- [ ] **(P1)** Tras victoria/derrota, intenta seguir jugando (mover, lanzar el lazo). Esperado: jugador y toros congelados — pero revisa si el joystick de apuntado sigue reaccionando visualmente aunque no lance nada (gap ya anotado).
- [ ] **(P2)** Verifica el HUD en 0/4 y 4/4 toros — texto correcto, sin desbordamientos visuales.
- [ ] **(P3)** Verifica que la barra de nervios desaparece correctamente al soltar/perder un toro (no se queda visible con un valor congelado).

### F. Controles táctiles (probar con ratón vía emulación; **el uso simultáneo de ambos dedos solo es verificable en dispositivo real**)
- [ ] **(P1)** Toca fuera de la mitad derecha de la pantalla intentando activar el joystick de apuntado. Esperado: no se activa (debe aparecer solo dentro de su mitad).
- [ ] **(P2)** Arrastra el joystick de apuntado más allá de su radio máximo. Esperado: la dirección se mantiene correcta, la fuerza se satura en 1.0.
- [ ] **(P2)** Suelta el dedo del joystick de movimiento cerca del centro (dentro de la zona muerta). Esperado: el jugador se detiene, no se mueve por una dirección residual mínima.
- [ ] **(P0 — solo dispositivo real)** Usa ambos joysticks a la vez (mover + apuntar simultáneamente). No puedo verificar esto desde aquí en absoluto — es el caso de mayor riesgo de todo el sistema táctil.
- [ ] **(P2)** Empieza a tocar el joystick de movimiento, sin soltar, mueve el dedo fuera de la pantalla (borde físico del dispositivo). Esperado: comportamiento razonable al soltar (no debería quedar "pegado" moviendo indefinidamente).

### G. Sistema de sprites (sin arte aún, pero probable que añadas alguno pronto)
- [ ] **(P2)** Añade SOLO la carpeta `idle` de un toro (deja el resto vacío) y verifica: `idle` muestra arte real, todos los demás estados siguen mostrando el recuadro de color de siempre — sin mezcla rara entre ambos sistemas.
- [ ] **(P1)** Confirma que cada uno de los 4 toros gestiona su propio sprite/color de forma independiente (que capturar uno no cambie visualmente a los otros 3).

---

## v2 — Animación direccional (walk_*/flee_* con espejado)

### H. Direcciones de movimiento y espejado
- [ ] **(P1)** Camina en las 8 direcciones (arriba, abajo, izquierda, derecha, 4 diagonales) sin arte añadido — confirma que sigue siendo el recuadro de color de siempre en todas (sin arte, la dirección no debería causar ningún error ni parpadeo).
- [ ] **(P1)** Añade SOLO `walk_side` (sin las otras 4 direcciones) y camina en las 8 direcciones. Esperado: solo se ve arte real yendo horizontalmente (derecha=normal, izquierda=espejado); el resto de direcciones cae al recuadro de color sin romperse.
- [ ] **(P2)** Con `walk_side` añadido, comprueba que izquierda es realmente el espejo de derecha (no una imagen distinta ni distorsionada).
- [ ] **(P2)** Dirección diagonal justo en el límite entre sectores (por ejemplo, casi exactamente a 22.5°) — comprueba que no hay parpadeo entre dos animaciones distintas al moverte en una diagonal cercana al límite.
- [ ] **(P3)** Quédate quieto tras caminar en diagonal — confirma que quedas mirando hacia la última dirección (no se resetea a "derecha" por defecto).
- [ ] **(P1)** Mismo set de pruebas (H1-H4) pero con el toro huyendo (`flee_*`) en vez del jugador — verificar que cambia de dirección de animación en tiempo real mientras la IA de huida gira (no solo al iniciar el estado `ESCAPED`).

---

## v3 — VirtualJoystick nativo (sustituye la implementación propia)

### I. Joysticks nativos
- [ ] **(P0)** Confirma que el proyecto abre sin error de parseo (la causa original de este cambio fue justo un error de carga de script).
- [ ] **(P1)** Repite TODOS los casos F (v1) con el joystick nativo — el comportamiento esperado no cambia, solo la implementación.
- [ ] **(P2)** El stick de apuntado (`AimJoystick`, modo `DYNAMIC`): comprueba en el Inspector si el círculo base se ve visible en reposo o solo al tocar. Si se ve siempre visible y no quieres eso, cambia `Visibility Mode` a "When Touched" desde el Inspector (no lo fijé por código — no tenía certeza del valor exacto del enum nativo, mejor que lo elijas tú desde el desplegable).
- [ ] **(P1)** Confirma que el teclado (flechas) sigue moviendo al jugador exactamente igual que antes — el stick de movimiento nativo alimenta las mismas acciones (`move_left/right/up/down`), no debería haber ningún cambio de sensación.
- [ ] **(P2)** Haz clic con el ratón para cargar el lazo, sin haber tocado antes el stick de apuntado — confirma que la carga por teclado/ratón (mantener pulsado, crece con el tiempo) sigue funcionando como alternativa de escritorio.
- [ ] **(P2)** Toca/haz clic exactamente sobre la zona del stick de apuntado y suelta muy rápido (clic simple, sin arrastrar) — confirma que no se lanza el lazo dos veces (una por la señal nativa `released`, otra por la acción de teclado/ratón `throw_lasso`); están protegidos con guardas de estado, pero solo lo he razonado, no probado.

---

## v4 — Joysticks agrandados, hit_radius corregido, botones de fin de partida

### J. Ajustes de sensación y cierre de partida
- [ ] **(P1)** Confirma que apuntar con el joystick derecho (ahora más grande) se siente más preciso/cómodo que antes — el objetivo era justo resolver esa queja.
- [ ] **(P1)** *(Obsoleto desde v5 — el joystick de movimiento ya no es fijo/siempre visible, ver casos K)* ~~Confirma que el joystick de movimiento (izquierda) es visible SIEMPRE~~
- [ ] **(P0)** Confirma que el lazo ahora acierta de forma consistente apuntando a cualquier parte del recuadro del toro, incluidas las esquinas — antes fallaba ahí específicamente.
- [ ] **(P2)** Confirma que el rango de aturdimiento (contacto con toro salvaje) NO se ha vuelto más generoso que antes — ahora usa solo `hit_radius` (28), independiente del radio de acierto del lazo (`hit_radius + capture_tolerance` = 58).
- [ ] **(P0)** Al ganar, aparecen los botones "Reiniciar partida" y "Finalizar" — pulsa "Reiniciar" y confirma que la partida vuelve limpia desde el principio (temporizador, contador de toros, todos los toros sueltos otra vez).
- [ ] **(P0)** Igual que el anterior pero perdiendo (se acaba el tiempo).
- [ ] **(P1)** Pulsa "Finalizar" — confirma que cierra la app limpiamente (sin crash, sin quedarse colgado).
- [ ] **(P0 — solo dispositivo real)** Todo lo anterior repetido en el móvil real, no solo en el editor con ratón.

---

## v5 — Ajuste a pantalla real (stretch/aspect) + joystick de movimiento dinámico

### K. Adaptación de pantalla y joystick de movimiento
- [ ] **(P0)** En el móvil real: confirma que el rancho ya llena la pantalla razonablemente (no se ve una franja pequeña en una esquina ni deformado).
- [ ] **(P1)** Comprueba las 4 esquinas del HUD (contador arriba-izq, panel de fin centrado) — deben verse en su sitio, no cortadas ni fuera de pantalla.
- [ ] **(P2)** Si tu móvil tiene una relación de aspecto muy distinta a 16:9 (muchos Android modernos son ~20:9), es esperable ver un poco más de área vacía más allá de la valla a los lados — es un efecto conocido del modo "expand" (revela más mundo en pantallas más anchas en vez de recortar). Dime si se ve mal, y cambiamos a un modo que recorte en vez de expandir.
- [ ] **(P0)** Toca en CUALQUIER punto de la mitad izquierda de la pantalla (arriba, abajo, centro) — el joystick de movimiento debe aparecer ahí mismo (ya no está fijo abajo).
- [ ] **(P1)** Toca cerca de la parte baja de la pantalla y arrastra hacia abajo — confirma que ahora tienes recorrido suficiente para el movimiento "hacia abajo" sin chocar con el borde físico de la pantalla.
- [ ] **(P2)** Confirma que el joystick de movimiento es invisible en reposo (como el del lazo) y solo aparece al tocar — es el comportamiento nuevo que pediste, distinto de antes.

---

---

## v6 — Precisión del lazo, botones desbloqueados, retraso de vuelo

### L. Verificación de los tres fixes
- [ ] **(P0)** Lanza el lazo apuntando varias veces directamente sobre un toro quieto (o recién capturado y soltado, para tenerlo más predecible) — confirma que ahora acierta de forma consistente, sin el patrón de "a veces arriba sí, exacto no".
- [ ] **(P1)** Revisa la consola/log de la partida (`print` temporal en `level_0.gd`) — si SIGUE fallando de forma inconsistente, copia las líneas `Lasso landed...` de varios intentos (aciertos y fallos) y las reviso con datos reales en vez de seguir ajustando a ciegas.
- [ ] **(P0)** Termina una partida (victoria o derrota) y pulsa "Reiniciar partida" — debe responder al toque/clic ahora.
- [ ] **(P0)** Igual con "Finalizar".
- [ ] **(P1)** Lanza el lazo y cuenta mentalmente ~1 segundo — confirma que la captura (o el fallo) se resuelve tras esa pausa, no al instante.
- [ ] **(P1)** Intenta lanzar un segundo lazo mientras el primero está "en vuelo" (dentro de ese segundo). Esperado: no debería poder cargar/lanzar otro hasta que el primero resuelva.
- [ ] **(P2)** Nota de sensación: durante ese segundo de vuelo no hay ningún indicador visual (la línea de carga desaparece al soltar, y no hay nada hasta que aparece el marcador de impacto). Puede sentirse como que "no pasó nada" ese segundo — si se siente raro/como un bug, dímelo y añado un indicador provisional (ej. la línea se mantiene visible y se desvanece durante ese segundo) mientras llega la animación real del lazo.

---

---

## v7 — Menú principal y selección de nivel

### M. Menú y niveles
- [ ] **(P0)** Al abrir el juego, aparece el menú (no entra directo a la partida).
- [ ] **(P0)** Nivel 1 → confirma que arranca con exactamente 1 toro visible/activo (los otros 3 no deben aparecer ni moverse).
- [ ] **(P0)** Nivel 2, 3 y 4 → confirma 2, 3 y 4 toros respectivamente.
- [ ] **(P1)** El contador del HUD ("Toros en el corral: X/N") debe usar el total correcto de CADA nivel (ej. "0/1" en nivel 1, no "0/4").
- [ ] **(P1)** Gana una partida en Nivel 1 (con 1 solo toro) — confirma que la condición de victoria se cumple con ese único toro devuelto, sin esperar a que aparezcan los otros 3.
- [ ] **(P1)** "Salir" desde el menú → cierra la aplicación.
- [ ] **(P0)** Termina una partida (victoria o derrota) → pulsa "Menú principal" (antes "Finalizar") → confirma que vuelve al menú, NO cierra la app.
- [ ] **(P1)** Desde el menú, entra otra vez a un nivel — confirma que los toros vuelven a su comportamiento normal (huyen, se puede interactuar), no quedan "congelados" por resto de estado de la partida anterior.
- [ ] **(P2)** "Reiniciar partida" sigue funcionando igual que antes (recarga el mismo nivel con el mismo número de toros que tenías, no vuelve al menú).
- [ ] **(P2)** Ve directamente del menú al Nivel 4, gana o pierde, pulsa "Reiniciar" — confirma que sigue siendo Nivel 4 (4 toros), no se resetea a Nivel 1 por defecto.

---

---

## v8 — Cuerda sin rotura + animación de vuelo/área

### N. Verificación
- [ ] **(P0)** Captura un toro desde el máximo alcance del lazo y confirma que YA NO se deshace la captura al instante — este era el bug real detrás de "el último disparo no capturó".
- [ ] **(P1)** Aléjate mucho del toro mientras lo llevas capturado/calmándose — confirma que la cuerda nunca se rompe por distancia (a propósito, por ahora).
- [ ] **(P1)** Lanza el lazo y observa: debe verse una línea viajando desde el jugador hacia el punto de caída durante ~1 segundo, no un salto instantáneo.
- [ ] **(P1)** Al caer, debe aparecer un círculo translúcido en el punto de impacto representando el área de acierto, que se desvanece.
- [ ] **(P2)** Mueve al jugador MIENTRAS el lazo está en vuelo — confirma que la línea sigue apuntando al punto de origen original del lanzamiento (fijo en el mundo), no se reajusta seguiéndote.
- [ ] **(P3)** Compara el tamaño del círculo con si realmente acertaste o no — es solo orientativo (radio fijo de referencia), no está atado al radio exacto del toro concreto que intentabas capturar.

---

---

## v9 — 10 niveles

### O. Verificación
- [ ] **(P0)** El menú muestra 10 botones de nivel (con scroll si no caben todos en pantalla) + Salir.
- [ ] **(P0)** Nivel 10 → confirma que arranca con 10 toros simultáneos activos y visibles.
- [ ] **(P1)** Prueba un par de niveles intermedios (5, 7) → confirma el número de toros correcto en cada uno.
- [ ] **(P2)** Con 10 toros a la vez, comprueba rendimiento/fluidez — es el escenario más exigente hasta ahora (10 IAs de huida + posibles interacciones de "caos" simultáneas).
- [ ] **(P2)** El scroll del menú funciona bien tanto con ratón (rueda) como (si puedes probarlo) con gesto táctil en el móvil.

---

---

## v10 — Caos por contacto real, no por proximidad

### P. Verificación
- [ ] **(P0)** En un nivel con muchos toros (8-10), captura uno y confirma que ahora SÍ se puede calmar en un tiempo razonable, incluso con otros toros sueltos cerca (pero no tocándolo).
- [ ] **(P1)** Provoca a propósito que un toro suelto choque/se superponga con el que tienes capturado — confirma que en ESE momento sí sube el nerviosismo, y que para en cuanto se separan.
- [ ] **(P2)** Compara la sensación en niveles bajos (2-3 toros, donde raramente había mucho caos) — no debería notarse apenas diferencia ahí, el cambio es principalmente relevante en niveles con muchos toros.

---

---

## v11 — Progresión persistente y tranquilizante

### Q. Verificación
- [ ] **(P0)** Completa el Nivel 1 por primera vez → el botón "Usar Tranquilizante" debe aparecer desde la SIGUIENTE partida (en cualquier nivel).
- [ ] **(P1)** Cierra la app por completo y vuelve a abrirla → el desbloqueo del tranquilizante debe seguir activo (persistencia real, no solo de sesión).
- [ ] **(P0)** Usa el tranquilizante con un toro capturado/calmándose → debe pasar a `CONTROLLED` al instante.
- [ ] **(P1)** Intenta usarlo una segunda vez en la misma partida → no debe hacer nada (botón oculto tras el primer uso).
- [ ] **(P1)** Juega otra partida (reiniciar o nueva) → el tranquilizante debe estar disponible de nuevo automáticamente.
- [ ] **(P1)** Intenta usarlo sin tener ningún toro capturado → no debe pasar nada.
- [ ] **(P2)** Completa el Nivel 2 → nota si el caballo se siente perceptiblemente más rápido en la siguiente partida.
- [ ] **(P2)** Completa el Nivel 4 → deja que un toro salvaje te aturda, cronometra aproximadamente — debería ser más corto que antes.
- [ ] **(P2)** Completa el Nivel 6 → el lazo debería "aterrizar" más rápido tras soltar.
- [ ] **(P2)** Completa el Nivel 8 → deberías poder cargar el lazo más lejos antes de tocar el límite.
- [ ] **(P3)** Verifica que borrar/reinstalar la app (o borrar el archivo de guardado si sabes dónde está) resetea todo el progreso a cero — comportamiento esperado, no un bug.

---

---

## v12 — Captura doble (SIN validación previa de v11 — probar ambas a la vez)

### R. Verificación
- [ ] **(P0)** Sin el Nivel 10 completado, intenta capturar un segundo toro teniendo ya uno — debe seguir bloqueado como antes (límite = 1).
- [ ] **(P0)** Con el Nivel 10 completado, captura dos toros a la vez — deben poder coexistir ambos remolcados simultáneamente.
- [ ] **(P1)** Con 2 toros remolcados, comprueba que el jugador se mueve notablemente más lento que con 0 o 1.
- [ ] **(P1)** El HUD debe mostrar DOS barras de nervios independientes cuando hay 2 toros en `CAPTURED`/`CALMING` a la vez.
- [ ] **(P1)** Si uno de los dos ya está `CONTROLLED` (nervios a 0) y el otro sigue `CALMING`, solo debe verse UNA barra (la del que sigue calmándose).
- [ ] **(P2)** Deja que un toro salvaje te toque teniendo 2 capturados — ahora mismo libera AMBOS de golpe (no solo uno). Dime si prefieres que solo suelte uno al azar/el más reciente — lo cambio si no te convence.
- [ ] **(P1)** Usa el tranquilizante teniendo 2 toros agarrados — debe calmar a AMBOS instantáneamente en el mismo uso.
- [ ] **(P0)** Termina la partida con los 2 toros devueltos — confirma que el conteo del HUD y la condición de victoria funcionan igual que con captura simple.

---

---

## v13 — Niveles con obstáculos (SIN validar v12 — probar todo junto)

### S. Verificación
- [ ] **(P0)** Nivel 1: sin obstáculos, igual que siempre.
- [ ] **(P0)** Recorre los niveles 2-10 y confirma que aparecen obstáculos visibles (bloques de color oscuro) — más presencia en niveles altos.
- [ ] **(P0)** Muy importante: revisa que NINGÚN toro aparece atascado dentro de un obstáculo al empezar la partida (coloqué las posiciones por cálculo, sin verlo correr — si algún toro empieza empotrado en una pared, dime en qué nivel y lo ajusto).
- [ ] **(P0)** Camina contra un obstáculo — debes quedarte bloqueado, no atravesarlo.
- [ ] **(P1)** Persigue a un toro hasta que quede al otro lado de un obstáculo respecto a ti — intenta lanzar el lazo en línea recta a través del obstáculo. [OBSOLETO desde v30/D038] Antes: el lanzamiento fallaba (bloqueado). Ahora debe CAPTURAR al toro igualmente (caso AH1).
- [ ] **(P1)** Lanza el lazo a un toro SIN ningún obstáculo de por medio, a pesar de que existan obstáculos en el nivel — debe funcionar con normalidad.
- [ ] **(P1)** Observa si un toro que huye rodea los obstáculos en vez de quedarse pegado a ellos (mismo comportamiento que ya tenía con la valla exterior).
- [ ] **(P2)** Prueba llevar un toro remolcado cerca de un obstáculo — no debería atravesarlo ni quedar atrapado de forma rara contra él.
- [ ] **(P2)** Nivel 7 y 9 tienen obstáculos altos y estrechos (una especie de "pasillo") — comprueba que no crean una zona donde el jugador o un toro se quede completamente encerrado sin salida.

---

---

## v14 — Corral protegido + acorralar en el perímetro (SIN validar v13 — probar todo junto)

### T. Verificación
- [ ] **(P0)** Lleva un toro `CONTROLLED` casi hasta el corral, y a propósito deja que un toro salvaje se acerque desde el otro lado del corral — confirma que el toro salvaje YA NO puede atravesar la zona del corral para llegar hasta ti.
- [ ] **(P0)** Repite la situación original que reportaste: guarda un toro tranquilo con otro salvaje cerca — confirma que ya no te lo "roban por detrás".
- [ ] **(P0)** Con un toro capturado/calmándose/controlado, camina normalmente HACIA el corral y entra — confirma que TÚ y el toro que llevas seguís pudiendo entrar sin bloqueo (la barrera es solo para toros salvajes).
- [ ] **(P1)** Persigue a un toro suelto directamente hacia cualquier borde del mapa — confirma que ahora sí puedes acorralarlo contra el perímetro en vez de que se quede siempre a una distancia "seguro" del borde.
- [ ] **(P1)** Repite lo mismo empujando a un toro hacia la zona cercana al corral (sin que sea capturado) — debería evitarla igual que evita un obstáculo, no atravesarla ni quedarse pegado en su borde de forma rara.
- [ ] **(P2)** Con el margen reducido, comprueba que los toros no se quedan atascados visualmente contra la valla exterior ni contra obstáculos internos (el peso de evasión bajó, así que si se ve mal, dímelo — es un ajuste de dos números, no un rediseño).
- [ ] **(P2)** Verifica visualmente que no hay ninguna forma extraña en la zona del corral (la barrera nueva no tiene representación visual propia, reutiliza el `Polygon2D` que ya existía del corral).

---

---

## v15 — Nivel 5 desbloquea captura doble + tiempos por nivel

### U. Verificación
- [ ] **(P0)** Con Nivel 5 completado (no hace falta llegar al 10) — confirma que la captura doble ya está activa.
- [ ] **(P1)** Juega el Nivel 10 completo — confirma que 300s es tiempo suficiente para capturar los 10 toros en una partida razonablemente buena (no perfecta). Si sigue sin dar tiempo, dímelo con cuánto te faltó.
- [ ] **(P2)** Juega el Nivel 1 — confirma que 80s no se siente absurdamente corto ni absurdamente largo para 1 solo toro.
- [ ] **(P2)** Compara la sensación de progresión de tiempo entre niveles intermedios (4, 6, 8) — debería notarse un aumento gradual, no saltos raros.

---

---

## v16 — Refactor de limpieza (sin cambios de jugabilidad esperados)

Esta versión NO debería sentirse distinta jugando — es reorganización interna. Si notas cualquier diferencia de comportamiento respecto a v15, es una regresión del refactor, repórtalo con prioridad P0.

- [ ] **(P0)** Repite un par de casos ya validados de versiones anteriores (por ejemplo, el aturdimiento al chocar con un toro salvaje, o la barrera del corral) — deben comportarse exactamente igual que antes.
- [ ] **(P2)** Confirma que ya no aparece ningún `print` de "Lasso landed..." en la consola al lanzar el lazo (el mensaje "Lasso blocked by an obstacle." ya no existe desde v30/D038).

---

---

## v17 — Clic izquierdo ya no lanza el lazo + diagnóstico reactivado

### V. Verificación
- [ ] **(P0)** Toca/haz clic repetidamente en la mitad IZQUIERDA de la pantalla (zona de movimiento) — confirma que YA NO aparece ninguna animación ni marcador de lanzamiento de lazo.
- [ ] **(P0)** Confirma que el joystick de movimiento sigue funcionando con normalidad tras este cambio.
- [ ] **(P0)** Confirma que el lazo sigue lanzándose correctamente desde el joystick de apuntado (mitad derecha) — este cambio no debería afectarlo.
- [ ] **(P1)** Prueba unas cuantas capturas que antes te hubieran parecido "debería haber cazado y no lo hizo" — dime si mejoró tras quitar el bug del clic izquierdo.
- [ ] **(P1)** Si SIGUE fallando alguna captura que parece que debería acertar, copia la línea `Lasso MISSED...` de la consola de ese intento y la reviso con datos reales — no voy a seguir ajustando a ciegas.
- [ ] **(P2)** Confirma que la tecla Espacio (si pruebas en escritorio con teclado) sigue lanzando el lazo con normalidad.

---

---

## v18 — Menú en rejilla + test de SaveData corregido

### W. Verificación
- [ ] **(P0)** El menú muestra los 10 niveles de un vistazo, sin scroll — confirma que se ven bien en rejilla, sin solaparse ni salirse de pantalla.
- [ ] **(P0)** Pulsa cualquier nivel — sigue llevándote a la partida correcta con el número de toros esperado.
- [ ] **(P0)** El botón "Salir" está ahora arriba a la derecha — confirma que cierra la app con normalidad desde ahí.
- [ ] **(P0)** Corre los tests (`godot --headless -s addons/gut/gut_cmdln.gd -gdir=res://tests/unit -gexit`) — confirma que `test_save_data.gd` ya NO muestra el aviso "does not extend GutTest". Si sigue apareciendo, dímelo tal cual salga en consola — no pude reproducir la causa exacta sin ejecutar el editor yo mismo.
- [ ] **(P1)** Tras correr los tests, comprueba que tu archivo `user://save.dat` NO ha cambiado de valor inesperadamente (antes del fix, correr los tests podía sobrescribir tu progreso real).

---

---

## v19 — test_save_data.gd: método renombrado a público

- [ ] **(P0)** Corre los tests otra vez. Si `test_save_data.gd` sigue sin cargar (mismo error de parseo o el mismo aviso), pégame la salida completa de consola tal cual — mi hipótesis puede estar equivocada y hace falta más información para diagnosticarlo bien, no seguir adivinando.
- [ ] **(P0)** Si ahora carga bien, confirma el total de tests — deberían ser 53 según mi recuento de funciones `test_*` en el repositorio (dímelo si GUT reporta un número distinto, por si hay algo más que revisar).

---

---

## v20 — Perseguidor único ("pilla-pilla")

### X. Verificación
- [ ] **(P0)** Con varios toros sueltos (prueba niveles 6+) y uno capturado, confirma que SIEMPRE hay exactamente un toro persiguiéndote activamente, nunca cero, nunca más de uno.
- [ ] **(P1)** Suelta/pierde el toro capturado (rotura de cuerda, tranquilizante, etc.) — confirma que el perseguidor deja de perseguir y vuelve a huir con normalidad.
- [ ] **(P1)** Captura al toro que te estaba persiguiendo — confirma que otro toro salvaje toma el relevo como nuevo perseguidor (no se queda sin perseguidor mientras sigas llevando algo capturado).
- [ ] **(P2)** Observa si el perseguidor parece ser consistentemente el más cercano a ti en el momento del relevo.
- [ ] **(P1)** Compara la sensación general con la versión anterior — ¿se siente ahora manejable/como un pilla-pilla en niveles altos (8-10 toros)?

---

---

## v21 — Modo puzzle de recintos (Nivel 11)

### Y. Verificación
- [ ] **(P0)** Entra al Nivel 11 desde el menú (ahora hay 11 botones) — confirma que carga sin errores.
- [ ] **(P0)** Los 3 toros del Nivel 11 empiezan quietos (no huyen, no hay "pilla-pilla") hasta que abras la puerta.
- [ ] **(P1)** Acércate a la puerta y quédate quieto ~1.2s — confirma que se abre (desaparece) y los 3 toros se activan a la vez (van a ESCAPED).
- [ ] **(P1)** Acércate a la puerta y muévete antes de que se cumpla el tiempo — confirma que el contador de "quieto" se reinicia y la puerta no se abre.
- [ ] **(P2)** Completa el Nivel 11 con normalidad (captura, calma, devuelve los 3 al corral) — confirma que el flujo de victoria es idéntico al de niveles anteriores.
- [ ] **(P0)** Repite un nivel normal (1-10) — confirma que el comportamiento es exactamente igual que antes (los toros siguen saliendo huyendo de inmediato, sin puerta).

---

---

## v22 — Rampa de niveles puzzle 12-15 (2 y 3 pens, hasta 10 toros)

### Z. Verificación
- [ ] **(P0)** El menú muestra ahora 15 botones de nivel; entra a cada uno de 12 a 15 y confirma que cargan sin errores.
- [ ] **(P0)** Nivel 12 (5 toros, 2 puertas): abre solo una puerta — confirma que los toros de la otra puerta siguen quietos/encerrados mientras gestionas los ya sueltos.
- [ ] **(P1)** Nivel 12: prueba abrir primero la puerta de 2 toros y luego la de 3, y en otra partida al revés — confirma que ambos órdenes son jugables (ninguno bloquea el nivel), aunque se sientan de dificultad distinta.
- [ ] **(P1)** Nivel 13 (7 toros, 2 puertas + obstáculos): confirma que los obstáculos no tapan ninguna puerta ni dejan un toro inalcanzable.
- [ ] **(P0)** Nivel 14 (9 toros, 3 puertas): confirma que puedes tener toros de dos puertas distintas sueltos a la vez sin que el juego se rompa (contador de vuelta al corral, perseguidor único, etc. siguen funcionando con 3 focos activos).
- [ ] **(P2)** Nivel 15 (10 toros, 3 puertas, obstáculos): partida completa — confirma que 320s es un tiempo razonable (ni absurdo ni imposible) para vaciar los 3 recintos y devolver los 10 toros.
- [ ] **(P1)** En cualquiera de estos niveles, confirma que ningún toro queda encerrado para siempre (todas las puertas del nivel son alcanzables y abribles).

---

---

## v23 — Persecución probabilística del resto de toros

### AA. Verificación
- [ ] **(P0)** Sin ningún toro capturado, deja pasar 10-15s observando a los toros salvajes — todos deben huir, ninguno debe perseguirte (antes esto podía fallar: un toro secundario podía perseguir aunque no llevaras nada capturado).
- [ ] **(P0)** Captura un toro con el lazo — confirma que, como antes, un toro salvaje empieza a perseguirte, pero ahora con ~1 segundo de retardo perceptible desde la captura (ya no es instantáneo).
- [ ] **(P1)** En Nivel 1 (chase_probability 5%): con un toro capturado, observa al resto durante varios ciclos de 5s — deberían perseguir casi nunca, casi siempre huir.
- [ ] **(P1)** En Nivel 10 o superior (chase_probability 50%, techo): con un toro capturado, alrededor de la mitad de los toros salvajes deberían acabar persiguiéndote, no todos (cada uno dentro de su propio ciclo de 5s, no todos a la vez de golpe).
- [ ] **(P1)** Observa un mismo toro salvaje varios ciclos de 5s seguidos — confirma que puede pasar de perseguir a huir y viceversa (no se queda fijado en un estado).
- [ ] **(P0)** Suelta al toro capturado (o devuélvelo) — confirma que el perseguidor designado Y cualquier perseguidor secundario dejan de perseguir de inmediato, volviendo todos a huir.
- [ ] **(P2)** Compara la sensación en un nivel bajo vs uno alto — el salto de "un perseguidor ocasional" a "la mitad persiguiendo" debería notarse como un salto real de dificultad, sin sentirse imposible.

---

---

## v24 — Enlaces entre puertas (maestra / encadenada / normal)

### AB. Verificación
- [ ] **(P0)** Nivel 11 (un solo recinto): no aparece ninguna línea rosa y la puerta se comporta como antes.
- [ ] **(P0)** Nivel 12: hay una línea rosa entre las dos puertas. Abre primero la puerta NORMAL (pen de 2 toros): solo se sueltan sus 2 toros y la línea desaparece (ya no hay nada por disparar entre puertas cerradas).
- [ ] **(P0)** Nivel 12, nueva partida: abre primero la puerta MAESTRA (pen de 3 toros): se sueltan los 5 toros a la vez y la otra puerta desaparece sola.
- [ ] **(P1)** Nivel 13: la maestra es ahora la puerta del pen pequeño (3 toros). Al abrirla se sueltan los 7 toros.
- [ ] **(P0)** Nivel 14: hay líneas rosas desde la puerta maestra hacia las otras dos, y una desde la encadenada hacia su objetivo. Abre la ENCADENADA: se sueltan sus toros y los de su objetivo (6 toros), la tercera puerta (la maestra) sigue cerrada pero ya no tiene líneas, porque sus dos objetivos están abiertos.
- [ ] **(P0)** Nivel 14: abre la NORMAL primero — solo se sueltan sus 3 toros; la línea que llegaba a esa puerta desaparece, el resto permanece.
- [ ] **(P0)** Nivel 14: abre la MAESTRA — se sueltan los 9 toros, todas las puertas desaparecen y no queda ninguna línea.
- [ ] **(P0)** Nivel 15: repite las tres pruebas anteriores con la disposición distinta (pen 0 normal, pen 1 maestra, pen 2 encadenada al pen 0). Confirma que la maestra suelta los 10 toros.
- [ ] **(P1)** Sin cascada: en cualquier nivel, si una puerta abierta por enlace fuera maestra, NO debe abrir más puertas por su cuenta (solo lo que dispara la puerta que abres tú).
- [ ] **(P1)** Abre una puerta que ya se había abierto por enlace, o una que el jugador ya abrió antes: no debe liberar los toros dos veces ni dar errores en consola.
- [ ] **(P1)** Con la partida en curso, comprueba que las líneas rosas no tapan al jugador ni a los toros de forma que impida jugar (son solo una ayuda de validación).
- [ ] **(P2)** Ningún toro queda encerrado para siempre en ninguna combinación de orden de apertura en los niveles 12-15.

---

---

## v25 — Niveles 15-20: enlaces nuevos con flecha direccional

### AC. Verificación
- [ ] **(P0)** El menú muestra ahora 20 botones de nivel.
- [ ] **(P0)** Niveles 12, 13, 14: ya NO debe verse ninguna línea/flecha rosa — se abren de forma independiente, sin enlaces, como antes de la v0.14.0.
- [ ] **(P0)** Nivel 15: 4 puertas cerca de las esquinas. Hay una única flecha rosa entre dos de ellas, apuntando hacia la que se abre automáticamente. Abre la puerta de origen de la flecha — confirma que la puerta señalada se abre sola.
- [ ] **(P1)** Nivel 15: abre primero una puerta sin flechas — confirma que solo libera sus propios toros.
- [ ] **(P0)** Nivel 16: una puerta tiene flechas hacia otras DOS puertas. Ábrela y confirma que ambas se abren, la cuarta sigue cerrada.
- [ ] **(P0)** Nivel 17: 4 esquinas + 1 puerta central. La central tiene flechas hacia 3 de las 4 esquinas. Ábrela y confirma que esas 3 se abren, la cuarta esquina no.
- [ ] **(P1)** Nivel 18: 6 puertas en posiciones dispersas, en 3 parejas. Abre una puerta de una pareja — confirma que su pareja se abre también. Repite abriendo la OTRA puerta de otra pareja — confirma que también funciona en ese sentido (mutuo, deberías ver dos flechas opuestas en esa línea antes de abrir ninguna).
- [ ] **(P1)** Nivel 19: igual que el 18, pero una puerta abre las 6 de golpe (maestra) — confirma que esa puerta tiene flechas hacia las 5 restantes, y que abrirla libera los 10 toros.
- [ ] **(P2)** Nivel 20: 8 puertas dispersas, mezcla de tipos — confirma que no se rompe nada con tantas puertas a la vez y que ningún toro queda inalcanzable.
- [ ] **(P1)** En cualquier nivel 15-20, confirma que las posiciones de las puertas no se superponen con obstáculos, la valla, el corral o el spawn del jugador de forma que bloquee el nivel.

---

---

## v26 — Nervios visibles: velocidad, color y sin solapes

### AD. Verificación
- [ ] **(P0)** Captura un toro y suéltalo sin calmarlo nada (nervios altos) — al escaparse, debe huir a velocidad normal (la misma de siempre).
- [ ] **(P0)** Captura un toro, cálmalo bastante (nervios bajos pero sin llegar a CONTROLLED) y provoca que se suelte (deja que otro toro salvaje te golpee mientras lo llevas) — el toro liberado debe huir notablemente más despacio que uno recién escapado, y no acelerar después.
- [ ] **(P1)** Compara dos toros salvajes a la vez, uno recién escapado y otro liberado a bajos nervios — deben verse claramente distintos en color (más verde el de bajos nervios, más naranja el recién escapado) y en velocidad.
- [ ] **(P0)** Observa un toro mientras lo calmas (CALMING) — el color debe ir cambiando de forma gradual y continua hacia el verde a medida que baja la barra de nervios, no dar saltos bruscos solo al cambiar de estado.
- [ ] **(P1)** Deja que un toro CONTROLLED (nervios 0) sea golpeado por otro salvaje mientras lo llevas al corral — confirma que se suelta y que se mueve muy despacio (pero visiblemente, no completamente congelado).
- [ ] **(P0)** Con varios toros sueltos a la vez, comprueba que dos toros nunca llegan a superponerse visualmente — se empujan o rodean entre sí en vez de atravesarse.
- [ ] **(P1)** Acércate con un toro salvaje a un grupo de toros encerrados en un pen (niveles 11+) — confirma que el salvaje los rodea en vez de atravesarlos, sin quedarse atascado de forma extraña.
- [ ] **(P2)** Sensación general: un toro de bajos nervios liberado debería sentirse claramente más fácil de recapturar que uno recién escapado.

---

## v27 — Orden en el Rancho (changelog 0.17.0)

### AE. Verificación (los tests automáticos ya cubren la lógica; esto es lo que solo se ve jugando)
- [ ] **(P0)** Nivel 3 (o cualquier nivel con menos de 10 toros): ningún toro choca contra "nada" ni se detiene sin motivo en las posiciones donde antes había toros ocultos.
- [ ] **(P0)** Niveles 7, 8, 9, 10 y 15: el jugador y todos los toros aparecen libres (ninguno dentro de una pared) y el obstáculo movido no hace el nivel imposible ni trivial.
- [ ] **(P0)** Build de RELEASE: solo el nivel 1 está abierto con partida nueva; completar el 1 abre el 2; los demás muestran "(bloqueado)". En build de depuración todos están abiertos.
- [ ] **(P0)** Android: pasar la app a segundo plano en mitad de un nivel y volver — aparece "Pausa", el contador no ha saltado, "Continuar" reanuda.
- [ ] **(P0)** Android: botón atrás en un nivel abre/cierra la pausa; en el menú principal cierra la app.
- [ ] **(P1)** Pausa con el lazo cargando o en vuelo: al continuar no hay disparos ni capturas fantasma.
- [ ] **(P1)** "Menú principal" desde la pausa vuelve al menú y el siguiente nivel arranca sin quedarse en pausa.
- [ ] **(P1)** Persecución: sin ninguna captura todos huyen; con captura aparece UN perseguidor tras ~1s; el comportamiento general se siente igual que en v26.
- [ ] **(P2)** Guardado: cerrar y reabrir la app conserva el progreso. (Un archivo de guardado corrupto debe arrancar como partida nueva sin crashear.)

---

## v28 — Hueco en el Corral (changelog 0.18.0)

### AF. Verificación
- [ ] **(P0)** Nivel 20 (o 10): se pueden meter los 10 toros en el corral, uno tras otro, sin que ninguno se quede atascado contra los ya entregados.
- [ ] **(P1)** Un toro remolcado atraviesa visualmente a otros toros (salvajes o ya en el corral) sin empujarlos ni ser frenado; sigue chocando con vallas y obstáculos.
- [ ] **(P1)** Un toro salvaje sigue sin poder entrar en el corral (barrera D013) ni solaparse con otros toros salvajes.
- [ ] **(P1)** Un toro soltado (te golpea otro toro) vuelve a ser sólido y no queda "incrustado" en otro toro.
- [ ] **(P1)** Provocar que el perseguidor se atasque (esquina/obstáculo/grupo de toros): tras ~1s otro toro pasa a perseguirte y el atascado vuelve a huir; nunca hay dos perseguidores designados.
- [ ] **(P2)** No hay relevos de perseguidor "espurios" cuando un toro roza una valla persiguiéndote con normalidad.

---

## v29 — Dedo Suelto (changelog 0.19.0)

### AG. Sticks y apuntado (solo se juzgan con el dedo, en dispositivo)
- [ ] **(P0)** Movimiento: arrastra el pulgar lejos del punto de contacto y cambia de dirección (incluso a la contraria): la respuesta es inmediata, sin tener que "volver" al centro. La base del stick te sigue.
- [ ] **(P0)** Apuntado: arrastra lejos y luego acorta retrocediendo un poco: la línea de carga se acorta a la vez, sin tener que volver al punto inicial.
- [ ] **(P0)** Apuntado: arrastra y cambia de dirección sin soltar: la línea gira con el dedo sin retrasos raros.
- [ ] **(P0)** Soltar el stick de apuntado casi en su centro (o tocar sin arrastrar) NO lanza el lazo: no se gasta lanzamiento ni aparece marcador de aterrizaje. La línea de carga desaparece mientras estás en esa zona.
- [ ] **(P1)** El alcance máximo se alcanza con un arrastre cómodo; un lanzamiento corto (~mitad de alcance) es repetible.
- [ ] **(P1)** Con movimiento y apuntado a la vez (dos pulgares), ninguno interfiere con el otro ni se queda "pegado" al soltar.
- [ ] **(P2)** Si la base sigue al dedo demasiado pronto/tarde o el stick es incómodo de grande/pequeño: anotar y ajustar `clampzone_ratio` / `joystick_size` en `level_0.tscn` (D037).

---

## v30 — Lazo Sin Muros (changelog 0.20.0)

### AH. Lazo y soltar toros
- [ ] **(P0)** Colócate detrás de un obstáculo con un toro al otro lado y lanza el lazo justo sobre él: lo captura.
- [ ] **(P0)** Con un toro capturado, doble toque rápido en el stick de apuntado (sin arrastrar): el toro se suelta y huye; sigue la barra de nervios del resto.
- [ ] **(P0)** Un solo toque no suelta nada (solo cancela); dos toques separados por más de ~0,4 s tampoco.
- [ ] **(P1)** Con captura doble, el doble toque suelta solo el último que capturaste.
- [ ] **(P1)** Un toro soltado a propósito no te aturde aunque quede pegado a ti; pasado ~1 s sí vuelve a ser un riesgo.
- [ ] **(P1)** Arrastrar y lanzar entre dos toques no suelta ningún toro.
- [ ] **(P2)** ¿Es fácil soltar por accidente al apuntar con prisas? Si lo es, ajustar `TAP_MAX_SECONDS` / `DOUBLE_TAP_WINDOW_SECONDS` en `lasso_aim.gd`.

---

---

## Cómo reportar resultados
Si algo falla, dime: qué caso (letra+número), qué esperabas, qué pasó. Lo uso para decidir si es bug de código o ajuste de diseño, igual que hemos hecho hasta ahora.

## Historial de versiones
- **v1**: primera versión, cubre el vertical slice completo hasta el sistema de joysticks táctiles.
- **v2**: añadido tras el sistema de animación direccional (8 direcciones vía 5 sets de arte + espejado). Ver casos H.
- **v3**: sustituido el joystick táctil propio por el nativo `VirtualJoystick` de Godot 4.7. Ver casos I.
- **v4**: joysticks agrandados, radio de acierto del lazo corregido/ampliado, botones de fin de partida. Ver casos J.
- **v5**: escalado a pantalla real (stretch mode), joystick de movimiento pasa a dinámico. Ver casos K.
- **v6**: precisión del lazo (vector exacto al soltar), botones de fin de partida ya pulsables, retraso de vuelo de 1s. Ver casos L.
- **v7**: menú principal con selección de nivel (1-4 toros), "Finalizar" ahora vuelve al menú en vez de cerrar la app. Ver casos M.
- **v8**: cuerda infinita (sin rotura por distancia, por ahora), animación de vuelo del lazo + círculo de área al caer. Ver casos N.
- **v9**: ampliado a 10 niveles (1-10 toros), menú con lista de niveles generada por código. Ver casos O.
- **v10**: el caos entre toros ahora exige contacto físico real, no solo proximidad. Ver casos P.
- **v11**: sistema de progresión persistente (mejoras desbloqueables por nivel completado) + objeto tranquilizante. Ver casos Q.
- **v12**: captura doble (Nivel 10) — sin validar v11 primero, riesgo aceptado explícitamente. Ver casos R.
- **v13**: niveles con diseño propio (obstáculos por nivel vía `LevelCatalog`), bloquean movimiento y el lazo. Ver casos S.
- **v14**: barrera física del corral contra toros salvajes, corrección de evasión de bordes (acorralar ahora funciona). Ver casos T.
- **v15**: captura doble movida a Nivel 5, tiempo límite específico por nivel. Ver casos U.
- **v16**: refactor de limpieza (sin cambios de jugabilidad) — `is_held()`/`is_wild()`, `CollisionLayers`, `print` de depuración retirado.
- **v17**: corregido que tocar la mitad izquierda (movimiento) también lanzaba el lazo. Diagnóstico de precisión de captura reactivado. Ver casos V.
- **v18**: menú rediseñado sin scroll (rejilla 5×2, salir arriba-derecha), test de `SaveData` corregido para no escribir en tu guardado real. Ver casos W.
- **v19**: el error de parseo de `test_save_data.gd` era real — método renombrado de privado a público, hipótesis no confirmada del todo.
- **v20**: agresividad probabilística sustituida por un único perseguidor "pilla-pilla". Ver casos X.
- **v21**: modo puzzle de recintos — Nivel 11, un pen con puerta de "hold to open" que encierra 3 toros hasta abrirla. Ver casos Y.
- **v22**: rampa de niveles puzzle 12-15 — 2 pens (12-13), 3 pens (14-15), hasta 10 toros repartidos en 3 puertas en el nivel 15. Ver casos Z.
- **v23**: persecución probabilística — el perseguidor designado tarda 1s en engancharse tras una captura; el resto de toros salvajes reevalúan cada 5s si también persiguen, con probabilidad 5%-50% según el nivel (D024; el texto original decía 10%-100%). Ver casos AA.
- **v24**: enlaces entre puertas — maestra (abre todas), encadenada (abre otra concreta) y normal; línea rosa de validación; aplicado a niveles 12-15. Ver casos AB.
- **v25**: niveles 15-20 rediseñados con enlaces nuevos y flecha direccional; 12-14 revertidos a sin enlaces. Ver casos AC.
- **v26** (= changelog 0.16.0): velocidad de huida y color proporcionales al nerviosismo del toro al soltarse; los toros ya no se solapan entre sí. Ver casos AD.

---
- **v27** (= changelog 0.17.0): bloqueo de niveles, pausa/atrás Android, guardado validado, toros sobrantes inertes, obstáculos corregidos. Ver casos AE.

Equivalencia plan <-> changelog desde que existe el changelog: v11=0.6.0, v12=0.7.0, v13=0.8.0, v14=0.9.0, v15=0.9.1, v16=0.9.2, v17=0.9.3, v18=0.9.4, v19=0.9.5, v20=0.10.0, v21=0.11.0, v22=0.12.0, v23=0.13.0, v24=0.14.0, v25=0.15.0, v26=0.16.0, v27=0.17.0, v28=0.18.0, v29=0.19.0, v30=0.20.0.
- **v28** (= changelog 0.18.0): toros sostenidos/entregados sin colisión con toros, relevo del perseguidor bloqueado. Ver casos AF.
- **v29** (= changelog 0.19.0): sticks en modo FOLLOWING y cancelación del lanzamiento al soltar cerca del centro. Ver casos AG.
- **v30** (= changelog 0.20.0): el lazo ya no lo bloquean los obstáculos; doble toque suelta un toro. Ver casos AH.
