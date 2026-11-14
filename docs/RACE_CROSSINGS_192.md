# Cruces de carreras: avance local

No publicado. Los tres circuitos anteriores se conservan. Se añade "Cruce del molino", un circuito en ocho con dos pasos por la misma intersección a nivel.

## Reglas aplicadas
- Al coincidir dos jinetes de distintos tramos a menos de 48 unidades dentro del cruce, ambos sufren un roce breve: 28% menos velocidad durante 0,65 segundos. No se empujan ni bloquean, no hay daño, aturdimiento ni pérdida de capturas.
- Protección de 1,5 segundos para evitar una cadena continua de frenados. Un salto en curso evita el roce a nivel del suelo.
- Los jinetes conservan su distancia y ramal de recorrido. El cruce no permite que la proyección salte al otro lado del ocho. Las 16 puertas siguen siendo obligatorias y una puerta compartida geométricamente necesita además el tramo correcto.
- La clasificación, los objetivos de la IA y el mapa siguen el ramal del jinete, no simplemente el punto de carretera más cercano.
- Si un rival con salto queda bloqueado ante una valla, puede tomar el paso lateral existente. No se teletransporta, no atraviesa obstáculos ni aprende una capacidad nueva.

## Decisiones pequeñas
El roce afecta a ambos para que no exista un jinete fantasma prioritario; el frenado es suave y temporal, coherente con la petición de que alguien lento te estorbe un poco. Es una primera apuesta de balance, no un ajuste definitivo. El primer prototipo usa un cruce central, con dos encuentros posibles por vuelta, antes de añadir intersecciones adicionales difíciles de leer.

## Comprobado
- Pruebas del ramal correcto en el mismo punto físico, rechazo de avance por el ramal remoto, roce/protección sin aturdimiento y salida por el hueco de una valla donde se bloqueaba un jinete con salto.
- Vueltas completas con los cuatro participantes y las 16 puertas: sin salto y con salto. Se simula física a velocidad normal.
- Mapa en ocho, marca del cruce y vista de carretera inspeccionados visualmente en escritorio.

No se publica APK ni web con este cambio. Falta prueba humana en Android, más vueltas con distintos ritmos y comprobar si el cruce genera encuentros suficientes para resultar divertido.

## Resultado de cierre local
107/107 pruebas dirigidas de integración aprobadas. El lote específico de carreras/diálogos/cruces pasa 38/38. Las ocho combinaciones (cuatro circuitos, con/sin salto) terminan con los cuatro participantes: se repitieron también las seis combinaciones antiguas tras el cambio. Cruce del molino: 69,90 s sin salto y 68,70 s con salto hasta la última llegada.

No se ha generado, subido ni publicado un APK nuevo. La versión disponible en GitHub sigue siendo la 2.7.138, anterior a los cruces.

Actualización posterior: este cambio se incluye en la versión de pruebas 2.7.139, junto con el duelo. La indicación anterior de no publicación describe el cierre local inicial, antes de recibir la orden de preparar ese APK.
