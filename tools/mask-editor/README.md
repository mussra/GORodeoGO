# Editor de revisión de máscaras

Fuente de la página privada de revisión de Rancho, sincronizada con los contornos aprobados el 6 de noviembre. No forma parte del juego ni se ejecuta al arrancarlo.

- 71 máscaras: retrato adulto y ojos, potrillo y ojos, reposo, aturdido y cinco direcciones de galope.
- Los PNG base y su SHA-256 identifican la revisión. Las variantes de sombrero reutilizan las máscaras de fase.
- Pintar, borrar, deshacer, restaurar, zoom, desplazar con Mano y cuatro vistas.
- Exporta JSON con trazos y hashes. Importar recupera la sesión.
- Guardado local por navegador con indicador de confirmación y envío explícito al chat. Preview usa memoria; no garantiza persistencia. Ver RECOVERY.md.
- Resultado usa colores diagnósticos, no reproduce exactamente el shader Godot.
- Ninguna corrección se aplica automáticamente al juego.

## Revisar un archivo recibido

Desde la raíz del repositorio, con Pillow instalado:

```
python tools/mask-editor/review_import.py rancho-mascaras.json --output /tmp/mascaras-revisadas
```

Valida formato, máscaras conocidas, SHA-256, tamaños y trazos antes de escribir. Solo escribe PNG candidatos y un resumen en un directorio nuevo fuera del árbol art. No cambia los originales. El rasterizado de trazos usa supersampling y puede diferir ligeramente del antialias del navegador: comparar el PNG exportado por el editor y revisar bordes antes de adoptar una corrección.

El siguiente paso es inspección visual y aprobación del alcance de incorporación. Crear un candidato no autoriza merge ni APK.
