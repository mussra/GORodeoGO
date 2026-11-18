# Creditos de audio

## Pasos de caballo (cocos) - art/audio/hoof_a.wav, hoof_b.wav
- Obra: "Coconut Horse Walking Sound Effects (Slow Gallop, Faster Gallop)"
- Autor: BorzSounds (Freesound)
- URL: https://freesound.org/people/BorzSounds/sounds/843303/
- Licencia: Creative Commons 0 (CC0, dominio publico) - verificado en la pagina el 8-nov-2026
- Fuente de descarga: preview publico HQ MP3 (cdn.freesound.org), sin login
- Uso: dos golpes de coco recortados (0.506s y 0.784s del original), normalizados,
  mono 48kHz 16-bit, fundidos cortos anti-clic. El ritmo de paso/trote/galope lo
  pone el motor (frontier_world._tick_hoofbeats), que alterna ambos samples.

## Audio provisional de interfaz y otros pendientes
`src/Application/menu_sounds.gd` contiene marcadores sintetizados originales,
no audio final de biblioteca. El mute global los desactiva. Registro de
sustituciones y requisitos de procedencia en [ASSET_REGISTER.md](ASSET_REGISTER.md).
La version final debe usar fuentes gratuitas con licencia comercial y de
redistribucion compatible, comprobada para cada archivo.

## Cerdos rosa/marron - art/world/pigs
- Hoja JPG aportada por Ant el 9-nov-2026 para integrarla en el juego.
- Original sin modificar: `art/world/pigs/source/running-sheet.jpg`.
- Conversion: `tools/extract_pig_sprites.py`; fondo negro exterior a alfa,
  20 fotogramas PNG, celdas160x144, pies alineados, sin redibujar el personaje.
- Procedencia/licencia anterior a la aportacion: no verificada; no se declara
  CC0 ni biblioteca gratuita. Pendiente de acreditar para distribucion final.

## Chasquido de látigo - audio/scare265.wav
- Obra: Whip crack #3, sonido 2951.
- Autor: Joseph SARDIN, BigSoundBank.
- Fuente: https://bigsoundbank.com/whip-crack-3-s2951.html
- Original WAV: https://bigsoundbank.com/UPLOAD/bwf-en/2951.wav
- Licencia: Creative Commons CC0 1.0 Universal, uso comercial y edición permitidos, sin atribución obligatoria.
- Términos del sitio: https://bigsoundbank.com/licenses.html
- Texto CC0: https://creativecommons.org/publicdomain/zero/1.0/
- Verificado y descargado sin cuenta el 18-nov-2026; elegido por Ant.
- Original preservado en audio/sources/whip-crack-3-2951-original.wav (excluido del APK).
- Edición: conserva 0,08..0,70 s, ganancia -3 dB, fundidos de 3/20 ms,
  mono PCM 48 kHz 16 bits. Sin cambiar tono ni velocidad.

## Icono de látigo - art/equipment271/latigo.png
Dibujo aportado por Ant el 18-nov-2026 para Rancho. Original intacto en
art/equipment271/source/latigo-ant-original.png. El PNG tiene alfa real;
solo se recorta el margen transparente, sin borrar píxeles del objeto ni redibujarlo.

## Botones de interfaz 2.7.200
Arte aportado por Ant el18nov2026. Original conservado en art/ui/skin272/source/original.png; recortes y trazabilidad en manifest.json. Se conserva alfa y se retiran partículas exteriores desconectadas. Integración nueve zonas en ButtonSkin272. Sin imágenes de terceros nuevas.
