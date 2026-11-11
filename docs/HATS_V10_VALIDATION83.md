# Sombreros v10, Atlas y Galaxy

11 de noviembre de 2026. Solo rama de prueba, sin APK ni merge a main.

## Máscaras y sombreros

Ant pidió respetar exactamente su trabajo y extender sombreros a TODOS los sprites del jinete. Se añadieron 95 capas de sombrero separadas:

- 45 frames PixelLab (5 vistas x 9), usados en marcha/galope nominal.
- 47 frames clásicos (reposo, cinco direcciones de salto y aturdido).
- 2 poses de beber y el retrato HD, copiando únicamente su canal de sombrero aprobado.

No cambió ningún PNG anterior de arte o máscara. El editor v10 conserva byte a byte los 101 registros de bases anteriores, sus imágenes fuente y máscaras embebidas, además de los 40 registros de cambios y sus 303 trazos exactos. No rehornea ni sobrescribe los trazos de Ant. Los 95 nuevos PNG están en `art/hat_masks_v10/`.

El recolor compartido afecta solo la capa de sombrero. Original conserva la textura. Azul noche y Arena conservan alpha, sombras, banda oscura y adorno dorado. El borrador inicial alcanzaba el pañuelo en una vista: detectado visualmente y corregido antes de publicar. Pruebas cubren todos los 45 frames nominales y comprueban cero cambios fuera de la capa nueva.

Editor autónomo con 196 capas. Las capas nuevas solo ofrecen Sombrero y Goma. Se verificó en 390 y 1280 px: pintado real, exportación completa, importación y recarga con igualdad de píxeles. Se renderizaron sus 95 bases mediante su motor de canvas y compararon píxel a píxel con el juego. El importador v10 solo puede aplicar las 95 capas nuevas; nunca escribe las 101 máscaras anteriores. Los editores v8/v9 y sus JSON siguen intactos.

## Atlas y Galaxy

Nueva categoría con cinco identidades: Galaxy azul, rosa, verde, rojo y negro. Solo sombra mientras no se haya conseguido. Se consulta especie `unicorn` y variante explícita, nunca el acabado Galaxy de un caballo normal. Si se vende, el registro ancestral conserva el descubrimiento. El contorno es provisional y reutiliza caballo sin jinete; falta aprobar el arte completo del unicornio y su obtención.

Corrección de Ant 13:24-13:25: los caballos Galaxy normales siguen obtenibles. Restaurados mercado, herencia del acabado, selector Debug y entradas de compra/adopción/entrega exactamente a sus reglas anteriores. No hay migración ni conversión automática. Los Galaxy normales cuentan como afinidad ancestral hacia una futura cría unicornio, todavía sin regla implementada.

El Atlas normal muestra y cuenta los Galaxy propios. No desbloquean por sí solos la categoría de unicornios. El Galaxy normal azul-morado permanece distinto de las cinco nuevas paletas de unicornio.

Las nuevas pruebas de paleta y nebulosas son opt-in, exclusivas del material de revisión. Fórmula anterior intacta cuando ese modo está desactivado. Nebulosas y estrellas usan shader estático, no arte raster generado. Se muestran cinco variantes sobre el retrato existente, que NO es el diseño final de unicornio.

## Validación

481/481 unitarias, 57.521 aserciones, después de restaurar las reglas Galaxy normales. 12/12 integraciones dirigidas, 93 aserciones. Persisten avisos de fixtures/orphans conocidos. Vídeo de agua actualizado y revisado: sombrero azul al acercarse, beber y salir, sin volver al marrón. No prueba de Android físico.

Pendientes: elección de aspecto Galaxy, regla genealógica de obtención, rastro arcoíris y río por mapa con objetivos accesibles y caballo especial. No se insertó una barrera que pueda hacer imposible una misión existente.

Hueco previo del mercado detectado: no hay ofertas Galaxy en los catálogos fijos 16-20; la primera aparece en 23 fuera de niveles actuales. Propuesta de garantizar una oferta en 16 o 20 pendiente de decisión. No afirmar Galaxy normalmente obtenible en partida nueva hasta cerrar este hueco.
