# Rancho Prueba 2.7.136

## Menú y arte de Ant
- Atlas ahora representa el estudio de caballos con lupa/regla, no un mapa del mundo.
- Frontera con valla/cartel y Niveles con escalones/bandera, recortados de la nueva hoja de Ant, con transparencia y sin números. Original conservado. Sin dibujos nuevos generados.
- Frontera y Niveles tienen más altura y presencia. Niveles mantiene su texto completo en dos líneas.
- Salto y regate del caballo montado están en columna vertical a su derecha. Comparten el bloque escalable y la animación de entrada del menú. Siguen abriendo su explicación al pulsar.

## Aviso de lazo sin hueco
Se muestra una vez por intento de nivel. Reintentar o entrar a otro nivel permite mostrarlo de nuevo. Liberar y volver a llenar huecos no lo reactiva durante el mismo intento. No cambia capacidad, rechazo del lanzamiento ni doble toque para soltar.

## Verificación
706/706 pruebas unitarias completas.35/35 dirigidas GL,1792 aserciones, incluyendo navegación, columna de habilidades, estilos/arte, dos lazos, hueco libre, aviso único y golpe que obliga a soltar. Capturas inspeccionadas a 960×540,1280×720 y 1600×720: composición final y fotograma de entrada, Atlas y recortes. Solo simulación de escritorio, no Android físico. Avisos conocidos de recursos al cerrar pruebas y de API obsoleta en el banco de pruebas.

Los 3 relojes HUD y controles de juego no cambian en esta versión. La petición posterior de mostrar color de ojos en controles se investiga aparte pendiente de identificar la pantalla.

## APK
2.7.136, código 395, arm 64, com.example.rancho.review. Misma firma de prueba; instalar encima sin desinstalar. Rama feat/open-world-test-20261107; main intacta. Web no publicada. Sin tienda ni gastos.
