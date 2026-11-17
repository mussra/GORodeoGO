# Rancho Prueba 2.7.182: el incremento tiene su propio color

APK de prueba, código 441. Mismo paquete y firma, instalar encima. Solo rama de pruebas, sin main ni tienda.

En la ficha de mejora, el progreso que ya tenía el caballo permanece dorado. Solo el tramo ganado en esa victoria crece en turquesa y conserva ese color al terminar la animación.

Los destellos blancos salen dentro del tramo nuevo, no alrededor de toda la propiedad. Sus posiciones y extremos se limitan al intervalo entre el valor anterior y el valor animado. El brillo desaparece al terminar, pero el incremento turquesa sigue visible hasta cerrar la ficha.

No se exagera el ancho de la mejora. En una victoria con un incremento pequeño, la franja es estrecha; representa la misma mejora real que antes. No cambian valores, premios, duración de la animación, caballo participante ni guardado.

Se reutiliza el control de dibujo de la ficha: cinco destellos, sin partículas ni física y sin añadir nodos frente a 2.7.181. El brillo solo se actualiza durante la animación.

## Validación

264/264 pruebas, 44.121 aserciones y 45 scripts. Cuatro deprecaciones. La prueba nueva verifica en cuatro puntos de la animación que la zona coloreada empieza exactamente en el valor anterior y termina en el valor animado, además de que el color nuevo es distinto y el control pertenece a la barra correcta. Se mantienen las pruebas de premios y guardado.

Capturas durante y después de la animación, detalle ampliado y vídeo revisados visualmente. Continuar responde a la entrada táctil del motor en escritorio. Sin prueba física en Android. La batería y el arnés visual dejan un aviso de dos objetos vivos al cerrar; persisten los avisos UID de GUT y fallos de guardado intencionados de las pruebas de reversión.
