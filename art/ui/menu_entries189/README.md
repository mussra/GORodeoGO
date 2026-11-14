# Iconos de menú aportados por Ant,14 de noviembre 2026

source.png conserva la hoja original 2146×732 RGBA. Recortes transparentes sin números: atlas.png 596×531 (caballo, lupa, regla), frontier.png 623×481 (valla, cartel, sol), levels.png 612×571 (escalones, estrella, bandera). La limpieza conserva piezas separadas del dibujo, incluidos los rayos del sol.

Reproducir: python 3 tools/crop_menu 189.py art/ui/menu_entries 189/source.png art/ui/menu_entries 189. Dependencias Pillow, NumPy, SciPy. Vista de revisión /downloads/menu 189-crops.png.

MenuEntryArt 189 cachea las texturas, conserva proporción y las comparte entre las tarjetas y los botones.44 px de icono en Frontera/Niveles;56 px en Atlas. No cambia áreas táctiles ni mecánicas.
