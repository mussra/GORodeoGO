# Rancho Prueba 2.7.103

## Hecho: vista previa de oro brillante, cristal e hielo

Equipo → Acabados · Vista previa abre tres estudios visuales juntos: retrato y caballo galopando con las animaciones actuales. Oro brillante tiene reflejos cálidos, cristal combina facetas y transparencia y hielo tiene escarcha y vetas claras.

Se usan los dibujos y máscaras existentes. No se genera arte nuevo ni se cambian poses o animaciones. El material solo afecta al caballo dentro de sus máscaras; vaquero, sombrero y equipo conservan su aspecto. Un mismo material dibuja retrato y movimiento.

## No es todavía una tienda

Esta pantalla no compra, equipa, cría ni guarda acabados. No modifica los caballos, estadísticas, genes, rareza, saldo, inventario ni partidas. Obtención, precios y condiciones de cría siguen pendientes de decisión. No reemplaza el caballo dorado normal ni etiqueta caballos antiguos como especiales.

Son propuestas de apariencia para revisar en imagen, movimiento y móvil antes de integrarlas como objetos obtenibles.

## Validación

- 605/605 pruebas unitarias, 2.556.500 aserciones.
- 21/21 integraciones relacionadas, 150 aserciones: vista previa, Mi rancho, viaje con siesta y compra/equipamiento existente.
- La prueba antigua de equipo exige literalmente texto español: pasa con idioma es. Con el idioma inglés por defecto falla igual en2.7.102; comprobado sin los cambios nuevos.
- Cinco pruebas nuevas: estilos explícitos, estilo desconocido sin efecto, nueve frames y caché acotada de27materiales, pantalla sin mutaciones/guardado, distribución a960x540 y cierre con Atrás.
- Capturas inspeccionadas a1280x720 y960x540 y vídeo de4segundos. Corregidos un recorte de los caballos animados y un solapamiento de la nota de Equipo con el botón nuevo.
- La suite unitaria conserva los avisos de recursos previos. No probado en Android físico ni medido rendimiento de estos materiales en móvil.

## APK

Paquete `com.example.rancho.review`, versionCode362, arm64, Android7.0 o posterior. FirmaV2/V3 con el certificado anterior. 69.685.373 bytes.

SHA-256: `37b2f4c48dc5aa5e1e03d579d94a8a2ad86f6f9001929a7af0ebe968674fc24a`.

Solo rama de pruebas, sin tocar main ni publicar en tienda. Instalar encima sin desinstalar.
