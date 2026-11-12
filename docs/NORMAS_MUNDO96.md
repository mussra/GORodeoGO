# Normas de generación coherente

Aplicadas al generador de la escena modular de prueba. No cambian el mundo con progreso ni su generador. Se conservan claro por defecto, oscuro opcional, ahorro del 35% sobre camino y cruce de salvajes cuando huyen. Sin APK nuevo ni merge a main.

## Normas comprobables aplicadas

| Norma | Criterio de aceptación | Resultado |
|---|---|---|
| Una sola red | Todas las celdas accesibles desde el paso oeste, enlaces recíprocos y ortogonales | Comprobado en 256 semillas |
| Sin circuitos de avance | Red conectada con E = V - 1; por tanto existe una única ruta simple entre dos puntos | Comprobado en 256 semillas; eliminado el circuito inferior anterior |
| Camino principal que lleva lejos | Paso oeste a paso este por 15 celdas, 14 tramos / 1.120 unidades; x avanza una celda cada tramo, sin retroceso ni vueltas | Comprobado en 256 semillas |
| Destinos alcanzables | Rancho, dos casas, floristería, paso oeste, paso este y mirador tienen ruta desde la red | Comprobado; los tres destinos de exploración llevan rótulo visible |
| Ramales que no cortan el eje | Cada edificio tiene un único ramal conectado una sola vez con el principal; puerta en nodo final, nunca sobre el eje | Comprobado en 256 semillas |
| Casas cercanas | Acceso a cada edificio a un máximo de cinco tramos (400 unidades) desde el principal | Comprobado en 256 semillas |
| Vía despejada | Los cuerpos sólidos de los edificios, ampliados nueve unidades para el jinete, no invaden los recorridos | Comprobado contra los cuerpos reales de escena en las 256 semillas |
| Exploración con destino, no otro circuito | Ruta oeste-mirador de al menos 1.200 unidades, con final señalado y sin reconectar al eje | Comprobado en 256 semillas |
| Reproducible | Misma semilla produce el mismo plan; RNG local, sin tocar datos de partida | Comprobado |
| Piezas completas | Cada nodo tiene pieza/orientación coherente con todos sus enlaces; curvas, T, cruz y finales | Tests previos conservados |

El generador `ModularWorldLayout93.plan(seed)` produce grafo, eje principal, ramales, puertas y destinos. La escena usa por ahora la semilla de revisión 752026. Las variaciones por semilla modifican los accesos curvos de los edificios dentro de posiciones seguras. No es un generador de biomas ni de pueblos completos.

El resultado por defecto tiene 37 baldosas: 19 rectas, siete curvas, tres T, una cruz y siete finales. Ya no hay ninguna ruta cerrada. El ramal inferior termina en el Mirador en lugar de volver a la ruta principal. Los dos extremos del eje llevan los rótulos Paso oeste y Paso este.

"Sin círculos" significa no generar circuitos en la red. El jugador aún puede dar media vuelta y recorrer el mismo camino al revés; no se ha prohibido volver a casa ni se obliga a caminar en una única dirección.

## Pueblos o asentamientos cada varios kilómetros

Nueva norma de Ant, incorporada al diseño: asentamientos periódicos, conectados por el camino principal y visibles en el mapa. **No se presenta como implementada en esta pequeña escena**: hoy no tiene escala física en kilómetros, pueblos completos ni minimapa.

Propuesta mínima verificable para la siguiente fase:

1. Definir primero la equivalencia de unidades a metros y medir separación por distancia recorrida en el eje principal, no por línea recta. Eso evita pueblos próximos en el mapa pero con recorridos largos por rodeos.
2. Intervalo propuesto de 2 a 4 km entre accesos consecutivos a asentamientos. Es una propuesta a elegir, no un número aprobado por Ant. El generador rechazaría una salida con huecos mayores de 4 km o asentamientos a menos de 2 km de recorrido, salvo excepciones aprobadas.
3. Cada asentamiento tendrá ID estable, posición, acceso al eje y etiqueta. Sus edificios irán en ramales secundarios; ningún cuerpo de edificio invadirá la vía de paso. No se contarán casas aisladas como pueblos sin una definición de qué constituye un asentamiento.
4. Mapa mínimo propuesto: vista de la red, icono distinto por asentamiento, nombre y acceso; el mismo ID y coordenadas deben alimentar la escena y el mapa. Un test exigirá un marcador por cada asentamiento, sin duplicados, y una ruta conectada desde cada acceso al eje.
5. Separar generación de información visible: decidir con Ant si los pueblos se muestran desde el principio o al descubrirlos. No escoger silenciosamente una regla de descubrimiento.

Pruebas pendientes de esta fase: conversión real de unidades a km, distancias entre asentamientos, presencia de pueblos construidos y correspondencia con marcadores del mapa. No hay tests verdes inventados para contenido aún no creado. Los rótulos actuales de pasos/mirador son ayudas de la escena, no un minimapa ni tres pueblos.

## Comprobaciones de esta entrega

- Suite completa: 517/517 unitarias, 116.825 aserciones en la ejecución de revisión. Incluye 57.275 aserciones nuevas de normas/generación en 256 semillas.
- Integración nueva: 1/1, 374.209 aserciones de cuerpos de edificios frente a recorridos en 256 semillas, destinos visibles y detección de superficie en ambos acabados.
- Integraciones de mapa, superficie/resistencia y cruce en huida: 5/5, 1.508 aserciones.
- Vuelta de la escena al mundo anterior: pasa la comprobación de visibilidad/procesamiento y posición/ediciones guardadas sin cambio.
- PNG claro y oscuro inspeccionados: eje de paso continuo, accesos curvos, ramal inferior abierto y tres destinos rotulados. Se desplazó el caballo blanco de práctica a la zona de hierba intermedia para que no quedase cortado por el borde inferior de la vista.
- Avisos conocidos de recursos/objetos al cerrar tests; sin fallos de aserciones. No hay prueba física Android ni perfil nuevo de FPS para esta disposición.

## Dudas grandes aparcadas

- Escala unidades/metros y separación exacta de asentamientos: propuesta 2-4 km, pendiente.
- Qué define un pueblo: cantidad de edificios, personajes y servicios; nombres y arte de esos lugares.
- Puntos clave reales a larga distancia y orden de aparición. El Mirador actual es solo un destino de revisión rotulado, no una nueva misión o contenido funcional.
- Si el mapa muestra pueblos no descubiertos o solo los conocidos.
- Si más adelante se quieren circuitos locales en pueblos. Ahora la regla conservadora impide todos los circuitos de la red, sin excepciones.
- Cómo expandir este esquema a streaming/biomas y cómo migrar o convivir con la partida actual. No se ha tocado esa partida.
- Ubicación de "En camino te cansas menos", todavía sin colocar.

El siguiente APK necesita un OK explícito. Esta entrega solo publica código de preview, capturas y estas normas.
