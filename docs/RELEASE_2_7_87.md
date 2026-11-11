# Rancho Prueba 2.7.87

APK de revisión, rama `feat/open-world-test-20261107`, sin merge a main.

## Desde 2.7.86

- Caminos continuos derivados de la recta aportada por Ant sobre los recorridos existentes.
- Mezcla determinista de las tres variantes de césped de su última hoja.
- Dos piezas cruz y dos T en las intersecciones reales: vías principales, acceso al rancho, accesos de casas y floristería.
- No se modifican generadores de mapa, colisiones, guardados ni posiciones de edificios.

El césped mantiene repetición reconocible de hojas. Los pequeños accesos tienen codos angulosos y diferencias de fase de textura. Es una versión para revisar el acabado, no una afirmación de acabado definitivo.

## Rendimiento

Comprobación de escritorio a 1280x720 con llvmpipe (render por software), semilla 752026, nueve chunks, cámara fija y simulación congelada. Mismos caminos nuevos en ambas condiciones. Dos tandas por condición, 25 fotogramas de calentamiento y 120 muestras por tanda:

| Suelo | Llamadas de dibujado | Mediana ms, tandas 1 / 2 | P95 ms, tandas 1 / 2 |
|---|---:|---:|---:|
| Tres céspedes mezclados | 671 | 41,67 / 40,80 | 46,35 / 44,89 |
| Verde liso de control | 582 | 25,74 / 27,58 | 26,47 / 30,38 |

El césped añade 89 llamadas y tiene coste medible en esta prueba. No son cifras Android ni predicción de FPS en móvil. Sin prueba en dispositivo ni emulador. Conviene comprobar la fluidez en Android y considerar cachear el suelo si hace falta, conservando la imagen aprobada. Fixture reproducible: `tools/profile_grass87.tscn`.

## Verificación

- 504/504 pruebas unitarias, 58.965 aserciones.
- 8/8 integraciones focales (floristería, descubrimiento, vallas y velocidad/lazo), 214 aserciones.
- Exportación Android Review y verificación de firma correctas.
- Package `com.example.rancho.review`, versionCode 346, versionName 2.7.87.
- Certificado SHA256: `46bdcb2213f8b82696b918f5cfd5764cd5690038ae2938aaec6f11bfffb79bbb` (mismo que 2.7.86).
- APK SHA256: `07e833557a6d3c99a053f2d50aa611b48ae239271a808e423ba63a328dd729f5`.
- Inspección visual de capturas del mundo real en la release de crucetas. No se ha abierto este APK en Android.

Las suites mantienen avisos conocidos. `aapt` muestra versión y paquete, pero avisa de un atributo `android:required` que su parser antiguo no interpreta; la exportación y `apksigner verify` finalizan correctamente. Sin dispositivo disponible para confirmar instalación.
