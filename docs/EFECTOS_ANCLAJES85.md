# Anclajes del lazo, estela y polvo en Frontera

Corrección en la rama de prueba posterior a 2.7.85. Sin APK.

## Causa

El jinete de Frontera lleva el sprite escalado a 1,20 y desplazado para colocar los cascos en el origen físico. Los efectos conservaban anclajes de la antigua ilustración centrada: estela a +27 y polvo a +28 unidades bajo ese origen; el lazo cargado nacía del origen físico y el vuelo de (8,-12), por debajo de la mano visible. Se reproducía también al renderizar a 1280×720: no era un problema exclusivo del tamaño de pantalla.

## Corrección

- Estela y polvo del regate se dibujan en el suelo de los cascos, sin ese +27/+28.
- El lazo cargado y el vuelo nacen de la mano de la ilustración, aplicando su escala, desplazamiento y orientación izquierda/derecha.
- El punto objetivo, círculo, alcance, herencia de velocidad, tolerancia de captura, colisiones y señal de lanzamiento conservan sus coordenadas anteriores.
- No se baja todo el caballo para compensar el fallo. Se mantiene la escala y el origen físico.
- Una sola implementación compartida del lazo y de los efectos. Los niveles conservan sus anclajes predeterminados.

## Comprobación

499 pruebas unitarias, 58.541 aserciones. Ocho pruebas de integración focales sobre vuelo, velocidad y stun, 54 aserciones. Capturas deterministas del mismo jinete, antes/después, durante carga y vuelo; revisadas a 1280×720 y reducidas a 800×450. No se ha probado aún en un dispositivo Android ni se ha generado otra APK.

Captura: `tools/qa_effect_anchors85.tscn`. Usa una partida aislada, no la del usuario.
