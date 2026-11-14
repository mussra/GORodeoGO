# Rancho Prueba 2.7.144

Cambio puntual de inicio de música:
- Carreras: silencio durante selección de circuito y 3-2-1. La música comienza con la salida. Reintentar vuelve a esperar la cuenta atrás, sin conservar la música de la carrera anterior.
- Justa: música desde la preparación, antes de correr. No se reinicia al salir.
- Se conserva la música de carreras con las ocho notas corregidas de 2.7.143. Sin silbido: las pruebas sintetizadas se han descartado y nunca se incluyeron en el APK.

Se mantienen los controles, regate desactivado solo en justa, apuntado previo y cuenta visible. Sin cambios de progreso, economía, arte, main, web ni tienda.

Verificación: 21/21 pruebas en ventana, 157 aserciones. Incluyen música, selector, cuenta atrás, salida, reintento, silencio, voz única, preparación de justa, lazo y gestos táctiles simulados. Dos pruebas táctiles no sirven en modo sin ventana; se repitieron en ventana y pasaron. Aviso conocido de dos objetos de pruebas sin liberar al salir.

Capturas de comprobación con leyenda temporal sobre el estado de música. Esa leyenda no forma parte del HUD del juego. Verificación del estado del reproductor, no certificación de escucha en Android físico.

APK arm64, `com.example.rancho.review`, versionCode 403, misma firma de pruebas. Sigue pendiente aclarar a quién se aplicaría el segundo parado tras el lazo; no se ha implementado.
