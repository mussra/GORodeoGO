# Rancho Prueba 2.7.148

## Salto de memoria: primera prueba jugable
Entrada "Salto de memoria" en el menú, junto a los modos de prueba. Cuatro vallas con colores y números, en una pista visible completa y con minimapa.

1. Mira cómo se iluminan las vallas, una cada vez. El caballo espera quieto.
2. Cuando dice TU TURNO, usa el joystick izquierdo para recorrer la pista. Acércate de frente a una valla: el caballo salta automáticamente con el mismo salto real y colisión que en el mundo.
3. Repite esos saltos en el mismo orden. Solo cuenta un salto completo que cruza una valla; caminar alrededor no cuenta.
4. Una ronda acertada añade una valla a la secuencia. Se permiten repeticiones. La prueba termina al recordar seis saltos.

Orden incorrecto: se detiene la ronda y puedes volver a ver y repetir la misma secuencia, sin penalización externa. "Ver secuencia" permite repasar durante tu turno, reiniciando ese intento. Pausa y vuelta al menú. Sin cronómetro de castigo.

Se usa una montura de entrenamiento con salto para que la prueba no dependa de desbloquearlo en un caballo guardado. No cambia sus capacidades reales, progreso, puntos ni maestría. Sin lazo ni sprint en este modo. Sin compras ni arte nuevo: jinete y vallas existentes, señales geométricas con números/colores.

## Verificación
76/76 pruebas dirigidas de regresión y nuevas, 546 aserciones; después se añadió y pasó una prueba de entrada del menú en tres tamaños, con 12 comprobaciones adicionales. Suite nueva aislada:11/11,73 aserciones. Saltos reales automáticos de las cuatro vallas desde ambos lados, orden correcto/incorrecto, secuencia creciente, cancelación sin punto, joystick táctil simulado, pausa, repetición y ausencia de guardado. Capturas reales inspeccionadas. Sin Android físico ni valoración humana aún de dificultad, ritmo o diversión.

Se conservan los demás modos y la música corregida sin silbido. La reorganización del juego alrededor de Frontera es solo una propuesta: no se han borrado niveles ni cambiado recompensas o maestría.

APK arm64, `com.example.rancho.review`, versionCode407, misma firma. Solo rama de pruebas; sin main, web ni tienda.
