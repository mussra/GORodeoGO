# Progresión exigente: modelo y bloques de implementación

La petición del 13 de noviembre acepta los diseños y exige muchos cerdos, cabras y misiones, sin completar todos los extras en 20-30 minutos. Esta base numérica es calibración de implementación, no una medición ni una promesa de horas. Desde2.7.120 el modelo se usa en premios de victoria, captura de cabra y encargos repetibles. Desde2.7.121 están activas las compras de acabados oro/cristal/hielo con esos requisitos. Los adornos oro/plata siguen pendientes.

## Auditoría anterior a2.7.120

- La victoria20 paga 8.500 puntos cada vez. Las primeras victorias1-20 suman46.665. Subir precios sin cerrar esa vía incentiva repetir el nivel20 y no explorar.
- Cerdo:40 al capturarlo y40 al venderlo. Cabra:0. Cada captura tiene ID persistente y no se repite como animal nuevo.
- Los encargos originales y regionales tienen final, no ciclo repetible. No reiniciarlos ni borrar sus logros para fabricar repetición.
- Oferta Galaxy desde progreso16; garantía de oferta20; premio de primer nivel puede salir Galaxy. La llave20/40 no limita nada hasta cerrar también esos accesos futuros.
- Crecer gratis está acotado al modo de pruebas; falta crecimiento normal.
- Los acabados y adornos siguen siendo estudios de retrato/lateral. No vender equipables hasta cubrir las demás poses.

## Base económica siguiente

Conservar recompensas de primera victoria y todo saldo/objeto ya adquirido. Solo repeticiones futuras:5% del premio, mínimo10 y máximo400. No cambiar la migración de créditos antiguos.

Nueva recompensa futura por capturar cabra:40. Cerdo conserva40+40. Encargos separados de los históricos, de5 animales, alternando cerdos/cabras y400 puntos al volver a cobrar. Requieren aceptación, IDs nuevos, cobro una vez, guardado atómico y supervivencia a reinicio. No usar temporizadores de reloj o moneda nueva.

| Extra | Puntos | Cerdos | Cabras | Encargos repetibles cobrados |
| --- | ---: | ---: | ---: | ---: |
| Adornos plata | 6.000 | 20 | 15 | 4 |
| Adornos oro | 12.000 | 40 | 30 | 8 |
| Oro brillante | 24.000 | 80 | 60 | 16 |
| Cristal | 42.000 | 160 | 120 | 32 |
| Hielo | 66.000 | 280 | 220 | 56 |

Los contadores de actividad son acumulativos, no se gastan en cada compra. Se cuenta lo ya capturado en guardados antiguos, pero no se dan premios retroactivos ni se rellenan encargos nuevos con capturas anteriores a aceptarlos. Moneda solo interna. Acabados cosméticos separados del acabado genético Galaxy.

## Sensibilidad del ritmo, NO tiempo medido

Cinco cerdos vendidos + cinco cabras y dos encargos:400 puntos de cerdo,200 de cabra y800 de encargos =1.400 puntos por10 capturas, media140. Presupone completar todos los encargos correspondientes y vender todos los cerdos. No incluye viajes, errores, enemigos, compras de caballo, reproducción ni niveles21-40.

Los cinco extras suman150.000 puntos. Con50 capturas mixtas/hora hipotéticas serían7.000 puntos/hora:21,4h sin ingresos de campaña;14,8h adicionales después de46.665 de primeras victorias. Con30/h:35,7h o24,6h adicionales; con80/h:13,4h o9,2h adicionales. Un saldo antiguo enorme no elimina los requisitos de280cerdos/220cabras/56encargos para el último extra. Esta barrera requiere500 capturas acumuladas, no un reloj artificial. No extrapolar esta tabla a todo el juego ni prometer un mínimo real sin probar rutas y densidad.

## Orden pendiente

1. Persistencia, contadores y encargos repetibles con UI común, deduplicación, fallos de guardado y compatibilidad.
2. Integración de recompensas de repetición/cabra; economía completa y pruebas antirrecarga, modo prueba y venta.
3. Máscaras/materiales en todas las poses y compra/equipado de extras con requisitos visibles.
4. Llaves20/40 con niveles21-40 reales, no victoria20 repetida; quitar nuevos Galaxy por premio y por un solo padre, preservando ejemplares existentes.
5. Crecimiento normal, maestría pura y ritual explícito. Las alternativas contradictorias de categoría no se convierten en dos categorías a la vez.

El límite de siestas del mismo día es otro bloque y no forma parte de este modelo.

## Estado2.7.120

Activo: premios de repetición limitados, recompensa de cabra, contratos alternos separados, persistencia/cobro atómicos y pantalla del granjero. Sin premios retroactivos. Los encargos aceptados desbloquean la captura necesaria por el mismo lazo que los históricos. Pendiente: cobertura visual y compra de extras; llaves, niveles21-40, crecimiento normal y ritual.

## Estado2.7.121

Activo: compra única de acabado oro/cristal/hielo, equipamiento por caballo adulto y retirada gratuita sin cambiar genes. Requisitos de la tabla aplicados con saldo, capturas acumuladas y encargos cobrados. Los contadores de actividad no se consumen. Pendiente: adornos de patas/botas, llaves y niveles21-40, crecimiento normal y ritual.

## Bloque169 /2.7.122

Adornos de plata y oro activados:6.000/12.000puntos,20/40cerdos,15/30cabras,4/8encargos cobrados. Los requisitos del modelo no se han rebajado. Una compra desbloquea cada metal para patas y botas; se equipa por caballo adulto y se puede combinar plata en botas con oro en patas, o al revés. Quitar no cobra puntos. No se hereda ni cambia estadísticas o genes; compatible con los tres acabados. Guardado atómico con reversión del cobro o equipado si falla. Las capturas/encargos no se gastan. Sigue pendiente el bloque de niveles21-40/llaves y la continuación Galaxy/cría/ritual.

## Correcciones 170-172 / 2.7.123

Siesta recta que despierta antes del primer obstáculo o límite conocido, incluida comprobación física por las zonas intermedias; no busca rodeos. Notas/fotos como destinos, visor completo, aviso sobre mapa, botón antiguo de casa retirado. Sustos del lazo incluidos para cerdos. Metal integrado con sombreado por pata, sin rayas; carga con hierba/cielo/nubes. Sin cambios en costes, logros ni cadena de progresión. Niveles21-40 y Galaxy/ritual todavía pendientes.
