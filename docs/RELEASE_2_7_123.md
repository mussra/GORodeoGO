# Rancho Prueba 2.7.123

## Siesta a sitios, notas y capturas

Ahora la siesta avanza en línea recta hacia la mitad de la distancia al destino, sin buscar rodeos. Si encuentra río, montaña, edificio, objeto físico o el límite del terreno conocido, el caballo se para antes y despiertas allí. Es el riesgo de dormir: tendrás que resolver el paso jugando. El rancho, los sitios visitados y las notas/fotos guardadas en terreno conocido son destinos válidos; la lista de notas tiene "Ir a esta nota".

Se comprueba el terreno y se barre la forma física real del caballo por las zonas intermedias, cargándolas antes de comprobar cada tramo. No busca un hueco de llegada al otro lado de una pared. Si el caballo choca durante el cierre del ojo, despierta donde se ha parado. Un fallo de guardado sí revierte el viaje al origen.

Se mantiene el tramo corto final manual y el descanso entre siestas. El aviso aparece completo encima del mapa, debajo de la barra superior, sin tapar notas ni confirmaciones. Un destino cercano usa otro texto, no un falso aviso de ruta imposible.

Caso de nota en prado conocido con mundo versión 3, semilla 752026, salida (500,3000), destino (6500,3000): avanza hasta (3500,3000). Caso de río real del país: salida (9917,2863), nota en la otra orilla (12317,2863), despierta en (10349,2863), antes del agua, sin desviarse. Pared física de 8 px entre zonas: también se detiene en el lado de salida. Son partidas de simulación, no la partida exacta del usuario. No se añaden descubrimientos ni se cambian notas. El aviso dice: "El caballo se ha detenido antes de un obstáculo o de terreno desconocido. Te despiertas aquí; tendrás que seguir a caballo."

## Adornos visibles

Bandas de las patas más anchas, plata azul/gris contrastada y oro ámbar. Sin rayas diagonales ni brillo móvil: el metal sigue el ancho local y la luz original de cada pata, con reflejo redondeado y bordes suavizados. Retrato y animaciones comparten el acabado de metal. Revisadas las 133 poses con máscara: montado, sin jinete, cinco direcciones, salto, golpe y beber. Las patas ocultas por la cola no se pintan por encima. No cambian precios, requisitos, genes, estadísticas ni progreso.

## Pantalla de carga

Hierba del juego abajo; cielo azul claro y nubes blancas arriba. Los animales y el jinete siguen desfilando durante la carga.

## Lazo fallado

Los cerdos no estaban incluidos en el aviso de impacto que ya recibían los caballos y cabras. Además, fuera del radio de proximidad su persecución no conservaba ese susto. Ahora los cerdos cercanos al fallo se alejan durante el susto. Verificado también el movimiento de las cabras. No afecta a animales ya atados o capturados ni convierte animales agotados en animales frescos.

## Capturas a pantalla completa

Tocar la miniatura de una foto guardada en la lista de notas o en su editor abre la imagen original ajustada al área completa, sin deformarla. Botón "Cerrar imagen" y atrás cierran el visor. No modifica ni sustituye la captura guardada.

## Navegación

Retirado el botón antiguo "Volver a casa" del menú de Frontera. El rancho sigue siendo un sitio visitado al que se puede elegir viajar con la siesta; no se elimina ese destino ni su lógica.

## Verificación

- 655/655 pruebas unitarias, 2.558.920 comprobaciones.
- 127/127 pruebas de integración, 6.661 comprobaciones.
- Incluye ruta real a nota fuera del camino generado, parada antes del terreno desconocido/bloqueado, río real, pared fina, choque durante el cierre del ojo, conservación de notas y descubrimientos, susto y movimiento de cerdo/cabra, animales atados/distantes, toque en ambas miniaturas, resolución original y cierre.
- Capturas inspeccionadas a 1280×720 y aviso a 960×540. Pruebas de escritorio, no prueba ni certificación Android físico.
- Persisten avisos de recursos al cerrar el ejecutor de pruebas. No son fallos de las comprobaciones; no se ha demostrado ausencia de fugas en sesiones largas.

Paquete com.example.rancho.review, arm64, versionCode 382, misma firma de Rancho Prueba. Instalar encima, sin desinstalar. Rama feat/open-world-test-20261107, main intacta, sin publicación en tienda.

La ampliación de niveles 21-40, llaves, crecimiento y cadena Galaxy/ritual sigue pendiente y no se presenta como terminada.
