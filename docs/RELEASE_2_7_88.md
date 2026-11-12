# Rancho Prueba 2.7.88

APK de revisión solicitado por Ant el 12 de noviembre de 2026. Rama `feat/open-world-test-20261107`, sin merge a main. Este OK se consume con este APK.

## Cambios desde 2.7.87

- Césped claro cacheado compartido, sin las franjas horizontales anteriores y con menos llamadas de dibujo.
- Lazo tenso unido a la misma mano que el lazo en vuelo, con cuerda/aro compartidos respetando escala y orientación.
- Botón Encargos dorado y más legible.
- Se conservan las dos hojas de terreno: clara por defecto y oscura como alternativa en la prueba modular. No hay ciclo nocturno ni cambio automático por zona.
- Escena modular nueva con piezas completas y trazado generado por normas: red conectada sin circuitos, eje largo oeste-este, edificios en ramales de una sola entrada sin cortar la vía, pasos y mirador señalados.
- Sobre camino, 35% menos consumo de energía a trote/galope; caminar y reposar recuperan como antes.
- Salvajes aparecen y pasean fuera del camino, pero pueden atravesarlo cuando huyen. Al terminar la huida vuelven hacia hierba. No cambia la regla de contacto/aturdimiento y soltar la captura.

## Cómo abrir el mapa modular

Entra en Frontera y abre Menú > Mapa modular nuevo. "Cambiar césped" permite comparar claro/oscuro. "Volver al mundo anterior" regresa al mismo mundo anterior en memoria.

**Es una escena de prueba jugable y acotada, no el mundo de progreso nuevo.** Tiene jinete, lazo compartido, caballos de práctica, resistencia y colisiones propias. No incorpora encargos, descubrimiento/minimapa, streaming ni progreso persistente. No se regenera ni migra la partida actual.

Los pueblos cada varios kilómetros y sus marcadores están descritos como norma/propuesta, no construidos. La equivalencia unidades-km, separación exacta y ubicación de "En camino te cansas menos" siguen pendientes. El Mirador es solo un destino rotulado de revisión, no una misión.

## Verificación

- 517/517 unitarias, 116.825 aserciones.
- 14/14 integraciones focales, 375.931 aserciones: mapa modular, normas de construcción en 256 semillas, superficie/resistencia, huida atravesando caminos, floristería, descubrimiento, vallas y velocidad/lazo.
- Exportación Android Review completada; `apksigner verify` correcto (v2/v3), mismo certificado que 2.7.87.
- Package `com.example.rancho.review`, versionCode 347, versionName 2.7.88.
- Certificado SHA256: `46bdcb2213f8b82696b918f5cfd5764cd5690038ae2938aaec6f11bfffb79bbb`.
- APK SHA256: `478a0d9bc2d2090a0c6a93435fa158262f806887b296167d03d7f9385c9851d1`.

**No se ha instalado ni ejecutado este APK en Android.** Las capturas previas se inspeccionaron en escritorio; no certifican controles táctiles físicos, instalación ni FPS móvil. La firma y los metadatos están verificados, no el funcionamiento en dispositivo.

Las suites mantienen avisos conocidos de objetos/recursos al cerrar. `aapt` muestra paquete y versiones, pero su parser antiguo avisa de `android:required`; Godot y `apksigner` completan sus verificaciones. No había dispositivo ADB conectado para probar instalación. No se promete un rendimiento Android a partir de los perfiles software de escritorio.
