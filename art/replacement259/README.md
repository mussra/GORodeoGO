# Entrada de arte del usuario

Preparación posterior a 2.7.188. No hay imágenes sustitutas activas todavía.

- PROMPT.txt: un solo prompt para una hoja de cien celdas.
- CELDAS.txt / manifest.json: orden de recorte y nombres estables.
- INVENTARIO.md: alcance, usos y tamaños.
- tools/crop_replacement259.py: recorte 10×10 y retirada del magenta.
- ReplacementArt259: lector opcional con retorno null cuando falta el archivo. Todavía no conectado a los dibujos existentes.

Al recibir la hoja: inspeccionar cuadrícula real y cada celda, recortar, revisar transparencia y calidad a tamaño de uso, conectar cada sustitución con fallback, probar y capturar antes de exportar. No reemplazar rutas, texto, números, porcentajes ni geometría de partida por dibujos fijos. Los fondos de pantalla o animaciones no adquieren resolución/detalle suficiente por estar representados como módulos en una hoja.

Prueba del recortador: cien celdas sintéticas, dimensiones y nombres correctos, fondo exterior y huecos interiores transparentes. No certifica la futura hoja real.
