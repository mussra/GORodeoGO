# Rancho Prueba 3.0.4

## Coronas de flores siempre cerradas y redondas
- Juegos y Frontera usan la corona de rosas redonda.
- Las seis flores del catálogo usan solo sus versiones redondas, conseguidas y pendientes.
- Eliminados el selector, su función, las 12 imágenes abiertas, su hoja fuente y la opción de regenerarlas.
- No se cambian las herraduras de equipo, la herradura del logo ni la corona dorada de rango del líder de manada. El historial y los lanzamientos antiguos se conservan.

## Logo
La imagen facilitada sustituye al título de texto del menú principal. Se respeta su proporción y transparencia. Se ubica a la izquierda, sin cubrir subtítulo ni botones.

## Verificación
435/435 pruebas dirigidas, 55.128 aserciones y 71 scripts. Prueba de posición del logo a 960×540, 1280×720 y 1600×720. Cinco capturas reales de Godot: principal, Juegos, Frontera y catálogo conseguido/pendiente. Fixtures separados, sin usar el progreso del jugador.

APK 3.0.4, código 464, mismo paquete y certificado que 3.0.3. Firma verificada. No se ha ejecutado en Android físico, de modo que estas comprobaciones no certifican rendimiento ni tacto en móvil. Los tests siguen mostrando avisos de API obsoleta y dos instancias ObjectDB al salir.

Sin cambios de mecánicas, economía ni formato de guardado. Rama de pruebas; sin tocar main ni tienda y sin gasto.
