# Rancho Prueba 2.7.169

APK de prueba en la rama `feat/open-world-test-20261107`, sin fusionar a main ni publicar en tienda.

## Cambios
- Guepardo con puntos simples, sólidos y redondos.
- Leopardo con rosetas abiertas e irregulares más gruesas y relleno cálido más oscuro que la base. Compartido por retratos, mundo, potrillos y sombreros.
- Conservado Rosa y añadida la base Rosa chicle claro (#f5a8cf), manteniendo IDs anteriores, cría, guardado y estilos arcoíris.
- Protegidos los sorteos de colores históricos del mundo: ampliar la paleta del editor no cambia apariencias salvajes deterministas.
- Menú Juegos explica qué está disponible desde el principio y cómo avanzan Rodeo y Copa. No se añaden requisitos de desbloqueo.
- Corregido el menú alternativo cartoon: nodo ausente que interrumpía la construcción, texto del botón Juegos, contador de 40 retos y botones superpuestos al progreso.

## Revisión realizada
- 806/806 pruebas unitarias en los 171 scripts; 2.599.079 aserciones.
- 99/99 pruebas de modos, textos, iconos y navegación, en ventana con gestos táctiles sintetizados.
- 36/36 pruebas adicionales de guardado, mundos, entrenamiento y separación de sesiones.
- 127/127 pruebas de la selección de seguridad anterior, con solapamiento respecto a los grupos anteriores. No deben sumarse como casos únicos.
- Capturas inspeccionadas de Juegos, menú cartoon, Carreras, Duelo, Justa, Hípica, paleta y editor/sombreros.
- Firma y paquete conservados, versionCode 428.

## Límites y siguientes tareas
No hay Android físico conectado: no se ha probado instalación encima, rendimiento, batería ni tacto reales. No se ha completado toda la suite de integración (138 scripts); varios grupos exploratorios largos llegaron al límite de tiempo y no cuentan como aprobados. Las mediciones de escritorio con renderizador por software son orientativas, no FPS del móvil. Hay avisos de objetos retenidos al cerrar algunas pruebas; falta distinguir limpieza de fixtures de retención del juego.

Siguiente prioridad: prueba Android de actualización, retorno/pausa y dos dedos en cada modo; después, perfil largo de carga del mundo y limpieza al cerrar. Instinto, nuevas reglas de desbloqueo y cambios grandes de economía o mundos quedan propuestos, no implementados.

La firma permite intentar actualizar la misma aplicación, pero no sustituye una prueba real de actualización. No desinstales la versión anterior para actualizar.
