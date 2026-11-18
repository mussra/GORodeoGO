# Rancho Prueba 3.0.8

Pre-release Android, código 468. Rama de pruebas, sin merge a main, tienda de aplicaciones ni gasto.

La pantalla «Victoria · tu caballo mejora» usa ahora la misma imagen del caballo con jinete que la Ficha. Comparte el retrato y su configuración: caballo que ha ganado, apariencia, sombrero, acabados, adornos y maestría. Ajustado el tamaño para dejar espacio antes del mensaje de mejoras guardadas.

Las barras, la mejora verde y el botón Continuar se conservan. Sin cambios de balance, recompensas ni guardados.

## Revisión de otros usos

Los retratos adultos de Ficha, Colección, Mercado, Genealogía, selector/entrenamiento, sombreros, acabados, adornos y atlas ya usan el retrato con jinete.

Se mantienen las representaciones sin jinete de animales libres/manadas del mundo, los recursos de animación de beber y los potros. No se sustituyen animales no montados ni se añade jinete a potros.

## Validación

457/457 pruebas, 55.490 comprobaciones, 76 scripts. Una prueba nueva comprueba que Victoria comparte textura, shader y propiedades de apariencia con el retrato de Ficha. Capturas de Victoria y Ficha revisadas visualmente, incluida la separación de cascos, texto y barras.

APK firmado, paquete `com.example.rancho.review`, misma firma de pruebas, código 468. Validado en Godot de escritorio, no en Android físico. Las pruebas de escritorio no certifican tacto ni rendimiento móvil. Advertencias conocidas de APIs antiguas en los tests.
