# Mapa modular nuevo: entrega de revisión

Rama `feat/open-world-test-20261107`. Sin APK nuevo, sin merge a main y sin cambios en la partida existente.

## Qué hay hecho

Mapa nuevo de 40 baldosas completas, diseñado para las piezas en lugar de deformar piezas sobre caminos antiguos: 16 rectas, 11 curvas, 6 T, 1 cruz y 6 finales. Red ortogonal conectada, sin diagonales ni codos cuadrados. Los cuatro accesos terminan en puertas: granero/rancho, dos casas y floristería. Hay circuito inferior, accesos curvos y finales de vía visibles. Ambos acabados usan las mismas coordenadas y topología:

- Claro: césped mezclado de las tres variantes y piezas derivadas de la primera recta de Ant.
- Oscuro: nueva hoja con el fondo de cuadriculado retirado, curva/cruz completas y T derivada de la misma hoja.

La recomendación visual para revisar primero es el oscuro: deja destacar edificios, flores y personajes y el contorno marrón delimita bien las curvas. Es una recomendación, no una elección hecha por Ant. Ambos quedan disponibles.

El botón "Cambiar césped" cambia césped y juego de caminos juntos. No genera arte nuevo. Se usan los sprites de edificios, personajes y flores ya aportados por Ant.

## Cómo abrirlo y volver

En el código de esta rama: Frontera > Menú > Mapa modular nuevo. Abre una escena de prueba separada. "Volver al mundo anterior" restaura el mismo mundo, cámara y controles que estaban en memoria. No recarga ni migra la partida.

El nuevo mapa tiene movimiento del jinete, controles táctiles compartidos, lazo compartido, dos caballos de práctica y colisiones de edificios coherentes con su ubicación nueva. La entrada hasta cada umbral está libre; el cuerpo del edificio bloquea el paso más allá. Un perímetro limita el mapa fijo para no perder al jinete fuera de cámara.

## Qué NO se ha hecho todavía

No es un reemplazo del mundo de progreso. Es un mapa de revisión jugable fijo, no un generador de mundo infinito. No incorpora aún los encargos, descubrimiento/minimapa, persistencia, streaming ni progreso de captura del mundo habitual. El lazo permite sujetar y soltar caballos de práctica, sin recompensas ni guardado.

No se ha generado otro APK. El APK 2.7.87 publicado anteriormente no contiene estos cambios. Para revisar esto en Android hace falta un nuevo OK para generar APK. Para convertir el mapa modular en el mundo habitual habrá que adaptar generador/colocación de contenido y diseñar la convivencia con partidas previas; no se debe aplicar una regeneración sobre los edificios y ediciones guardados de Ant.

## Razón de los codos anteriores

Los accesos antiguos tenían piernas de solo 34 y 44 unidades hacia las puertas. El suavizado descartaba radios tan cortos y dejaba los vértices rectos. La curva de baldosa completa ocupaba más espacio y tenía otro radio. Las piezas cruz/T sí se usaban desde la corrección anterior, pero solo su región central deformada hacia la tangente diagonal: no se veía una baldosa completa reconocible. Este mapa nuevo resuelve esa incompatibilidad en el diseño del recorrido, sin deformar las piezas.

## Verificación

- 511/511 pruebas unitarias, 59.621 aserciones en la última ejecución.
- 10/10 integraciones focales: 2 del mapa nuevo (32 aserciones) más 8 de floristería, descubrimiento, vallas y velocidad/lazo (214), total 246 aserciones.
- Red única conectada, enlaces recíprocos solo ortogonales, orientación y puertos de cada pieza, cuatro puertas como finales conectados.
- Comprobación física real de aproximación al umbral y bloqueo posterior en los cuatro edificios.
- Entrada y vuelta desde el mundo real comprobadas: mundo original visible/procesando otra vez, posición guardada y ediciones sin cambiar.
- Alternancia de arte comprobada; capturas generales de ambas opciones y menú inspeccionadas. PNG comparativo antes/después en ambos acabados. Las imágenes anteriores y nuevas no comparten disposición, ya que precisamente se ha rehecho el mapa; conservan escala de captura 1598x720.
- Las suites conservan avisos conocidos. Sin errores de script en las capturas finales.
- No se ha ejecutado en Android ni comprobado el tacto en un teléfono. Alguna pequeña diferencia de anchura/color entre piezas de la hoja JPEG puede verse al ampliar; no se promete uniones de píxel idénticas.

## Rendimiento

Escena nueva completa a 1598x720, cámara fija, simulación congelada, llvmpipe por software. 25 fotogramas de calentamiento y 120 muestras por tanda, dos tandas por acabado:

| Acabado | Draw calls | Mediana ms, 1 / 2 | P95 ms, 1 / 2 |
|---|---:|---:|---:|
| Claro | 65 | 17,26 / 17,31 | 22,67 / 21,17 |
| Oscuro | 65 | 17,29 / 17,35 | 20,94 / 21,64 |

Estos datos no certifican FPS Android. Tampoco son una comparación directa con el mundo habitual de nueve chunks: este mapa tiene menos entidades y no ejecuta sus sistemas de misiones. En el mundo habitual, el arreglo anterior del césped sí bajó las llamadas de 671 a 586 en el mismo escenario controlado.

## Decisiones de Ant

1. Qué acabado quiere: claro u oscuro. Se recomienda revisar primero oscuro.
2. Si este diseño modular le convence como dirección del mundo habitual, o quiere variar el recorrido/distribución.
3. OK nuevo de APK para revisar en el móvil la escena y los arreglos de césped, lazo y Encargos. Ese OK no autoriza borrar ni regenerar su partida.

## Cambios previos incluidos en la rama, posteriores al APK 2.7.87

- Césped claro sin las franjas horizontales anteriores, cacheado para reducir dibujo.
- Lazo tenso en la misma mano que vuelo, respetando escala/desplazamiento/espejo, trazo de cuerda y aro compartidos.
- Botón Encargos dorado más visible, misma ubicación y tamaño.
- Alternativa oscura de la nueva hoja, disponible para comparación sin sustituir el acabado actual.

Recetas: `tools/qa_modular93.tscn`, `tools/qa_modular_return93.tscn`, `tools/profile_modular93.tscn`. La disposición nueva vive en `ModularWorldLayout93`, no en WorldMap ni WorldPaths.

### Actualización posterior: reglas de caminos 94

El mapa modular ahora sí simula resistencia con menos consumo sobre camino y limita los salvajes a hierba. El alcance anterior describe el estado de la entrega 93. Ver `REGLAS_CAMINOS94.md` y su release para los cambios y pruebas posteriores; sigue sin ser un mundo con progreso/encargos ni un APK nuevo.
