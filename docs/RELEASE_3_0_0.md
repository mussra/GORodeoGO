# Rancho Prueba 3.0.0

VersionCode460. Misma aplicación y firma de prueba: se instala encima de2.7.200.

## Incluye
- Fondo del rancho de Ant en principal, Juegos, Equipo y Ajustes, conservando árbol y molino tal como aprobó.
- Principal: saturación80%, capa petróleo gradual70% izquierda a32% derecha. Pantallas de contenido: saturación45%, desenfoque5px a1280x720, capa petróleo180/255. Tratamientos precalculados para no aplicar desenfoque cada fotograma.
- Pieza larga de Ant convertida en atlas teselado: esquinas fijas, bordes y centro repetidos en ambos ejes. Modo TILE, no TILE_FIT ni estiramiento.
- Normal, pulsado y desactivado derivados de la misma pieza. Hover conserva normal. Pulsado oscurece y desplaza el texto3px mediante los márgenes internos.
- Misma familia compartida en principal/niveles, tarjetas de Juegos, Equipo, Ajustes y pausa; marco de filas de Equipo y panel de pausa.
- Ajuste mínimo de posición del texto de las filas de Equipo para dejarlo dentro de las puntadas.

## Sin cambios
No hay cambios de mecánicas, economía, guardado, desbloqueos ni controles. Incluye los16 iconos nuevos de Equipo: sombrero, volver, caballeriza, adornos, acabados, conseguir, equipar, silla, riendas, estribos, herradura, espuelas, manta, sombrero de gala, fusta y lazo. La hoja tiene alfa real. Se extraen las figuras completas por componentes y centro de celda porque algunos sombreros cruzan la cuadrícula, preservando sus alas y las transparencias. El emblema de caballeriza no cambia el caballo personalizado. Fustas usan el icono de fusta y el lazo de captura usa la cuerda, sin cambiar catálogo ni efectos. No cambia los fondos de otros menús ni el del juego. No incluye integración en main ni tienda.

## Verificación
408/408 pruebas dirigidas,54728 aserciones en65 scripts, no toda la suite histórica. APK exportado y firma comprobada. Capturas reales del motor de escritorio con partida de prueba aislada. La captura de pausa es el HUD real instanciado aparte, no una sesión de juego en Android. No hay prueba en Android físico ni certificación de rendimiento/táctil.

Avisos:1 aviso de recurso de GUT,21 llamadas obsoletas,2 instancias ObjectDB al salir de las capturas/segunda tanda. Exportación con herramientas35 para target36.

El grano repetido puede apreciarse en paneles grandes. La composición mantiene el árbol detrás del texto y el molino a la derecha por aprobación expresa.

SHA256 del APK: `d52ab359877767e2a21b01ec8c7e468e86ccc18410b8c97c4137725d5bcd7eb1`
