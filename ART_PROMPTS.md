# ART PROMPTS — GO Rodeo GO

## Cómo incorporar las imágenes generadas (proceso completo, paso a paso)

1. **Genera las imágenes** con los prompts de más abajo, en tu herramienta de IA de imágenes (Midjourney, DALL-E, tu editor con IA, etc.).
2. **Recorta/ajusta cada imagen** a un lienzo cuadrado del tamaño recomendado (ver tabla más abajo — 96×96 para jugador/toro, 160×160 para el corral), con fondo transparente. La mayoría de herramientas de IA no generan exactamente ese tamaño ni con transparencia real — normalmente necesitarás un paso extra en un editor (Photopea, GIMP, Photoshop) para: quitar el fondo (o generar directamente con fondo transparente si tu herramienta lo permite) y recortar/centrar al tamaño exacto.
3. **Nombra los archivos** siguiendo la convención exacta: `frame_0.png`, `frame_1.png`, `frame_2.png`... (ver tabla de carpetas más abajo). El orden importa — se cargan alfabéticamente.
4. **Copia los archivos a la carpeta del proyecto**, dentro de `res://art/...` (es decir, la carpeta `art/` en la raíz de tu proyecto Godot, junto a `src/`, `addons/`, etc.). Puedes hacerlo de dos formas:
   - **Fuera de Godot**: copia los archivos directamente con el explorador de archivos de Windows a la ruta física del proyecto (ej. `...\GO Rodeo GO\rancho\GORodeoGO\art\bull\idle\frame_0.png`). Si Godot está abierto, detectará los archivos nuevos automáticamente (o pulsa clic derecho en el panel "Sistema de Archivos" → "Reimportar" si no aparecen al momento).
   - **Dentro de Godot**: arrastra los archivos desde tu explorador directamente al panel "Sistema de Archivos" de Godot, en la carpeta correspondiente (créala antes con clic derecho → "Nueva Carpeta" si no existe todavía).
5. **No hace falta tocar ninguna escena ni código.** `sprite_swap.gd` escanea esas carpetas en tiempo de ejecución cada vez que arranca un `Bull` o el `Player` — en cuanto los archivos estén en su sitio, la próxima vez que ejecutes el juego (F6) aparecerá el arte real en vez del recuadro de color, automáticamente.
6. **Verifica**: ejecuta el juego. Si una animación tiene su carpeta con al menos un `frame_0.png` válido, verás el sprite real. Si falta la carpeta o está vacía, sigue viéndose el recuadro de color de siempre — es el comportamiento esperado (fallback), no un error.

**Nota importante:** puedes añadir las animaciones de una en una, en cualquier orden — no hace falta tener el set completo para empezar a ver resultados. Por ejemplo, añade solo `res://art/bull/idle/` primero para probar el proceso, y ve añadiendo el resto cuando quieras.

---

Convención de carpetas que el código ya escanea automáticamente en tiempo de ejecución
(`sprite_swap.gd`). Si una carpeta o animación no existe, el juego sigue usando el
recuadro de color placeholder actual — nunca falla. Puedes ir añadiendo animaciones una
a una.

## Sistema de direcciones (8 direcciones con solo 5 sets de arte)

El personaje/toro se mueve en 8 direcciones, pero solo generas arte para 5: el código
espeja horizontalmente las otras 3 automáticamente. Genera SIEMPRE mirando hacia la
derecha (o hacia la derecha-abajo / derecha-arriba en las diagonales) — nunca generes las
versiones espejadas, el código ya lo hace.

| Carpeta (sufijo)  | Dirección real que cubre           | Se espeja también para... |
|-------------------|-------------------------------------|----------------------------|
| `_side`           | Derecha (Este)                      | Izquierda (Oeste)          |
| `_down`           | Abajo (Sur)                         | — (sin espejo, es simétrico)|
| `_up`             | Arriba (Norte)                      | — (sin espejo, es simétrico)|
| `_diag_down`      | Abajo-derecha (Sureste)              | Abajo-izquierda (Suroeste) |
| `_diag_up`        | Arriba-derecha (Noreste)             | Arriba-izquierda (Noroeste)|

## Convención de archivos (OBLIGATORIA — el código busca exactamente esto)

