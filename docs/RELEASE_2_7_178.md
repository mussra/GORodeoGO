# Rancho Prueba 2.7.178: muros, profundidad, destinos y caballos

APK de prueba, código 437. Mismo paquete y firma, instalar encima. Solo rama de pruebas, sin main ni tienda.

## Muros de pueblos sin costuras

La textura de cebra no era repetible por sus bordes. Los polígonos ya compartían coordenadas de textura globales, pero al repetir la imagen se juntaban dos bordes distintos. Ahora el material se repite en espejo, conservando su escala, colores e imagen. Así casa consigo mismo al repetirse. Lo usan el muro cargado, sus cortes entre sectores, el contorno lejano y la panorámica. También se aplica al acabado antiguo de los muros. No se crean texturas mayores, shaders, sectores ni geometría nueva.

Las pruebas visuales incluyen tramo vertical, esquina, diagonal, corte entre sectores y patrón de cebra. La geometría de las seis formas y la apertura de la puerta no cambian. El dibujo de la textura cambia de orientación en las repeticiones reflejadas; es deliberado para eliminar la costura sin sustituir el material.

## Cabras y profundidad

Las cabras estaban dentro de un contenedor sin ordenación por pies. El mundo y los árboles sí se ordenaban, pero el grupo de cabras se trataba como una pieza con un solo punto de profundidad. Ahora cada cabra se ordena por sus pies como caballos, cerdos, personajes y árboles. Durante el salto sube su dibujo, pero no pasa a una capa universal por encima de todas las copas. No cambia la posición, colisión, altura visual ni duración del salto.

Capturas antes/después con posiciones iguales: la cabra situada detrás del árbol queda tapada; la que está delante sigue visible. Los contenedores de cerdos, sectores, pueblos y servicios ya tenían ordenación activada. La prueba de músico/personaje también se mantiene.

## Pueblo destino: imagen, nombre debajo y viaje sencillo

- Miniatura del contorno y puerta reales del destino. Usa el mismo plan y material del mundo y del mapa, no un icono de casas inventado.
- A la derecha del contorno hay una muestra ampliada del material, para reconocer el dibujo aunque la muralla a escala de mapa sea muy fina.
- Nombre debajo de la imagen, sin coordenadas. Dirección en palabras: norte, sur, este, oeste o diagonal cuando corresponde.
- Sustituye la explicación del color y dibujo por la imagen.
- Tiempo simple: «Tardarás aproximadamente X minutos con ese caballo». Usa el caballo montado, su energía y las reglas de viaje existentes. No muestra velocidades, distancias internas, rangos ni la explicación del cálculo.
- En un recado transmitido se separan el recado contado y el siguiente pendiente. Miniatura, nombre, dirección, tiempo y botón se refieren siempre al siguiente destino que se va a marcar.
- La imagen se genera una sola vez al abrir el diálogo y se guarda en una caché limitada a 24 imágenes de 288x160. Después se libera la vista de generación. No hay una cámara o un mundo funcionando cada frame dentro de la miniatura.

Los nombres visibles de los diálogos antiguos y el aviso de llegada tampoco muestran el sufijo de coordenadas. Las identidades y referencias internas se conservan.

## Caballos: muro diagonal y animación al volver de lejos

Dos fallos reproducidos en una escena de prueba:

1. El caballo recortaba el paso al tocar el muro y seguía intentando avanzar de frente. El cerdo ya probaba pasos tangentes legales. Ahora ambos usan el mismo selector de tangentes; solo se prueban alternativas si el paso directo está mayormente bloqueado. Se mantienen el muro, caminos, límite de alejamiento y captura quieta.
2. La pausa por distancia ponía la velocidad de reproducción en cero. Algunas vías para volver a moverse no la restauraban. El caballo podía avanzar con la imagen congelada. Ahora la animación responde al desplazamiento final y sale de esa pausa al moverse de verdad. No se modifica ni duplica su caché de fotogramas.

El caballo tiene la colisión entre cuerpos desactivada deliberadamente desde versiones anteriores. Su movimiento confirma directamente el paso ya validado contra el terreno, sin una segunda integración del mismo paso. No se añade colisión con el jinete ni se cambia la domesticación.

Escena manual de 150 pasos: antes el caballo contra el muro recorre 3,8 unidades; después 550,1 sin atravesarlo. El caballo que vuelve de la pausa pasa de cero cambios de fotograma y reproducción a cero, a 32 cambios y reproducción activa. Los vídeos muestran ambos casos. No es una prueba de la partida exacta de Ant ni de Android físico.

## Rendimiento y el pico de física

- Escena estática de muro/cabras: 12 llamadas de dibujo y 25 nodos antes y después. Media de escritorio 19,28 -> 19,52 ms; variación pequeña, no una garantía universal.
- Mundo completo de escritorio: reposo 22,17 ms antes, 22,46 y 22,26 después; 275 llamadas de dibujo en todos. Desplazamiento 25,71 antes, 25,81 y 25,86 después. El movimiento distinto de los caballos cambia qué entidades quedan en rango, por lo que esa ruta no es una equivalencia exacta de contenido.
- Dos caballos, uno continuamente contra el muro: aproximadamente 87 -> 103 microsegundos por paso en el arnés de prueba. Las alternativas tienen coste cuando hay bloqueo, no son gratis. No hay nuevos escaneos permanentes, animales o tareas de simulación.
- No se ha reproducido ni atribuido de forma concluyente el pico de 31 ms de física del teléfono. La captura mostraba 60 FPS y unos 1,9 ms propios del mundo; las muestras del motor y el frame no deben sumarse ni tratarse como una atribución por entidad. Los datos de escritorio no certifican el mismo coste móvil.
- No cambia la frecuencia de guardado ni se elimina protección de progreso.

## Validación

231/231 pruebas, 41.433 aserciones y 40 scripts. Incluye tangentes en las seis formas a 30/60/120 Hz, no atravesar muros, límite de alejamiento, captura quieta, fotogramas que avanzan tras pausa lejana, cerdos, cabras, profundidad, dirección, nombres sin coordenadas, caché de miniatura y viajes. Cuatro deprecaciones. Algunas baterías previas emitieron un aviso de dos objetos vivos al cerrar; la última ejecución completa termina sin ese aviso.

Capturas y vídeos revisados visualmente. Sin prueba física de esta APK en Android. Pendiente la comprobación de Ant en el muro donde encontró los caballos y al volver a acercarse a una manada lejana.
