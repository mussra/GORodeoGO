# Rancho Prueba 2.7.98

## Cuatro primos, cuatro pistas

Añadidos cuatro locos del pueblo estáticos e interactuables en el mundo V3: uno en el pueblo del rancho, uno en Camino del Este y dos en nuevos caseríos, Oeste y Este Lejano. Los caseríos usan las casas existentes y se reservan fuera de la exploración anterior, sin recolocar pueblos ni borrar partidas. Las posiciones quedan fijas en el guardado.

Cada primo da una pista distinta: los legendarios del Atlas, la advertencia ambigua sobre los cuernos, el cuerno recto y único, y el rumor de una fuente mágica. Ninguno cuenta toda la receta. El cuarto no inventa una dirección hacia una fuente que aún no existe en el juego. Su futuro rumbo dependerá de implementar el país nuevo, árbol, río y fuente. Ultra raro frente a Legendario sigue pendiente de decisión: se usa Legendario sin cambiar categorías del Atlas.

Después de la pista puedes preguntar "¿Y tus primos?". Consulta el diario y te dirige a uno todavía desconocido, con rumbo cardinal calculado desde posiciones reales. Si ya conoces a los cuatro, lo reconoce sin inventar otro. El pueblo registra el lado por el que llegaste al entrar desde fuera; cargar dentro del pueblo no inventa una procedencia. Se conserva el último lado conocido.

El botón "Primos" abre el diario desde el mundo; también se puede abrir en el diálogo. Guarda los primos conocidos y las cuatro pistas escuchadas, en cualquier orden. Repetir una conversación no añade duplicados ni entrega desbloqueos nuevos. Si falla el guardado de la primera conversación, no registra la pista como escuchada.

## Arte de Ant, sin cambiar los originales

Se conservan los dos PNG originales. Los derivados eliminan el fondo y se reducen con nearest-neighbor, sin generar otras vistas ni ciclos de andar. Lienzo 192x192, dibujo 144px alto, escala 0,625: 90px visibles en el mundo, parecido al granjero y florista.

Normal: sombrero tapando los ojos. Sorpresa: ojos desorbitados, al detectar una montura con especie unicornio real, no por acabado Galaxy ni por una silueta del Atlas. Esa especie se usa solo en la partida aislada de QA para probar el cambio: no se concede un unicornio al jugador ni se implementa todavía el ritual.

El hueco cerrado entre pierna y bastón se limpia en ambas versiones. Se comprobaron los fondos oscuro y verde a 2x: de 9106 píxeles de fondo original en ese hueco normal y 12132 en sorpresa, quedan 0 opacos tras la reducción. Barba, cabello blanco, calcetines y bordes del dibujo se conservan. Los originales mantienen sus hashes.

## Caminos y compatibilidad

Los cuatro primos tienen acceso al camino real. Se reserva su acercamiento frente a decoración generada, respetando las ediciones manuales del jugador. Los caseríos se cargan cerca del jugador y se retiran lejos; el diario y sus posiciones no dependen de que sus nodos estén en memoria. El mapa muestra los accesos y nombres en terreno ya descubierto.

La simulación del recorrido hasta el primo lejano detectó una casa del Camino del Este que invadía un giro posterior de la carretera. Se apartó la casa de ese giro; el recorrido completo y las misiones de florista se volvieron a comprobar.

Estado separado `world/cousins140`, versión1, ligado a la semilla. V1/V2 se conservan sin convertirlos ni añadir estos cuatro núcleos. Actualizar V3 no borra misiones, capturas, flores, notas, caballos ni las posiciones de manadas de 2.7.97. Guardar con APK antiguas puede perder las secciones nuevas que desconocen.

## Pruebas y límites

- 585/585 pruebas unitarias,2556240 comprobaciones.
- Cinco integraciones nuevas: cuatro conversaciones, repetición, diario/recarga, fuera de alcance y fallo de guardado; camino real con superficie/montaña/colisión, llegada por cuatro puntos cardinales, carga sin inventar procedencia, streaming sin duplicados, tamaño/sorpresa y V1 sin ampliación.
- Regresiones aisladas de flores/floristas, mapas, cercas, misiones NPC, manadas, posiciones guardadas, lazo y percepción. 43/43 integraciones pertinentes, 659860 comprobaciones, 12 scripts en procesos aislados.
- Capturas inspeccionadas directamente de la escena real. La partida QA está aislada, se mueve entre pueblos para fotografiarlos y marca un caballo como especie unicornio solo para probar la sorpresa. No reproduce un desbloqueo normal del unicornio.
- Sin prueba en teléfono físico. No se certifican controles táctiles ni rendimiento móvil. Los nuevos NPC son estáticos, sin procesos por fotograma de animación. Permanecen advertencias preexistentes de recursos retenidos al cerrar la suite unitaria; las cinco integraciones nuevas cierran sin esos huérfanos.

## Cómo probar

1. Instala sobre 2.7.97 sin borrar datos. Entra en V3 y busca al loco cerca de la floristería del rancho.
2. Habla, escucha la primera pista, pregunta por sus primos y sigue el camino en la dirección que indica.
3. Visita los otros pueblos y habla con sus primos. Puedes volver a preguntar; cambia la sugerencia según a quién conoces.
4. Abre "Primos" y revisa el diario. Sal/carga: las pistas y conocidos deben mantenerse.
5. Comprueba el fondo entre bastón y pierna tanto en el personaje como en el retrato. La variante de sorpresa está integrada, pero no tiene por qué aparecer con un caballo normal o Galaxy.

No incluye todavía fuente, transformación, país nuevo, árbol gigante, río, estela ni siesta. Ese trabajo y la auditoría de los pendientes antiguos continúan en versiones de prueba posteriores.

## APK

Paquete `com.example.rancho.review`, versionName 2.7.98, versionCode 357, arm64-v8a, mínimo Android 24, target 36. Firma V2/V3; certificado SHA256 `46bdcb2213f8b82696b918f5cfd5764cd5690038ae2938aaec6f11bfffb79bbb`.

69651221 bytes. SHA256 `c513611e071649aaf0f17d8bd306f9c0cd76988fcf3ee9632965d3dd586d0deb`.
