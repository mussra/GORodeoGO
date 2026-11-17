# Rancho Prueba 2.7.179: encargos, destinos y zoom

APK de prueba, código 438. Mismo paquete y firma, para instalar encima. Solo rama de pruebas, sin main ni tienda.

## Encargos que se pueden leer y completar

La lista admite arrastrar con el dedo y tiene una barra dorada visible. Un gesto que empieza dentro de la lista permanece en ella: no pasa a controlar al jinete al salir del panel. Los encargos nuevos muestran el objetivo real, su progreso y el regreso pendiente.

Cada personaje ofrece un trabajo antes de recomendar a otro:

- Granjero: entregar un cerdo o una cabra por 40 puntos. Reconoce los animales que ya tienes, incluso antes de aceptar. La entrega descuenta ese animal una sola vez.
- Florista: recoger tres flores reales con aura azul en los alrededores y volver. Recompensa: 120 puntos.
- Guarnicionero: domar un caballo salvaje después de aceptar y volver. Recompensa: 120 puntos. El caballo permanece en tu cuadra.
- Loco: visitar el punto dorado fuera de la puerta y regresar. Recompensa: 80 puntos.

Aceptar, progresar, regresar y cobrar son estados separados. La recomendación solo aparece después de entregar el trabajo y recibir las gracias. Los dos encargos originales del granjero y de la florista del pueblo inicial se conservan para no romper sus desbloqueos; la recomendación se abre al terminar esa secuencia.

Se pueden capturar cerdos y cabras sin tener un encargo. El granjero inicial también reconoce el inventario para su entrega. Inventario, recompensa y entrega se guardan juntos; si falla el guardado, se revierten. Las pruebas incluyen entrega repetida, inventario insuficiente y fallo de guardado para evitar cobrar dos veces o perder animales.

## Mapa grande y llegada

El mapa usa las posiciones de los pueblos del mundo generado, no posiciones antiguas almacenadas. Ajusta el encuadre para mostrar varios destinos recomendados y señala qué profesión te envía a cada uno. Los destinos al sur colocan el texto encima para evitar cortarlo por el borde. No se inventa una profesión para recomendaciones antiguas que no permiten recuperar su origen.

La miniatura del pueblo destino en el diálogo se conserva. Las marcas de objetivo son flores que se pueden recoger o el punto que hay que visitar, no flores decorativas pintadas en el mapa.

La primera llegada muestra el nombre grande del pueblo, sin coordenadas, sobre una banda con entrada y salida progresivas.

## Cerdo junto al muro

El selector de escape conserva durante un breve intervalo una dirección tangente legal, en lugar de alternar de lado cada frame. El giro visual usa una zona muerta y un pequeño tiempo de confirmación. La animación de huida requiere desplazamiento real. Caballos y cerdos comparten el selector de escape.

En una reproducción controlada de 180 pasos, el cerdo pasa de 145 cambios de orientación a 3; no atraviesa el muro en ninguno de los dos casos. El recorrido neto pasa de 410,88 a 416,16 unidades. El vídeo anterior ya avanzaba aunque vibraba: esta escena demuestra la mejora del temblor, no reproduce de forma concluyente el atasco exacto del teléfono.

## Zoom y animales más lejanos: experimento acotado

El mínimo pasa del 25% al 5%. Un 0% literal no produce una vista útil. Se añaden los pasos 5%, 10% y 15%. Al alejar la cámara se preparan más sectores: radio 1 normalmente, radio 2 por debajo del 70% y radio 3 por debajo del 25%, hasta 49 sectores. La generación sigue repartida entre frames. Preparar sectores no los marca como explorados ni completa encargos. Se mantiene la pausa de física lejana.

Medición de escritorio con renderizado por software, 1280x720, misma semilla y 150 frames estables por caso:

| Vista | Sectores | Nodos | Memoria | Frame medio | Física media / máxima |
| --- | ---: | ---: | ---: | ---: | ---: |
| 25%, radio 1 | 9 | 395 | 110,34 MiB | 22,94 ms, unos 43,6 FPS | 0,175 / 0,183 ms |
| 25%, radio 2 | 25 | 1020 | 127,39 MiB | 23,42 ms, unos 42,7 FPS | 0,411 / 0,512 ms |
| 5%, radio 3 | 49 | 1800 | 132,79 MiB | 23,94 ms, unos 41,8 FPS | 0,723 / 0,944 ms |

La ampliación al radio 3 tarda 11,19 segundos en terminar de preparar el contenido y registra un pico de frame de 131,49 ms; la física llega a 1,087 ms. Hay un tirón de generación pendiente de mejorar. No son FPS de Android ni explican el antiguo pico de física del móvil. El coste estable y la memoria suben al preparar más animales. Se conserva como prueba acotada, no como promesa de rendimiento móvil.

## Validación y límites

250/250 pruebas, 41.748 aserciones y 43 scripts. Cuatro deprecaciones. Las pruebas de reversión provocan errores de guardado intencionadamente. Hay avisos de UID de fuentes de GUT con recuperación por ruta. Una ejecución anterior avisó de dos objetos vivos al cerrar; la última batería completa no muestra ese aviso. El arnés visual sí deja avisos de recursos al cerrarse.

Capturas revisadas de trabajos, lista, recomendaciones, mapa, título y vista alejada; vídeos antes/después del cerdo. La APK está firmada y verificada. No se ha probado físicamente en Android. Quedan por comprobar el arrastre real en el teléfono, el muro concreto del cerdo y el coste del zoom con los animales lejanos en ese dispositivo.
