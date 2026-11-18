# Rancho Prueba 2.7.200

## Piel de botones aprobada

La hoja de Ant se usa en una implementación compartida de botones 9-slice. Cuero cálido para la acción principal y petróleo para las secundarias. Etiquetas e iconos continúan separados del dibujo.

Aplicado en menú principal y niveles, selector de Juegos, Equipo (categorías, conseguir/mejorar/equipar), Ajustes y panel de pausa. Se conservan la distribución funcional y las áreas táctiles existentes; no se han copiado datos de muestra ni se ha ocultado la sexta tarjeta de Coronas y victorias que las maquetas simplificadas no mostraban. Ajustes mantiene ambos modos de mando.

Se preservan textos, precios, saldos, desbloqueos, compras con puntos, progresión, guardados y personalización del caballo. La ilustración de caballo de las capturas es la de la partida de prueba. No fija el aspecto de los caballos del usuario.

## Material y escalado

Original RGBA1536x1024 con transparencia real. Recortes horizontales343x154, cuadrados248x248 y círculos250x250; los dos últimos usan relleno transparente, sin deformación. Se conserva el original y su manifest. Los cuatro estados normal/hover/pressed/disabled se comparten; foco recibe además un contorno crema.

Los horizontales se preparan en memoria a120x54 para mantener bordes proporcionados en móvil. Guías de textura20/20/17/17, equivalentes aproximadas de58/58/48/48 en el recorte original. Centro y bordes se estiran por nueve zonas; esquinas conservadas. No se aplican marcos de botones a los paneles de texto. Pequeñas diferencias de dibujo entre estados vienen en la hoja original.

Los recortes cuadrados/circulares quedan disponibles, pero no se cambia el HUD de habilidades ni el látigo en esta versión. No hay audio, personajes, fondos, fuentes ni iconos nuevos. Paneles, barras, interruptores y flechas conservan su material anterior cuando no son la base del botón.

## Verificación

- 405/405 pruebas,54.659 aserciones,65 scripts en dos bloques sobre la versión final.
- Pruebas añadidas para geometría9-slice, los cuatro estados, conservación de posición/tamaño/texto, botones de compra/equipo y los dos modos de mando.
- Capturas reales del menú, Juegos, Equipo y Ajustes, abiertas e inspeccionadas. La captura de pausa muestra el HUD real instanciado aisladamente para comprobar el panel, no una partida en Android.
- APK firmado verificado: com.example.rancho.review, versionCode459, versionName2.7.200. Misma firma de las versiones anteriores.
- SHA256 APK: cb3e1ae34e3da270b2567e84e6f5a445d58b50afe88d589d172dfa727f42bc36.

Limitaciones: sin Android físico ni certificación táctil/audio/rendimiento móvil. No es la ejecución de todas las pruebas históricas. La batería informa1 advertencia GUT y21 usos obsoletos; una ejecución registró2 referencias pendientes al cerrar. No se observaron fallos de pruebas. El empaquetador usa las herramientas Android35 disponibles, y la firma del APK se verificó correctamente.

Solo rama de pruebas y prerelease de GitHub. Main y tienda sin cambios.
