# Rancho Prueba 2.7.96

## Hecho en el mundo V3

- Dos campos silvestres extensos: amapolas rojas y violetas. Cada especie llena un núcleo de 2048x1024px (dos chunks) con un borde exterior irregular, estable por semilla. Pocos árboles dispersos, sin mezclar las flores decorativas aleatorias dentro del campo.
- El mapa y minimapa muestran el mismo contorno suave en los chunks ya descubiertos. No revelan terreno sin visitar.
- Un asentamiento nuevo del Camino del Este, con dos casas y una floristería real, junto al camino principal existente. Se reserva más allá del extremo este ya explorado y queda fijo en el guardado. No recoloca pueblos anteriores ni modifica los generadores V1/V2.
- Dos encargos nuevos, después de los dos antiguos de la florista: muestra de amapolas y luego de violetas. La florista de destino permite pedir una muestra directamente o preguntar dónde recogerla. Ambas vías valen; la entrega solo cuenta al volver a la florista de origen.
- Pistas cardinales, sin coordenadas: este para el pueblo, norte y sur para sus campos. Caminos visibles y transitables conectan el pueblo de origen, el de destino y las dos muestras.
- Cada entrega crea su propio cultivo visible al sur de la tienda de origen y un agradecimiento que lo reconoce. Se guarda junto con la misión, una sola vez; recargar o hablar de nuevo no duplica muestras ni cultivos. Un fallo de guardado conserva la muestra y el estado anterior.
- Cultivos cercados junto a las dos floristerías, con puertas abiertas y acceso central libre. La tienda de origen tiene azules/doradas desde el principio, no las especies que todavía debe pedir. El espacio de una edición manual del jugador se respeta: se omite una parcela si una edición la ocupa.

El estado nuevo está separado en `world/flora138`, versión1. Conserva las misiones, capturas, notas, genes, progreso y datos de terreno anteriores. No se crean efectos por entregas antiguas que el registro no demuestra. No usar una APK anterior para guardar sobre esta partida si se quiere conservar la expansión: esa APK no conoce su nueva sección.

## Cómo probar

1. Entra en un mundo V3. Si quedan encargos antiguos de tres flores azules y tres doradas, termínalos; no se borran ni se saltan.
2. Habla con la florista y acepta las amapolas. Sigue el camino al este: pasa por el nuevo pueblo.
3. Habla con su florista. Puedes pedir la muestra o seguir el camino al norte para recoger la marcada en el campo rojo.
4. Vuelve a entregar la muestra en la floristería de origen. Mira el cultivo al sur y vuelve a hablar con ella.
5. Repite con violetas, cuyo campo está al sur del pueblo de destino. Prueba la otra vía de obtención.
6. Sal y carga la partida: los dos cultivos y los encargos terminados deben mantenerse, sin reabrirse.

V1/V2 conservan su contenido anterior. Esta versión no convierte partidas antiguas en V3. La ampliación de V3 se activa sin borrar la exploración anterior y no cambia la semilla del mundo.

## Pruebas y límites

- 574/574 pruebas unitarias, 2540847 comprobaciones. Después del último ajuste de texto/persistencia de pista se repitieron las9pruebas nuevas:16895 comprobaciones.
- 32/32 pruebas de integración pertinentes,13scripts ejecutados por separado para aislar el estado global:659037 comprobaciones. Incluyen las dos vías, vuelta/entrega, fallo de guardado, recarga, no repetición, mundo V1 sin ampliación, cercas, mapa, animales, lazo y orientación.
- El recorrido de carretera se simula sobre la escena real, construyendo sus chunks y comprobando colisión/superficie a lo largo del trayecto. La geometría de trazado se comprueba con50semillas.
- Se corrigió la preparación de un test antiguo que esperaba las tres cabras del mundo legado pero creaba por defecto un mundo V3. El mismo fallo se reprodujo en la base e3e447c antes de ajustar el test; no se alteró el número de animales del juego para hacerlo pasar.
- Flores agrupadas en MultiMesh de tiles de512px, construidos como máximo uno por frame y retenidos mientras sigan visibles. No hay nodo, colisión, proceso ni fila de guardado por tallo.
- Medición orientativa de escritorio, Mesa llvmpipe,1280x720: máximo3049instancias en12tiles, unas10llamadas de dibujo adicionales; mediana29,2ms con flores y21,3ms sin esa capa, p95 34,1ms frente a24,6ms. Construcción del tile de mayor coste:3,94ms en esa pasada. Son mediciones de renderizado software, NO de Android.
- Las capturas proceden de la escena de juego con una partida aislada de pruebas. Para mostrar el mapa completo se marcaron los chunks de ejemplo como descubiertos en esa partida de QA; en el juego normal se descubren cabalgando.
- Permanecen advertencias preexistentes de recursos/objetos retenidos al salir de la suite. No se ha probado un teléfono físico, controles táctiles reales ni rendimiento móvil.

Alcance cerrado de esta entrega: campos, encargos entre estas dos floristerías, efectos guardados y cultivos cercados. No es toda la futura red regional de pueblos. Primos/pistas del unicornio, país nuevo, árbol gigante/río/fuente, Galaxy PURO, bosque y viaje rápido de siesta siguen pendientes. No se han integrado las nuevas referencias de caballo192px ni cambiado sus animaciones.

## APK

Paquete `com.example.rancho.review`, versionName2.7.96, versionCode355, arm64-v8a, mínimoAndroid24,target36. FirmaV2/V3, mismo certificado SHA256 `46bdcb2213f8b82696b918f5cfd5764cd5690038ae2938aaec6f11bfffb79bbb`.

67535947bytes. SHA256 `31020aef7354b96abafacf1233ca481c29d5c1b9b0b2c9c69913fc70e4548ef3`.