```
res://art/player/idle/frame_0.png, frame_1.png, ...
res://art/player/walk_side/frame_0.png, ...
res://art/player/walk_up/frame_0.png, ...
res://art/player/walk_down/frame_0.png, ...
res://art/player/walk_diag_down/frame_0.png, ...
res://art/player/walk_diag_up/frame_0.png, ...
res://art/player/stunned/frame_0.png, ...

res://art/bull/idle/frame_0.png, ...
res://art/bull/flee_side/frame_0.png, ...
res://art/bull/flee_up/frame_0.png, ...
res://art/bull/flee_down/frame_0.png, ...
res://art/bull/flee_diag_down/frame_0.png, ...
res://art/bull/flee_diag_up/frame_0.png, ...
res://art/bull/captured/frame_0.png, ...
res://art/bull/calming/frame_0.png, ...
res://art/bull/controlled/frame_0.png, ...

res://art/pen/pen.png   (una sola imagen estática, no carpeta de frames)
```

- Nombres de archivo: `frame_0.png`, `frame_1.png`, `frame_2.png`... (se cargan en orden alfabético; usa cero-relleno si llegas a 10+: `frame_00.png`).
- Fondo transparente (PNG con alpha), nunca fondo sólido.
- Mismo tamaño de lienzo en TODOS los frames de una misma entidad — tamaños distintos entre frames rompen la animación.
- Estilo: cartoon, colorido, formas claras, lectura inmediata — ver PROJECT_SPEC.md #Visual direction.
- **Nota de alcance:** `idle` y `stunned` (jugador) y `idle`/`captured`/`calming`/`controlled` (toro) NO tienen variantes direccionales todavía — son animaciones únicas sin importar hacia dónde mires. Solo `walk_*`/`flee_*` son direccionales por ahora. Si quieres que el resto también lo sea (por ejemplo, un toro `controlled` que se ve arrastrado en la dirección real hacia el corral), dilo y lo amplío.

## Tamaños recomendados (lienzo cuadrado, deja margen alrededor del sujeto)

- Jugador (vaquero a caballo): 96×96 px
- Toro: 96×96 px
- Corral (pen.png): 160×160 px

---

## PROMPTS — Vaquero a caballo

### idle (reposo, sin dirección — vista general)
```
2D top-down cartoon sprite, cowboy riding a horse, viewed from directly above at a slight
angle (3/4 top-down, arcade game style), idle standing pose, facing right, bright saturated
colors, thick clean outlines, simple readable shapes, family-friendly, no violence,
transparent background, square canvas, centered subject with padding, flat cel-shaded
coloring
```

### walk_side (andando hacia la derecha, 4-6 frames)
```
2D top-down cartoon sprite sheet, cowboy riding a horse in a walking gait cycle, viewed
from directly above at a slight angle (3/4 top-down), moving toward the RIGHT side of the
frame, facing right, legs/hooves in mid-stride, bright saturated colors, thick clean
outlines, transparent background, consistent character proportions across all frames,
4 to 6 frame walk cycle, each frame same canvas size and character scale
```

### walk_down (andando hacia la cámara / hacia abajo en pantalla, 4-6 frames)
```
2D top-down cartoon sprite sheet, cowboy riding a horse walking directly toward the
viewer (top-down view, character moving downward on screen, facing the camera/downward),
walking gait cycle, bright saturated colors, thick clean outlines, transparent background,
consistent proportions across frames, 4 to 6 frame walk cycle, same canvas size as the
other walk directions for this character
```

### walk_up (andando alejándose de la cámara / hacia arriba en pantalla, 4-6 frames)
```
2D top-down cartoon sprite sheet, cowboy riding a horse walking away from the viewer
(top-down view, character moving upward on screen, back of the character visible),
walking gait cycle, bright saturated colors, thick clean outlines, transparent background,
consistent proportions across frames, 4 to 6 frame walk cycle, same canvas size as the
other walk directions for this character
```

### walk_diag_down (andando en diagonal hacia abajo-derecha, 4-6 frames)
```
2D top-down cartoon sprite sheet, cowboy riding a horse walking diagonally toward the
bottom-right of the frame (three-quarter view, moving down and to the right), walking
gait cycle, bright saturated colors, thick clean outlines, transparent background,
consistent proportions across frames, 4 to 6 frame walk cycle, same canvas size as the
other walk directions for this character
```

### walk_diag_up (andando en diagonal hacia arriba-derecha, 4-6 frames)
```
2D top-down cartoon sprite sheet, cowboy riding a horse walking diagonally toward the
top-right of the frame (three-quarter view, moving up and to the right, back mostly
visible), walking gait cycle, bright saturated colors, thick clean outlines, transparent
background, consistent proportions across frames, 4 to 6 frame walk cycle, same canvas
size as the other walk directions for this character
```

### stunned (aturdido, 2-3 frames, sin dirección)
```
2D top-down cartoon sprite, cowboy on a horse in a dazed/stunned pose, spinning stars or
wobble effect above the head, slight swaying animation, facing right, bright saturated
colors, thick clean outlines, transparent background, family-friendly comedic style,
2 to 3 frame loop, same canvas size and proportions as the idle/walk sprites for this
character
```

