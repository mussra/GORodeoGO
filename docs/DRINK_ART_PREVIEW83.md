# Preview beber, 11 noviembre2026

Arte suministrado por Ant en PNG12:24:57,1774×887RGBcon fondo verde. JPEG anterior descartado. Original conservado en art/experimental/drink_preview83/source_ant.png. No arte generado por nosotros.

Preparación reproducible tools/key_drink_preview83.py: separación de dos mitades, alfa por dominancia de verde, reducción de contaminación en bordes parciales, misma escala común83/674, misma traslación de referencia de pies. Lienzo112×96para no recortar cabeza baja. Datos exactos alignment.json. Sin interpolación ni nueva pose dibujada. PNGresultantes solo para preview.

Dos poses lateral derecha, espejo horizontal sirve para izquierda. Pies comparten ancla; no estirar cada pose por separado. Cabeza baja cambia de golpe, no hay intermedio. Estilo más compacto/robusto que el caballo clásico, sombrero/jinete con proporciones distintas. Fuente sigue teniendo suavidad propia; PNGno equivale a sprite96pxnativo idéntico al clásico.

QA tools/qa_drink83.tscn usa estanque y componente real del jinete. Movimiento guionizado, sustitución visual temporal al parar, dos poses, levantarse y salir. No muta mecánica ni gasto/recuperación, no código de interacción persistente en partida. Captura y vídeo10sinspeccionados: hocico junto al agua y patas fijas entre las dos poses. No APK.

Faltan aprobación de diseño/proporciones y máscaras de genes por pose para pelaje/crin/cola/ojos/protección de jinete-sombrero-ropa-silla, y mapa UVde manchas. Las máscaras actuales son referencia, no se pueden copiar a una silueta diferente. Se pueden crear sobre esta fuente sin regenerarla. Castaño no impide recolor porque pipeline usa luminosidad; crema neutro facilita tonos claros y contraste consistente. Caballo+jinete juntos coincide con arquitectura actual, no hace falta separarlos.

Recomendación: revisar preview antes de trabajo de máscaras. Si cambia diseño, regenerar tomando referencia exacta del sprite clásico y variar solo cuello/cabeza; pies/cuerpo/jinete/tamaño constantes. Frame intermedio opcional para suavidad, no requisito del primer prototipo. No prometer beber animado fluido con solo2poses.
