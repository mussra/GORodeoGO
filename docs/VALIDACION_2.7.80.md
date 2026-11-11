# Rancho 2.7.80 - una barra por habilidad

- Ficha y Atlas muestran una sola barra de Salto y una de Esquiva.
- Verde y llena si el caballo sabe la habilidad. Color normal con su progreso si está aprendiendo; vacía si aún no ha empezado.
- Se quita la segunda barra de dominio de cada habilidad de Ficha/Atlas. Los datos de dominio siguen guardados y afectan la recarga como antes, sin cambios de valores ni física.
- Entrenamiento conserva sus indicadores específicos de aprendizaje, dominio y afinidad. Las estadísticas restantes siguen sin cifras ni px.
- Sin cambios de genética, genes dominantes/recesivos, unicornios, magia, arte ni diseño de crianza: todo eso sigue siendo diseño, no parte de esta versión.
- Bonus100del granjero sigue apagado. Captura de cerdo/cabra agotados sigue requiriendo lazo durante1s, a la espera de respuesta a la alternativa sin lazo.

## Validación

-462/462 unitarias,54905aserciones. Comprueban siete filas, barra de habilidad adquirida llena/verde y datos de dominio/recarga intactos.
- Capturas y vídeo inspeccionados antes del APK: una habilidad aprendida y otra sin aprender, y ambas adquiridas. Sin barras duplicadas en la Ficha.
- APK arm64,2.7.80,código339,paquete com.example.rancho.review, misma firma habitual verificada.
- Sin Android real ni repetir toda la integración. Persisten avisos de recursos/objetos al cerrar las pruebas.
- Rama feat/open-world-test-20261107. Sin merge a main.
