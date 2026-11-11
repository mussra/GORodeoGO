# Prueba del vaquero narrador

Usa `art/ui/hero/rider_hd.png` sin cambios. No genera ilustraciones. Rota la ilustración entera un máximo de 1,05 grados y desplaza unos píxeles: el sombrero no se separa de la cara y no aparecen los ojos.

El MP4 publicado es una animática con narración provisional, no sincronía labial. El WAV de narración no se guarda en el repositorio.

Render visual:

```sh
python tools/story_preview/render_cowboy_intro.py --duration 24.1 --breaks 5.4,12.1,16.9 --output /tmp/vaquero-visual.mp4
```

Después se mezcla el WAV de 23,28 segundos sin cortar su final y se deja una breve cola silenciosa. Las tarjetas cambian en pausas entre párrafos. No usa música.

Guion completo y disparadores propuestos: `docs/HISTORIA_DIALOGOS_BORRADOR83.md`.
