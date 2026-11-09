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
