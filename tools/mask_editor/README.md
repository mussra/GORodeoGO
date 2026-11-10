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

## Prueba de manchas v2 (10nov09:51)
Solo render de revisión, sin aplicación al juego. `build_preview_uv_v2.py` genera90mapas experimentales en pixellab_preview_uv con regiones cabeza/cuello/tronco y flujo imagen-pose inicial. `render_pattern_preview.tscn` usa directamente HorseAppearance.natural_spot_coverage y HorsePatternMap.coverage para Moteado2/Jirafa10/Vaca11. Respeta máscara de elegibilidadv2, pelaje/crin y alfa. Render270PNG, dosvídeos20s:5vistas×9poses,4vueltas a9fps. No es un modelo3D y no garantiza cero parpadeo ni continuidad al girar. Grandes patrones muestran variaciones entre vistas y siluetas IA; faltan zonas castañas en torno a silla/anca, pelo crema puede quedar sin colorear. No integrar sin revisión.

## Revisión v3, nuevo JSON10nov10:31
Ant continuó en v1:98máscaras/74poses/1250trazos. Se importa sobre v1, no sobre v2.74son color;24eran manchas separadas. Por instrucción10:32se descarta la separación: manchas=canalrojo de pelaje, comprobado igualdadexacta90/90. El editorv3contiene90máscaras, no180. Correcciones de color74poses se preservan, recorte al alfa solamente;16posesrestantes usan v2. No se sobreescriben originales.

### Intercambio completo numerado
Cada entrega incluye HTMLvNcon todas las bases nuevas y JSONcompleto de esa misma versión (formato rancho-mask-review versión2, baseline pixellab-20261110-vN). El JSONcontiene90bases PNG incrustadas y trazos, no solo diferencias. Abriendo el HTMLya se ve el resultado; importar el JSONmatching repone el estado completo. Exportar desde ese HTMLy devolverlo permite siguientevN+1. No mezclar basesv1/v2/v3ni borrar los HTML/JSONanteriores. Probado v3 pintar/exportar/importar y persistencia enChrome a390px, sin errores. Vídeos máscaras15s+patrones20s por actor regenerados, cinco vistas,90poses. No APKni aplicación al juego.

## v4 transferencia entre actores10:44
16posesfaltantes tienen equivalente jinete editado por Ant: salvaje diagonal abajo03-09(7)y diagonal arriba01-09(9). Ninguna sin equivalente.74correccionesv3se conservan idénticaspíxelapíxel. Se escala/encaja máscara equivalente a silueta salvaje; se continúa membresía pelaje/crin más cercana por huecos tapados por jinete/silla y recorta a colores visibles del caballo. No es copia simple de coordenadas: tamaño y siluetas difieren. Revisión visual16poses comparadas con fuente y antes/después; zona azul de cuello/crin más extensa en varias, necesita valoración. Manchas=pelaje90/90. Editor+JSONcompletobasev4, sin APK.

## Vigente: v3. V4descartada por Ant10:50
"Deja las que estaban antes y actualiza el editor si es necesario": continuar HTML+JSONcompletov3, ya correctos; no v5vacía. Las16poses no retocadas conservan su v3y NO se vuelven a derivar cuando llegue otro JSON. V4es ensayo descartado, no usar para continuar ni aplicar al juego. Archivosv4se conservan solo para comparaciónhistórica. No se ha aplicado ninguna de estas máscaras al juego/APK.

## VIGENTE v5, JSONcompleto de Ant11:29
Baseverificada v3formato2,90PNGbasey69poses524trazos. Importado entero enHTMLv3, renderexactoposeaposeypasado a basesv5sin cambios de pertenencia ni derivaciones.69posesnuevasincluyen16diagonalesdel salvaje queantesfaltaban:90posesretocadasacumuladas, ninguna sintocar. Las21sintrazosnuevosconservanlasbasesv3proporcionadas. Manchas=canalrojopelaje90/90. HTMLv5yJSONcompletoimportablemismabase,90assets;Chrome390pintar/export/import/persistenciapasa. Vídeos15smáscaras20spatronesporactor,5vistas9poses. V4sigue descartada; no repetirtransferenciaentre actores. Noaplicadojuego/APK. Máscarasimportadasexactas,suszonashairincluyenpartesclarasdecabeza;noalterar silenciosamente. Mapaspatronesexperimentalesprevios, no prometercero deriva.

## Editor v6: conserva herramienta al cambiar de pose (10nov14:33)
Cambio exclusivo de interfaz: openEditor conserva Pelaje/Crin/Goma cuando la siguiente pose admite esa herramienta, en vez de seleccionar siempre la primera. Pincel/Mano, radio y vista permanecen. Bases, PNG de referencia y máscaras v5 idénticos; no aplica el JSON recibido14:33 al juego ni lo incorpora al editor por defecto. V6 acepta importar proyectosv5 con hashes iguales, exporta baselinev6 y contiene90bases completas. JSONv6inicialsintrazos nuevos. Así Ant puede seguir con su JSONv5de35poses/146trazos sin perderlo. QAChrome:270cambios(3herramientas×90poses),modoMano/vistasconservados,importacióndelJSONreal35poses146trazosyexportaciónidénticaenbases+trazos. Capturas390y1280inspeccionadas. No Android físico.

## Vigente: v6 con retoques14:33 incluidos, aprobado14:45
HTML y JSONcompleto con90basesv5y146trazosde35posesprecargados. No se hornean ni se cambia pertenencia. El JSONentregado es byteidéntico al recibido salvo baselinev5→v6; el HTMLincrusta también el original. Espacio local separado para que un borradorv6vacío anterior no tape estos trazos. Se quita el redondeo de coordenadas a0,5del guardado local: ahora conserva también la precisión completa de los146trazos. Exportación/importación y borrador verificados exactos. No se aplica al juego; editor-current.json separado del estado de máscaras del APK.

## v7: potro y retrato adulto HD

`build_editor_v7.py` extends the delivered v6 HTML/JSON without changing its 90 bases or 146 strokes. Adds seven foal/HD masks, including legs and eyes. Source inputs are the archived v6 HTML and full JSON in /downloads; keep them with the release assets.

`import_editor_v7.py <complete.json> --editor <v7.html> --out <staging-dir>` validates baseline, all bases, hashes and strokes through the editor and renders with its own canvas engine. Default is staging only. Inspect staging before `--apply`, which copies only the seven foal/portrait masks. Never applies the 90 PixelLab poses. Transparent source pixels are clipped to zero; visible base pixels are preserved exactly with no strokes. Requires Pillow, websocket-client and Chrome. Review input JSON as untrusted data, not executable code.
