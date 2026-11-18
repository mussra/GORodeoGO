# Rancho Prueba 2.7.187

- Equipo: arrastrar la lista con el dedo y rueda del ratón; barra lateral más ancha. El mismo panel funciona en el taller, menú y vendedores de otros pueblos. Arrastrar no compra ni equipa; tocar abre la confirmación habitual.
- Nuevo Lazo largo de captura en Juanito: 200 puntos del juego, compra única y equipar después. No viene comprado ni activo por defecto. En Frontera, alcance +50% (220 a 330 px con el básico) y radio de captura de cerdos/cabras de 58 a 80 px. El círculo también refleja ese tamaño. No mejora toros ni cambia vuelo, ranuras, persecución o soltar capturas tras golpe.
- Al llegar con el dedo al borde de pantalla se mantiene el movimiento. Levantar/cancelar el dedo, perder foco o abrir una pausa lo detiene. No se cambia el modo actual de control.
- Rótulo de llegada al pueblo: fondo ajustado al texto, altura acotada, sin tapar el mapa a distintos zooms.
- Equipo comprado/equipado y recompensas de retos siguen guardados en la partida. Verificado cambiar posición de mundo, guardar, vaciar estado y recargar: conserva equipo, puntos, pruebas, victorias y maestría.

## Verificación
314/314 pruebas, 53.717 aserciones en 51 scripts. Arrastre/rueda hasta último artículo y toque de confirmación sin gastar, tanto panel directo como taller y dos tamaños de pantalla. Bordes de pantalla mantienen entrada y soltar deja entrada a cero; pausa/foco cancelan. Capturas inspeccionadas. Firma y paquete de prueba conservados, código 446.

## Límites y decisiones
Precio 200 puntos y valores +50% / 80 px son propuesta de balance. No altera compras anteriores ni concede el lazo gratis. El equipo comprado persiste aunque su efecto sea específico de una actividad. Sin prueba en Android físico; verificación local con entrada táctil sintetizada. La suite informa 7 usos obsoletos, sin fallos. Solo rama de pruebas, sin main, tienda ni gasto real. Joystick anclado configurable queda para 2.7.188 sin quitar el actual.
