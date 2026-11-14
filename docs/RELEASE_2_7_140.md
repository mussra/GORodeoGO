# Rancho Prueba 2.7.140

APK de prueba. Añade una copa optativa con progreso, caballo especial y recuerdo elemental al circuito del cruce y duelo de lazos de 2.7.139. Rama `feat/open-world-test-20261107`; sin cambios en main, web ni tienda.

## Para probar
En Carreras, entra en "Copa de objetivos · prueba". Lee el objetivo y pulsa Jugar. Al terminar, vuelve a la copa. Las carreras libres siguen sin premios.

- 32 objetivos ordenados en ocho capítulos: aprender las pistas, podios, técnicas, victorias y finales que combinan posición con lazos, regates o no recibir lazos. Incluye ganar el duelo 2-0.
- Solo el objetivo actual se acredita, con resultados reales. Una manga no equivale a ganar un duelo. Un lazo cargado no equivale a un acierto.
- Progreso separado del guardado anterior. Normal y Debug tienen archivos distintos. La sesión temporal no concede progreso ni premios.
- Sin precio de inscripción, moneda nueva, esperas por reloj ni compras.

## Premio único al terminar
"Recoger premios" guarda juntos a Brisa del Alba y la Brújula del Viento. Se comprueba que la copa esté completada. Un fallo de guardado revierte ambos; pulsar de nuevo o recargar no duplica el premio.

- Brisa del Alba es un caballo celeste con estrellas, adulto y capaz de saltar, con estadísticas base. No se monta automáticamente ni reemplaza ningún caballo.
- Su cualidad Temple de cruce reduce el tiempo del freno por roce en el molino de 0,65 a 0,52 segundos. No sube la velocidad ni reduce los efectos del lazo. Una cría con al menos un progenitor portador hereda la cualidad, sin sorteo oculto.
- La Brújula del Viento queda en el recibo de la copa con una pista sobre el árbol madre. Es un recuerdo narrativo elemental, no un poder utilizable ni un activador de unicornio. El ritual existente continúa deshabilitado.

## Validación y límites
- 164/164 pruebas en 26 scripts, 3.398 aserciones: carreras, cruce, duelo, entrada con dos dedos simulados, menú, regate, modo Normal/Debug, crecimiento y premios. Ejecución con ventana gráfica para las pruebas de entrada.
- Incluye concesión única, recarga, herencia, ficha del caballo, datos anteriores, fallo de disco y reintento ligado al mismo modo.
- 711/711 pruebas unitarias adicionales en dos lotes.
- Inspección visual del selector, objetivo, resultado, final y recogida de premios. Los finales son fixtures de QA, no una campaña humana completada.
- Si falla el guardado de un resultado, puede reintentarse desde la copa mientras el proceso siga abierto. Todavía no hay recuperación de ese resultado pendiente después de cerrar forzosamente la aplicación.
- Avisos de limpieza de objetos al cerrar algunos tests siguen pendientes.

La duración de dos o tres días es un objetivo de diseño, NO una duración demostrada. 32 objetivos pueden completarse en una sesión por un jugador hábil. Falta jugar sesiones humanas, medir repetición/diversión y probar instalación, tacto y rendimiento en Android real. No es una versión de producción ni un juego ya terminado.

APK arm64, paquete `com.example.rancho.review`, versionCode 399, misma firma de pruebas que 2.7.139.
