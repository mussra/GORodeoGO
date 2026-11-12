# Rancho Prueba 2.7.97

## Flores de misión en la zona salvaje del pueblo

Las tres flores azules y las tres doradas ya no aparecen pegadas a la floristería. Se reparten en seis puntos separados de terreno salvaje alrededor del pueblo que las pide. Sus lugares dependen de la semilla; evitan el camino, las montañas, los obstáculos naturales y los corrales generados. No se borran árboles ni se cambia el generador del terreno. Las colocaciones manuales del editor siguen siendo del jugador.

Se conservan los identificadores y el número de flores ya recogidas. Al actualizar, solo cambian de sitio las que falten. Los encargos terminados no se reinician. La florista explica que están en la zona salvaje cercana; el mapa conserva los iconos de las flores activas.

En los encargos nuevos de amapolas y violetas, la misión indica expresamente el otro pueblo. Las muestras de campo están ahora más dentro de sus campos, a más de1200 unidades de su floristería, siguiendo sus caminos norte/sur. La opción de pedir una muestra directamente a la florista de destino sigue siendo intencionada y válida.

## Avisos: gana el estado más reciente

Un aviso con el mismo texto y otro contador/cantidad reemplaza al anterior de su tipo. Si el anterior está en pantalla, se sustituye al instante y recupera su tiempo de lectura. Si esperaba en la cola, se actualiza allí sin añadir otro. Por ejemplo:1/3,2/3,3/3 deja solo3/3.

Esto se aplica a la cola compartida de mundo y niveles. Los avisos distintos conservan su orden; los errores no se eliminan por recibir un progreso. Las misiones usan además un identificador propio, para que instrucciones y progreso de la misma misión se reemplacen aunque cambien las palabras. Los encargos nuevos de floristas también lo usan.

## Manadas huidas: ubicación persistente

Causa reproducida: los caballos seguían perteneciendo al chunk donde nacieron. Si huían fuera de él, descargar ese terreno podía borrar un caballo que seguía a 300px del jugador.

Ahora:
- Descargar el terreno de origen no borra un caballo que siga cerca o esté sujeto con el lazo.
- Se registra cada individuo por su identidad estable, origen y última posición. Un índice por chunk actual permite cargarlo por donde está, no por donde nació.
- Al alejarse, se guarda antes de retirar la entidad de memoria. Si falla ese guardado, la entidad se conserva para reintentar.
- Volver a esa zona, incluso después de cerrar y cargar la escena desde disco, recupera el individuo allí. No se crea otra copia en su origen.
- Capturar un superviviente elimina su registro de posición; no reaparece al cargar.

Guardado aditivo `world/roaming139`, versión1, ligado a la semilla. No cambia genes, capturas, recuentos ni los generadores V1/V2/V3. No puede recuperar una posición de huida que una APK anterior ya hubiera perdido: registra los movimientos a partir de esta versión. No se simula movimiento mientras el individuo está descargado; permanece en su última ubicación guardada.

## Pruebas

- 582/582 pruebas unitarias,2556178 comprobaciones. Incluyen100 semillas por cada uno de los tres generadores para distribución, distancias y terreno libre; cola visible/pendiente, contadores, mensajes distintos e índice de posiciones.
- 50/50 integraciones pertinentes,659422 comprobaciones, 17 scripts en procesos aislados. Flores antiguas/nuevas, guardado, cercas, animales, lazo, orientación y manadas.
- Reproducción de streaming falla en la base sin corregir: el superviviente visible se marca para borrar al salir su chunk de origen. Con el cambio pasa. La prueba final mueve al caballo con 900 pasos de física y luego descarga ese origen.
- Guardar en disco, destruir escena, cargar, visitar origen, regresar a la última ubicación, capturar, no duplicar y fallo de guardado comprobados en simulación.
- QA visual de cuatro supervivientes: mismas identidades y posiciones exactas antes y después de guardar/cargar. Las capturas se hacen con una partida aislada y se detiene la IA para comparar posiciones sin que empiecen a huir otra vez al aparecer el jugador.
- Microprueba de índice en escritorio con 4000 individuos descargados,1000 muestras de nueve consultas: mediana 3 microsegundos, p95 3, máximo 26. Solo mide la búsqueda espacial, no el renderizado ni los FPS de Android.
- Permanecen advertencias preexistentes de objetos/recursos retenidos al salir de la suite. Una prueba de campaña no relacionada se interrumpió por tiempo y no se incluye en los 50 resultados.

No probado en teléfono físico. No se han cambiado los tamaños, el arte ni las animaciones de los personajes. El loco del pueblo no forma parte de esta APK.

## Cómo probar sin borrar partida

1. Instala sobre Rancho Prueba 2.7.96. Mantiene paquete y firma; no hace falta borrar la partida.
2. Si tienes flores azules/doradas pendientes, mira el mapa y búscalas por la zona salvaje de ese pueblo. Las recogidas siguen contando.
3. Comprueba que al recoger varias el aviso visible salta al último número sin esperar a los anteriores.
4. Captura un caballo y sigue a los supervivientes mientras huyen. Al cambiar de zona no deben desaparecer delante del jugador por descargar su origen.
5. Aléjate bastante, vuelve y comprueba dónde quedaron. Guarda, sal/carga y vuelve a esa ubicación; no deben reaparecer por defecto en su punto inicial.

Evita guardar la misma partida con una APK anterior si quieres conservar las posiciones nuevas y la expansión de flores: esas APK desconocen las secciones aditivas y pueden descartarlas.

## APK

Paquete `com.example.rancho.review`, versionName 2.7.97, versionCode 356, arm64-v8a, mínimo Android 24, target 36. Firma V2/V3; certificado SHA256 `46bdcb2213f8b82696b918f5cfd5764cd5690038ae2938aaec6f11bfffb79bbb`.

67540240 bytes. SHA256 `f127194cfabb6b162023ab06be750f4c8ad7383166a49a4fa334bbeb5d552b78`.