---

## PROMPTS — Toro

### idle (tranquilo, sin dirección, 2-4 frames)
```
2D top-down cartoon sprite, a bull standing calmly, viewed from directly above at a slight
angle (3/4 top-down), facing right, gentle breathing/tail-swish idle animation, bright
saturated colors, thick clean outlines, simple readable shapes, family-friendly (no gore,
no aggressive expression), transparent background, square canvas, 2 to 4 frame loop
```

### flee_side (huyendo hacia la derecha, 4-6 frames)
```
2D top-down cartoon sprite sheet, a bull running/fleeing in a panicked but comedic way,
viewed from directly above at a slight angle (3/4 top-down), moving toward the RIGHT side
of the frame, facing right, dust cloud optional at the feet, bright saturated colors,
thick clean outlines, transparent background, consistent proportions across frames,
4 to 6 frame run cycle
```

### flee_down (huyendo hacia la cámara, 4-6 frames)
```
2D top-down cartoon sprite sheet, a bull running/fleeing directly toward the viewer
(top-down view, moving downward on screen, facing the camera), panicked but comedic
expression, dust cloud optional, bright saturated colors, thick clean outlines,
transparent background, consistent proportions across frames, 4 to 6 frame run cycle,
same canvas size as the other flee directions
```

### flee_up (huyendo alejándose de la cámara, 4-6 frames)
```
2D top-down cartoon sprite sheet, a bull running/fleeing away from the viewer (top-down
view, moving upward on screen, back of the bull visible), panicked but comedic posture,
dust cloud optional, bright saturated colors, thick clean outlines, transparent
background, consistent proportions across frames, 4 to 6 frame run cycle, same canvas
size as the other flee directions
```

### flee_diag_down (huyendo en diagonal hacia abajo-derecha, 4-6 frames)
```
2D top-down cartoon sprite sheet, a bull running/fleeing diagonally toward the
bottom-right of the frame, panicked but comedic posture, dust cloud optional, bright
saturated colors, thick clean outlines, transparent background, consistent proportions
across frames, 4 to 6 frame run cycle, same canvas size as the other flee directions
```

### flee_diag_up (huyendo en diagonal hacia arriba-derecha, 4-6 frames)
```
2D top-down cartoon sprite sheet, a bull running/fleeing diagonally toward the top-right
of the frame, back mostly visible, panicked but comedic posture, dust cloud optional,
bright saturated colors, thick clean outlines, transparent background, consistent
proportions across frames, 4 to 6 frame run cycle, same canvas size as the other flee
directions
```

### captured (enlazado, 1-2 frames, sin dirección)
```
2D top-down cartoon sprite, a bull with a lasso rope around it, startled/surprised
expression, brief struggle pose, viewed from directly above at a slight angle (3/4
top-down), facing right, bright saturated colors, thick clean outlines, transparent
background, family-friendly, 1 to 2 frame pose (can be a short flinch animation)
```

### calming (tranquilizándose, 2-3 frames, sin dirección)
```
2D top-down cartoon sprite, a bull with a lasso around it visibly relaxing, tension
easing out of its posture, calmer expression than the captured pose, viewed from directly
above at a slight angle (3/4 top-down), facing right, bright saturated colors, thick clean
outlines, transparent background, family-friendly, 2 to 3 frame gentle loop
```

### controlled (controlado, 2-3 frames, sin dirección)
```
2D top-down cartoon sprite sheet, a fully calm bull walking gently on a lead, relaxed
posture, content expression, viewed from directly above at a slight angle (3/4 top-down),
facing right, bright saturated colors, thick clean outlines, transparent background,
family-friendly, 2 to 3 frame calm walk cycle, consistent proportions
```

---

## PROMPT — Corral / cuadra (pen.png, imagen única)

```
2D top-down cartoon illustration of a small wooden ranch corral/pen, viewed from directly
above at a slight angle (3/4 top-down), open gate facing right, wooden fence rails, dirt
ground texture inside, bright saturated colors, thick clean outlines, family-friendly,
transparent background outside the fence silhouette, single static image, square canvas,
160x160 composition
```

---

## Pendiente de prompts (no bloquea el vertical slice de código, pero falta arte)

- **Valla del rancho (fence):** rectángulos de color placeholder con colisión física real ya funcionando. Sistema de sprites aún no cableado para esto (geometría tileable, más compleja que un sprite único/animación por carpeta).
- **Fondo/terreno del rancho:** sin sprite de suelo todavía.
- **Iconos UI:** el HUD es solo texto/barra nativa de Godot, sin iconos.
- **Direccionalidad de `idle`/`captured`/`calming`/`controlled`:** ver nota de alcance arriba.
