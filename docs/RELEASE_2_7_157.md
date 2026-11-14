# Rancho Prueba 2.7.157

Rama de pruebas. No es una certificación de versión estable. Misma aplicación y firma que 2.7.156; versión Android 416. No se modifica main ni se publica en tienda.

## Cambios

- Estrellas y manchas de los pueblos tienen un segundo color propio de la paleta de los caballos. Muro e icono comparten ese color. Se mantienen nombre, color base y patrón de los pueblos existentes.
- Las manadas nuevas en zonas no exploradas reciben afinidad visual del pueblo cercano: 70% de probabilidad de su patrón y 60% de su capa junto al pueblo. La influencia baja entre 1000 y 3000 unidades. Entre pueblos se mezclan influencias, y cada manada conserva diferencias entre sus miembros.
- No se recolorean los caballos ya vistos, trasladados o capturados, ni los de la colección. La genética nueva queda guardada por manada; no cambia cuando un caballo camina a otra zona.
- El loco del segundo pueblo visitado explica la relación y nombra su patrón y colores reales. En partidas sin historial del orden de visita lo explica el siguiente pueblo nuevo. El diario conserva las pistas de los primos.
- Actividad NPC discreta con el arte existente: giros y desplazamientos de hasta seis píxeles para personajes de una sola pose; Lucía alterna sus poses actuales y vuelve a reposo. Es cosmética, no concede ni consume progreso del huerto. Se detiene durante conversaciones, menús, mapa y acciones del huerto, y cuando el jugador está muy cerca o lejos.
- Las manadas lejanas sin influencia no generan escrituras innecesarias de su genética sin cambios.

## Pruebas y límites

Se completó el recorrido de los 285 scripts del proyecto, con ejecuciones separadas para evitar contaminación de partidas entre pruebas:

- 163 scripts unitarios: 737 casos, 736 aprobados. El fallo restante es el radio de recuperación de un caballo: alrededor de 610,6 frente a un límite de prueba de 610,01. También se reproduce en 2.7.156.
- 122 scripts de integración: 553 casos, 507 aprobados y 46 fallidos en el recorrido automatizado, principalmente sin pantalla. Todos los scripts con fallos restantes se contrastaron con 2.7.156 y también fallan allí. No se presentan como aprobados ni se relajan sus tolerancias.
- Se repitieron pruebas con ventana real. Pasan el joystick y sus píxeles en todos los modos, la liberación del mapa, el tiempo bala y el regate de borde; varias fallaban o esperaban indefinidamente sin render. Persisten fallos heredados de entrada del minimapa, vista previa de regate, algunas pantallas antiguas y otros casos. La batería global NO está completamente verde.
- Las pruebas nuevas de afinidad, conservación, distancia, migración, guardado atómico, orden real de visita y actividad NPC pasan. Se ajustó una expectativa antigua del primo para aceptar la explicación aprobada en el segundo pueblo.
- Revisadas capturas reales a 1280×720 y 960×540. Se corrigió un texto cortado en el diálogo. Revisados minimapa, mapa, colores y retorno de Lucía a reposo.
- Sin móvil Android físico: el tacto real, los tiempos de carga, la batería y la fluidez en el dispositivo siguen pendientes.

El inventario por script está en `QA_2_7_157_integracion.json`. La valoración global y las medidas están en `VALORACION_2_7_157.md`.

## No incluido

Huertos remotos, cambios de la regla "segundo parado", reorganización estructural o de maestría, nuevas poses dibujadas ni otras geometrías de muralla.

## Archivo Android

- Paquete: `com.example.rancho.review`
- `versionCode`: 416
- Tamaño: 82194377 bytes
- SHA-256: `c2770754d8eb1776273cad30191625c5be301f3ec3d2d8b0097b0b5c6a67c51d`
- Certificado SHA-256: `46bdcb2213f8b82696b918f5cfd5764cd5690038ae2938aaec6f11bfffb79bbb`
