# Preview: entrada, caminos, ambiente y marcas

## Cambios preparados para el juego, sin APK todavía
- Transición persistente menú→mundo: fundido0,22s,órbita discreta sin texto, calentamiento incremental del arte de exhibición, mundo completo antes de revelar en0,4s. Mismo bloqueo de seguridad inicial hasta9chunks.
- Presupuesto de construcción3msen vez de6ms,anticipación3sen vez de1,6s. No es un límite duro: una textura puede superar el presupuesto.
- Caminos: ramal desde tronco seeded a casa principal y acceso compartido desde delante de las dos casas de la zona fija. Accesos compartidos entre vista del mundo,minimapa y consulta on_trail. Sin cambiar RNG,contenido de chunks,estado descubierto o esquema de guardado. Quitados dos senderos sueltos de la zona fija.

### Medición local, sin Android
PC headless,seed752026,caché fría,1200pasos a500px/s. Es tiempo de trabajo en CPU, no FPS real ni latencia de entrada.
- Antes: entrada2,606s,ready1,182s;construcción131iteraciones,p95=18,309ms,máximo19,589ms. Viaje p95=10,826ms,máximo19,165ms,0frames sin chunk actual.
- Después con calentamiento:0,832srepartidos bajo animación;ready0,290s;entrada tras calentar1,733s,total≈2,565s. Construcción163iteraciones,p95=18,150ms,máximo18,712ms. Viaje p95=10,570ms,máximo26,212ms,0frames sin chunk actual,2chunks anticipados en caché al terminar.
- Conclusión: oculta construcción y reduce bloqueo previo al primer frame, pero no elimina espera ni garantiza60fps. Picos indivisibles de recolor siguen. Android real debe medir entrada fría/caliente,FPS,memoria,galope/regate,giros bruscos,cruces y retorno al menú. Vídeo QA con FPS fijos no mide duración real.

## Prototipos solo de diseño, no conectados al juego
- preview_ambient_yard.gd:8animales ambientales extra y24flores. Dos recursos de animación compartidos, sin cuerpos físicos/captura/encargos. Aún pulir separación,pausa fuera de cámara y posición de floristería. Arte de florista pendiente. No inventar raster nuevo.
- demo_map_notes.gd:4iconos,nota opcional propuesta60caracteres,añadir captura,galería/compartir. Mapa esquemático,miniatura real de QA como ejemplo. No guarda marcas/fotos ni exporta/llama a Android. Requiere persistencia por mundo,validación,migración segura,límites y borrado de huérfanos antes de implementación.
- Fotos propuesta:640×360JPEG,una por marca,limitar bytes por foto y total local. No son números aprobados. Galería:exportación voluntaria de copia,distinta de compartir. Sin cuentas,red ni subida automática. Validar permisos por versión Android y flujo cancelado/disco lleno en dispositivo.

## Fuentes de Android revisadas
- https://developer.android.com/training/data-storage/shared/media
- https://developer.android.com/training/sharing/send
MediaStore para fotos creadas por la propia app,no acceso general a biblioteca. Android10+no necesita permisos de almacenamiento para los archivos multimedia que la app crea;versiones antiguas requieren tratamiento aparte. Sharesheet con URI de contenido y permiso temporal. No se ha implementado el puente nativo.

Rama de pruebas,sin merge a main. Previews inspeccionadas y enviadas antes de cualquier APK.
