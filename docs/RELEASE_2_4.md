# Rancho Prueba 2.4

Corrección pequeña sobre 2.3, manteniendo la animación y el efecto de salto aprobados.

- La barra sobre el vaquero acompaña la altura visual del salto y recupera su posición al aterrizar o interrumpirse.
- La estela del regate sigue desvaneciéndose durante el salto y el aturdimiento, en vez de quedar congelada por una salida anticipada del ciclo. Se borra al agotar su tiempo; sigue marcando el recorrido sobre el suelo.
- No modifica arte, arco, duración, trayectoria, controles ni reglas del salto.

71 pruebas focales / 75.329 aserciones pasan, incluyendo barra en cima, aterrizaje/cancelación y limpieza de estela durante salto/aturdimiento. Capturas reales de despegue, cima y aterrizaje revisadas. Sin prueba de esta corrección en teléfono Android físico; avisos auxiliares GUT conocidos, no suite global limpia.

Paquete com.example.rancho.review, versión2.4/code256, misma firma. Actualiza encima sin desinstalar. Solo rama de pruebas, main sin cambios, sin tiendas.
