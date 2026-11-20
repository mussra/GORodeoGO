# Rancho Prueba 3.0.24

## Cambios
- Restauradas las dos pezuñas delanteras del retrato montado con los píxeles de la imagen original aprobada. Sin arte nuevo. Corrección compartida por introducción, menú, colección y cruces.
- Adaptados el encuadre, las ocho máscaras del retrato y sus efectos al lienzo completo.
- Retirada la barra sobre la cabeza del jinete tanto en Frontera como en Rodeo. Los indicadores específicos del HUD no cambian.
- Cabras y cerdos enlazados se capturan en el mismo instante en que se agotan, sin espera adicional. Se conservan el alcance del lazo y el choque de la cabra.

## Comprobaciones
- 521 pruebas pasan, 66.581 aserciones: 493 de regresión y 28 adicionales dirigidas.
- Prueba de integración: Frontera registra y elimina al cerdo/cabra en el mismo tick de agotamiento, sin duplicar la captura.
- Verificación exacta de los píxeles recuperados y de las dimensiones de ocho máscaras.
- Inspección visual de introducción, menú y cruces, además de 108 fotogramas de animación. No se ha detectado otro recorte claro como el del retrato adulto.
- APK con paquete y firma de Rancho Prueba, versionCode 484.

## Límites
No se ha validado en un dispositivo Android físico. El diagnóstico detallado de una comprobación antigua de colores ya desactualizada se conserva en QA_3_0_24.json. No cambia la progresión ni se publica en tienda o en main.
