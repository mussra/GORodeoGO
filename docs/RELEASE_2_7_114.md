# Rancho Prueba 2.7.114

## Una captura debe pertenecer al marcador

Al editar una nota desde otro lugar, la fila amarilla muestra "Captura bloqueada · acércate al marcador" y no permite adjuntar o sustituir la foto. La miniatura original se conserva, y el texto se puede editar normalmente.

Para añadir o sustituir la captura: acércate al punto de la nota, cierra y vuelve a abrir el mapa, edita la nota, activa la captura y guarda. Se comprueba tanto dónde se tomó la captura como dónde está el jugador al guardar. Volver al marcador sin renovar una captura tomada lejos no permite asociar esa imagen ajena.

La misma protección cubre notas nuevas creadas a distancia. Margen local de 120 unidades del mundo alrededor del marcador. No intenta demostrar qué contiene cada píxel de la foto; evita asociar una vista capturada desde otro punto del mundo.

Se corrige el editor/controlador compartido de Frontera y del país. Sin migración ni cambio de formato. No borra fotos antiguas ni intenta corregir automáticamente fotos asociadas antes de esta versión. No cambia la siesta.

## Verificación

622 pruebas unitarias (2.556.804 comprobaciones), 89 de integración dirigidas (5.326): bloqueo en interfaz y al guardar, foto original intacta byte a byte, texto editable desde lejos, captura antigua inválida aunque vuelva al punto, nueva captura local válida y bloqueo de nota nueva remota.

Pulsaciones táctiles sintetizadas en Frontera y en el país a 1600×720 y 960×540: foto local guardada, recarga desde disco, nota reabierta desde lejos, casilla bloqueada y foto original conservada al editar texto. Capturas del editor inspeccionadas.

Validación de escritorio, no Android físico. APK arm64, mismo paquete y firma, versionCode 373. Rama de prueba, sin publicación en tienda.
