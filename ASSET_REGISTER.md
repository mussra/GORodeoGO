# Registro de activos y sustituciones

Actualizado: 9 noviembre 2026. Documento de trabajo, no certificacion legal.

## Audio

| Activo | Estado y origen | Sustitucion final |
|---|---|---|
| `art/audio/hoof_a.wav`, `hoof_b.wav` | Biblioteca gratuita, CC0 segun registro existente. Autor, fuente y transformaciones en CREDITS.md. | Conservar evidencia de licencia. |
| `src/Application/menu_sounds.gd`: tap, open, back | Marcadores sintetizados locales, provisionales. | Biblioteca gratuita con permiso comercial y redistribucion. Destinos: `audio/ui/tap.wav`, `open.wav`, `back.wav`, WAV mono 16-bit; 40-150 ms, sin silencio inicial. El sistema usa los archivos automaticamente cuando existen. |
| `src/Presentation/ranch_audio.gd`: lazo, captura, puerta, victoria, derrota, etc. | Sintesis local provisional. | Reemplazar por biblioteca gratuita y documentar cada fuente/licencia. |
| `audio/music/menu.wav`, `gameplay.wav` | Pendiente de revisar procedencia/licencia para version final. | No dar por acreditados por estar en el repositorio. |
| `art/audio/pant.wav` | Pendiente de revisar procedencia/licencia para version final. | Biblioteca gratuita acreditada. |

Cada reemplazo debe anotar: nombre del archivo, obra original, autor, URL de
origen, licencia exacta y URL, fecha de comprobacion, modificaciones y credito
requerido. Gratuito no significa permiso comercial o de redistribucion.
Los marcadores no se presentan como audio final de biblioteca.

## Sprites pendientes

Las medidas siguientes son recomendaciones de entrega, no autorizacion para
cambiar el diseno del caballo clasico ni el jinete oficial.

1. Cerdo: PNG RGBA, celdas de 128x128, perfil a derecha, pies en y=110.
   Carrera 6-10 fotogramas, reposo 4, cansado/jadeo 4, una tira por animacion.
   Rosa y marron con la misma escala y pivote. Hoja JPG de carrera recibida
   el 9-nov: 10 fotogramas por color, pendiente de integrar tras 2.7.46.
2. Iconos: coleccion, cria, atlas/mapa, mercado, entrenamiento, genealogia,
   editor, casa, salir, volver. PNG RGBA 128x128, margen interior 12 px,
   sin letras. Los glifos por codigo actuales son provisionales.
3. Fondo de menu: paisaje del rancho 1920x1080, sin texto ni botones,
   zonas tranquilas detras del contenido. Fondo por codigo provisional.
4. Inventario de segunda pasada: decoracion de mundo (arbol, cactus, roca,
   casa, vallas/corrales), toros y adornos aun dibujados por codigo.
   Revisar cada renderer para distinguir sprites existentes de alternativas
   provisionales y extraer escala/pivote antes de pedir nuevas hojas.

Cuerdas, barras de progreso, guias, minimapa e indicadores son informacion de
juego. Su conversion literal a sprites esta pendiente de concretar; este
registro no elimina esos elementos ni cambia sus reglas.
