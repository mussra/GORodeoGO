# Rancho Prueba 2.7.102

## Hecho: viajar con una siesta

En el mapa ampliado, toca un círculo dorado o abre "Sitios visitados", elige el destino y confirma "Ir a este sitio". El caballo te lleva mientras aparece una transición de siesta con tu montura y unos Zzz animados. Volver a casa usa esta misma confirmación.

- Solo se ofrecen sitios visitados físicamente o conocidos al hablar con su primo. Descubrir una casilla del mapa no desbloquea el viaje.
- El rancho inicial siempre permite regresar, también al cargar partidas antiguas que estén lejos. Los mundos antiguos conservan su generador.
- No cuesta energía ni puntos. No completa encargos ni explora todo el camino intermedio.
- Guarda el origen y las manadas antes de empezar. Carga y comprueba una llegada libre antes de guardar el destino. Si no puede cargar, llegar o guardar, vuelve al origen.
- La transición pausa la simulación. No viaja durante una captura, un lazo en vuelo, una carga, un golpe, un diálogo o una manada cercana en huida. No suelta animales para hacer el viaje.
- El toque corto en un sitio se distingue de arrastrar, pellizcar y mantener para añadir una nota. Cancelar no mueve al personaje.

## Alcance

Por ahora son los sitios existentes: rancho y pueblos de los primos en el mundo V3. No inventa un país, fuente, río, árbol, nuevas misiones ni un viaje con capturas atadas. Es una primera lista de destinos, no un teletransporte a cualquier punto arbitrario del terreno.

## Validación

- 603/603 pruebas unitarias, 2.556.403 aserciones.
- 30/30 pruebas de integración relacionadas, 2.975 aserciones: siesta, descubrimiento, notas, vallas, primos, persistencia de manadas y Galaxy puro.
- Ida y vuelta real, recarga, llegada bloqueada, fallos de guardado de origen y destino, visitas antiguas, varios seeds, captura retenida y botón Atrás simulado.
- Eventos táctiles nativos simulados distinguen toque, arrastre y pellizco. No equivalen a probar el gesto en un teléfono.
- Capturas inspeccionadas: selector legible, confirmación a1280x720 y960x540, transición, llegada separada del primo y mapa ampliado.
- Corregido un guardado prematuro del streaming que podía escribir el destino antes de validar la llegada. Una prueba lee el archivo para confirmar que un destino bloqueado conserva el origen.
- Persisten los avisos previos de recursos de la suite. No probado en Android físico.

## APK

Paquete `com.example.rancho.review`, versionCode361, arm64, Android7.0 o posterior. FirmaV2/V3 con el certificado anterior. 69.676.724 bytes.

SHA-256: `24f5064381a5139d67107d0a24ac9913805dbbbf5f6969960b541694eb8901ef`.

Solo rama de pruebas, sin tocar main ni publicar en tienda. Instalar encima sin desinstalar.
