# Reposo del caballo y controles del mapa

Preview sin APK, en `feat/open-world-test-20261107`. No modifica main.

## Reposo
- La causa era `idle = primer fotograma de marcha`, con una pata levantada.
- El caballo montado usa las dos poses de beber existentes: cabeza levantada en reposo y cabeza baja como gesto. No hay arte raster nuevo.
- Espera aleatoria de 5 a 10 segundos, gesto de 3 segundos y nueva espera aleatoria. El ciclo continúa mientras siga parado. El movimiento corta el gesto y conserva los nueve fotogramas de marcha.
- Alineación compensada por la diferencia de ancho entre los lienzos de 112 y 96 píxeles.
- Los retratos adultos ya usaban una ilustración independiente con patas apoyadas.
- Salvajes: se corrige la selección de idle cuando se paran, están enlazados o quedan fuera de actividad. Su recurso idle sigue siendo un fotograma de marcha: falta una pose de reposo SIN jinete para resolver también el dibujo. No se ha reutilizado una imagen con jinete para ellos.

## Mapa
- Android: arrastrar con un dedo y pellizcar con dos. El zoom conserva el punto bajo el centro de ambos dedos y permite mover ese centro.
- PC: arrastrar con botón izquierdo y zoom con rueda centrado en el cursor. Se ignoran eventos de ratón emulados por pantalla táctil.
- Después de un pellizco no se abre una nota accidentalmente. Una pulsación larga nueva sigue abriendo notas.
- Se mantienen +/- y slider, límites de zoom 0,5 a 32x y límites de desplazamiento.
- X y Encontrar mi caballo usan el estilo dorado. El botón recentra al jugador actual sin cambiar el zoom, sujeto al límite de desplazamiento existente. Si el jugador está cerca del borde de la zona descubierta y el clamp impide llevarlo al centro, se acerca hasta donde permite el mapa.
- Marcador con aura circular translúcida que aparece y desaparece. Tamaño constante en píxeles de pantalla, independiente del zoom. El marcador queda recortado al área del mapa, sin invadir la cabecera.
- HUD superior marrón con borde dorado y botón Menú dorado.

## Verificación
- 541/541 pruebas unitarias, 1.588.152 comprobaciones en la pasada final. El número puede variar ligeramente por esperas aleatorias y pruebas de carga.
- 11/11 integraciones pertinentes, 1.257 comprobaciones: notas/foto/persistencia de caballo, montañas, cerdos, flores, mundo nominal, huida/caminos, florista, NPC y caché.
- Pruebas nuevas: dos contactos con índices distintos, ancla de zoom, paso de dos dedos a uno, supresión de notas, rueda, arrastre con ratón, botón de recentrado y clamp. Secuencia de reposo simulada durante 60 segundos.
- Capturas reales del render a 896x414 inspeccionadas, tanto mundo como mapa y zoom. También se inspeccionaron reposo/gesto/marcha ampliados.
- No probado en Android físico. No se ha generado APK. Las capturas de tamaño móvil no son una certificación de rendimiento táctil en un dispositivo.
- Persisten avisos conocidos de recursos y objetos al cerrar las escenas de QA; no se presenta el cierre como limpio. Sin cambios de formato de guardado ni de generador V1/V2.
