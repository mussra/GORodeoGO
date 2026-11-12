# Rancho Prueba 2.7.91

Actualización de visibilidad del Atlas sobre2.7.90. Incluye todos los cambios acumulados de2.7.90 (reposo, mapa, alerta, lazo0,35s, cabras, Encargos, sombreros, Atlas/legendarios). Rama feat/open-world-test-20261107; main intacto.

## Cambio

Antes cada página contenía seis tarjetas en tres filas, pero solo se veía la primera fila y las demás exigían scroll. No faltaban familias:1.440familias base (20pelajes×12patrones×6crines) más registros propios, no un tope de500.

Ahora son seis tarjetas completas visibles a la vez, tres columnas y dos filas, sin scroll oculto. Tarjeta compacta con retrato, nombre propio o familia/crin, rareza, estado conseguido y acceso a variantes/ficha. Se mantienen filtros, botón Los míos primero y paginador. Los valores completos y barras quedan en la ficha en vez de aparecer cortados en cada tarjeta. Las siluetas legendarias no revelan identidad ni permiten entrar a fichas ocultas.

## Validación

- 552/552unitarias,1.659.247aserciones en la pasada. Prueba nueva de seis tarjetas completamente contenidas y sin ScrollContainer.
- Capturas reales896x414 de antes/después, orden natural, variantes y legendarios inspeccionadas: seis tarjetas visibles, texto sin cortes y controles conservados. No es un Android físico.
- Export completado. ZIP íntegro y firmaV2/V3 verificada con el mismo certificado que2.7.89/2.7.90. Paquete com.example.rancho.review, Rancho Prueba, versionCode350, versionName2.7.91, arm64-v8a, mínimoAndroid24,target36.
- Sin dispositivo conectado: no se afirma instalación, rendimiento, teclado ni táctil en móvil real. Se mantienen las limitaciones de2.7.90, incluido el arte pendiente de reposo/pastar sin jinete y arte final de unicornios, economía/cámara/múltiples partidas y escalabilidad. V1/V2 y progreso no se reinician.

## Integridad

- APK:67.321.840bytes.
- SHA256:d1aeef70cc224f663068916e4e65ead6dee8c78bd9c2cd6f24e96615aaad09c2
- Certificado SHA256:46bdcb2213f8b82696b918f5cfd5764cd5690038ae2938aaec6f11bfffb79bbb

Autorización: Ant12/11/2026 12:15:37 pidió generar APK cuando haya avance real;12:18:46 pidió mejorar visibilidad del Atlas. Esta versión añade esa mejora comprobada sin sustituir silenciosamente el APK anterior.
