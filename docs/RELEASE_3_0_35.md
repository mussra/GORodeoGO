# Rancho Prueba 3.0.35

## Rancho original y vuelta a la exploración

- El mapa ampliado marca el rancho con un aro dorado y la etiqueta «RANCHO ORIGINAL». Su marcador abre la confirmación de viaje completo.
- En «Sitios visitados», «Rancho original» viaja hasta el rancho sin limitarse a media ruta ni exigir terreno intermedio conocido. Se carga la zona de llegada y se busca una posición libre antes de guardar.
- Al viajar al rancho se guarda el punto desde el que saliste. Aparece «Volver a mi exploración» para volver a ese lugar mediante otra siesta completa. Ese punto queda guardado con la partida y se conserva si falla el viaje.
- Estos dos viajes no exigen esperar el descanso de 300 segundos y no consumen otro descanso. El resto de destinos conserva su siesta de recorrido parcial y sus reglas actuales.
- No se permite viajar con una captura activa, durante un golpe o con diálogos abiertos. No se sueltan animales por viajar.
- Se guarda primero el origen y se valida y guarda la llegada. Si falla, se vuelve al origen. No se marcan como exploradas todas las zonas intermedias.

Un punto de regreso por partida. El siguiente viaje al rancho recuerda el nuevo punto de salida. Desde otro país sigue aplicándose su propio sistema de salida, no este viaje de Frontera.

## Comprobación de zanahorias y comida

Se adjuntan capturas de la muestra silvestre real: zanahoria naranja en tierra y hojas verdes, no flor genérica. El menú de Lucía ofrece «Dar una al caballo» y funciona: una zanahoria consumida activa 120 segundos con 15% menos gasto de energía al trotar/galopar. No se ha añadido un menú de comida independiente ni nuevas comidas.

## Verificación

140 pruebas y 60.385 aserciones, todas pasan. Viaje de ida y vuelta desde 50.000 unidades con descanso ya activo, recarga independiente del punto de vuelta, conservación de caballos/misiones, bloqueo con captura y fallo de guardado de llegada con restauración del origen. Mapa y confirmación inspeccionados visualmente a 1280 × 720. Las capturas de comida se ejecutaron con inventario sintético.

No probado en Android físico. Ninguna partida real del usuario abierta ni cambiada durante las pruebas. Mismo paquete y firma, nombre Rancho, versionCode 495. Instalar encima sin desinstalar ni borrar datos. Solo rama de prueba, main y tienda sin cambios.
