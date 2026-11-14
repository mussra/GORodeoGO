# Justa de lazos: decisiones para probar

Petición de Ant, 14 de noviembre: "Otro tipo de duelos puede ser las justas pero con lazos. No estoy seguro de que se quede para la versión final pero impleméntalo para probarlo".

- Modo aparte, no reemplaza el duelo libre ni introduce requisitos en la copa.
- Galope automático en direcciones contrarias para que la prueba se centre en el momento de soltar el lazo. La mano izquierda ajusta la línea vertical y conserva el regate compartido. El avance no puede invertirse ni salir de la pista.
- Mismo primer lazo válido y mejor de tres del duelo. Una pasada sin captura no da punto y se reinicia con confirmación desde los lados contrarios; se distingue pasada de manga. Empate simultáneo sin punto.
- IA con reacción cuando el vuelo ya es visible (65% del trayecto), no esquiva perfecta desde el momento del lanzamiento. La primera simulación con reacción inmediata quedaba 0-0 indefinidamente y fue descartada. No se ha concluido que el ajuste actual sea divertido o equilibrado para personas.
- Reutilizar todo el movimiento, arte, lazo y regate. Dos puntos de extensión mantienen idéntico comportamiento del mundo/duelo salvo en esta pista de pasadas. La IA no lee los botones de lazo del jugador.
- Sin lanzas, daño, monedas, inscripción, premios, mejoras de caballo ni progreso persistente. Se puede quitar el prototipo sin migrar guardados.
- Menú con dos entradas de duelo compactas para no cubrir Salir. Posiciones revisadas visualmente y por pruebas de rectángulos a 960×540, 1280×720 y 1600×720.

Pendiente: probar con Ant, medir si la ventana de lazo es legible y si conviene conducción manual, otras distancias o eliminar este modo. No incorporarlo a producción por inercia.
