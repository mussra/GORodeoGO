# Rancho Prueba 3.0.11

Se aprovecha únicamente la placa vacía de la nueva hoja de Ant, para el número de apertura de cada corral. El texto permanece dinámico y oscuro para contraste. No cambia la detección, radio, tiempo de apertura, colisiones ni progreso.

## Resultado de la revisión de la hoja

- Original 1254×1254 RGB, sin canal alfa. El damero está pintado, no es transparencia.
- Placa: contorno oscuro cerrado recuperable. Recorte por silueta, preservando sus píxeles interiores, sin repintar. Probada sobre verde y arena sin damero visible.
- Laterales: postes superpuestos, sin dos tramos laterales visibles en profundidad. No se usan.
- Supuestas esquinas: vistas frontales, no esquinas de suelo. No se usan.
- T: forma frontal con un soporte central, no unión de tres direcciones de suelo. No se usa.

Faltan laterales correctos, esquinas y unión T. Se mantienen los laterales previos hasta recibir arte compatible; esta entrega no afirma completar el vallado. Conviene pedir solo un tramo lateral en la siguiente imagen, sin mezclar otras piezas.

Original conservado sin cambios en `art/corral311/source/ant-laterals-sheet.png`, excluido del APK. El fondo se retiró solo de la placa derivada. No hay imágenes nuevas generadas por el integrador.

457/457 pruebas habituales, 55.490 comprobaciones. Capturas inspeccionadas de corral 11 cerrado/abierto y verificación de placa sobre dos fondos. Pruebas de escritorio, no Android físico. Persisten las advertencias previas de escena de mundo y de cierre de tests documentadas en 3.0.10. Sin main, tienda ni gasto.

Paquete `com.example.rancho.review`, código 471, firma estable. APK 80.259.491 bytes, incremento de 82.121 bytes frente a 3.0.10.
