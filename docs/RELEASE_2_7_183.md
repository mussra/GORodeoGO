# Rancho Prueba 2.7.183: incremento redondo y destello visible

APK de prueba, código 442. Mismo paquete y firma, instalar encima. Solo rama de pruebas, sin main ni tienda.

La barra de mejora vuelve a usar bordes redondeados: tanto la parte dorada como el tramo turquesa ganado tienen esquinas curvas, ajustadas al ancho real. La mejora no se ensancha artificialmente.

El efecto estelar ahora es un destello blanco con halo turquesa, centrado exactamente en el tramo que se está ganando. Sus rayos pueden sobresalir de la barra para que el efecto se vea aunque la franja nueva mida pocos píxeles; no nace en la parte antigua ni se reparte por toda la propiedad. Al terminar el crecimiento se desvanece durante un segundo. El incremento turquesa permanece visible hasta cerrar la ficha.

Sin cambios en propiedades, premios, balance o guardado. No añade nodos, partículas ni física: reutiliza el dibujo de la ficha, con dos halos, una estrella y un rayo. Solo se actualiza durante la animación y su salida.

## Validación

265/265 pruebas, 44.128 aserciones y 45 scripts. Cuatro deprecaciones. Prueba de radios redondeados para un tramo estrecho, origen de la estrella dentro del incremento y desvanecimiento del efecto. Se conserva la batería de premios y guardado.

Capturas ampliadas con el destello y tras desaparecer, ficha completa y vídeo inspeccionados. Continuar responde a eventos táctiles por la entrada del juego en escritorio. Sin prueba física en Android. La última batería principal no muestra aviso de objetos vivos; el arnés visual sí avisa de dos al cerrar. Persisten los avisos UID de GUT y errores de guardado intencionados de las pruebas de reversión.
