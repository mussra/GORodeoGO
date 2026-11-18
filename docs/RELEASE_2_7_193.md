# Rancho Prueba 2.7.193

## Zoom progresivo y minimapa a la derecha
- Los botones - y + animan el zoom de cámara durante 0,38 segundos, con inicio y final suaves, en vez de saltar directamente al porcentaje elegido.
- 100% también vuelve con la misma transición. El porcentaje del botón indica el destino.
- Si se pulsa varias veces, cada paso se acumula y la nueva animación empieza en el zoom visible actual, sin saltar hacia atrás ni dejar transiciones compitiendo.
- Se mantienen todos los niveles de zoom, la preferencia guardada, la presentación panorámica y la interrupción del recorrido de llegada. No cambia física, colisiones, lazo ni movimiento.
- El minimapa compartido queda a la derecha. En el pueblo queda encima de - / porcentaje / +: minimapa y=62..174; controles y=182..228. La barra superior conserva sus botones. El mapa ampliado sigue centrado y mantiene sus funciones.
- Se conserva el látigo de 192 y todos los sistemas previos, sin retirar nada.

## Verificación
374/374 pruebas seleccionadas, 54.193 aserciones, 60 scripts. Pruebas nuevas de zoom intermedio, destino exacto, toques rápidos, vuelta a 100% y posiciones sin solapamiento. La prueba antigua de llegada espera ahora al final de la animación, manteniendo su validación de cancelación y guardado.

Clic de ratón inyectado en el botón real del mundo y capturas de vista normal, transición y 85% revisadas. La prueba desactiva la emulación de toque desde ratón para no duplicar el evento sintético. Zoom intermedio y destino exacto comprobados. Un aviso GUT y 18 deprecados heredados. No Android físico ni toda la suite histórica. Falta valorar la sensación en móvil real. APK de prueba, mismo paquete y firma, versionCode452. Main y tienda sin cambios. Sin gastos.
