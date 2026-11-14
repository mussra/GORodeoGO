# Valoración de Rancho Prueba 2.7.157

## Resultado

La identidad de los pueblos ya tiene una relación legible con la fauna. Los cambios nuevos pasan sus pruebas específicas y no se ha encontrado una regresión nueva pendiente en las ejecuciones comparables. No se puede llamar estable al conjunto: el recorrido completo revela deuda anterior de pruebas y de jugabilidad que no se debe esconder con el resultado de las pruebas dirigidas.

## Pueblos y lectura visual

El segundo color diferencia de verdad estrellas y manchas sin cambiar la identidad principal del pueblo. Las estrellas claras llevan un contorno fino para sostener su lectura. El muro sigue teniendo la misma colisión y el mismo paso de 160 unidades; es un cambio de aspecto, no una nueva topología.

La captura del segundo pueblo a 960×540 muestra el texto completo, cuatro botones sin solape y el minimapa visible. Se redujo el texto tras encontrar una elipsis en la primera inspección. El mapa no revela terreno porque un primo dé una pista. En el mapa grande sigue habiendo un rótulo de sitios visitados abreviado y el terreno solo aparece donde está descubierto: conviene mejorar la lectura de esa pantalla, no confundirlo con desbloqueo de terreno.

## Manadas y doma

La variación es individual y se guarda, no una capa visual aplicada continuamente. Se compararon tres manadas generadas de una misma zona, con 14 caballos en total. La lámina de comparación está identificada como QA y no pretende ser una captura de una partida real.

Medida de 2500 manadas y 9976 caballos a menos de 1000 unidades de un pueblo, con un caballo equipado que coincide con su capa y patrón y tiene crin 0:

- Coincide el patrón: 72,71% del total observado, incluida la coincidencia aleatoria restante.
- Coincide la capa: 61,10%.
- Dos o más rasgos coincidentes: del 2,78% anterior al 52,04%.
- Multiplicador medio de doma por afinidad: de 1,0749 a 1,3748, un aumento aproximado del 28%. A igualdad del resto de condiciones equivale a cerca de un 22% menos de tiempo.

Es un cambio importante de equilibrio, no solo decorativo. No se han tocado estadísticas ni multiplicadores de doma. La ventaja regional puede ser una razón útil para elegir montura y explorar, pero necesita juego en móvil para decidir si acerca demasiado los ejemplares fáciles. No he rebajado silenciosamente el 70/60 aprobado.

## Escala y actividad

Se conserva la escala compartida basada en píxeles visibles: adultos 92, Lucía 76. Lucía encaja como niña junto a la montura; la parcela tiene acceso propio y sus poses no invaden el camino. Se comprobó visualmente una pose de trabajo y su vuelta a reposo, sin pasar `growing` a otra fase ni marcar riego.

La actividad da algo de vida, pero no sustituye animaciones nuevas. En personajes con una sola imagen solo hay un giro y un ajuste de posición pequeño. No se finge que caminen ni que trabajen con una animación que no existe.

## Rendimiento y persistencia

Escena del segundo pueblo, render por software en escritorio, 120 fotogramas a 1280×720: mediana 23,1 ms, p95 26,7 ms y máximo 28,2 ms. Es una muestra corta y local, no una promesa de FPS en Android.

Guardado de prueba con 7 repeticiones por tamaño de banco:

| Manadas guardadas | Tamaño del archivo | Mediana | Máximo |
| --- | ---: | ---: | ---: |
| 0 | 3991 bytes | 0,25 ms | 0,31 ms |
| 10 | 7711 bytes | 0,38 ms | 0,41 ms |
| 100 | 41281 bytes | 1,67 ms | 1,71 ms |
| 1000 | 377881 bytes | 13,98 ms | 14,83 ms |

El banco es lineal en tamaño. Se evita guardar manadas fuera de toda influencia. Aun así, el guardado es síncrono: el coste en almacenamiento móvil puede ser mayor y merece medirse antes de aumentar la cantidad de estado persistente. Las advertencias de recursos al cerrar algunas pruebas siguen ahí; no se han presentado como resueltas.

## Deuda detectada por el recorrido completo

Las 46 incidencias de integración son casos fallidos, no 46 errores nuevos confirmados. Las repeticiones con ventana descartan parte de los fallos de entrada/audio producidos sin render. Otros casos siguen fallando igual en 2.7.156, por ejemplo la entrada del minimapa y vistas antiguas de menús.

Hay una reserva de jugabilidad más seria: el conductor automatizado de las pruebas de arrastre de los niveles 15-19 captura y detecta persecución, pero no logra entregar un animal tras 150 segundos simulados por nivel y recibe muchos aturdimientos. El mismo resultado aparece en 2.7.156. Esto no demuestra que un jugador no pueda hacerlo, pero sí justifica revisar dificultad, recorrido y estrategia de esa prueba. No se cambia la decisión del usuario de que el contacto aturda y suelte capturas.

Se encontró además contaminación entre pruebas: algunas cambian la semilla y reutilizan otros datos de la partida. Las nuevas pruebas restauran su estado; para comparar se usaron perfiles limpios. No se quitó la protección que rechaza una política de manadas de otra semilla.

## Siguientes prioridades

1. Juego real en Android: doma regional, minimapa táctil, fluidez y sensaciones de escala.
2. Separar y corregir deuda de pruebas antiguas, empezando por las que reproducen un problema de jugabilidad real.
3. Medir el guardado y la carga en el teléfono antes de ampliar el estado o los huertos.

Los huertos remotos siguen aparcados: necesitan parcelas y progreso aislados por pueblo. No se ha reutilizado el mismo huerto detrás de varias puertas. La regla de carreras pendiente y la reorganización de maestría tampoco se han decidido por el usuario.
