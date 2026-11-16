# Iconos de coronas provisionales

Fuente: hoja suministrada por Antonio el 16 de noviembre de 2026. La transparencia es real (canal alfa; esquinas a cero), no un fondo negro. `source.png` conserva el original U; `source_round.png`, el circular. El manifiesto registra su hash y los seis recortes.

Recrear: desde la raíz del proyecto, `python tools/crop_crowns241.py` y `python tools/crop_crowns241.py --round` (requiere Pillow).

`art/ui/crowns241/{bulls,race,duel,joust,memory,cup}.png` contiene las versiones a color y los mismos nombres con sufijo `_pending` las desaturadas. Todas de 512×512, máximo de contenido 448×448 y margen centrado de al menos 32 px. Se preserva la proporción de cada corona.

El subdirectorio `round/` contiene los doce equivalentes redondos. El selector de prueba del catálogo alterna U y redonda durante la sesión, sin guardado de esa preferencia ni cambios de progreso. Antonio aún está comparando ambos estilos. Sustituir los PNG con los mismos nombres y dimensiones actualiza el catálogo sin cambiar reglas o guardados.
