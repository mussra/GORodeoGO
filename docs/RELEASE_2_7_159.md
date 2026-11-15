# Rancho Prueba 2.7.159

## Carreras: menos texto

- Pantalla de carrera centrada en posición/tiempo, estado corto del lazo, barra de progreso y minimapa.
- Quitados la clasificación larga, velocidad, porcentaje, descripción de puertas y el aviso largo de vallas durante el juego.
- El aviso de parada solo aparece cuando se recibe el lazo: "Parado 1.0 s". Desaparece al recuperarse.
- Ayuda corta de controles en Pausa. La leyenda del mapa queda en el mapa ampliado.
- Misma parada de 1 segundo, sprint, lazo, IA, circuitos y premios que 2.7.158. Sin cambios de equilibrio ni huerto.

Capturas de juego normal y parado revisadas a 960×540 y enviadas antes de publicar. Sin recortes ni solapes.

## Pruebas

65 casos dirigidos de carreras, mapa y controles: 63 pasan; quedan los mismos dos casos heredados de carreras (entrada del mapa y antigua expectativa de esquive automático de IA) que también fallan en 2.7.156. La prueba nueva de interfaz, parada, copa, recuperación, controles, textos y liberación del mapa pasa. El detalle está en `QA_2_7_159.json`.

También se corrigió el conductor de prueba de los niveles 15-19: no debe recapturar mientras el jugador está aturdido. Con esa restricción real consigue la primera entrega en los cinco niveles, sin cambiar el comportamiento del juego. La alerta anterior de cero entregas no era una base válida para bajar dificultad. El análisis `BALANCE_221_PROPUESTA.md` compara tres opciones con datos y límites, sin aplicarlas.

No se ha repetido la batería completa de 285 scripts. Sigue deuda anterior y avisos de recursos al cerrar algunas pruebas. Sin Android físico.

## Análisis, no cambios de juego

Se adjuntan propuesta y datos de afinidad regional y niveles 15-19. La opción 70/60 sigue activa. No se ha ajustado ni el +25% por rasgo ni la dificultad, ni se ha decidido nada del huerto.

## Archivo Android

Paquete `com.example.rancho.review`, código 418, 82194615 bytes. Misma firma que 2.7.158.

SHA-256: `d2d1af071c18dc6bbc3a153dd7d7d7a45d07debcc53d0cfb7634f77f734061a8`.
