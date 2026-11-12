# Rancho Prueba 2.7.110

## HECHO: el país de prueba es una isla

- Costa redondeada e irregular con playa, agua baja y mar animado. Ya no aparece el vacío negro al llegar al borde.
- La costa dibujada, la colisión física y los destinos seguros usan el mismo contorno. No se puede caminar al mar.
- Se conservan entrada, fuente, río, raíces y ambos caminos transitables. El río sigue terminando bajo el árbol, no se cambia la misión.
- Mapa local: tierra y mar aparecen solo en las celdas exploradas. No se revela el contorno completo.
- Un guardado antiguo junto al borde rectangular se recupera en tierra libre antes de activar y guardar la sesión, sin borrar el progreso.
- Sin nuevo arte generado: es una costa sencilla dibujada con los recursos del juego, no una isla artística definitiva.

## Verificación

622 pruebas unitarias y70 de integración dirigidas pasan:2.556.804 +3.433 comprobaciones. Salida física bloqueada al norte, sur, este y oeste; rutas y sitios comprobados con4 semillas; recuperación de posición antigua probada. Capturas de costa y mapa inspeccionadas.

Simulación de escritorio, no validación en un móvil físico. APK arm64, mismo paquete y firma,versionCode369. Incluye las correcciones táctiles, relojes y árbol de2.7.109. No cambia condiciones de acceso, ritual, precios ni publica en tienda.
