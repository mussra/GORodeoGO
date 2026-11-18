# Rancho Prueba 2.7.192

## Látigo de chasquido
- Nuevo equipo de Juanito: 250 puntos del juego; mejora por 500 puntos adicionales, requiere el básico. Comprar y equipar. No se entrega por defecto.
- Usa una ranura independiente: no sustituye la fusta de regate ni modifica su gesto.
- Botón Látigo de 112×112, mayor que los relojes de 76×76. Muestra LISTO y cuenta atrás con arco de reloj; recarga básica 5 s, mejorada 4 s. Situado a la izquierda de espuelas y relojes, sin tapar esos controles ni los botones contextuales centrales.
- Chasquido sonoro breve, sin contacto, golpes ni daño. Con sonido desactivado se mantiene la respuesta visual del botón.
- Toro libre: frena, gira y se aparta brevemente. Cerdo y cabra libres: se alejan. Caballo libre: se aparta de forma más corta. No cambia su salud, genotipo ni propiedad, no suelta animales ya capturados.
- Radio básico 240 px; mejorado 310 px. El movimiento usa las colisiones/límites ya existentes.

## Cabra enlazada, petición de Ant
Si una cabra ya va enlazada y viene hacia ti, el chasquido permite capturarla inmediatamente. Se usa la captura/guardado/recompensa actuales, sin doble cobro ni doble registro. No captura cabras libres, no salta los requisitos de misión y exige estar a 240 px como máximo, incluso con la mejora. Solo se puede mantener la captura enlazada actual y hay que esperar la recarga para el siguiente chasquido. Son valores de prueba, pendientes de sensación/balance en móvil.

## Pruebas
366/366 pruebas de regresión seleccionada, 54.155 aserciones, 59 scripts. Compra, equipo, mejora y recarga de partida comprobados aparte con 250+500 puntos del juego. Clic real inyectado en el botón, capturas de listo/recargando inspeccionadas. Prueba de cabra enlazada, guardado y protección de registro duplicado.

Un aviso GUT, 18 deprecados heredados y dos objetos al cerrar siguen presentes. No certifica toda la suite histórica ni Android físico. Falta probar el tacto y balance real en móvil. Sin cambios de historia, sin retirar sistemas, sin main, tienda ni gastos reales. Mismo paquete/firma de Rancho Prueba, versionCode451.
