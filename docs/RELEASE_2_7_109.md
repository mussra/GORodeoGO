# Rancho Prueba 2.7.109

## HECHO: corrección urgente de los botones del país

Antonio informó en Android real con 2.7.107 que no respondían Mapa local y Salir a Frontera en la maqueta.

Reproducido con eventos táctiles simulados a1600×720: Mapa no abría y Salir no emitía ninguna acción. Los joysticks de pantalla completa estaban por encima de la cabecera y recibían el toque.

- Cabecera y ventanas del país ahora están en una capa superior a los joysticks.
- El fondo de la cabecera y el contenedor de interfaz dejan pasar los toques al mundo. Solo los botones y las ventanas interactivas los bloquean.
- Se aplica a la maqueta y al país guardado, que comparten pantalla.
- Frontera usa también el orden de capas explícito. Comprobado Menú → País guardado con toques simulados, no con llamadas directas al botón.

## HECHO: cansancio y habilidades en ambos países de prueba

No estaban creados en la maqueta ni en el país guardado: no era un recorte de pantalla.

- Ahora muestran los mismos relojes de cansancio y habilidades de Frontera, con el mismo arte y reglas compartidas.
- Cansancio del caballo montado y recuperación/reglas de galope, con el mismo descuento del35% en camino.
- Regate y salto muestran disponibilidad y recarga según las habilidades reales del caballo. No concede habilidades que no conoce.
- Al abrir el mapa o viajar se detiene este avance. No se cambia el cansancio de los niveles clásicos.

## Verificación y límites

-622 pruebas unitarias y67 pruebas de integración dirigidas pasan (2.556.804 +3.382 comprobaciones).
- Eventos táctiles: abrir/cerrar mapa, salir de la maqueta y del país guardado, arrastrar joystick de movimiento sin que el HUD lo bloquee, menú de Frontera y acceso a País guardado. Pantalla ancha1600×720 y comprobaciones adicionales1280×720 y960×540.
- Capturas de pantalla ancha inspeccionadas con los relojes visibles.
- Esto es simulación de escritorio. El problema fue comunicado desde Android real, pero la corrección todavía debe confirmarse allí.

APK arm64, mismo paquete y firma,versionCode368. Conserva todas las funciones anteriores, sin publicar en tienda, sin cambiar precios ni reglas de ritual.

## HECHO: árbol madre, escala, base y mapa

- Escala0,35 de la anterior:2.800×2.394 en vez de8.000×6.840. Se mantiene el original de Antonio sin generar detalle nuevo. La imagen aún se amplía y puede verse suave de cerca.
- Colisión trazada con58 puntos a partir de la silueta inferior real del dibujo: tronco, raíces, piedras y matas. Misma geometría para física y validación de destinos.
- Copa por encima del jinete, con una pequeña zona de transparencia alrededor para verlo al pasar por debajo. Las hojas no son un suelo y la base sólida no se atraviesa.
- El río conserva el extremo bajo las raíces y los caminos conservan su ruta transitable hasta los sitios.
- Árbol visible en su posición real en el Mapa local después de descubrirlo. Tocar su dibujo selecciona el destino seguro de las raíces; no revela todo el terreno.
- Si una posición de guardado antigua coincide con una raíz ahora sólida, se busca una llegada libre junto al contorno antes de guardar y activar la sesión.
