# Rancho Prueba 2.7.152

## El aro y el dedo vuelven a coincidir
Salto de memoria ya usaba el mismo joystick nativo y la misma escena TouchControls que Frontera y carreras, no una implementación distinta. El fallo estaba en la capa compartida de gestos introducida en 2.7.150:

- Al convertir un arrastre iniciado sobre UI se trasladaba artificialmente el origen hacia dentro del área del joystick. El aro ya no coincidía con el punto tocado.
- Al volver a enviar los eventos al joystick se mezclaban coordenadas de pantalla y escena. En pantallas escaladas, como 960x540, eso aplicaba dos veces la conversión y desviaba el arrastre.

Ahora no se desplaza el toque. Las zonas de ambos joysticks cubren toda la altura de su mitad de pantalla y la capa compartida sigue distinguiendo toque de UI y arrastre. Se aplica la conversión de coordenadas exactamente una vez al reenviar el evento. El aro nace en el punto tocado y la dirección sale del desplazamiento real del dedo. Se conserva el seguimiento nativo del aro cuando el dedo supera el radio, sin cambiar esa mecánica.

Se mantienen las correcciones de soltar encima del mapa, arrastrar desde UI, pausa y pérdida de foco. El arreglo se aplica a todos los modos que comparten el componente; no hay copia especial para Salto de memoria.

## Verificación
108/108 pruebas dirigidas, 893 aserciones, 19 scripts. Se comprueban los píxeles reales del aro contra el origen del toque, dirección sin sesgo y liberación en Salto de memoria, Frontera, carreras, justa, duelo, toros, vista modular y país. Comprobación de escalado en 960x540, 1280x720 y 1600x720. Incluye regresión de mapas, gestos, notas, salto y modos anteriores.

La captura real en 960x540 marca el inicio del toque en blanco y la posición del dedo en verde. Son referencias de la captura, no controles nuevos del juego. Sin prueba en Android físico; siguen los avisos conocidos del ejecutor sobre decoración/recursos vivos al cerrar pruebas de mundo.

Mismo paquete y firma, versionCode411. Rama de pruebas, main intacta. Sin cambios de estructura, progresión ni huerto.
