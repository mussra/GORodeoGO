# Rancho Prueba 2.7.139

APK de pruebas, no versión de tienda. Incluye el circuito con cruce y el prototipo de duelo de lazos. Rama `feat/open-world-test-20261107`; `main` y web sin cambios.

## Duelo de lazos
- Entrada "Duelo de lazos · prueba" en el menú. Jugador contra Luna, controlada por el juego.
- Dos jinetes: el primer lazo que captura válidamente gana la manga. Mejor de tres, termina a dos victorias (2-0 o 2-1).
- Si ambos impactos llegan en el mismo paso de física, se repite la manga sin punto, sin favorecer el orden de procesamiento.
- Cuenta atrás, posiciones de salida simétricas y lados alternos. Siguiente manga con confirmación, no automática mientras se lee.
- Misma base de movimiento, lazo, vuelo de 0,35 s y regate. Sin daño, golpes ni cambios de los caballos.
- Marcador, pausa, repetir duelo y salir. Reinicio de la entrada táctil entre mangas para que un dedo retenido no siga moviendo o apuntando en la siguiente.
- La IA se acerca, mantiene distancia y puede esquivar un lazo que ya está en vuelo; no usa una captura instantánea ni un sistema paralelo.

## Carreras con cruce
- Cuarto circuito: "Cruce del molino", en ocho. Los tres anteriores siguen disponibles.
- Un roce con un jinete del otro ramal dentro del cruce frena brevemente a ambos, sin aturdir ni bloquear. Protección contra frenados continuos.
- El recorrido conserva el ramal de cada jinete, y las puertas exigen orden y tramo correcto: no se puede cortar media vuelta por la intersección.
- Mapa en ocho con marca del cruce. Los rivales pueden tomar el hueco de una valla si llegan de lado y quedan bloqueados, sin teletransporte.

## Validación
- 711/711 pruebas unitarias y 116/116 pruebas dirigidas de integración.
- 59/59 pruebas adicionales centradas en movimiento compartido, duelo, carreras, lazo y menú tras cerrar el reinicio táctil.
- Ocho combinaciones de carreras simuladas: cuatro circuitos, con/sin salto, cuatro participantes y 16 puertas en cada una.
- Duelo simulado completo 0-2; pruebas de 2-0, 2-1, empate simultáneo, impacto de un lazo real, pausa, salida, límites de arena y movimiento/apuntado con dos dedos simulados.
- Inspección visual de menú, arena, vuelo, pausa, marcador de manga/duelo y formato ancho; mapa y cruce de carreras revisados.
- APK arm64, paquete `com.example.rancho.review`, versionCode 398 y misma firma de pruebas.

Todas estas pruebas son de escritorio. Falta validar instalación, tacto, legibilidad y rendimiento en Android real y jugar sesiones humanas para ajustar dificultad/diversión. Los avisos de limpieza al cerrar algunos bancos de pruebas siguen pendientes; no es certificación de producción.

No hay inscripción, recompensas, caballo nuevo, objeto elemental ni cambios persistentes de progresión en este APK. Ese siguiente ciclo sigue pendiente. El duelo no incluye multijugador ni red.
