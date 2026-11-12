# Rancho Prueba 2.7.93

## Árboles mayores y variables

- Robles, pinos y frutales varían de su escala previa hasta x3, con más tamaños moderados que gigantes. Tamaño estable por semilla, especie y posición, sin consumir el RNG del generador ni cambiar datos o progreso de partidas V1/V2/V3.
- Dibujo, tronco sólido y cobertura de escondite usan la misma escala. Copas atravesables, orden por pie del tronco y marcador del jinete por encima de copas grandes. Corrige el offset local que antes se escalaba dos veces.
- El crecimiento de troncos generados se limita junto a carreteras para no invadirlas. Las copas pueden sobresalir. Las colocaciones del editor se conservan.
- Si una partida guardada queda dentro de un tronco ampliado, busca un punto libre cercano al cargar, sin teletransporte al rancho. Escondite conserva detección al30%; el contacto sigue alertando.

## Trasera blanca B elegida

- Medias traseras altas con borde irregular, sin el bloque rectangular anterior.
- Cobertura por anatomía/vista, no una caja de pantalla copiada a todos los ángulos: retrato, montado, salvaje, reposo/beber, saltos, aturdido y cría.
- Máscaras derivadas de arte existente, sin nuevos sprites o arte generado. No modifica silueta, genética, estadísticas, colisiones ni escala del caballo.
- En vista frontal las traseras están ocultas y no se blanquean las delanteras. Las máscaras siguen también las patas dobladas durante el galope.
- Los textos de rasgos no cambian. La propuesta de iconos sigue siendo solo demo hasta decidirla.

## Comprobaciones

- 560/560 tests unitarios,2524402 comprobaciones. Solo se actualizaron las30 referencias de textura de patrón3, los restantes330 hashes siguen idénticos.
- 18/18 tests de integración pertinentes,3962 comprobaciones: tronco sólido/copa libre, carreteras, recuperación de una partida dentro de árbol, cobertura/marcador, alerta/huida/captura, vallas, retorno al rancho V1/V3 y beber.
- Inspección visual de las90 poses nominales (montado+salvaje,5vistas×9fotogramas), retrato, reposo y otras poses, y árbol con jinete detrás/delante.
- APK verificada como ZIP y firmaV2/V3 con certificado habitual. com.example.rancho.review, versionCode352, versionName2.7.93, arm64-v8a, mínimoAndroid24,target36. Sin instalación, rendimiento ni controles táctiles verificados en Android físico.
- Export usa build-tools35 como alternativa disponible para target36. El proceso mantiene los avisos conocidos de recursos al cerrar las pruebas; no falló ningún test.

APK:67502041bytes. SHA-256:6d3d4e81a9a60e5b2e432e002bae335c6523243c0449b3d2004116c48ded1e07

Solo rama de pruebas. Sin cambios en main. Mantiene todos los arreglos de2.7.92, incluida agrupación de caballos y volver desde genealogía a la colección.
