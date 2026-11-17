# Rancho Prueba 2.7.185: topes y herencia por media

Código 444, mismo paquete y firma. Instalar encima. Solo rama de prueba, sin main ni tienda.

## Topes reales

Velocidad 300, Manejo 1500, Fuerza 0,9, Agilidad 1 y Serenidad 2. Se usan los máximos existentes de la ficha. Antes, el crecimiento se sumaba después del límite: corregido para juego, herencia, guardado, linaje y animación.

La ganancia se recorta al espacio restante. Si quedan 0,4 puntos, aparece +0,4 pts, no +2. Si ya está al máximo, aparece Máximo y no se dibuja estrella ni tramo ganado falso. La barra llega a su final exactamente en el máximo. Las otras mejoras del mismo premio siguen funcionando.

Los guardados anteriores conservan caballos, victorias y contadores de progreso. Se consolida una sola vez su mejora real, limitada al máximo, para no sumarla dos veces. El crecimiento posterior conserva los rendimientos decrecientes. Un caballo que estaba por encima del tope pasa al máximo, no lo mantiene por encima.

Los premios exclusivos y supremos también respetan estos topes. Si la familia ya está al máximo, el exclusivo no lo supera: conserva su identidad y brillo. No se eliminan premios ni se altera el progreso de maestría.

## Crías: media de ambos padres

Cada nueva cría hereda la media aritmética de las cinco propiedades efectivas de ambos padres, incluidas sus mejoras y con los topes aplicados. Sin redondeo interno, sin azar ni mutación de propiedades. Los campos antiguos ausentes usan el valor base habitual, no cero. No se recalculan crías anteriores. Aspecto, aprendizaje y condiciones de cruce mantienen sus reglas propias.

## Validación

289/289 pruebas, 44.243 aserciones y 48 scripts. Casos de cientos de victorias al máximo, varias ganancias cerca del límite, premio mixto con una propiedad llena, migración de exceso antiguo, guardado y recarga sin doble crecimiento, herencia media fraccionaria, nacimiento real, linaje exclusivo y supremo al máximo, animación y estrella limitadas al tramo real. Se amplía la batería con colección, herencia de aspecto y resumen de propiedades.

Capturas revisadas durante y después: Manejo Máximo, Agilidad +0,4 pts y Serenidad +0,67 pts. Continuar probado con entrada táctil simulada. Sin Android físico. Cuatro deprecaciones, avisos UID de GUT y errores de guardado intencionados. El arnés visual avisa de dos ObjectDB al cerrar; la batería final no muestra ese aviso.
