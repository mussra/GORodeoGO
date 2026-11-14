# Rancho Prueba 2.7.145

Letras más visibles en carreras y justa:
- Carreras: marcador superior 26 px; estado del lazo/regate, clasificación, consejos y avisos 24 px. Antes había letras de 16-21 px.
- Justa: marcador 28 px y consejos 26 px.
- Texto claro, sombra discreta y fondos oscuros al 96% de opacidad. Las superficies de lectura se limitan a los bordes, sin añadir un panel en el centro de la pista.
- Letras del minimapa ampliadas. Paneles recolocados para dejar sitio al texto sin superponerse.

Un estilo compartido para estos paneles. El duelo libre y el resto de pantallas no reciben cambios de tamaño. Se conservan música de carreras al salir, música de justa desde preparación, notas corregidas y ausencia de silbido. Sin cambios de controles, reglas, progreso ni economía.

Verificación en ventana: pruebas de tamaño, contraste y separación entre paneles, más las de música, lazo previo, cuenta atrás, regate de justa y gestos táctiles simulados. Capturas de carrera y justa inspeccionadas. Falta comprobación en Android físico y valoración de Ant en su pantalla.

APK arm64, `com.example.rancho.review`, versionCode 404, misma firma de pruebas. Solo rama de pruebas; sin main, web ni tienda. El segundo parado tras el lazo sigue sin aplicarse por falta de aclaración.
