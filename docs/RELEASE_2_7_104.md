# Rancho Prueba 2.7.104

## Hecho: maqueta aislada del país del agua

Frontera → Menú → País nuevo abre una maqueta sin guardado ni ritual. Se puede recorrer con el jinete y controles compartidos actuales. Volver a Frontera restaura el mismo mundo, cámara y posición anteriores. No es todavía la entrada normal del país.

La maqueta tiene hierba distinta, entrada arcoíris, árbol gigantesco, río que entra en sus raíces y una orilla transitable río arriba hasta un nacimiento de agua provisional. La topología se genera como una estructura, no un río distinto por casilla. El tronco es más ancho que la pantalla; hace falta desplazarse para ver el árbol entero. El río evita la copa para que la orilla no quede oculta.

Se reutilizan las texturas existentes. El árbol está ampliado como referencia de escala y se ve borroso de cerca: no es su arte definitivo. Caminos, arcoíris y nacimiento de agua son marcadores geométricos provisionales, no dibujos finales. La toma general de topología es evidencia de QA; no es un mapa que el jugador reciba revelado al entrar.

## Base preparada, no activada como recorrido final

- Modelo separado de país, semilla, versión, posición, notas, sitios visitados y acceso de retorno. El mundo original mantiene su propia información.
- Planes de regreso por capas: casa dentro del país significa su entrada; cruzar el acceso devuelve a su origen, no al rancho directamente.
- Almacenamiento aditivo y atómico del registro de países, con rechazo de versiones desconocidas. Partidas antiguas V1/V2/V3 mantienen generador y posición.
- La maqueta no usa ese almacenamiento: sus paseos se descartan al salir. No altera encargos, caballos, posiciones o descubrimientos de la partida real.

Siguen pendientes la entrada/rastro del mapa original, activación y posible velocidad de la estela, guardado y recarga del recorrido final, mapa/siesta dentro del país, pistas, requisitos de entrada y ritual. No se impone Galaxy puro maestro para explorar ni se transforma un caballo al acercarse al agua. No es la entrega completa del país ni de la fuente.

## Validación

- 610/610 pruebas unitarias: 2.556.585 aserciones.
- 36/36 pruebas de integración relacionadas: 3.075 aserciones.
- Recorrido completo de aproximación, subida, bajada y regreso con el personaje y colisiones reales. El agua impide atravesar el río.
- Guardado/recarga separados, fallo de guardado con rollback, versión desconocida sin sobreescribir archivo, compatibilidad con partidas antiguas y entrada/salida de la maqueta sin cambiar archivo, cámara ni posición originales.
- Inspección visual de menú, entrada, raíces, orilla, nacimiento, topología y regreso. Entrada también a960x540.
- Sin prueba en Android físico. Conserva avisos de recursos anteriores de la suite.

## APK

Paquete `com.example.rancho.review`, versionCode363, arm64, Android7.0 o posterior. FirmaV2/V3 anterior. 69.698.218 bytes.

SHA-256: `5edbc0194bdec67157a4c89bce70445bd408511c60a2b86b99d17fdc867ebccf`.

Solo rama de pruebas, sin tocar main ni publicar en tienda. Instalar encima sin desinstalar.
