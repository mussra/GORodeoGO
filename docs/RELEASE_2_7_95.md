# Rancho Prueba2.7.95

## Orientación estable de los caballos salvajes

Se corrige la alternancia de vista al perseguirlos, sin cambiar arte raster.

- Histéresis de8grados entre vista lateral, diagonal y vertical, en vez de un único umbral que oscila ante valores casi iguales. Se comprueban los cocientes anteriores1,6y0,45 y epsilon a ambos lados.
- Zona muerta horizontal de18% del vector cerca de la vertical, incluidos igualdad y tolerancia flotante, para que un dx casi cero no alterne espejo izquierda/derecha.
- El nuevo par vista/espejo debe mantenerse0,10s. Picos de un frame se descartan; cambios sostenidos sí se muestran.
- Velocidad angular limitada a240grados/s, conservando la velocidad lineal de huida. El límite usa delta, no una mezcla fija por fotograma.
- Sprite actualizado una vez desde el movimiento final aplicado, no desde órdenes contradictorias previas. Se conserva la fase de la animación al cambiar vista, sin reiniciar la zancada.
- Parado mantiene la última orientación y no inventa una vista abajo. El giro de mirada parado tiene una zona muerta de24px. Captura detiene y limpia el movimiento inmediatamente.
- No se alteran radio ni momento del susto por lazo de2.7.94, contacto/aturdimiento ni reglas de captura. Las restricciones de carretera/terreno y cohesión siguen teniendo prioridad sobre suavizado.

## Verificación

569/569 unitarias,2525490 comprobaciones.35/35 integración focalizadas,2457 comprobaciones: nuevos casos de dirección/sprite, conciencia/caída, manada, captura del mundo, cruces y aturdimiento. Total nuevo específico8/8 (4unitarias y4integración).

Pruebas de límites exactos, cero/casi cero, alternancia de epsilon, inversión180grados,30/60/120Hz, confirmación exacta0,1s, fase de animación, captura y dos rutas de huida. Simulación visual6s con persecución cambiando rumbo, incluido cambio brusco de lado. Cada caballo realizó10-11cambios sostenidos de vista/espejo durante6s, no cambios cada frame. No es una medición de Android.

APK ZIP y firmaV2/V3 comprobados, mismo certificado46bdcb2213f8b82696b918f5cfd5764cd5690038ae2938aaec6f11bfffb79bbb. Paquete com.example.rancho.review, versionCode354, versionName2.7.95, arm64-v8a, mínimoAndroid24,target36.67510806bytes, SHA256ac353ab4c26a32146fea54cb2446d58256b9f49fb7b039f410077c3ab8e84315.

Solo rama de pruebas, main intacto. Sin Android físico: pendiente comprobar tacto de la persecución, controles táctiles y rendimiento en dispositivo. Persisten advertencias de recursos retenidos al salir de la suite unitaria, sin tests fallidos. Campos, nuevos pueblos y nuevas misiones siguen como diseño/preview, no integrados.
