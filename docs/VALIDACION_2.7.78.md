# Rancho 2.7.78 - huida, cansancio y agradecimiento

- Arreglado el bloqueo de cabras/cerdos en su límite invisible al origen: giran dentro del mismo radio en vez de quedarse clavados cuando el jinete se acerca con regate. El caballo salvaje recibe la misma protección de borde.
- Cerdos y cabras usan AnimalFatigue y AnimalFatigueBar compartidos: energía siempre visible sin cifras, baja mientras corren, se paran al agotarse y descansan/recuperan para volver a huir si están libres.
- Agotados y enlazados se capturan tras1s; un nuevo lazo no reinicia su energía. Se mantiene el requisito previo del lazo. La pregunta al usuario sobre captura automática sin lazo sigue pendiente, no se ha supuesto autorización para ella.
- Cabra conserva carga hacia el jinete mientras está enlazada y tiene energía; conserva rotura por distancia/contacto. No se cambian radios ni velocidades.
- El granjero agradece el encargo terminado antes de ofrecer el siguiente. HUD actualizado al capturar y abrir diálogo: completado3/3 en lugar de texto viejo0/3. El reconocimiento queda guardado.
- Bonus propuesto de100puntos por encargo: APAGADO, pendiente de respuesta. Se conservan los40puntos por cerdo existentes, sin añadir premio nuevo.
- Revisión de la huida y propuesta de diseño en el archivo aparte. No se aplicó el rediseño general, ni cansancio nuevo a toro/caballo.

## Validación

-460/460 pruebas unitarias,54893aserciones. Tres pruebas de regresión fallaban antes del arreglo de borde/recuperación y pasan después.
- Integración4/4,137aserciones: regate real en mundo con cabra/cerdo al borde, recuperación repetida, persecución/lazo/captura de cerdos generados, animales/niveles y PNJ.
- Capturas y vídeo QA inspeccionados antes del APK: energía al correr, agotamiento, descanso, vuelta a huir, lazo y agradecimiento3/3. El jinete sigue automáticamente al animal para encuadrar. Para el agradecimiento se añaden eventos QA que adelantan las otras dos capturas; no representa tres capturas manuales.
- APK arm64,2.7.78,código337,com.example.rancho.review. Misma firma habitual, verificada.
- Sin Android real ni suite completa de integración. Siguen avisos de recursos/objetos retenidos al salir de pruebas.
- Sin arte nuevo, sin merge a main. Rama feat/open-world-test-20261107.
