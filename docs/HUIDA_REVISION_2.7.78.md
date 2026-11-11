# Huida de animales - revisión del 11 de noviembre

## Cómo funciona hoy, antes de estos cambios

- Cerdo: huye a menos de260 de distancia; corre225, agota tras7s (el lazo multiplica desgaste por1,5), descansa5s y recupera parte de su energía. El lazo rompe a más de240. Antes se forzaba otra carrera al enlazar incluso agotado. Límite al origen420: se clavaba en el borde.
- Cabra: huye a menos de260, corre205; enlazada carga hacia el jinete a235. Contacto a46 rompe el lazo y aturde; más de240 rompe. Antes se capturaba tras5s enlazada y no tenía cansancio. Límite550: se clavaba en el borde.
- Caballo salvaje: se asusta si entras a menos de120 con velocidad mayor de130, huye mientras queda susto a menos de272. El susto dura2,5s (1,5 con afinidad), con avisos/manada y sementales que reaccionan antes. La manada corre285, pánico350, después de6s baja a235. No se para por agotamiento. Lazo lo inmoviliza mientras llena confianza; puede romperlo. Límite610, con guía de manada que ya intenta girar antes.
- Toro de niveles: huye dentro del corral con giro ante bordes y obstáculos; algunos pasan a perseguir al jinete. No tiene una barra de energía ni descanso por agotamiento. Enlazado pasa por captura/calma/control y sigue al jinete. No comparte la IA de los animales silvestres.
- Regate: comparte el controlador del jinete entre mundo y niveles. El dibujo usa cámara lenta; la ejecución mueve rápidamente al jinete. El bloqueo reproducido de cabras/cerdos era el límite invisible del origen, no una regla de inmunidad al regate.

Las distancias y velocidades anteriores son unidades internas, no etiquetas que se enseñen al jugador.

## Cambios pedidos el 11 de noviembre

- Mismo cansancio y misma barra de energía sin cifras para cerdos y cabras. Baja a la vista mientras corren, se paran al agotar, y recuperan cuando quedan libres.
- Agotados y enlazados: captura tras1s. Sin lazo no hay captura automática, pendiente de la confirmación del usuario al cerrar esta nota.
- Se conservan radio, velocidades, rotura de lazo y carga de cabra. El límite del origen hace girar al animal sin congelarlo. El caballo recibe el mismo arreglo de borde sin cambiar afinidad ni manada.
- Agradecimiento del granjero antes de ofrecer el siguiente encargo. El HUD se actualiza también al capturar y abrir diálogo, y muestra3/3 completado en vez de conservar0/3.
- Bonus propuesto:100puntos por encargo una vez, además de los40por cerdo existentes. No activado sin aprobación.

## Propuesta de diseño para decidir, no aplicada

Mantener una base común: tranquilo → alerta → huida → agotado → recuperación, con barra de energía siempre visible mientras corre/descansa. El regate no anula la reacción, solo permite acercarse más rápido. Al agotarse se abre una ventana clara para el lazo; si queda libre recupera y vuelve a huir. Cada especie conserva su carácter: cerdo zigzaguea, cabra carga si está enlazada, caballo mantiene manada/afinidad, toro mantiene persecución y calma. Unificar después los radios de entrada/salida con un pequeño margen para evitar encendidos/apagados justo en la frontera, y añadir indicador de alerta. No cambiar radios, tiempos, dificultad ni extender cansancio a caballo/toro sin aprobación.
