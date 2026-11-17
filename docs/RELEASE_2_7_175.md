# Rancho Prueba 2.7.175

Mismo paquete/firma, código 434. Instalar encima de 174. Sin main ni tienda.

## OSD sin cambiar partida

- En Frontera: Menú -> Rendimiento (OSD). Tocar alterna activado/desactivado y vuelve al juego.
- En menú principal: Ajustes -> Mostrar rendimiento (OSD).
- Se recuerda al cerrar. No activa DEBUG, no cambia la partida ni desbloquea ventajas. Se oculta mientras un menú pausa el juego para no tapar sus opciones.
- La 174 lo ligaba al modo DEBUG: esa ruta cambiaba a una partida separada y por eso no servía para medir el problema de la partida normal.

## Menú sin dos entradas al mundo

Antes de desbloquear Rodeo, JUEGOS se convertía en otro acceso a Frontera. Ahora JUEGOS siempre abre el catálogo y sus requisitos, y la tarjeta Frontera es la única que entra al mundo. No cambia desbloqueos ni progreso.

## Cámara más cinematográfica

Salida y vuelta de 1,2 s cada una, curva quintic con velocidad y aceleración suaves en los extremos, zoom interpolado en escala perceptual/logarítmica. Conserva el segundo quieto, encuadre completo, control activo y vuelta al zoom manual. La 174 ya tenía una suavización corta; esta curva es más marcada y la transición menos apresurada. No reinicia pueblos ya vistos: se verá en primeras visitas pendientes. La curva es temporal, no añade una trayectoria lateral.

## Validación

137/137 pruebas, 16.826 aserciones en 22 scripts dirigidos. Incluyen curva monótona y extremos, OSD sin cambio de modo/archivo, JUEGOS separado de Frontera, llegada/cancelación/persistencia, táctil sintético, equipo y compras. Capturas de menú, ajustes, opción en Frontera, OSD en partida normal, y secuencia completa revisadas. Vídeo a 30 fotogramas sintéticos/segundo, no grabación de teléfono.

Perfil de escritorio 1280x720, Vulkan mobile/llvmpipe: 9 sectores en ambas vistas; no aumenta la carga ni se añaden nodos por la nueva curva. Contorno temporal conserva tres nodos. JSON de seis muestras adjunto. No es garantía de coste cero ni certificación Android. El vídeo/capturas afectan al tiempo del motor del OSD, no usar esos valores como benchmark. Sin prueba en teléfono físico ni solución demostrada al atasco largo/Rodeo20. Cuatro deprecaciones y aviso de dos objetos al salir del arnés, sin aserciones fallidas.
