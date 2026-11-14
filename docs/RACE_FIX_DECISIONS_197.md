# Correcciones de carreras, ciclo 197

- Regate contra el borde: al recortar un trazado fuera de pista, se termina ese trazado sin reintegro de recarga. No se altera el movimiento normal ni se cambia de ramal en el cruce. La valla continúa siendo una colisión física compartida.
- Mantener apuntado durante recarga conserva la intención de apuntar, no una orden de disparar. La salida sigue dependiendo de una liberación válida cuando está listo. Una liberación prematura no se ejecuta más tarde. Sin reducir los 3 s de recarga.
- La IA obtiene el mismo impulso trazado que el jugador en lugar de quitar el impulso al jugador. Alcance de trazado 250 frente al límite compartido 260, recarga compartida 2,5 s. No usarlo cerca de una valla ni pegado al borde. Sin multiplicador oculto de velocidad, recuperación por distancia, avance de puertas artificial o teletransporte.
- Trazada interior elegida por los rivales, dejando de conservar el carril decorativo de salida. Vallas, salto y hueco siguen siendo obligatorios por geometría real.
- No se ha aplicado un segundo parado porque la frase sobre el lazo no aclara el destinatario. Esperar respuesta de Ant antes de penalizar al tirador o cambiar el efecto del impacto.

Tests antes de corregir: 0/2 pasaban; regate con 114 puntos pendientes, remaining=1, velocidad 572 sin avanzar. Después: finaliza y permite movimiento/lazo. Verificación completa y ocho simulaciones descritas en RELEASE_2_7_142.md. La comparación no sustituye una prueba humana de dificultad.
