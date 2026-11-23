# Rancho Prueba 3.0.36

- Cada zanahoria mantiene su efecto durante 5 minutos de juego activo en Frontera (300 segundos): 15% menos gasto de energía al trotar/galopar. No cambia velocidad, captura ni genética.
- Límite de inventario: 10 zanahorias. El panel muestra la cantidad y el límite.
- Cada cosecha sigue dando 3 zanahorias y 1 semilla. Si las tres zanahorias no caben (8 o más guardadas), Lucía conserva la cosecha entera en la parcela y avisa. Se entrega cuando vuelvan a caber las tres. No se pierde la semilla ni se recorta la cosecha.
- Los excedentes de partidas antiguas se conservan sin borrarlos. No se añaden más hasta liberar hueco.
- No se acumulan ni reemplazan efectos activos. Los efectos ya empezados conservan su tiempo restante al actualizar; la siguiente zanahoria concede 300 segundos.
- Incluye lo de 3.0.35: rancho original marcado en el mapa y viaje completo de siesta de ida y vuelta al punto de exploración, sin límite de recorrido ni media ruta para esos dos destinos. Se mantienen bloqueos por captura/golpe/diálogo y las transacciones de guardado.

144 pruebas y 60.420 aserciones pasan. Duración, expiración exacta, persistencia de 300 s, no acumulación, tope y espera de cosecha sin pérdida probados. Menú e inventario lleno inspeccionados visualmente. Consumo ejecutado: 3→2 zanahorias, efecto 300 s, multiplicador 0,85.

No probado en Android físico. Ninguna partida real del usuario abierta ni cambiada. Mismo paquete com.example.rancho.review, misma firma, nombre Rancho, código 496. Instalar encima sin desinstalar ni borrar datos. Rama de prueba solamente, main y tienda sin cambios. Nuevos alimentos y assets pendientes de propuesta y aprobación, no implementados.
