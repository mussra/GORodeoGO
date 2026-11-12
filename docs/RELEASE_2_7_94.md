# Rancho Prueba2.7.94

## Lazo: huida en la caída, no en el lanzamiento

- Lanzar o mantener el lazo en vuelo ya no provoca pánico anticipado ni elige un supuesto objetivo para excluirlo.
- Al caer, el controlador compartido resuelve primero si captura. Después todos los caballos libres a300px o menos del punto de caída reciben el susto, excepto el atrapado. Se incluye el borde exacto del radio.
- Un fallo cercano provoca la misma huida. Un fallo lejano no causa susto de lazo. No se extiende el alcance a toda una celda por compartir manada.
- Radio300px propuesto: ligeramente mayor que el alcance máximo de lanzamiento220px, acotado al entorno de la caída. Duración de pánico existente6s, sin añadir azar de captura.
- No hay excepción al impacto por afinidad/Líder de manada. La afinidad sigue funcionando para la aproximación natural y la confianza.
- Cancelar antes de caer, abrir navegación o aturdir al jinete no inventa una caída ni produce susto de fallo.
- Lanzar no congela los que ya huyen ni protege de las reacciones naturales existentes al aproximarse deprisa. Esas reacciones no las causa el lanzamiento.
- Se conserva el controlador único de captura para mundo/corral y el contacto que aturde y suelta la captura. Cabras conservan la ruta compartida de impacto; toros no reciben lógica de pánico del mundo.

## Diseño, no activado

La florista tendrá cultivos cercados junto a su tienda, con puerta y acceso despejados. Siguen sin integrarse los campos silvestres aprobados, las nuevas misiones entre floristas, consecuencias persistentes, poblados adicionales, bosque, nuevo país ni cadenaGalaxy/unicornio. Las previews siguen siendo escenas aisladas.

## Verificación y límites

-565/565 pruebas unitarias,2525031 comprobaciones.82/82 pruebas de integración pertinentes: conciencia/caída, manada, captura/mundo, aturdimiento, velocidad, cabras, cruce de cercas, humo de niveles/toros y aspecto compartido del lazo.
- Casos nuevos: nadie entra en pánico durante vuelo real; éxito excluye solo capturado; fallo cercano sin objetivo; fallo lejano; límite300px; cercanía entre celdas; misma celda fuera del radio; cancelación y Líder de manada real.
- Capturas visuales inspeccionadas de vuelo, fallo y captura tras movimiento real de los personajes en escritorio. No se ha instalado ni probado en Android físico; no se certifican controles táctiles ni rendimiento móvil. La suite unitaria informa objetos/recursos retenidos al salir, sin pruebas fallidas.
- APK ZIP y firmaV2/V3 verificadas. Paquete com.example.rancho.review, versionCode353, versionName2.7.94, arm64-v8a, mínimoAndroid24,target36. CertificadoSHA25646bdcb2213f8b82696b918f5cfd5764cd5690038ae2938aaec6f11bfffb79bbb, igual que2.7.93.
- APK67510625bytes. SHA2569ca8eda6ccf6d8908935ede7cd170951884f6b499cfe3ab903a6e7b1be7cfd97.
- Solo rama de pruebas. Main y estructura de partidas intactos.
