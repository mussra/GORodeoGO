# Decisiones del prototipo de duelo y cruces

## Aplicadas
- Duelo jugador contra IA, no multijugador. Arena pequeña, ambos con velocidad igualada, salida fuera del alcance del lazo y lados alternos.
- Regla de Ant: primer lazo válido gana, mejor de tres. Se termina al conseguir dos victorias.
- Un empate de impactos en el mismo paso de física repite sin punto; lo decide la llegada, no quién se procesa primero. No hay muerte súbita ni vencedor por reloj.
- Confirmación entre mangas y reinicio de controles. La pausa cancela el lazo propio en curso para que no resuelva una victoria detrás del modal; el tiempo de juego queda parado.
- El cuerpo de movimiento del mundo se extrae a una función compartida sin cambiar su lógica. El duelo llama esa función y reutiliza lazo/regate, no una copia nueva.
- El roce de cruce usa 28% de frenado durante 0,65 s, con 1,5 s de protección. Balance provisional y reversible. Ambos jinetes se frenan; no se otorga prioridad invisible.
- El ocho añade un cruce central con dos pasos por vuelta, sin sustituir las otras pistas. Se limita al ramal actual para evitar atajos.

## Pendiente antes de producción
- Android real y sesiones humanas, especialmente dificultad del rival, tacto simultáneo, lectura de arena/cruce y duración de partidas.
- Ajustar la frecuencia de encuentros del cruce. Que se pueda terminar no demuestra por sí solo que sea trepidante.
- Progresión entretenida de dos o tres días hacia caballo especial y objeto elemental. Todavía no está implementada ni validada.
- Inscripción y premios con moneda del juego, cantidades, herencia de la cualidad especial, guardado/versionado y conexión con la historia: decisiones de diseño pendientes, no cobros ni recompensas ocultas en este avance.
- Sin publicar web, sin tienda, sin tocar `main`, sin gastos.
