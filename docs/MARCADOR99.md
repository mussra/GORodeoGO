# Marcador de posición constante

El marcador del jugador ya no depende del tamaño de celda, del área descubierta, del tamaño del mapa ni del zoom. Aro de 20 píxeles de diámetro, trazo de dos píxeles, centro de 14 píxeles y flecha de 15 píxeles desde el centro. La pulsación cambia opacidad, nunca el diámetro.

Compensa también la escala del render de pantalla: en la ventana pequeña no se reduce a la mitad por el escalado de la interfaz. El marcador conserva su posición real en el mapa; no se agranda el resto del mapa ni los iconos de misión.

Capturas verificadas en 1598x720 y en 896x414 (simulación de pantalla pequeña apaisada), en minimapa, mapa grande, zoom 0,5 y zoom 3. Medición del contorno amarillo del marcador: 21-22 píxeles de ancho y 24-25 de alto en las ocho capturas, con la variación de un píxel propia del antialias y posición fraccionaria. No son tamaños proporcionales al zoom.

522/522 pruebas unitarias; dos integraciones focales de caché de mapa y generador nominal, 242 aserciones. Los recuentos de aserciones de la suite de arte varían con el caché; ejecución de esta entrega: 132.472.

No hay Android conectado: `adb devices` no devuelve dispositivos. La revisión 896x414 es render de escritorio con tamaño de teléfono, NO prueba instalada en el teléfono de Ant. No se ha generado APK ni modificado main. El APK 2.7.88 no incorpora este arreglo.
