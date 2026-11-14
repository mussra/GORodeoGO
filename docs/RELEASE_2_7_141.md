# Rancho Prueba 2.7.141

Añade "Justa con lazos" como modo de prueba aparte en el menú. Incluye también la copa, caballo y objeto narrativo de 2.7.140. Rama `feat/open-world-test-20261107`; sin cambios en main, web ni tienda.

Ant pidió probar justas con lazos sin decidir aún si quedarán en la versión final. Este es un prototipo para valorar esa idea, no un modo final.

## Cómo se juega
- Tú contra Luna. Dos jinetes parten de extremos opuestos y galopan automáticamente hacia el cruce.
- Izquierda: subir/bajar para ajustar la línea y usar el mismo regate. Derecha: apuntar y soltar el mismo lazo. No se conduce hacia atrás ni se abandona la pista de pasadas.
- El primer lazo válido gana la manga. Mejor de tres, termina a dos puntos. Impactos simultáneos repiten sin punto.
- Si termina la pasada sin captura, no se regala un punto: "Otra pasada" confirma el nuevo intento desde los extremos contrarios. Las mangas y pasadas se muestran por separado.
- Cuenta atrás, pausa, vuelta al menú y repetir la justa. Se limpian movimiento, apuntado y vuelo entre pasadas.
- Sin lanzas, daño, premios ni escritura de progreso. La justa no cuenta como el duelo de la copa.

## Se conserva lo compartido
Mismo jinete, arte, anclaje de mano, movimiento, lazo de 0,35 s y regate del resto del juego. El duelo libre anterior sigue disponible. La IA no usa las acciones de la mano derecha del jugador ni captura al soltar de forma instantánea.

## Validación
- 173/173 pruebas dirigidas en 27 scripts, 3.459 aserciones: mundo, carreras, cruce, duelo libre, copa, guardados, herencia, premios y justa. Dos lotes con ventana gráfica para probar entrada real de pantalla simulada.
- 711/711 unitarias adicionales, reejecutadas tras los pequeños puntos de extensión del movimiento compartido.
- La justa tiene pruebas de pasada automática opuesta, cambio de lados sin punto, impactos simultáneos, vuelo real, ausencia de daño/premios, pausa, límites, no retroceder, aislamiento de los controles de la IA, dos dedos y limpieza de dedo retenido. El menú comprueba que sus entradas no tapen Salir en tres tamaños.
- Simulación completa con ambos jinetes controlados por el juego: resultado 0-2, dos pasadas, 9,92 s de tiempo de juego incluyendo cuenta atrás. No demuestra equilibrio ni diversión para personas.
- Inspección visual a 960×540 del menú, salida mirándose, aproximación, vuelo, manga, pasada sin captura, pausa y final. Los finales de las capturas se prepararon para revisión visual; no son una partida humana.

Falta instalación y prueba táctil/rendimiento en Android físico, sesiones humanas y ajuste de ritmo/dificultad. Se mantienen avisos de limpieza al cerrar algunos tests. El diseño todavía no está decidido para producción.

APK arm64, paquete `com.example.rancho.review`, versionCode 400 y misma firma de pruebas. Los límites de 2.7.140 siguen vigentes: la copa no tiene duración de varios días demostrada, la Brújula del Viento no activa un poder ni unicornio, y el resultado pendiente de guardado aún requiere mantener el proceso abierto.
