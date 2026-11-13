# Rancho Prueba 2.7.127

## Encargos y lectura
- Encargos separados en tarjetas, con título, objetivo, estado y barra de avance cuando corresponde.
- Lista desplazable, con aviso de desplazamiento y márgenes pensados para móvil.
- Componente visual compartido en conversaciones del granjero, la florista y los primos, contratos, tablón, diario y avisos. Los avisos siguen siendo translúcidos para no tapar el juego.
- En ensayo aislado, aviso temporal y rótulo fijo separados para que no se pisen.

## Minimapa
- Minimapa de Frontera y País guardado colocado arriba a la izquierda, bajo la barra superior.
- Abrir Encargos ya no oculta el minimapa. Se inicializa al entrar y se restaura al volver del menú o de una vista de diseño.
- Eliminada la entrada Mapa del menú de Frontera. El minimapa permite seguir abriendo y cerrando el mapa grande.
- Se ha corregido una causa comprobada de ocultación. No se ha reproducido por separado un posible fallo de arranque específico de Android.

## Maestría
- Para nueva maestría, cada caballo debe ganar los cinco niveles distintos 36, 37, 38, 39 y 40 con esa montura. Cada uno aporta 20%; repetir un nivel no suma.
- Los niveles 16-20 y completar ahora 1-20 no conceden nueva maestría.
- Se conservan las maestrías ya obtenidas antes de esta versión al completar 1-20 o 21-40. La migración no convierte un antiguo 19/20 en maestro al terminar ahora el nivel 20.
- Se conserva el historial de niveles. La ficha explica el nuevo requisito o que se conserva una maestría anterior.
- Galaxy maestro sigue requiriendo caballo adulto de acabado Galaxy y 100% de maestría. El ritual usa el mismo requisito compartido.

## Verificación
- 684 pruebas unitarias superadas, con 2.559.326 aserciones.
- 31 pruebas dirigidas de tarjetas, minimapa, contratos, mapas y victoria real con la montura original superadas, con 245 aserciones. Prueba adicional de victoria real en nivel 40 y conservación de maestría anterior: 1/1, 3 aserciones.
- Escenas reales inspeccionadas a 960x540 y 1600x720; desplazamiento mediante eventos táctiles simulados; comprobaciones de minimapa al cargar, abrir Encargos, cerrar mapa grande y volver del menú.
- Inspección visual de conversaciones, diario, tablón, contratos, avisos, HUD de ensayo y ficha de maestría nueva/anterior.
- Simulación de escritorio, no prueba física Android. Una ejecución más amplia de integración de campaña no terminó dentro del tiempo de la sesión de prueba; no se incluye como prueba completada.
- Se mantienen avisos conocidos de recursos al cerrar las pruebas. No se han observado errores de ejecución en las escenas visuales comprobadas.

## Instalación
- APK de prueba arm64, paquete com.example.rancho.review, versión 2.7.127, código 386.
- Misma firma que las versiones de prueba anteriores. Instalar encima; no desinstalar si se desea conservar el guardado local.
- SHA-256 del APK: dffa3bc8e42b64f53189ee114614a4ca94557118bdf8eb16b3b9504d1c890085.
- Tamaño: 71.402.017 bytes.
- Rama de prueba feat/open-world-test-20261107. Sin fusionar en main, sin publicación en tiendas ni gastos.
- El ZIP de Windows sigue en 2.7.125. La preparación web sigue local, sin subir ni desplegar.
