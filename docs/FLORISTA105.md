# Florista: encargos con flores visibles y recogida al pasar

Preview de código, sin APK ni main. El APK conjunto 2.7.89 sigue pendiente de marcas/fotos, zoom/arrastre y validación final.

- La florista real de la tienda ahora tiene interacción para dar encargos. No se añade un segundo sprite de personaje encima de ella. Su posición sigue a la tienda de V3; V1/V2 mantienen su localización.
- Dos encargos consecutivos: tres flores azules y tres doradas. El diálogo muestra la flor solicitada. El recuadro de Encargos muestra el mismo dibujo y el contador individual.
- Flores de misión provisionales dibujadas por código, con aura azul/dorada pulsante, distintas de la decoración existente. Se muestran también con su color en mini/mapa.
- Recogida automática al pasar a 28 unidades del objetivo; no usa el lazo. Progreso por ID, sin doble recuento. Las recogidas se guardan y no reaparecen al reabrir la partida. El segundo encargo se desbloquea al completar el primero.
- Objetivos deterministas junto al eje de caminos, fuera de roca en V3. Solo se mantienen tres nodos de objetivo del encargo activo, posiciones cacheadas. El recuadro no se reconstruye cada frame si nada cambia.
- Un fallo de guardado revierte el progreso de la flor. El texto de aviso se desplaza debajo del panel de encargos, sin tapar su icono.

## Pruebas y capturas

- Unitarias específicas: 2/2, 1.010 aserciones. Orden de encargos, eventos, limpieza del guardado y 100 semillas con tres objetivos deterministas fuera de roca por encargo.
- Integración real: 1/1, 14 aserciones. Diálogo, aceptar, icono activo, tres objetivos, no recoge a 45 unidades, sí al pisar, finalización, desaparición y recarga persistida.
- Regresión de lógica NPC anterior: 6/6, 42 aserciones.
- Regresión unitaria global de esta revisión: 532/532, 1.585.980 aserciones.
- Las tres capturas son render de escritorio en español: encargo, aura+recuadro y recogida 1/3. Se inspeccionó y corrigió una superposición inicial del aviso con el recuadro. No son pruebas Android.
- El intento de ejecutar TODA la integración en headless no concluyó antes del límite del proceso, y mostró fallos de entrada real de pantalla/joystick. No se presenta como aprobado. Las pruebas relevantes de cada funcionalidad anteriores sí pasaron; antes del APK se ejecutará la regresión seleccionada con render donde corresponde.

## Pendiente de decisión

Arte final de flores/aura, distancia definitiva de recogida, premios, encargos repetibles o nuevos catálogos y misiones entre pueblos. En esta entrega hay dos encargos de tres flores, no un generador ilimitado de encargos ni pagos añadidos sin decisión. La flor azul del evento antiguo del este conserva su flujo anterior y no se sustituye por estos nuevos encargos.
