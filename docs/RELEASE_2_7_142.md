# Rancho Prueba 2.7.142

Corrige el jinete bloqueado al regatear contra el borde y la pulsación de lazo perdida durante recarga. Mejora rivales de carreras sin aumentar su velocidad base. Conserva copa, duelo y justa de 2.7.141. Rama `feat/open-world-test-20261107`; sin main, web ni tienda.

## Bloqueo del jinete
Reproducido en el óvalo, puerta 8 y 44% del recorrido: un regate dibujado hacia fuera seguía intentando alcanzar puntos imposibles mientras el borde devolvía al jinete a la pista. Marcaba 57 m/s sin avanzar, con 114 puntos de trazado pendientes. No era una congelación de toda la aplicación.

Ahora, si el borde recorta ese regate, termina el trazado y devuelve el control. No teletransporta al jinete ni reembolsa la recarga. Probado que después puede moverse hacia dentro y volver a lanzar.

## Lazo
- Antes, pulsar durante la recarga ignoraba el comienzo del gesto: mantener el dedo hasta que aparecía LISTO no bastaba para lanzar.
- Ahora se conserva la pulsación mantenida durante recarga/vuelo y permite apuntar cuando acaba la recarga. Soltar después lanza normalmente.
- Soltar antes de estar listo cancela ese gesto. No hay un disparo automático o tardío después de soltar. Pausa/cancelación descarta el gesto pendiente.
- La recarga sigue siendo de 3 segundos. La información distingue LISTO, APUNTANDO y EN VUELO.

## Rivales e impulso
Se conserva el regate hacia delante del jugador; la IA puede usar el mismo regate trazado, con igual recarga de 2,5 s y alcance no superior al del jugador. Anticipa las vallas antes de usarlo y elige una trazada interior en lugar de mantener el carril de salida. Siguen pasando puertas en orden, saltando o usando el hueco real de la valla. Velocidad base 260 para todos, sin aceleración por ir perdiendo ni teletransporte.

Ocho simulaciones completas, cuatro circuitos con/sin salto, los cuatro jinetes y las 16 puertas:
- Óvalo: último en meta a 45,83 / 44,45 s.
- Valle: 47,30 / 45,13 s.
- Serpiente: 46,00 / 44,50 s.
- Cruce: 54,73 / 52,30 s.

En la referencia anterior sin salto, los rivales terminaban el óvalo en 58,6-58,9 s, el valle en 61,2-61,8 s y serpiente en 60,9-61,0 s. Ahora lo hacen en 43,8-45,8, 46,1-47,3 y 44,6-46,0 s respectivamente. Son simulaciones, no balance demostrado contra personas.

## Verificación y pendientes
180/180 pruebas dirigidas en 28 scripts, 3.485 aserciones, más 711/711 unitarias reejecutadas. Se incluye entrada de pantalla simulada: mantener apuntado durante recarga, soltar y un solo vuelo, sin repetición tardía. Inspección visual del borde liberado, jinete desplazado hacia dentro, apuntado y vuelo posterior. Las capturas son fixtures de QA, no una partida humana.

No se aplica aún la propuesta del segundo completamente parado: está pendiente que Ant aclare si se refiere a quien recibe o quien lanza el lazo. No se ha adivinado esa intención.

Falta Android físico y feedback de sensaciones. Continúan los avisos de limpieza de algunos tests y los límites ya documentados de copa/objeto narrativo y duración no demostrada.

APK arm64, `com.example.rancho.review`, versionCode 401, misma firma de pruebas.
