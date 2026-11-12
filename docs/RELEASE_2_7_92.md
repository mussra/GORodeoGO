# Rancho Prueba 2.7.92

Sobre2.7.91, incluye todos los avances acumulados. Rama de pruebas, main intacto.

## Colección agrupada

Una fila por apariencia, contador y botón Ver caballos. Al desplegar conserva cada caballo con su nombre, ID, iconos, Equipar y Ficha. Indica si el grupo incluye el equipado. No fusiona registros ni altera estadísticas, genes, entrenamiento, padres, ventas o cría. Se agrupa por rasgos de retrato, etapa, especie y estado visual de Galaxy; estadísticas/nombres no separan grupos. Criterio conservador para evitar ocultar diferencias de aspecto. Los datos del usuario no se reescriben para agrupar.

## Volver desde mapa genealógico

Reproducido el flujo del vídeo: Colección → Ficha → Mapa genealógico → Volver mostraba una caballeriza vacía y luego el hub. La ruta cambiaba de estado sin reconstruir la lista bajo el mapa. Ahora reconstruye la lista de origen: al cerrar mapa vuelve a colección con el grupo abierto y la posición guardada. Abrir/cerrar ficha también mantiene ese estado. Las otras entradas al mapa no se redirigen a colección por defecto.

## Validación y límites

- 556/556unitarias,1.659.283aserciones. Tests de agrupado sin pérdida de registros, diferencias visuales, acciones por ID, equipado y regreso desde genealogía con grupo desplegado.
- Capturas896x414 antes/agrupado/desplegado/genealogía/volver inspeccionadas. Datos de QA sintéticos, no cambios a la colección real.
- Export y ZIP íntegros; firmaV2/V3 con certificado habitual, com.example.rancho.review, versionCode351, versionName2.7.92, arm64-v8a, mínimoAndroid24,target36. Sin Android físico para instalación/rendimiento/táctil.
- Se mantienen pendientes y restricciones de2.7.90/2.7.91: arte de reposo/pastar sin jinete, arte final unicornio, economía/cámara/múltiples partidas y escalabilidad. V1/V2 y progreso conservados.
- La demo de rasgos con iconos NO sustituye el texto actual ni va activada en este APK; espera valoración del usuario.

## Integridad

- Tamaño67.326.139bytes.
- SHA256 APK cf290c5e2cc4c02e4520c45182af0e3971669080ec32fb8e9ba67e2d0640070a
- Certificado SHA25646bdcb2213f8b82696b918f5cfd5764cd5690038ae2938aaec6f11bfffb79bbb

Autoridad: Ant12/11/2026 12:15:37 permite APK con avances;12:26:41 pide agrupar apariencia y12:29:07 corregir navegación mostrada en vídeo.2.7.92 inicial no se publicó antes de incorporar este arreglo.
