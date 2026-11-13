# Rancho Prueba 2.7.131

## Una colección, dos vistas
- Un único acceso a Colección desde Caballeriza.
- Dentro se puede cambiar entre Vista de colección (lista agrupada de gestión) y Vista de rancho (tarjetas visuales animadas).
- Eliminados los accesos duplicados Mi rancho y Mi rancho · vista anterior. Se conserva el código de las pantallas y todos sus datos; no se borra la colección ni se cambia el guardado.
- Ficha y vuelta mantienen el modo y el filtro. Se conserva el desplazamiento de lista al cambiar de vista. Los modos son estado de la sesión, no se escriben en el guardado.
- Reemplaza el prototipo130, publicado justo antes de la decisión final sobre los nombres y el acceso único.

## Comprobaciones
- 688/688 pruebas unitarias completas en130;131 solo modifica los nombres y accesos de este selector.
- 44/44 pruebas de integración dirigidas tras el cambio; incluyen8 pruebas del rancho y comprobación de un solo acceso desde el menú.
- Las8 pruebas del rancho pasan también con renderizado GL y pulsaciones de puntero simuladas sobre ambos modos.
- Estado de la colección comparado antes/después de navegar: sin cambios de caballos, progresión ni datos.
- Capturas a960×540 inspeccionadas: menú con acceso único, Vista de colección, Vista de rancho y vuelta desde ficha. Los nombres largos permanecen dentro de sus áreas.
- No probado en Android físico. Pendiente tacto, legibilidad y rendimiento en teléfono. Persisten avisos conocidos de recursos al cerrar pruebas.

## APK
- Rancho Prueba2.7.131, código390, paquete com.example.rancho.review, arm64.
- Misma firma de prueba que129/130. Instalar encima, sin desinstalar para conservar guardado local.
- Tamaño:71410573bytes.
- SHA-256:46071518ff103d85a34e56d47e12f9a4e1533107610919cde69f74dbebfb97f5.
- Rama feat/open-world-test-20261107, sin fusionar main, sin tiendas ni gastos.
- Web no publicada, Windows sigue125. Incluye correcciones de texto/apariencia de129 y mantiene maestría36-40.
