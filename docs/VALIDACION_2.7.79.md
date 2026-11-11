# Rancho 2.7.79 - habilidad adquirida y dominio separados

- Corregida la confusión entre tener una habilidad y su dominio: la Ficha/Atlas ahora muestran una barra llena de “Salto/Esquiva · adquirido” cuando el caballo sabe la técnica, y una barra aparte de dominio con el valor real.
- Si no sabe la técnica, se muestra el aprendizaje real. En entrenamiento/HUD/resultado, el aprendizaje se ve completo cuando ya la sabe, aunque no exista un valor learning guardado por ser una habilidad inicial.
- Un único componente para ambas vistas. Sin regalar dominio, cambiar guardados ni alterar recarga, física, genética o habilidad.
- Se conservan cambios2.7.78: cansancio común cerdo/cabra y agradecimiento. Lazo sigue necesario, pendiente de la respuesta sobre captura automática; bonus100sigue APAGADO pendiente de aprobación.

## Validación

-462/462 unitarias,54932aserciones. Nuevos casos de habilidad inicial, dominio vacío/parcial, habilidad no aprendida y comprobación de que presentar la barra no altera datos ni recarga.
- Integración entrenamiento4/4,22aserciones. No se repitió toda integración.
- Capturas y vídeo QA inspeccionados antes del APK: morado con Esquiva adquirida llena y dominio vacío; otro caso con Salto adquirido/dominio completo y Esquiva con dominio parcial. Valores de prueba, no lectura de la partida del usuario.
- APK arm64,2.7.79,código338,paquete com.example.rancho.review. Firma habitual verificada.
- Sin prueba en Android real. Persisten avisos de recursos/objetos al salir de pruebas.
- Rama feat/open-world-test-20261107, sin merge a main. Sin arte nuevo.
