# Rancho Prueba 2.7.83

11 de noviembre de 2026. APK autorizado tras las previews. Rama de trabajo, sin merge a main.

## Galaxy y maestría

- Galaxy normal marrón miel aprobado, con nebulosas también en crin y cola. Sin aura, sol ni luna. Las estrellas aumentan según la maestría de ese caballo.
- Galaxy maestro azul al completar los 20 niveles distintos con ese caballo adulto. Aura azul, sol en pecho y luna en muslo al 70%, sin letras. La luna tiene prioridad visual sobre el emblema, pero no borra el emblema guardado.
- Aspecto compartido en retratos, marcha montada, poses clásicas, bebida y miniaturas. Las manadas sin registro siguen siendo Galaxy normales, no maestros.
- Ficha con niveles y porcentaje antes de los genes. No se atribuyen victorias antiguas sin registro, ni se suman repeticiones o partidas de ensayo. Una victoria acredita la montura con la que arrancó el nivel.
- Una oferta Galaxy normal garantizada entre las seis del nivel 20, por 1.400 puntos del juego. Las otras cinco ofertas conservan sus reglas. No se compra nada automáticamente.

## Otros cambios desde 2.7.82

- Bebida cosmética compartida entre niveles y Frontera al parar junto al estanque o bebedero. Movimiento y acciones la cancelan. Sin bonificación de energía.
- Canales de sombrero separados para las poses de marcha/bebida, conservando las bases y trazos anteriores del editor.
- Encargos plegables y barras de habilidad ocultas si el caballo no tiene esa capacidad.
- Vallas continuas y sólidas con profundidad por tramos; salto compartido para caballos capaces y arco visual de cabras. Agua sólida no saltable.
- Lazo que hereda la velocidad inicial de la montura; recuperación de fatiga al quedar libre.
- Vuelta a casa bajo cortina sin viaje visible por todo el mapa. Suelta el animal donde estaba.
- Preparación de recursos repartida durante la carga y eliminación de trabajo de joystick no utilizado. No se promete eliminar todas las pausas ni mejorar Android sin medirlo.
- Atlas con identidades de unicornio en silueta. No se implementa adquisición, río, receta, rastro arcoíris, fuente mágica ni loco del pueblo.

## Verificación y límites

- 489/489 pruebas unitarias, 57.877 comprobaciones.
- 13/13 integraciones dirigidas de maestría, bebida, vallas, vuelta y lazo, 99 comprobaciones. Otras 4/4 de tiempo bala/joystick con pantalla, 14 comprobaciones.
- Inspección visual de 45 fotogramas montados, 45 sin jinete y 47 de poses clásicas en ambos estados, ficha, sombreros, miniaturas, mercado y bebida en el mundo real de prueba. Pruebas de píxeles de crin/cola y protección de jinete/equipo; anclajes de astros presentes en las vistas donde son visibles.
- Medición de escritorio: preparar 45 texturas tarda aproximadamente 1 s en normal y 4,1 s en maestro; después, una consulta de caché ronda 0,13 ms. No es una medición Android.
- El barrido de todas las integraciones no se completó. La prueba de joystick que falla sin pantalla pasa con pantalla. Persisten avisos de fixtures y objetos no liberados al cerrar pruebas. No se afirma una suite completa sin avisos.
- APK firmado y manifiesto verificado. Mismo paquete y certificado de Rancho Prueba, versionCode 342. Sin prueba en teléfono o emulador Android: no hay dispositivo conectado.
