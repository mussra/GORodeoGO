# Rancho Prueba 2.7.177: recados de pueblos y lectura en móvil

## Qué cambia

- Diálogos de pueblos: nombre del personaje separado del pueblo, título de conversación, texto corto, tiempo orientativo en línea aparte y botones grandes. Sin unidades internas, velocidades ni explicaciones del generador.
- El OSD se oculta durante diálogos, diario, mapas, encargos y paneles de lectura. Su ajuste no cambia; reaparece al cerrar.
- No se declara el final por llegar a un NPC sin recomendación. Se comprueban recados pendientes del mismo oficio en la red inicial, en orden de profundidad de la cadena. El NPC actual transmite el primero omitido y marca el siguiente pendiente si queda alguno. No obliga a volver al anterior para oír ese mensaje.
- Registro por pueblo y oficio, distinguiendo mensaje oído allí y transmitido por otro personaje. Descubrir el pueblo no completa conversaciones. El registro persiste con la partida y la escritura falla sin destruir el estado previo.
- Compatibilidad: las versiones anteriores no guardaban conversaciones individuales. No se puede reconstruir con certeza qué se oyó; los recados antiguos sin registro se pueden repetir una vez. No se borra ninguna misión, pueblo o progreso. Cada oficio se comprueba por separado; no se pretende completar todos los pueblos de un mundo infinito.
- No se añaden botones de servicios aún inexistentes. Caballos, equipo y encargos conservan sus accesos reales.

## Textos nuevos

### Recomendación

Título: «Tengo a alguien que presentarte».

«Busca a mi primo [el granjero / el guarnicionero] / mi prima, la florista, en [pueblo], hacia el [dirección]. Reconocerás el pueblo por el color y el dibujo de su muralla.»

Si hay un pueblo intermedio: «Pasarás por otro pueblo antes de llegar.»

«A caballo: [intervalo], aproximadamente. Sigue el camino.»

Botón: «Marcar en el mapa».

### Recado omitido

Título: «Tengo un recado para ti».

«En [pueblo de origen] te recomiendan visitar [destino], hacia el [dirección].»

Si ese origen no recomienda otro destino: «En [pueblo] puedes hablar con [personajes].»

Pie: «Siguiente recado: [pueblo].» y «Marcar siguiente recado», o «Con este recado ya estás al día. ¡Buen viaje!» si no queda ninguno.

### Sin pendientes

Título: «Ya estás al día».

«Ya has oído todos los recados de [tus primos / los granjeros / las floristas / los guarnicioneros]. Si sigues explorando, encontrarás otros pueblos.»

### Botones y servicios

«Ver encargos», «Ver equipo», «Ver caballos», «Hasta luego».

Caballeriza: «Puedes ver tus caballos y elegir cuáles quieres criar. Tu caballeriza te acompaña vayas donde vayas.»

Juanito: «Echa un vistazo al equipo para ti y tu caballo. Aquí puedes comprarlo y mejorarlo con tus puntos.»

## Rendimiento y guardados

Ant reportó que la 176 iba más limpia y ya no se bloqueaba. Su captura muestra 60 FPS, 16,6 ms/frame y pico 18,1 ms, con zoom 35%, 16 sectores y 57 misiones activas. Mejora móvil confirmada tras la 176, sin aislar la contribución de cada cambio. El coste redundante de carreteras sí se demostró por microprueba y equivalencia. No se atribuye toda la mejora solo a ese índice.

La captura muestra 341 guardados, último 16,6 ms y máximo 18,2 ms. La fuente hace autoguardado cada 4 s activos, además de descubrimientos y acciones. Sin duración de sesión ni desglose por motivo no se puede declarar redundancia por ese total. Esta versión no cambia frecuencia ni protección de progreso a ciegas; queda como revisión posterior si hay tirones al guardar.

## Validación

204/204 pruebas, 37.504 aserciones y 32 scripts; cuatro deprecaciones, sin fallos. Capturas antes/después del mismo diálogo a 1600x720, más casos de recomendación intermedia, recado transmitido y final real. OSD activado en ambas fases. Revisados píxeles, espaciado y botones. Sin prueba Android física para este nuevo formato.

La última batería emitió un aviso de 2 objetos vivos al cerrar el proceso de pruebas. La prueba de integración añadida, ejecutada por separado con diagnóstico detallado, termina sin ese aviso. No se presenta como prueba de una fuga en Android.
