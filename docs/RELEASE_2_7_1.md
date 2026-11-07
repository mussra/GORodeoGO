# Rancho Prueba 2.7.1 - corrección de escudos y caballeriza

Correcciones sobre los tres fallos reportados por Antonio el 7 de noviembre de 2026:

- El color elegido del escudo ahora se dibuja sobre el caballo. Antes el shader del retrato lo pintaba siempre en blanco hueso o casi negro según el pelaje, sin usar el color de la ficha. Si el color elegido pegaría poco con el pelaje, se aclara u oscurece hasta dos pasos para que siga leyéndose, con el borde opuesto para que las aristas sobrevivan.
- El diálogo de habilidad muestra el título de su propia placa (Regate o Salto de vallas). Antes todas las placas usaban el título fijo de salto, así que la placa de regate abría un diálogo titulado "Salto de vallas" con cuerpo de regate.
- Las placas de la colección vuelven a 64x56 en vez de estirar su zona táctil a toda la altura de la fila, a pocos píxeles de EQUIPAR y FICHA. El icono del escudo ya no captura toques. Hipótesis de causa del toque de Antonio: la zona táctil agrandada de la placa de regate, pegada a FICHA; el runtime prueba que la ruta de FICHA es correcta, no qué píxel tocó él.
- El texto superior de la caballeriza ya no pisa el botón Entrenamiento: clip_text se activa antes de fijar el tamaño (Godot 4.7 recorta el tamaño al ancho del texto mientras el recorte está desactivado).

Sin cambios en datos guardados, escudos existentes, economía ni controles de niveles.

## Comprobaciones

Suite unitaria completa en verde (16 scripts, incluidos tests nuevos: el color elegido lidera y se mantiene legible; el título del diálogo corresponde a la habilidad). Tests de integración de genealogía UI y recursos de animación en verde. Capturas de runtime inspeccionadas: colección de 12 caballos sin solape, diálogo de regate con su título, emblema sobre pelaje oscuro (color elegido directo), claro y gris (color ajustado por contraste). No probado en dispositivo Android físico: el táctil real, el rendimiento y la legibilidad en pantalla de teléfono quedan por certificar en el móvil de Antonio.

Mantiene paquete com.example.rancho.review, firma de pruebas 46bdcb... y versionCode 260; instalar como actualización.
