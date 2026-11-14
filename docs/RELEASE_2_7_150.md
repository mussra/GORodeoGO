# Rancho Prueba 2.7.150

## El gesto no se queda atrapado en el mapa
Reproducido con eventos táctiles reales: en carreras, apuntar el lazo, mover el dedo sobre el minimapa y soltar allí dejaba la carga activa. El mapa consumía la liberación de un dedo que había empezado fuera de él.

Ahora el contacto mantiene su dueño hasta terminar. El minimapa no se apropia del final del lazo ni abre el mapa por cruzarlo. Un contacto iniciado sobre botones, paneles o mapas del HUD espera a distinguir un toque limpio de un arrastre. Si se arrastra, pasa al joystick correspondiente; si se toca y suelta sin arrastrar, activa el elemento una sola vez. Volver sobre el botón después de haberlo arrastrado no cuenta como clic. El umbral es de 12 px en las coordenadas del juego.

Una sola capa compartida usa los joysticks nativos en toros, Frontera, carreras, duelo, justa, Salto de memoria, vista modular y país. Se conserva la dirección y distancia del arrastre, incluso si comenzó por encima del área original del joystick. No cambia la mecánica de lazo, salto, carrera o regate. El mapa ampliado conserva sus propios gestos de desplazamiento y pellizco. Pausas, diálogos y selectores mantienen sus controles normales.

También se filtra el clic de ratón emulado por ese mismo dedo para evitar activaciones duplicadas. Soltar con la partida pausada libera los joysticks; perder el foco cancela la carga sin lanzar. Los joysticks reconstruidos al cambiar de manga se registran de nuevo.

## Verificación
105/105 pruebas dirigidas, 820 aserciones, 18 scripts. Incluyen reproducción del bug, arrastres iniciados sobre UI, salir y volver sobre botones, toque limpio único, liberación sobre minimapa de Frontera, dos dedos, pausa/reanudación y pérdida de foco. Regresión de mapa ampliado, notas, música, modos anteriores y Salto de memoria.

Capturas reales de apuntar sobre el mapa y soltar: la segunda muestra el lazo en vuelo, no una carga atascada. Sin prueba en Android físico. El ejecutor sigue notificando objetos de decoración/recursos vivos al salir de algunas pruebas de mundo; no se presenta como ausencia de fugas.

Paquete com.example.rancho.review, misma firma de pruebas, arm64, versionCode409. Rama de pruebas, main intacta. Ningún cambio de estructura, niveles, progreso, maestría ni identidad de pueblos.
