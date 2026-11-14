# Propuesta: duelo de lazos

Estado: propuesta, no implementada ni publicada.

## Reglas pedidas por Ant
Dos jinetes intentan capturar al otro con el lazo. El primer lazo que captura válidamente gana la manga. El duelo es al mejor de tres: termina cuando un jinete gana dos mangas, por lo que puede acabar 2-0 o 2-1. No se fuerza una tercera manga cuando el resultado ya está decidido.

Sin violencia. La captura termina la manga, sin daño, golpes, combate ni castigos persistentes. Reutilizar el lazo, su vuelo de 0,35 s, apuntado, captura y regate compartidos; no crear otro sistema parecido.

## Primer prototipo propuesto
- Jugador contra un rival controlado por el juego, en una arena pequeña y legible. Esto es una decisión propuesta: todavía no implica multijugador, red ni segundo mando.
- Posiciones de salida simétricas, separación inicial fuera del alcance del lazo y una cuenta atrás de tres segundos. Se alternan los lados entre mangas.
- Velocidad igualada y lazo/regate disponibles para ambos. El rival solo reacciona a un lazo que ya está en vuelo, no al gesto futuro del jugador.
- Marcador de mangas, indicación de ronda, pausa, repetir y salir. Sin inscripciones, recompensas ni cambios de los caballos en esta fase.
- Al capturar se cancela la entrada y se muestra ganador de manga. El jugador confirma la siguiente; no empieza inesperadamente mientras lee el resultado.

## Casos que debe resolver la implementación
- Si ambos lazos impactan en el mismo paso de física, proponer manga empatada y repetirla sin punto; evita que el orden de procesamiento de los jinetes decida el ganador. Esta excepción no cambia la regla normal de primer impacto.
- Un lazo soltado antes del resultado no puede sumar un segundo punto después. Pausa, salir o reintentar cancelan tareas y vuelo pendientes.
- Rechazar capturas fuera de alcance o fuera de la arena. Regate desplaza realmente al jinete; no es una tirada de probabilidad.
- No declarar ganador por reloj. Si la manga se alarga, permitir continuar o salir. El límite de duración y cualquier desempate posterior son decisiones de diseño, no reglas ya asumidas.

## Verificación necesaria
Pruebas de 2-0 y 2-1, primer impacto, empate simultáneo, lazo en vuelo al terminar, pausa, reinicio, salida, tacto simultáneo y ausencia de escrituras de progreso. Luego sesiones humanas para ajustar tamaño de arena, dificultad y lectura del rival antes de ofrecer premios o conexiones con la historia.

Es un modo separado de las carreras y no reemplaza el objetivo de preparar el juego completo para producción.
