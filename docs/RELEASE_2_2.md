# Rancho Prueba 2.2

Revisión testable de mapa genealógico, modos de progreso separados, regate suavizado y salto de vallas. Rama de pruebas separada; sin cambios en main ni publicación en tiendas.

## Incluye
- Correcciones de máscaras aprobadas: retrato adulto, crin, cola y bordes.
- Mapa adicional de toda la ascendencia registrada, búsqueda por nombre/ID, filtros combinados, resaltar u ocultar, zoom y desplazamiento. Conserva colección y familia. Los antepasados externos se registran sin convertirlos en caballos en propiedad; no inventa padres.
- Normal y Debug con archivos independientes. Cambiar de modo guarda el que dejas; ambos conservan caballos, equipo, puntos y progreso. Arranque Normal. El guardado 2.1 se conserva como origen de migración, sin borrarlo. Un archivo ilegible bloquea guardar sobre él.
- Interfaz ampliada en español e inglés.
- El trazo del regate se limita antes de suavizar sus esquinas. La previsualización y la ejecución usan la misma curva.
- Vallas interiores desde nivel 3. Caballos con habilidad de salto las cruzan automáticamente al acercarse en movimiento; se comprueba trayectoria y espacio de aterrizaje. Animación por fases en cinco direcciones, recoloración y sombreros sincronizados. Perímetro y rocas siguen sólidos. Un golpe interrumpe el salto y conserva el aturdimiento y la suelta de capturas.
- Los toros no saltan. Los enlazados mantienen la colisión y recuperan una ruta alrededor de la valla.

## Decisiones de esta revisión
- Salto es una habilidad independiente del color y de la raza. Original no recibe la habilidad retroactivamente. Azul de prueba en un Debug nuevo sí salta, las parejas nuevas incluyen un caballo capaz y los premios nuevos desde nivel 3 pueden saltar. La cría la hereda si cualquiera de sus padres la tiene. La ficha indica si puede saltar.
- No se han asignado razas a partir del color ni creado un catálogo ficticio en la partida. Los campos de linaje son informativos. Las reglas A/B, dos adultos distintos, padres conservados y sin coste continúan. No se han añadido compras de caballos, genética mendeliana, restricciones raciales ni consanguinidad.

## Verificación y límites
64 pruebas focales y 75.272 aserciones pasan: genética, máscaras, cría, nombres, genealogía, separación de modos, fallos de guardado, localización, regate y física del salto. Carga de los 20 niveles comprobada. Incluye pruebas de límites, obstáculos, aterrizaje dinámico, interrupción por golpe, acciones en vuelo y ruta de toro enlazado alrededor de valla. Render real del juego revisado.

No es certificación de dispositivo físico Android. No se ha probado instalación sobre un teléfono ni rendimiento, gestos y persistencia en el teléfono del usuario. El motor de desarrollo produce avisos conocidos de compatibilidad de auxiliares GUT y UID, por lo que no se presenta como suite global limpia. Recomendable conservar una copia de datos. No desinstales la versión anterior para actualizar.

Paquete com.example.rancho.review, versión 2.2, versionCode 254. Firma compatible con 2.0/2.1: SHA256 46bdcb2213f8b82696b918f5cfd5764cd5690038ae2938aaec6f11bfffb79bbb.
