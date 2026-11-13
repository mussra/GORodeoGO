# Rancho Prueba 2.7.116

## Siesta: arranque automático y ojo de un segundo

Al confirmar una siesta, el caballo empieza a caminar solo por la ruta. El jugador pierde el control durante la transición. La imagen se cierra con forma de ojo durante un segundo; la carga y el guardado se completan a oscuras y el ojo se abre durante otro segundo. Si la carga tarda, el ojo espera cerrado: no se enseña una zona a medio construir.

La animación y el breve movimiento inicial son un único componente para Frontera y el país. Se reutilizan la transacción de viaje, el guardado de origen, la consulta física de llegada y la recuperación ante fallos. El tramo visible usa el cuerpo físico del caballo, no atraviesa un obstáculo.

## Avanza la mitad, no todo el trayecto

Se mantiene la idea de Antonio: cada siesta avanza la mitad del camino que queda hacia un sitio visitado. Se mide la longitud de una ruta transitable sobre los caminos existentes, no la mitad de una recta que pueda caer en el mar, en el río o dentro del árbol.

- Solo se usa una conexión que atraviese terreno ya descubierto. Un destino conocido pero sin conexión explorada no basta.
- No descubre terreno ni completa encargos durante la transición.
- Si quedan menos de 240 unidades de ruta, no ofrece ese avance: el tramo final se hace jugando. Repetir mitades no permite llegar exactamente al sitio.
- El punto final se comprueba con la forma física real del jinete y contra el terreno. Si el arranque queda bloqueado, vuelve al origen; si falla la carga, la llegada o el guardado, se conserva el origen guardado.
- Los caminos de los generadores antiguos no se sustituyen. El cálculo usa sus propios datos existentes; no se crea un nuevo mundo ni se migra la partida.

Esta entrega cambia las siestas ya existentes a sitios visitados. No añade viajes a cualquier nota, costes de energía ni cooldowns que solo estaban propuestos. Tampoco simula todos los pasos del caballo durante el tramo tapado: camina al principio y el avance restante se hace oculto durante la carga. La ruta evita terreno sólido; la llegada y el arranque comprueban obstáculos físicos. No se promete una simulación de encuentros con toros en todo el tramo oculto.

## Verificación

626 pruebas unitarias (2.557.037 comprobaciones), 95 integraciones dirigidas (5.371). Nuevas pruebas de mitad de longitud en una ruta con esquina, mar/río/árbol, conexión desconocida, tramo final manual, control manual bloqueado, movimiento visible, ojo en cierre y recuperación de un bloqueo físico. Las regresiones comprueban fallo de escritura, retorno al origen, exploración, encargos y colección sin cambios.

Vídeo de escritorio de Frontera y país, capturas del ojo y llegada inspeccionadas. La grabación usa partidas aisladas y rutas preparadas para probar el cambio; no es un recorrido de exploración completo ni Android físico. La carga de Frontera puede mantener el ojo cerrado varios segundos en esta simulación.

APK arm64, mismo paquete y firma, versionCode 375. Rama de prueba, sin main, gasto ni publicación en tienda.
