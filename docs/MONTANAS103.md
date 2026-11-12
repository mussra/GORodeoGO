# V3: montañas y posiciones variables

Preview de código, sin APK ni main. No está incluida en el APK 2.7.88. Los mundos existentes V1 y V2 conservan su generador y datos; únicamente los mundos sin semilla se crean en V3. Aún no hay selector de varias partidas: no borres una partida para probar esto.

## Implementado

- Cordilleras deterministas por semilla y región, también a norte/sur, descritas sin almacenar terreno infinito. Solo se crean sus trozos visibles por chunk, y se liberan al descargar el chunk.
- Colisión del jinete con cuerpos estáticos de montaña. Animales con barrido de movimiento independiente de la física: caballos, cerdos y cabras no atraviesan roca, ni huyendo, ni con lazo ni cargando. Saltar una valla no desactiva la capa de montaña.
- Puertos provisionales de 160 unidades libres de roca. El eje de caminos atraviesa el puerto. Fuera del eje hay otros pasos libres y extremos abiertos; las cordilleras no forman perímetros cerrados que aíslen zonas.
- Mini/mapa usa las mismas cajas de terreno, con gris violeta. Decoración procedural dentro de la roca se omite; no se elimina una edición manual del guardado.
- El núcleo siempre contiene rancho/granjero, dos casas y floristería. Sus posiciones y accesos cambian según semilla. Granjero, tablón, hogar y sprites siguen las posiciones nuevas. La floristería conserva la florista y las flores existentes.
- Eje regional con desvíos ortogonales deterministas. Cada ramal toca un único punto del eje. Una red en árbol, sin circuitos.
- Los puntos de aparición procedurales de manadas/cerdos se recolocan fuera de roca de forma determinista, tanto para juego como mapa. No se aplica a V1/V2.
- Caché de red local acotada en detección de suelo. No se crea un grafo mundial completo.

## Pruebas medidas

- 1.000 semillas: 381 esqueletos distintos del núcleo, 54 disposiciones de edificios. No es el número total demostrado de mundos únicos. Determinismo repetido, reciprocidad de aristas, árbol conectado y caminos a las cuatro puertas verificados. Los edificios de misión están siempre presentes.
- Para esas semillas: puertos libres, roca a ambos lados y posiciones de aparición despejadas en regiones/bandas -7, 0, 1, 1.000. Son comprobaciones geométricas, no una navegación jugada de todo el mundo.
- Tres semillas, 357 chunks: bordes recortados, piezas de caminos, extremos de tierra de cada conexión y ausencia de roca sobre nodos del camino. En curvas el centro de baldosa puede ser hierba intencionadamente: comprobamos los puertos, no atribuimos tierra a toda la baldosa.
- Integración: caballos/cerdos/cabras reales contra la roca (incluye huida/lazo/carga), jinete real contra pared y atravesando puerto, y guardado/carga V1/V2/V3. 3 pruebas, 318 aserciones. Unitarias nuevas: 4 pruebas, 1.451.977 aserciones.
- Capturas reales de render de escritorio 1598x720: núcleo, puerto, mapa y choque. En el choque el jinete se detiene en x=1605,49 ante cordillera x=1680; el puerto permanece libre.
- No es prueba de Android ni de control táctil. El cierre de pruebas deja avisos de recursos de arte no liberados, ya presentes en otros fixtures; no se ha medido aquí RAM/GPU de una sesión Android prolongada.

## Arte provisional y propuesta para Ant

El patrón geométrico gris está dibujado por código y NO es arte final. No se ha creado nuevo raster con IA. La colisión es una franja de roca completa, no solo el pie de cada triángulo. La silueta raster final debe concordar con ella.

Propuesta de hoja PNG de 1024x1024, transparencia, 4x4 celdas de 256x256 sin separación. Uso previsto: tramos de cordillera de ancho 128 y paso visual de 80 unidades. Solicitar primero una hoja de prueba, no dar por aprobada la escala.

Prompt propuesto: "Hoja modular para juego 2D cenital tres cuartos, estilo cartoon western luminoso y pintado, coherente con rancho y floristería de referencia. PNG RGBA 1024x1024 transparente, rejilla exacta 4x4, cada celda 256x256, sin texto, sin cuadrícula visible ni sombra exterior cortada. Una cordillera de roca gris cálida con crestas y textura legibles desde arriba. Filas 1 y 2: cuatro variaciones cada una de tramo vertical continuo, roca que llegue al borde superior e inferior y encaje entre celdas. Fila 3: extremo norte, extremo sur, extremo izquierdo y extremo derecho, cada uno cerrando la masa de roca sin edificios ni vegetación grande. Fila 4: cuatro variaciones de detalle interior de roca. La masa sólida central ocupará aproximadamente 128 píxeles de ancho; no dibujar puentes, túneles, puertas ni caminos: el juego deja físicamente el puerto entre extremos. Luz desde arriba izquierda, sin nieve por ahora. Mantener mucho contraste entre suelo transitable transparente y roca infranqueable."

Pendiente decidir: ancho final del paso y escala del arte; variedad de biomas y nieve; si el lazo debe bloquearse al chocar con roca (ahora no cambia su lanzamiento, pero el animal no atraviesa); posible rodeo inteligente de animales que se detienen contra la pared; precio/venta de animales, misiones de florista y marcas personales son trabajos siguientes, no parte de esta entrega.

## Alcance y límites conocidos

No hay nuevos pueblos regionales ni misiones de florista en esta entrega. Las montañas crecen por regiones sin imponer un borde al mundo, pero siguen pendientes los problemas generales del mapa global, historial y precisión float señalados en AUDITORIA_ESCALA100.md. Este cambio no arregla por sí solo esos problemas. No garantiza precisión arbitraria a distancia extrema.

Regresión unitaria completa tras cambios: 526/526, 1.584.681 aserciones. La regresión de integración global se repetirá antes del APK conjunto; aquí se ejecutaron las tres pruebas nuevas y la regresión unitaria completa.
