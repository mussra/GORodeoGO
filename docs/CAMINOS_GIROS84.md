# Curvas y cruces en la rama de prueba

Después de la APK 2.7.84. Sin otra APK.

El componente compartido RoadTiles utiliza los sprites existentes de Ant:
- road_corner.png: curva de 90 grados, con copia derivada que elimina por transparencia la pieza suelta ajena a la curva. El original no cambia y todos los píxeles de la curva se conservan.
- road_t.png: entradas desde el camino principal a los accesos locales.
- road_cross.png: cruce principal junto al rancho.
- road_end.png: remates en accesos suficientemente largos, sin invadir las curvas cortas frente a las casas.

Solo cambia el dibujo: las coordenadas del camino, colisiones y guardado son iguales. Los tramos orgánicos del camino generado siguen usando el recto rotado; las curvas de 90 grados se usan donde existen giros rectos en los accesos. No se fuerzan esquinas a las curvas suaves del terreno.

Verificado: 491 pruebas unitarias (58.119 aserciones), integración de acceso de floristería (158 aserciones), capturas reales del acceso y del rancho e inspección de las cuatro orientaciones de cada pieza. Quedan juntas de estampación visibles en los tramos rectos, también existentes antes; no se presenta como un camino sin ninguna junta. Sin prueba Android.
