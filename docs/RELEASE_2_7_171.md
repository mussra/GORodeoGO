# Rancho Prueba 2.7.171

## Rodeo: guardar la victoria sin perderla al cambiar de pantalla

Si se supera una prueba pero falla el guardado, Rodeo ya no muestra puntos como concedidos ni ofrece pasar al nivel siguiente. Muestra un aviso claro y un botón grande de **Reintentar guardado**. El resultado permanece en esa pantalla hasta que se puede guardar. No se puede volver al menú o repetir la prueba perdiendo el resultado de forma silenciosa.

Al reintentar se recuperan juntos progreso, puntos, victoria y entrenamiento, sin duplicarlos. La confirmación de éxito indica que la victoria está guardada y recuerda el paso para abrir Carreras. Una sesión temporal sigue sin guardar premios.

El reintento conserva el resultado mientras la aplicación siga abierta. Si se fuerza el cierre antes de guardarlo, ese resultado pendiente no está garantizado; el aviso lo indica. Los datos previamente guardados siguen protegidos.

## Coronas de flores suministradas

Se integran los seis iconos de la hoja proporcionada: amapolas/Rodeo, girasoles/Carreras, acianos/Duelo, violetas/Justa, margaritas/Hípica y rosas/Copa. Fondo realmente transparente, recortes centrados en lienzos iguales de 512 px y variantes desaturadas para las pendientes.

Se incluyen dos juegos: U y redondas cerradas. El botón **Diseño: U / redonda · cambiar** alterna ambos en el catálogo para compararlos; no modifica victorias, premios ni partidas. La selección es solo para la sesión de prueba. Cambiar los PNG con los mismos nombres basta para sustituir los iconos sin tocar lógica ni partidas. La concesión de coronas y los umbrales de acceso no cambian en esta versión. Aún no son adornos equipables en los caballos.

## Comprobaciones y límites

- 69/69 pruebas seleccionadas en 13 scripts, 677 comprobaciones. Incluyen fracaso y reintento reiterado de guardado, progreso y premios una sola vez, botón de reintento con eventos táctiles sintetizados, tarjeta de Carreras bloqueada, navegación al catálogo de coronas y selector de diseño.
- Revisadas capturas reales de Rodeo antes y después del reintento. Corregido un desbordamiento de texto en la confirmación de victoria.
- Catálogo revisado a 1280×720 y a 640×360. Se comprueban transparencia, dimensiones, estado pendiente y que los iconos no invadan las tarjetas.
- Las pantallas de ejemplo usan datos sintéticos y un fallo de escritura forzado, no una partida humana completa.
- Pruebas de escritorio con ventana y eventos táctiles sintetizados. No se ha probado en un Android físico ni se ha medido rendimiento móvil. La cadena completa mediante juego humano y toda la batería histórica de integración siguen pendientes.
- La ejecución registra un aviso de limpieza al cerrar (2 objetos); no se ha establecido que sea una fuga durante el juego.
- Mismo paquete y firma de prueba, versión interna superior. Conserva las partidas y progreso de la 2.7.170, sin reiniciarlos otra vez. Los archivos previos a la 170 siguen intactos.
- Solo rama de pruebas. Main, tienda, economía y reglas de desbloqueo sin cambios.
