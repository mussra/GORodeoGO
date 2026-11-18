# Rancho Prueba 2.7.191

## Buscar dentro de edificios
- Floristería y taller de Juanito usan la búsqueda común. Toca zonas del decorado: se puede descubrir un lazo de trabajo o un retal de cuero, respectivamente. Son hallazgos para mostrar a su dueño, no premios de inventario automáticos.
- Zonas vacías: aviso al cuarto toque y después cada cinco (9, 14, 19...). Los puntos con objeto no muestran el aviso de vacío al descubrirlo.
- Al encontrar: "Le mostraré esto a la florista" o a Juanito.
- Tras encontrarlo, el contador de ese punto empieza de nuevo: al cuarto toque y cada cinco indica "Ya no queda nada más aquí".
- Al pulsar Salir con hallazgos pendientes, se produce una conversación. En estos primeros dos hallazgos el personaje conserva su material de trabajo. No se inventan precios, gastos ni recompensas; futuras ofertas de venta o regalo las decidirá el personaje, no un selector del jugador.
- Hallazgos y conversación pendiente se guardan, incluso al cerrar/reabrir. Si falla guardar el hallazgo, sigue disponible; la conversación se confirma guardada antes de salir.
- El botón Salir sigue visible durante la exploración. Las zonas de búsqueda se rechazan si invaden UI, incluidos Salir, Hablar y los botones de acciones. No se pueden esconder objetos detrás de esos controles.

## Alcance
Esta versión conecta los dos interiores ya existentes. Casas, granjero y tiendas remotas recibirán la misma base cuando se creen sus interiores; no se finge que ya estén terminados. No se ha cambiado la historia, reorganizado menús, ocultado ni eliminado sistemas.

Los contadores de toques se reinician al volver a entrar; los hallazgos y las conversaciones ya cerradas no. Son zonas definidas, no cada píxel del decorado: los botones de UI y el resto de pantalla no suman intentos.

## Pruebas
- Regresión seleccionada: 357/357, 54.083 aserciones, 57 scripts. No equivale a certificar toda la suite histórica.
- Prueba de interfaz con clics inyectados: vacío, hallazgo, agotado y conversación al salir en los dos edificios.
- Pruebas de guardado/recarga, descubrimiento único, salida normal, conversación pendiente y zonas reservadas.
- Capturas revisadas. No probado en Android físico. Persisten un aviso GUT y 14 deprecados heredados; sin aviso de fugas en esta ejecución.
- Mismo paquete y certificado de Rancho Prueba, versionCode450. Solo rama/release de prueba, sin main, tienda ni gasto.
