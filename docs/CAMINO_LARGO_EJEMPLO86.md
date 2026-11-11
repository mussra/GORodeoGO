# Ejemplo de camino largo con las piezas de Ant

Comparación aislada de diseño, no conversión aplicada todavía al mundo. Rama de prueba, sin APK nueva.

El antes utiliza el mismo componente que pinta los caminos largos actuales: repite tramos rectos girados sobre una línea sinuosa. No es una captura del lugar exacto del móvil, sino un ejemplo reproducible de ese tipo de camino.

El después convierte la misma conexión en tramos rectos con cuatro esquinas de la hoja de Ant, una T de acceso a una casa, un cruce y remates finales. Son giros redondeados de 90 grados. El recorrido modular no conserva exactamente la curva suave anterior; mantiene los extremos y puntos de referencia de este ejemplo.

Reutiliza RoadTiles, el recorte conectado de la esquina ya usado en los accesos, el resto de sus PNG y la casa/pinos existentes. No genera ni sobrescribe ilustraciones. Las juntas de textura de los tramos rectos siguen apreciándose.

No modifica el terreno, las coordenadas de los caminos, decoraciones, colisiones ni guardados del mundo jugable. Si se elige este aspecto, falta convertir las rutas generadas de forma determinista y conectar los accesos existentes para que dibujo y distancia al camino sigan de acuerdo, además de comprobar uniones entre zonas.

Reproducción: `tools/qa_modular_road86.tscn`. Capturas de 1280×720 antes/después inspeccionadas.
