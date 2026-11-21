# Rancho Prueba 3.0.26

## Tiempo bala con botón propio

- Nuevo botón TIEMPO BALA junto al látigo. Púlsalo, dibuja el recorrido con el mando izquierdo y suelta el mando para ejecutar el regate.
- El doble toque del mando izquierdo ya no activa el tiempo bala. El doble toque derecho para soltar animales no cambia.
- El botón usa el mismo controlador en Frontera, Rodeo y los otros modos que comparten regate. Conserva entrenamiento, recarga y restricciones de cada modo.

## Cabras y cerdos enlazados

Mientras eliges el recorrido en tiempo bala, el animal enlazado conserva posición, lazo, cansancio y temporizador. La cabra no carga contra el jinete quieto y no se evalúa la rotura por distancia durante ese intervalo. Al terminar el trazado vuelven las reglas normales de captura, distancia y golpes. No se añade inmunidad general.

## Verificación

556 pruebas pasan, 66.833 aserciones. Incluyen activación táctil real del botón en Frontera y Rodeo, ausencia de suelta del lazo, trazado posterior con el dedo izquierdo, conservación de cabra/cerdo enlazados, recarga y entrenamiento. Botón revisado visualmente junto al látigo.

Mismo paquete y firma de Rancho Prueba, versionCode 486. No probado en Android físico. Sin cambios en main ni publicación en tienda.
