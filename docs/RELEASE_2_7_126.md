# Rancho Prueba 2.7.126

## Capturas en notas del mapa

La captura solo se puede adjuntar cerca del marcador. Antes, el control bloqueado seguía amarillo y parecía que no respondía. Ahora se ve gris y dice "Captura no disponible · estás lejos".

El aviso explica qué hacer: cerrar el mapa, acercarse al marcador y abrirlo de nuevo. Entonces se puede marcar la captura y pulsar Guardar. La foto anterior se conserva si editas la nota sin adjuntar otra. Esta corrección usa el mismo componente en Frontera y País.

No cambia la distancia, el progreso ni las partidas. Sin nuevos cuernos ni ritual activo. La web sigue sin publicar. El ZIP de Windows disponible sigue siendo 2.7.125 y no incluye esta corrección.

## Compatibilidad y pruebas

Android arm64, paquete com.example.rancho.review, versión interna 385. Misma firma que 2.7.125. Instalar encima sin desinstalar para conservar partida.

14/14 pruebas de integración dirigidas, 111 aserciones: bloqueo lejano, estilos gris/amarillo, conservación de foto al editar lejos y nuevo guardado al regresar con captura local. Pasada táctil simulada en Frontera y País a 960×540 y 1600×720: marcar, guardar, recargar y bloqueo lejano.

La suite unitaria completa pasa. No se afirma pasada completa de integración: un lanzamiento inicial incluyó por error todas las integraciones, encontró fallos antiguos de touch y se interrumpió por tiempo. La suite dirigida se ejecutó después de forma aislada. Persisten avisos antiguos de recursos al cerrar. Sin prueba física Android ni Windows.

SHA256 APK: 91d45769ea4dcbcedbce3a8f4b3f28d65d724cbe0b84cbc01c03464f1c87c266
