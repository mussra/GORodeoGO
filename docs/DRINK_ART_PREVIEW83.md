# Preview beber, 11 noviembre2026

Arte suministrado por Ant en PNG12:24:57,1774×887RGBcon fondo verde. JPEG anterior descartado. Original conservado en art/experimental/drink_preview83/source_ant.png. No arte generado por nosotros.

Preparación reproducible tools/key_drink_preview83.py: separación de dos mitades, alfa por dominancia de verde, reducción de contaminación en bordes parciales, misma escala común83/674, misma traslación de referencia de pies. Lienzo112×96para no recortar cabeza baja. Datos exactos alignment.json. Sin interpolación ni nueva pose dibujada. PNGresultantes solo para preview.

Dos poses lateral derecha, espejo horizontal sirve para izquierda. Pies comparten ancla; no estirar cada pose por separado. Cabeza baja cambia de golpe, no hay intermedio. Estilo más compacto/robusto que el caballo clásico, sombrero/jinete con proporciones distintas. Fuente sigue teniendo suavidad propia; PNGno equivale a sprite96pxnativo idéntico al clásico.

QA tools/qa_drink83.tscn usa estanque y componente real del jinete. Movimiento guionizado, sustitución visual temporal al parar, dos poses, levantarse y salir. No muta mecánica ni gasto/recuperación, no código de interacción persistente en partida. Captura y vídeo10sinspeccionados: hocico junto al agua y patas fijas entre las dos poses. No APK.

Faltan aprobación de diseño/proporciones y máscaras de genes por pose para pelaje/crin/cola/ojos/protección de jinete-sombrero-ropa-silla, y mapa UVde manchas. Las máscaras actuales son referencia, no se pueden copiar a una silueta diferente. Se pueden crear sobre esta fuente sin regenerarla. Castaño no impide recolor porque pipeline usa luminosidad; crema neutro facilita tonos claros y contraste consistente. Caballo+jinete juntos coincide con arquitectura actual, no hace falta separarlos.

Recomendación: revisar preview antes de trabajo de máscaras. Si cambia diseño, regenerar tomando referencia exacta del sprite clásico y variar solo cuello/cabeza; pies/cuerpo/jinete/tamaño constantes. Frame intermedio opcional para suavidad, no requisito del primer prototipo. No prometer beber animado fluido con solo2poses.

## Máscaras automáticas, revisión v8
Ant aprobó diseño/poses12:27:53y pidió generación automática para retocar. Borradores RGBpelaje/crin por pose y máscara iris separada,4nuevos assets editables en mismo editorv8. Las97bases y146trazos v7 se conservan exactos. Manchas usan canal pelaje; UVde pose provisional deriva cuerpo fijo y remapea cabeza baja. No prometer continuidad perfecta ni todos genes soportados: patas/ojos/acabados requieren revisión individual. Preview azul/crin dorada,moteado,jirafa,vaca usa HorseAppearance real; iris aplicado con HorseAppearance.eye_color_at. No se integra en gameplay.

HTMLv8yJSONcompleto,baseline rancho-20261111-drink-v8. Build tools/mask_editor/build_drink83.py; importador tools/mask_editor/import_drink83.py valida101bases y aplica únicamente4máscaras de bebida tras revisión explícita(--apply), nunca97anteriores. QAChrome390/1280: pintar conPointerEvent,exportar/importar/recargar exacto;4máscaras exportadas sin trazos byte de píxelidénticas;97bases/146trazos anteriores exactos. Capturas inspeccionadas. Entrega por assetsGitHub, no APK. Para devolver por WhatsApp,renombrarJSONa.txt(sin editar su contenido);ZIPsolo siWhatsApplo permite, no asumirlo.
