# Rancho 2.7.110: auditoría de hitos y tiempo de juego

12 de noviembre de 2026. Partida aislada desde cero, semilla 752026, en escritorio. No se ha jugado una partida completa de principio a fin. Los atajos y estados simulados aparecen en cada captura y en el vídeo. No se modifica la partida de Antonio.

## Entrega

Vídeo MP4 de 2 min 40 s, 1280×720, sin voz, con explicación rotulada de cada pantalla. Sin créditos ni fuentes en pantalla. Las catorce capturas originales se entregan por separado para poder ampliarlas.

## Qué ocurrió en cada hito

| Captura | Hito | Verificación y atajo |
|---|---|---|
| 01 | Inicio | Guardado nuevo con Original, nivel 1 y cero puntos. |
| 02 | Nivel terminado | Victoria activada directamente. Se comprueban pantalla, 10 puntos y guardado. No se capturó el toro jugando el nivel. |
| 03–04 | Captura de un caballo | Animal y posición preparados. Se resuelve directamente una caída acertada mediante el controlador compartido; la confianza avanza y la entrega añade el caballo a la colección. No se ejecutó un gesto táctil, vuelo ni persecución completos. |
| 05 | Cerdos | Encargo aceptado y tres capturas registradas, sin perseguir animales. Diálogo completado, tres en inventario y venta disponible. No se pulsó vender. |
| 06 | Cabras | Encargo aceptado y tres capturas registradas, sin jugar las embestidas. El granjero muestra que no tiene más encargos. |
| 07 | Flores | Se registran tres eventos de recogida. La florista reconoce la entrega. No se recorrió el campo ni se completó el encargo posterior de flores doradas. |
| 08 | Hablar con el loco | Diálogo del primo del pueblo del rancho, llegado por atajo. La pista queda registrada. No se visitaron los otros tres primos en esta auditoría. |
| 09 | Conseguir Galaxy | Se prepara progreso hasta nivel 20 y saldo de puntos. Se compra de verdad la oferta Galaxy del catálogo mediante la economía del juego. No se ganaron esos puntos ni niveles jugando. |
| 10 | Criarlo | Cruce real de Galaxy con el caballo capturado, usando el crédito del nivel simulado. La elección hereda acabado Galaxy. El potro no es Galaxy puro: solo uno de los padres es Galaxy. No es unicornio. |
| 11 | Galaxy maestro | Se marcan los 20 niveles distintos en su registro. La ficha alcanza 100% y muestra el aspecto azul, aura, sol y luna. No se jugaron esos 20 niveles. |
| 12 | País nuevo | Se abre la maqueta de prueba real, no la puerta normal. La isla existe y bloquea caminar al mar. La sesión guardada fue probada por separado en 2.7.107–110; aquí no se prueba el viaje de entrada persistente. |
| 13 | Fuente | Llegada por atajo a la fuente real del país. No se recorrió toda la ruta en esta secuencia. |
| 14 | Unicornio | Atlas real con cinco variantes sin conseguir. No hay todavía ritual de obtención implementado. No se ha conseguido un unicornio. |

Galaxy a 0% tiene deliberadamente un acabado discreto y castaño; el azul con estrellas intensas aparece al llegar a maestro. La cría hereda el acabado, pero no hereda el 100% de maestría. Esto explica el cambio visual entre las capturas 09–11.

## Tiempo: datos calculados, no una partida cronometrada

La ejecución automatizada de las catorce capturas duró aproximadamente 26 segundos. Ese dato mide una auditoría acelerada con atajos, no la duración de juego de una persona.

### Reglas actuales comprobadas

