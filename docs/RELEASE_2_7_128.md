# Rancho Prueba 2.7.128

## Botones del mundo
- Hablar con personajes, Tablón de encargos y Recoger flor del este usan el mismo componente dorado que Encargos, con letra oscura, estados de pulsación/foco y separación uniforme.
- Botones contextuales ampliados de260/280px a330px de ancho y de46/48px a56px de alto, con letra22.
- Primos, Herramientas, Terminar edición y la salida de recuperación también usan el estilo compartido. La barra de herramientas ya no tapa el minimapa.
- La condición de cercanía, acciones, recompensas y guardado no cambian.

## Campos de flores
- Corregida la inversión vertical de las flores rojas y violetas del mosaico: pétalos arriba, tallo y hojas abajo. Se conserva el arte original y el punto de apoyo de cada flor.
- La precarga sigue la cámara real, con640unidades de margen y hasta dos segundos por delante del movimiento. Antes solo había80unidades de margen.
- Se retienen mosaicos cercanos al girar para evitar borrarlos y recrearlos en cada cruce. Se da prioridad a lo visible; la carga inicial no descubre el mundo hasta tener sus flores visibles.
- Construcción repartida entre fotogramas: máximo dos mosaicos por fotograma, con presupuesto blando de3ms. Un mosaico individual puede superar ese presupuesto; no se construye el campo completo de una vez.
- Se reutiliza el contorno del campo. Las posiciones y cantidades se generan igual que antes; no se cambia el progreso de florista ni la geometría del mundo.

## Comprobaciones
- 685/685 pruebas unitarias, divididas en dos grupos completos:373 y312 pruebas;2.559.282 aserciones en total.
- 31/31 pruebas dirigidas de tarjetas, minimapa, contratos y montura:245 aserciones.
- Pruebas adicionales de acceso a cultivos/retención de mosaicos y generador antiguo:2/2,159 aserciones.
- Carga inicial en campo: zona visible completa antes de revelar el mundo. Comprobación con renderizado GL real, incluida orientación de las instancias:1/1,34 aserciones.
- Pulsación táctil simulada sobre Hablar con granjero, Tablón y Primos: abre sus pantallas reales. Capturas revisadas a960x540 y1598x719; también tres accesos contextuales simultáneos y herramientas sin solaparse con minimapa.
- Recorrido gráfico de880fotogramas: entrada desde fuera a los campos rojo y violeta y giros en cuatro direcciones, con desplazamiento nominal520unidades/s a30fps. Cero mosaicos visibles ausentes; máximo40mosaicos retenidos y6pendientes. Construcción máxima observada de un mosaico:4,491ms en escritorio Mesa llvmpipe.
- No probado en Android físico. Los datos anteriores no certifican rendimiento ni ausencia de tirones en un teléfono. Se mantienen avisos conocidos de recursos al cerrar las pruebas.

## APK
- Rancho Prueba2.7.128, código387, paquete com.example.rancho.review, arm64.
- Misma firma de prueba que127. Instalar encima; no desinstalar si se desea conservar el guardado local.
- Tamaño:71402017bytes.
- SHA-256:246bff61c24ab971e3d62d77403fdd743e4eb2fdeec6bdf7d7cb383260d2da27.
- Rama feat/open-world-test-20261107, sin fusionar en main. Sin tiendas ni gastos.
- Maestría36-40 y conservación de lo ganado de127, sin cambios. Windows sigue125; web local, sin publicar.
