# Rancho Prueba 2.7.170

Prueba de progresión gradual. No es una publicación en tienda.

## Recorrido desde una partida nueva

- Empiezas con Frontera. El botón principal lleva al mundo abierto.
- Completa el encargo de los tres cerdos del granjero. En el menú de Frontera aparece la misión de Rodeo; hay que aceptarla.
- Supera **un nivel de Rodeo (nivel 1)** y visita **dos pueblos distintos del rancho** para abrir Carreras. No es necesario completar los 40 niveles.
- Gana **dos carreras** para abrir Duelo. Repetir circuito cuenta.
- Gana **un duelo completo** (al mejor de tres mangas) para abrir Justa y Copa.
- Gana **una justa completa** para abrir Hípica de memoria.

El orden Frontera → Rodeo → Carreras está acordado. Los números y los pasos posteriores son parámetros de prueba ajustables, no cifras dictadas por Antonio. No hay pagos ni esperas obligatorias nuevas.

## Victorias y coronas

Se guardan las victorias de Rodeo, Carreras, Duelo, Justa e Hípica. Carreras también guarda las victorias por circuito. Solo cuentan partidas completas ganadas, no mangas sueltas, derrotas ni abandonos. La Copa conserva su registro de 32 objetivos y su premio existente.

En Coronas y victorias se muestran seis guirnaldas florales: amapolas (Rodeo), girasoles (Carreras), acianos (Duelo), violetas (Justa), margaritas (Hípica) y rosas (Copa). La regla de prueba es una primera victoria completa para cada corona; Copa exige sus 32 objetivos. Las pendientes se ven atenuadas y las conseguidas iluminadas. Es un catálogo de progreso: aún no equipa adornos en los caballos ni cambia sus estadísticas.

Acceso al catálogo: sexta tarjeta en Juegos o menú de Frontera. Normal y DEBUG guardan progreso por separado. DEBUG mantiene los modos abiertos sin inventar victorias. Una sesión temporal no registra victorias.

Si falla el guardado de una victoria de Carreras, Duelo, Justa o Hípica, se conserva el progreso anterior, se avisa y se puede reintentar en Coronas antes de cerrar. No se inicia otra partida hasta recuperar ese resultado. No se promete recuperación del resultado pendiente después de cerrar la aplicación.

## Alcance y comprobación

- 56/56 pruebas en diez scripts seleccionados, 545 comprobaciones: reglas, duplicados, guardado y fallo/reintento, circuito, separación Duelo/Justa, derrota sin victoria y visitas reales V6 tras recarga.
- Importación y compilación con Godot 4.7.2; APK de prueba firmado con el certificado habitual.
- Revisión visual de Juegos y Coronas a 1280 × 720, con estados conseguidos y pendientes. Las capturas de ejemplo usan datos sintéticos, no una partida humana terminada.
- No se ha probado la instalación, actualización ni la cadena completa mediante juego humano en un Android físico. No es una medición de rendimiento móvil.
- No se ha repetido toda la batería histórica de integración. La ejecución de 56 pruebas es el alcance verificado para esta entrega.
- Esta versión empieza con archivos de prueba nuevos, separados para normal y DEBUG, incluida la Copa. Los archivos de la 169 quedan intactos como respaldo; no se borran. Al actualizar verás el progreso desde cero, sin los caballos previos. Puedes recuperarlos mediante Añadir caballo en las herramientas de prueba. No se migran victorias antiguas que no se registraban. La política de migraciones queda pendiente antes de publicación/validación.
- Main y tienda sin cambios. Instinto sigue siendo solo una propuesta.

## Diagrama temporal

El PNG adjunto modela un recorrido orientativo: todos los modos podrían estar abiertos hacia los 18-47 minutos. No es una media de jugadores medida. El límite de 80 segundos del primer Rodeo y la geometría/velocidad base de Carreras son datos del juego; los intentos y tiempos humanos son hipótesis de balance.
