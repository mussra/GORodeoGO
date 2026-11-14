# Músico Ganjo: hueco preparado, fuera de 2.7.146

Propuesta: un vaquero músico de ambiente, sin misión ni tienda de momento. Sombrero/gorro, Ganjo en las manos y espiga de trigo en la boca. El arte lo entrega Ant desde PixelLab.

- Carreras: junto a la salida, fuera del vallado. Toca mientras espera la parrilla. La música sigue empezando con la carrera; el personaje no crea otro reproductor ni cambia esa regla.
- Frontera: cerca de casa, apartado del acceso. Da identidad al lugar, sin colisión, interacción ni cambios de guardado.

Componente único opcional: GanjoMusician205. Si no hay arte, no muestra ningún sustituto. Los dos lugares ya tienen anclaje. La posición final y escala se revisarán visualmente con el sprite real, antes de publicar su aparición.

Entrada prevista: SpriteFrames en art/npc/ganjo_musician205.tres, animación play (un fotograma sirve como estático; un bucle permite tocar). Pies abajo, fondo transparente. Puede adaptarse desde los PNG/frames que mande Ant; no hace falta que él prepare el archivo de Godot. Altura inicial86px en mundo, ajustable al arte. No se añaden efectos de audio, ni recompensas, ni diálogos, ni gasto.

Tres pruebas del hueco opcional: ausencia de arte invisible/sin colisión, activación con frames de prueba, posición de carreras fuera de pista. El rectángulo de prueba no es arte del personaje ni se incluye como sustituto.
