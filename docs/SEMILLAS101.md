# Cuántas semillas y cuántos mapas distintos

Cálculo y medición, no cambio de generador. Muestra reproducible: semillas enteras consecutivas 1-100.000, script `tools/audit_seeds101.gd`, ~8,12 segundos en este escritorio.

## Espacio de entrada

La creación actual usa `int(randi()) + 1`: randi entrega un valor sin signo de 32 bits, así que la selección automática admite 1 a 4.294.967.296, es decir 2^32 semillas. El campo guardado es entero de 64 bits de Godot y el cargador admite enteros positivos, pero eso no significa que la UI genere todo ese rango ni que cada entrada produzca un mapa estructuralmente único.

El contenido de un chunk mezcla la cadena `rancho-frontera-<semilla>-<cx>-<cy>` mediante `hash` antes de alimentar su RNG local. La red modular usa RNG local sembrado directamente. Repetir mismo algoritmo/semilla/coordenada da el mismo resultado en este build; mantenerlo entre versiones requiere fijar algoritmo/versión y contratos de prueba, no confiar en que cualquier futura versión del motor conserve todos los hashes/RNG.

## Resultado medido en 100.000 semillas

- **8 trazados de caminos distintos.** Tres decisiones binarias de ramales, cada una con dos variantes. Eje principal siempre igual.
- Frecuencias por trazado: 12.273, 12.477, 12.556, 12.539, 12.666, 12.558, 12.422 y 12.509.
- **Una única colocación de los cuatro edificios.** Las puertas son constantes. No hay variación de posición de pueblos porque aún no se generan pueblos.
- **100.000 contenidos distintos del chunk (1,0)** al comparar la serialización completa de decoración y animales. Cero duplicados de ese contenido en la muestra.
- Cero colisiones de la semilla mezclada/hash de ese chunk en esa muestra. Esto no demuestra ausencia de colisiones para todo el dominio ni que todas las entradas generen mundos enteros distintos.

Por tanto: hay miles de millones de valores de semilla posibles, pero SOLO ocho esqueletos de camino hoy. Muchas semillas dan mapas casi iguales en su estructura, aunque cambien árboles, flores, animales y genética. No sería correcto anunciar miles de millones de mapas con pueblos y redes diferentes.

## Qué puede estimarse y qué no

La decoración usa posiciones aleatorias, tipos, tamaños, presencia de cerdos/manadas y genética; el espacio de combinaciones es enorme. Pero no se ha enumerado el mundo entero ni hay una fórmula verificada de cuántos mundos globales únicos produce la mezcla por chunk. No multiplicar ingenuamente opciones de árboles por coordenadas ni confundir una huella hash con prueba de identidad.

Las ocho redes sí son un espacio estructural exacto del algoritmo actual: tres elecciones binarias y edificios fijos. Se recomienda ampliar estructura y posición de edificios en un generador nuevo versionado: macroregiones, puertos coherentes en fronteras y selección de árboles conectados sin circuitos. Conservar V1 y V2 para no mover guardados existentes. Esa recomendación no está implementada por esta medición.
