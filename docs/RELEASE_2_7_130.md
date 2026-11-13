# Rancho Prueba 2.7.130

## Prototipo: una colección, dos vistas
- Colección tiene un selector común: Lista de gestión / Vista del rancho. Las dos muestran los mismos caballos, no colecciones separadas.
- Lista conserva la agrupación por apariencia, despliegue de individuos, equipar y ficha. Vista del rancho conserva tarjetas animadas, filtros de rareza, familia y ficha.
- Abrir una ficha desde el rancho integrado y volver mantiene el modo y filtro. Cambiar de modo conserva el desplazamiento de lista y el filtro/página del rancho durante esa sesión.
- Para comparar se conserva el acceso independiente a Mi rancho desde Caballeriza y el botón Mi rancho · vista anterior dentro de Colección.
- Es un prototipo para decidir la organización, no una eliminación ni una fusión definitiva. No se modifica el formato de guardado, los caballos ni la progresión. El modo elegido solo vive en memoria y no se escribe en el guardado.

## Comprobaciones
- 688/688 pruebas unitarias.
- 43/43 pruebas de integración dirigidas con renderizado GL, incluidas las7 pruebas del rancho.
- Pulsaciones de puntero simuladas sobre el selector en ambos sentidos. Verificado que la vista integrada no bloquea el selector ni Volver.
- Verificado con comparación del estado antes/después: navegar, filtrar, abrir ficha, volver, cambiar modo y abrir vista anterior no cambia la colección.
- Capturas inspeccionadas a960×540: lista con nombre de59caracteres, rancho integrado y regreso de ficha, y Mi rancho anterior.
- No probado en Android físico. Pendiente la valoración de Antonio sobre esta propuesta y la validación de tacto/legibilidad/rendimiento en teléfono. Persisten avisos conocidos de recursos al cerrar pruebas.

## APK
- Rancho Prueba2.7.130, código389, paquete com.example.rancho.review, arm64.
- Misma firma de prueba que129. Instalar encima, sin desinstalar para conservar guardado local.
- Tamaño:71410573bytes.
- SHA-256:7e3a860f08b4c1153ada0285d7b4f0a0db80633d9ea3a719cd53212a2f2134f4.
- Commit en feat/open-world-test-20261107, sin fusionar main, sin tiendas ni gastos.
- Web no publicada. Windows sigue125. Incluye las correcciones de texto y apariencia de129; no cambia maestría36-40.
