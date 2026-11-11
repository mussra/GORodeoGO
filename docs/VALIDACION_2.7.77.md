# Rancho 2.7.77 - gen oculto en la Ficha

- La Ficha de un caballo conseguido explica los traits guardados que no se ven: “Lleva gen: Jirafa (oculto)” si patrón y pelaje tienen el mismo color, o “Lleva gen: color de manchas Verde (oculto)” en un liso con ese color guardado.
- También identifica patrones cubiertos por acabado Galaxy/Original y color de manchas sin uso en Patas claras. El pigmento Original de Jirafa coincide con Castaño y el de Vaca con Negro.
- Sin genotipos nuevos, cambios en herencia, cambios de guardado, generación de arte ni cambios de estadísticas. No se deduce un patrón Jirafa en un caballo Liso ni se muestran genes inventados de variantes sin conseguir.
- Las estadísticas siguen como barras.

## Validación

- 451/451 pruebas unitarias, 54171 aserciones.
- Pruebas nuevas: patrón sin contraste, color oculto en liso, ausencia de etiqueta con contraste, pigmento Original, conservación de traits/herencia y render de etiqueta en Ficha solo para caballos propios.
- Dos capturas y vídeo QA inspeccionados visualmente: Violeta con Jirafa del mismo color y Violeta liso con color de manchas Verde. Texto legible, sin solapes, dentro del panel deslizable.
- APK arm64 2.7.77, código336, paquete com.example.rancho.review. Firma habitual verificada: 46bdcb2213f8b82696b918f5cfd5764cd5690038ae2938aaec6f11bfffb79bbb.
- SHA256: e967d00b7df3e247c085765434724dd01d7b4d695766fb52b11b6846368f8040.
- Sin prueba en Android real ni repetir toda la integración. Persisten avisos de recursos/objetos retenidos al salir de las pruebas.
- Rama feat/open-world-test-20261107, sin merge a main.
