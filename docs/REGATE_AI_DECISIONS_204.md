# Rancho Prueba 2.7.146

## Regate sin detenerte para dar doble toque
Frontera y carreras ya reconocen el mismo gesto del rodeo clásico: mientras corres con el dedo apoyado, levanta y vuelve a apoyar en menos de 0,3 segundos para dibujar el sprint. Después suelta para ejecutarlo. Se conserva el doble toque desde parado y la recarga de 2,5 segundos. No se crea otro sistema de movimiento: faltaba conectar el estado de movimiento al componente compartido.

Justa vuelve a tener sprint por la petición más reciente de Ant, que sustituye su desactivación anterior. No se puede activar durante la preparación. Conserva dirección de pasada y límites: un trazado contra el límite se cancela limpiamente sin devolver la recarga.

## Reloj bajo el jinete
En carreras y justa el aro del jugador muestra la disponibilidad: se vacía al usar sprint y se rellena en sentido horario durante la recarga. Completo dorado significa listo; arco turquesa significa recargando. No se confunde con el círculo grande de apuntado del lazo.

## IA sin reflejos de máquina
Eliminada la consulta del lazo rival y su punto de aterrizaje para esquivar. Los sprints de IA dependen de un temporizador propio, no de que el jugador lance: primera intención a los 6,8/8,1/9,4 segundos según rival, luego cada 6,5-8,9 segundos. Carreras también respeta vallas y límites al intentar su sprint. Duelo y justa siguen el mismo plan independiente.

No se reduce el área de captura, no se dan inmunidades ni se fuerza el resultado de un lazo. Un lazo puede fallar por movimiento normal o por un sprint que coincidía con el plan, pero no provoca ese sprint. Se ha probado captura con vuelo real sin reacción; no se afirma un porcentaje de acierto humano no medido.

## Validación y límites
62/62 pruebas dirigidas en ventana, 461 aserciones: Frontera real tras carga, gesto táctil, pulsación mantenida larga, reintento, recarga, bloqueo de preparación, justa, música, legibilidad y lazo real. Capturas del reloj vacío, medio y lleno inspeccionadas. No Android físico.

Una tanda antigua adicional conserva cuatro fallos también reproducidos con el código anterior: fixtures de carga/entrenamiento de Frontera, antigua inercia al acabar regate y tolerancia geométrica del suavizado. No se cuentan como pasados. Dos pruebas antiguas de trazado se actualizaron para comprobar ejecución contra la proyección suavizada compartida en vez de exigir los puntos crudos anteriores.

Misma música corregida sin silbido, mismo paquete `com.example.rancho.review`, versionCode 405, misma firma. Sin cambios de main, web, tienda, economía ni progreso. Músico Ganjo queda para otro ciclo cuando llegue su arte.
