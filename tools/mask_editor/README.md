# Editor PixelLab, borrador v1

Generador `python3 tools/mask_editor/build_pixellab_review.py`. Usa las90poses ya extraídas en `art/experimental/pixellab/{rider,horse}/{view}` y genera180PNG en `art/experimental/pixellab_masks_draft` y HTML autónomo en Descargas.

Por pose: máscara RGB de pelaje(rojo)/crin-cola(verde) y máscara blanca de zona permitida para manchas. Segmentación conservadora por colores y regiones específicas de vista, con exclusiones del jinete/silla/sombrero. Es borrador, no supervisión humana ni máscara aprobada. Las hojas lisas no contienen manchas; su máscara permite pintar la elegibilidad, no deducir un patrón inexistente. No genera UV y no se aplica en el juego.

Abrir el HTML descargado con Chrome/navegador. Elegir grupo, Editar, Pelaje/Crin/Goma o Zona de manchas, pintar y usar Anterior/Siguiente. Mano permite desplazar sin pintar; Deshacer revierte un trazo. Mostrar PNG devuelve la máscara seleccionada, no el dibujo.

Descargar JSON guarda los trazos de TODAS las poses editadas. Mantener también este mismo HTML: el JSON guarda correcciones, no las bases incrustadas. Guardado local solo en el navegador/origen actual, no garantizado al abrir archivos desde gestores distintos o borrar datos. Exportar JSON antes de cerrar, adjuntarlo en el chat, e Importar proyecto permite retomarlo sobre esta misma base. El editor rechaza JSON de otras bases y hashes distintos. No sobrescribe el editor ni los borradores anteriores.

QA local Chrome:180bases cargan sin máscara vacía, viewport390/1280, pintura real por puntero, persistencia tras recargar, exportación/importación JSON y PNG, modoMano no pinta. Capturas inspeccionadas. No probado en teléfono físico. Se permite revisar/corregir antes de aplicar, no hay envío automático.

Vídeos de revisión:15s por actor,5vistas×9frames repetidos3veces, original/recolor rosa+azul/zona de manchas. Son el borrador exacto del editor. Se ven fallos que requieren trabajo: protección del jinete demasiado amplia en frontal/trasera que omite caballo, crin/cola incompletas, cara crema incluida como crin, bordes/patas sin teñir. No se presenta como listo. No aplicar al juego hasta revisión.

## Revisión v2 sobre el parcial de Ant (10nov09:39)
JSON original validado en el editorv1:35máscaras de18poses,372trazos.17color+18manchas, jinete de frente y espalda. Su importación exacta se guarda como referencia inalterada en reviews/20261110-ant; v2 recorta desbordes al alfa y paleta de caballo, mantiene las zonas elegidas y completa el color de frontal09/09a partir de01/09(cierre del ciclo). El resto usa regiones más ajustadas y flujo óptico por pose.180PNG refinadas en pixellab_masks_review_v2. Zona de manchas recortada al pelaje, no crin ni jinete.

Editorv2 independiente, bases ya incluyen el trabajo parcial y ajustes. NuevoJSONv2 solo para nuevas correcciones. Conservar JSONv1yHTMLv1como copia; no importar v1en v2 porque son bases distintas. Guardado/recarga/exportación/importación comprobados con la nueva basev2. Los90frames se inspeccionaron en contactos y vistas de vídeo. Invariantes90/90: máscara dentro del alfa visible, sin solape pelaje-crin, manchas solo en pelaje. Quedan detalles de crin/cola en diagonales y límites de silla/patas. No acabado final, sin UV nuevos ni aplicación al juego. Se pide valoración del vídeo antes de una APK con máscaras.
