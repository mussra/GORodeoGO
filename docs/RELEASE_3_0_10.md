# Rancho Prueba 3.0.10

Integra las partes utilizables de tres hojas de arte generadas por Ant con ChatGPT.

- Huerto: parcelas vacía y preparada con transparencia real. Lucía, zanahorias, anclas y reglas de cultivo intactas.
- Rodeo: suelo de arena derivado del interior de la hoja y repetido por espejo; vallas horizontales ilustradas.
- Corrales: tramos horizontales y portón cerrado/hojas abiertas. Se conserva el hueco de 120 unidades, colisión y profundidad del frente.

Los originales siguen intactos en `art/{garden,arena,corral}310/source/`, excluidos del APK. Recortes sin pérdida, escalado uniforme, sin generar arte nuevo.

## Qué no sirve tal como vino

Las tres hojas tienen alfa real. La hoja de huerto es 1254×1254 y sus celdas se pueden recortar; el módulo inferior tiene borde transparente y no repite sin juntas: se conserva de estudio, no se integra. Las parcelas completas sí sirven.

La arena 1254×1254 incluye un borde con hierba, así que tampoco es seamless. Se recorta un interior de 435×435 y se crea un mosaico 2×2 por espejo, sin rellenado generativo ni repintado. La repetición simétrica de piedras puede notarse. No se vende como textura original seamless.

La hoja de cercas trae vistas oblicuas, no laterales verticales compatibles con las líneas de colisión. La tercera hoja (1536×1024) trae portones y horizontal, pero no un tramo vertical correcto, esquina, T ni placa. Se conservan los laterales de código donde falta la vista correcta. No se gira una vista frontal ni se inventan piezas. Los cambios son parciales y quedan listados.

## Comprobaciones

457/457 pruebas habituales, 55.490 comprobaciones. Prueba antigua adicional de huerto: 9/11, idéntico resultado con el archivo de huerto de 3.0.9; falla por expectativas previas de navegación/diálogo y guardado. Logs de ambas ejecuciones incluidos. No se declara que toda la batería histórica pase.

Inspección visual de introducción, búsqueda, muestra, plantar, regar y cosecha; Rodeo niveles 1, 11, 40 y puerta 11 abierta/cerrada. Pruebas de escritorio. No Android físico.

Aviso previo de escena de mundo: `TownLayer227` accede a `look.base` inexistente en una ruta de pruebas; no se corrige dentro de una integración de arte. Advertencias de APIs de tests antiguas y objetos al cerrar. Sin cambios de reglas, economía, guardados, main, tienda ni gasto.

APK 80.177.370 bytes (80,18 MB). Sigue por debajo de los 92,16 MB previos a la limpieza 3.0.9; añade 2,33 MB frente a 3.0.9 por el nuevo arte. Paquete `com.example.rancho.review`, código 470 y firma de pruebas estable.
