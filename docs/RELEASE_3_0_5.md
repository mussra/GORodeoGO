# Rancho Prueba 3.0.5

## El rancho es una zona segura
El suelo de entrega marcado RANCHO en Rodeo (80×80, incluido el borde) protege al jinete. Mientras está dentro, los toros salvajes dejan de perseguirle y se retiran del rancho, con una zona de evitación de 100 px alrededor. No hay teletransporte: si estaban cerca cuando entras, se alejan andando. El contacto por distancia no puede aturdir ni hacer soltar capturas a través del límite. Al salir se recupera la regla habitual de golpe y pérdida de capturas.

Esto no convierte en refugios todos los corrales de salida de los puzles ni todo Frontera. Los toros devueltos del corral del granjero de Frontera siguen siendo decorativos, sin persecución.

## Látigo de chasquido por calidad
| Calidad | Radio | Efecto | Recarga |
| --- | --- | --- | --- |
| Básico | 240 px | 1,1 s | 5 s |
| Mejorado | 310 px | 1,4 s | 4 s |

Los animales afectados reciben esos segundos completos. Se eliminan los reductores ocultos del tiempo para toros y caballos. La tienda, la comparación de mejora y la confirmación muestran radio y segundos. Sin cambios de precio, equipamiento automático, premios ni guardado. El látigo solo hace ruido, sin golpes ni daño. No es la fusta de dibujar regates.

## Principal y diálogos
El jinete es algo menor y queda más abajo: el sombrero tiene más de 32 unidades de separación respecto a los botones superiores en los tamaños probados. El texto de equipo se adapta al mismo bloque para no pisar las patas en pantallas más altas. Se mantiene el logo de 3.0.4.

Una sola piel aplica el marco azul con borde dorado y los botones de los menús a los avisos, confirmaciones y conversaciones. Se repiten las piezas de borde, sin estirarlas. No se cambian acciones ni textos de confirmación.

Capturas de los nueve casos nativos: salir, equipo, salto, regate, propiedades, compra y venta de caballo, descartar y quitar emblema. También de siete paneles: granjero, florista, primo, nota de mapa, servicio, diálogo de pueblo y huerto. La casilla de adjuntar foto conserva su indicador propio.

## Pruebas y límites
447/447 pruebas dirigidas, 55.206 aserciones, 74 scripts. Reproducción rojo/verde del golpe a través del límite. Casos de bordes, entrada/salida, conservar/soltar captura y retirada del perseguidor. Pruebas de radio y segundos de ambas calidades, piel automática, botones añadidos después y separación del sombrero en cuatro tamaños.

25 capturas reales de Godot con perfiles de prueba separados. No se confirmó ninguna compra en las capturas. APK firmado y verificado, versión 3.0.5, código 465, mismo paquete y certificado que 3.0.4. No probado en Android físico: no certifica tacto ni rendimiento móvil. Persisten avisos de tests obsoletos y dos instancias ObjectDB al salir.

Rama de pruebas, sin tocar main ni publicar en tienda y sin gasto real.
