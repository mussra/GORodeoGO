# Editor PixelLab, borrador v1

Generador `python3 tools/mask_editor/build_pixellab_review.py`. Usa las90poses ya extraídas en `art/experimental/pixellab/{rider,horse}/{view}` y genera180PNG en `art/experimental/pixellab_masks_draft` y HTML autónomo en Descargas.

Por pose: máscara RGB de pelaje(rojo)/crin-cola(verde) y máscara blanca de zona permitida para manchas. Segmentación conservadora por colores y regiones específicas de vista, con exclusiones del jinete/silla/sombrero. Es borrador, no supervisión humana ni máscara aprobada. Las hojas lisas no contienen manchas; su máscara permite pintar la elegibilidad, no deducir un patrón inexistente. No genera UV y no se aplica en el juego.

Abrir el HTML descargado con Chrome/navegador. Elegir grupo, Editar, Pelaje/Crin/Goma o Zona de manchas, pintar y usar Anterior/Siguiente. Mano permite desplazar sin pintar; Deshacer revierte un trazo. Mostrar PNG devuelve la máscara seleccionada, no el dibujo.

Descargar JSON guarda los trazos de TODAS las poses editadas. Mantener también este mismo HTML: el JSON guarda correcciones, no las bases incrustadas. Guardado local solo en el navegador/origen actual, no garantizado al abrir archivos desde gestores distintos o borrar datos. Exportar JSON antes de cerrar, adjuntarlo en el chat, e Importar proyecto permite retomarlo sobre esta misma base. El editor rechaza JSON de otras bases y hashes distintos. No sobrescribe el editor ni los borradores anteriores.

QA local Chrome:180bases cargan sin máscara vacía, viewport390/1280, pintura real por puntero, persistencia tras recargar, exportación/importación JSON y PNG, modoMano no pinta. Capturas inspeccionadas. No probado en teléfono físico. Se permite revisar/corregir antes de aplicar, no hay envío automático.
