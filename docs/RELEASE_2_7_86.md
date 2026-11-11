# Rancho Prueba 2.7.86

APK de revisión, package `com.example.rancho.review`, versionCode 345. Rama de prueba, sin merge a main.

## Cambio desde 2.7.85

Arreglo de anclajes del lazo, estela y polvo en Frontera (cfdd668):
- La cuerda cargada y el vuelo nacen de la mano visible, respetando escala, desplazamiento del sprite y orientación izquierda/derecha.
- La estela y polvo del regate quedan en el suelo de los cascos, sin el antiguo desfase de +27/+28 unidades.
- No se baja el caballo ni se modifican colisiones, alcance, círculo objetivo, tolerancia de captura, herencia de velocidad o señales de lanzamiento.
- Los componentes siguen compartidos con los niveles, que conservan sus anclajes predeterminados.

Conserva el contenido anterior de 2.7.85: relojes, caminos, floristería y optimización de caballos/minimapa. El vídeo cinematográfico es un archivo aparte; no añade historia nueva al juego.

## Comprobaciones

- 499/499 pruebas unitarias, 58.541 aserciones.
- 8/8 integraciones focales sobre vuelo del lazo, velocidad y stun, 54 aserciones.
- Capturas deterministas de carga y vuelo, antes/después. Inspección a 1280×720 y reducida a 800×450.
- Firma Android igual a la APK previa: SHA-256 de certificado `46bdcb2213f8b82696b918f5cfd5764cd5690038ae2938aaec6f11bfffb79bbb`.

## Límites

No se ha ejecutado esta APK en dispositivo ni emulador Android. No hay certificación de posición ni controles en el móvil de Ant. No se ha completado el barrido general de integración. Las pruebas y capturas son de escritorio.

APK SHA-256: `c5fe600693ddb2ccbb159467cccddaf0c0a9753f733d279d20e853cce3486b5e`.
