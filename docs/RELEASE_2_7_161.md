# Rancho Prueba 2.7.161

## Movimiento que no se detenía

El gesto se cancela al alcanzar el borde exterior de la pantalla (franja de 2 unidades) o salir de ella, al pausar/desactivar al jugador, al cancelar el toque y al perder foco o pasar la aplicación a segundo plano. También se limpia un índice de dedo reutilizado sin una suelta anterior.

La cancelación reinicia el estado nativo del joystick, su dibujo y las acciones. No se convierte en una suelta que lance el lazo o ejecute un regate. Los eventos pendientes anteriores a la cancelación se descartan. No se añade un temporizador que corte una pulsación larga. El dibujo del regate conserva su extensión deliberada en el borde.

Reproducción contra 2.7.160: pausa, salida del dedo y desactivación del jugador sin suelta dejaban dirección activa y velocidad 260. Las pruebas de recuperación pasan con esta corrección. El gesto exacto de la partida comunicada y su versión instalada no están confirmados: se corrigen rutas reproducidas, no se afirma haber reproducido toda su sesión ni cualquier pérdida silenciosa de eventos del sistema.

## Cerdos contra muros

Si el paso de huida frontal está bloqueado por un muro de pueblo o una valla, el cerdo elige un paso lateral legal. Conserva su radio de hogar, no atraviesa muros ni cambia el generador, mapa o guardado.

La prueba junto a un muro real del mundo recorre 225 unidades en 1 segundo sin atravesarlo. El lazo, agotamiento y captura integrada funcionan y el inventario pasa de 0 a 1.

La condición anterior de misión/encargo para capturar cerdos permanece. No se ha confirmado si estaba habilitada en la partida comunicada. No se quita por suposición. La captura integrada se ha probado con la misión de cerdos aceptada, sin usar el guardado del usuario.

## Verificación

93/93 casos dirigidos de integración en 18 scripts, 1113 comprobaciones. Incluye las 77 pruebas de la versión anterior y 16 nuevas. La reproducción inicial de 14 casos nuevos contra 2.7.160 tuvo 5 fallos confirmados (movimiento tras pausa, salida de pantalla y desactivación; cerdo ante muro y valla).

20 casos unitarios: 19 pasan y sigue un fallo anterior del radio de hogar de un caballo (610.4248 frente al límite 610.01), también presente en la base. No se modifica ese comportamiento en esta corrección. Hay avisos de recursos al cerrar algunas pruebas (12 CanvasItem RIDs, 17 ObjectDB, 2 recursos en uso). No se presenta la batería completa como verde. Sin Android físico.

Cinco capturas del motor a 960 × 540 inspeccionadas, incluida parada tras salir el dedo y secuencia de cerdo junto al muro y capturado. La prueba de toque del mundo espera a que termine la carga y cortina de entrada; los conductores antiguos que actuaban antes no son una prueba móvil fiable.

Solo rama de pruebas, sin main ni tienda. Incluye las correcciones, marcas e iconos de 2.7.160. No se modifica el huerto, maestría, afinidad regional, economía ni dificultad. El bloqueo de regate del Duelo fue descartado por Ant y no se reabre aquí.

## Android

Paquete `com.example.rancho.review`, código 420, 83547591 bytes. Misma firma SHA-256 `46bdcb2213f8b82696b918f5cfd5764cd5690038ae2938aaec6f11bfffb79bbb`.

APK SHA-256: `738b1351375b66b59faa7a88cb66edd71f6910b8f829b7d9bcf59df1c4737188`.