- Los límites de los niveles 1–20 suman 4.790 segundos: **79 min 50 s**. Es la suma del tiempo máximo que permite cada intento exitoso, no un promedio de lo que tarda un jugador. No incluye menús, pausas ni intentos fallidos.
- Galaxy maestro exige los **20 niveles distintos con ese caballo**. Los niveles superados con Original no se transfieren al Galaxy comprado después. Una primera vuelta completa para llegar al catálogo 20 y una vuelta con Galaxy suman 40 victorias. Los dos conjuntos de temporizadores suman **2 h 39 min 40 s**, antes de menús y reintentos. No es un mínimo: se puede terminar antes de que agoten los temporizadores, y un Galaxy puede aparecer antes de nivel 20.
- El catálogo fijo de nivel 20 ofrece al menos un Galaxy. En esta versión, `offer_20_5` cuesta **1.400 puntos del juego**. Las recompensas de una victoria de cada nivel suman **46.665 puntos**, sin descontar otras compras. No hace falta simular 100.000 puntos para que sea alcanzable; ese saldo solo permitió aislar la comprobación de compra.
- Una victoria da un crédito de cría. Crear el potro no exige esperar un temporizador en esta versión. Su crecimiento y el plazo para poder volver a cruzarlo no tienen aún una duración normal de juego aprobada; no se añade un tiempo inventado.
- Caballo salvaje: la confianza con lazo depende de temperamento, afinidad y Serenidad. El caso preparado de la auditoría tarda aproximadamente dos segundos de avance de confianza después de la caída acertada; buscarlo, acercarse y acertar no están medidos.
- Cerdos/cabras: presupuesto de fatiga compartido de 7 segundos, multiplicador de lazo 1,5 y captura de 1 segundo una vez agotados. Son constantes del sistema, no una estimación de completar sus misiones. Cabras pueden romper el lazo por contacto o distancia.
- Camino de entrada a sitio del árbol: 6.764 unidades. Sitio del árbol a fuente: 9.880. Total: **16.645 unidades** aproximadamente. Con velocidad máxima de 260 y trote del 72%, eso equivale a unos **64 s de galope continuo o 89 s de trote** sin aceleración, descansos, errores ni desvíos. Es cálculo geométrico, no recorrido cronometrado. Para alguien que ya conoce el camino, reservar 2–4 minutos es una previsión, no un resultado medido.

### Presupuesto orientativo para una persona

Los rangos siguientes son hipótesis de planificación, de baja confianza. No proceden de un grupo de jugadores ni de una partida completa. Suponen que se conocen los controles, no se intenta llenar el Atlas y no hay largas pausas.

| Bloque | Previsión orientativa | Qué puede ampliarlo |
|---|---:|---|
| Primera vuelta de niveles hasta el catálogo 20 | 60–120 min | Reintentos, aprendizaje de puertas y controles |
| Capturar algún caballo | 3–10 min | Búsqueda, lazo y temperamento |
| Tres cerdos | 5–15 min | Encontrarlos, persecuciones y regreso |
| Tres cabras | 5–15 min | Embestidas y lazos rotos |
| Encargo de tres flores | 5–15 min | Explorar sin conocer dónde están |
| Hablar con el loco local | 1–5 min | Llegada y lectura, sin visitar todos los primos |
| Elegir/comprar Galaxy | 2–5 min | Revisión del mercado y saldo disponible |
| Crear una cría | 2–5 min | Elegir rasgos, sin incluir crecimiento |
| Vuelta de los 20 niveles con Galaxy | 60–120 min | Maestría individual y reintentos |
| Ruta conocida de la isla hasta fuente | 2–4 min | Orientación y descanso |

Suma de esos rangos: **145–314 minutos**, aproximadamente **2,5–5,5 horas** como presupuesto amplio para niveles, tareas, cría y maestría. No es una promesa de duración ni un dato medido de juego. Las misiones pueden hacerse en otro orden y los viajes se pueden solapar, así que no conviene interpretar la suma con precisión de minutos.

**Tiempo total hasta obtener unicornio: no calculable todavía.** Faltan acceso normal al país y ritual de obtención, además de los tiempos de crecimiento si el diseño finalmente exige criar y madurar una línea. No se ha sumado una espera o ceremonia ficticia.

## Qué sigue sin validar

- Manejo, legibilidad y rendimiento de este recorrido en un Android físico.
- Una partida continua sin atajos, incluyendo todas las persecuciones y los dos recorridos de niveles.
- Duración real con jugadores nuevos y tasa de reintentos.
- Acceso normal al país y ritual que entrega el unicornio.
- Progresión genética completa hasta unicornio y crecimiento de la cría.

El generador y progreso de mundos anteriores no se reinician. No hay cambios en tienda, precios de dinero real ni publicación en una tienda de aplicaciones.
