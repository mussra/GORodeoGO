# Rancho Prueba 2.7.160

## Duelo de lazos

Corregido un rechazo de impactos válidos: al caer el lazo se exigía que los dos caballos siguieran a menos de 220 unidades, aunque el círculo hubiese aterrizado sobre el rival. Ahora la captura se decide por el lugar real de caída y su radio de 58, igual para ambos. El límite de 220 sigue siendo de lanzamiento, no un segundo filtro después del vuelo. El rival conserva el mismo filtro de decisión de lanzamiento y su temporizador. No cambian alcance, vuelo, velocidad ni recarga.

Reproducido en la versión anterior: fallan 3 de las 8 pruebas nuevas, incluidas las de vuelo y alejamiento de quien lanza en ambos sentidos. Las 8 pasan con la corrección.

El regate del jugador funciona en las pruebas de doble toque, dibujo y suelta, también tras otra manga y en pantalla ancha con el otro dedo apuntando. No se ha reproducido el bloqueo comunicado en el móvil y no se afirma haberlo corregido. El vídeo del móvil muestra que el jugador lanza primero, pero no permite atribuir con certeza ese impacto concreto al fallo encontrado.

## Justa con lazos

Separación central de madera visible y física. Cada caballo permanece en su pista al girar y al usar regate. El lazo puede cruzar y capturar. Solo afecta a Justa; no cambia puntuación, daño ni velocidad.

## Tu jugador, más reconocible

Una sola marca compartida: aro turquesa con borde claro y pequeño triángulo bajo tu caballo. Presente en Rodeo, Carreras, Duelo, Justa, Hípica de memoria y mundo. No se añade a los rivales ni cambia las animaciones.

## Juegos: imagen primero

Cinco iconos recortados de la imagen aportada por Ant, con transparencia, iguales y sin recortar el marco. Cada tarjeta muestra el icono y su nombre pequeño debajo. Toda la tarjeta sigue siendo pulsable. Las descripciones largas se omiten en estas cinco tarjetas; no cambia la navegación restante.

## Pruebas y límites

77 casos dirigidos, 15 scripts, 991 comprobaciones: pasan todos. Incluyen vuelo real, simetría, controles de dos dedos, reinicio de manga, separador, captura a través de la separación, identidad, iconos, copa, recuperación, mapa, parada de un segundo y HUD corto de Carreras. Hay avisos de recursos al cerrar las pruebas. Detalle en QA_2_7_160.json.

Además se repitió el script antiguo de Carreras: 23/25, con los mismos dos fallos ya documentados (mapa esperado al pulsar en lugar de soltar, y esquive reflejo de IA que se desactivó). El script antiguo de controles del mundo sigue teniendo dos fallos con su conductor anterior. No se declara verde la batería completa ni validación en Android físico.

Se han inspeccionado capturas reales del motor a 960 × 540 de los cinco juegos y el menú. Sin cambios en huerto, afinidad regional, niveles, colección, economía ni maestría. Rama de pruebas, sin fusión a main ni envío a tienda.

## Android

Paquete `com.example.rancho.review`, código 419, 83547518 bytes. Firma SHA-256 `46bdcb2213f8b82696b918f5cfd5764cd5690038ae2938aaec6f11bfffb79bbb`, la misma que 2.7.159.

APK SHA-256: `edfd2b09678b9889ade75dfa781e19c3b8e883f38d541935103b3ca3fc5165de`.
