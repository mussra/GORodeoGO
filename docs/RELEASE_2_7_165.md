# Rancho Prueba 2.7.165

## Equipo
- Los nueve botones de navegación y acción pasan a icono principal y rótulo pequeño debajo: Caballeriza/cría, Sombreros, Adornos, Acabados, Volver, Conseguir y Equipar en ambas fustas.
- Las fustas tienen representación visual propia; precio, alcance, requisitos y estado equipado siguen visibles. Comprar y equipar conservan acciones separadas. No se modifican costes ni prestaciones.
- Reutilizados los recursos existentes de caballo y medallón; sombrero, fustas y acciones se dibujan por código. No se requiere arte nuevo para usar esta pantalla.

## Animación de carga
- El caballo del jugador y el salvaje usan la misma escala. El salvaje sigue sin jinete: no se le añade un dueño para igualar su altura total.
- El granjero se mide por los píxeles visibles, no por el tamaño del lienzo PNG. Los actores pisan la misma línea y los animales compensan el movimiento de sus pies entre fotogramas.
- El caballo del jugador muestra su apariencia equipada y su sombrero, en vez de sortear otra apariencia al cargar. Los salvajes conservan variedad cosmética; esto no escribe en la colección.

## Comprobación
119/119 pruebas de integración, 1.335 aserciones en 26 scripts. Las 12 pruebas dirigidas de UI y flujos pasan también por separado. Se verifican iconos con rótulos, tamaño táctil, compra/equipado/recarga, accesos a tiendas, escala de caballo compartida, granjero y apariencia equipada. Una prueba antigua de Equipo necesitó aislamiento completo del perfil para no heredar estado de otras pruebas; no se cambió la economía para forzar el resultado.

Capturas a 960 × 540 inspeccionadas. APK exportado, firma y versión comprobadas. No se ha ejecutado en Android físico. Avisos al cerrar la regresión: 14 CanvasItem, 19 ObjectDB y 2 recursos.

## Conservación y pendiente
Incluye V4 de la 2.7.164: pueblos nuevos solo en mundos nuevos, sin migración ni borrado automático. No cambia huerto, maestría, precios o main. La revisión general de textos de las demás pantallas está inventariada, pero no aplicada; esta versión cambia solo Equipo y la carga.

Código 424, com.example.rancho.review, misma firma de prueba. Instalar encima sin desinstalar para conservar la partida.
