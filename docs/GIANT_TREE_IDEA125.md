# Árbol gigantesco, idea de encuentro

Idea pedida: muy raramente un árbol tan grande que cerca de él solo quepa el tronco en pantalla y haya que desplazarse para verlo entero. Punto de encuentro y posible misión especial futura, sin nombre ni mística obligatorios. No implementado ni requisito de otra cadena.

Propuesta técnica:

- Descriptor independiente de la variación normal x1..3. Semilla + ID de región + versión eligen un candidato y una tirada rara. Prefiero máximo uno por macroregión y separación mínima entre ellos, no una probabilidad por cada árbol normal. Probabilidad y frecuencia por decidir; evitar anunciar un porcentaje antes de medir el número de candidatos.
- Solo mapas V3 con versión aditiva nueva, o regiones aún sin explorar si se decide ese modo. V1/V2 y ubicaciones visitadas/progreso intactos. Guardar ID/coordenadas; no reroll al recargar. Validar espacio libre, acceso y separación de caminos, puertas y objetivos. Si ningún candidato es seguro, no forzar el árbol.
- Ejemplo de escala visual, no cifra aprobada: altura4000-6000px y tronco500-900px de ancho. La copa sale de la pantalla cuando estás cerca; al alejarte/recorrerlo se entiende su tamaño. No otro árbol normal con colisión rectangular de toda la copa.
- Colisión solo del tronco/raíces de suelo. Orden por pie del tronco, copa separada en capas y marcador del jinete encima de lo que lo oculta. La copa no es pared invisible. Geometría de cobertura dividida o semántica, sin conceder escondite a un rectángulo vacío enorme. Revisar oclusión, lasso, cámara y entradas por los cuatro lados.
- Reutilizar arte existente en capas o un renderer dedicado, sin generar raster. Texturas originales pueden no dar detalle suficiente a esa escala: la preview debe demostrarlo antes de pedir arte. Culling por bounds reales para que no desaparezca una copa al salir el tronco del chunk. Pocos nodos/colisiones, sin cientos de árboles superpuestos.
- Minimapa: símbolo especial solo al descubrirlo; luego nota de encuentro persistente. No revelar todos los árboles remotos antes de explorar. Marcador opcional del objetivo al aceptar una misión, no un faro permanente obligatorio.
- Ganchos futuros: tree_id estable, región, zona de interacción accesible, señal de descubrimiento y estado de misión por ID. No inventar objetivo, premio o NPC hasta elegirlos. Puede alojar una pista de un primo o reunión, sin convertirlo automáticamente en fuente o paso obligatorio para unicornio.

Pendiente: frecuencia deseada por hora/mapa, tamaño, estética de copa, interacción, nombre y misión. Prioridad posterior a pueblos y diseño de progresión.
