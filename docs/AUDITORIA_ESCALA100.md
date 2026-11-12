# Auditoría: crecer sin techo, no recortar el mundo

12 noviembre 2026. Mediciones de escritorio con Godot 4.7.2, renderer de software llvmpipe. Sin Android físico ni APK nuevo. No se han optimizado todavía los cuellos de botella descritos: esta auditoría mide y propone. Solo el ajuste de encuadre al abrir el mapa pertenece a la petición independiente del marcador.

## Conclusión

El streaming de nodos ya descarga regiones lejanas y el coste de generar un chunk no aumenta por estar lejos. Pero eso NO basta para afirmar que todo el mundo escala: el mapa procesa todo el historial, las cachés de arte retienen caballos, las ediciones se recorren completas y la posición global pierde precisión. Los pueblos a gran escala aún no existen. Hay que hacer el coste del juego dependiente de la zona visible y de sus cambios, no de todos los kilómetros recorridos.

El objetivo recomendado es memoria de trabajo acotada, guardado incremental y coordenadas regionales, con exploración sin límite de diseño. Un presupuesto de caché o de trabajo por fotograma limita recursos simultáneos, no la extensión del mundo ni lo que el usuario puede descubrir.

## Qué se midió realmente

Fixture `tools/audit_scalability100.tscn`: mundo V2 real, semilla 752026, datos temporales, nueve saltos de carga/descarga entre chunks x=0, 2, 10, 100, 1.000, 10.000, 100.000, 1.000.000 y vuelta a cero. Se fuerza completar construcción para medir el trabajo total, no para simular un viaje continuo a velocidad de juego. Los tiempos NO son FPS ni pausas inevitables de producción: producción reparte la construcción por fotogramas.

| Punto | Chunks activos | Tiempo total de transición | Caché global de frames de caballos | Memoria estática reportada |
|---|---:|---:|---:|---:|
| Origen | 9 | 78 ms | 4 | 58,28 MB |
| Chunk 2 | 12 | 991 ms | 8 | 59,97 MB |
| Chunk 10 | 9 | 1.125 ms | 14 | 59,87 MB |
| Chunk 1.000 | 9 | 1.047 ms | 24 | 61,14 MB |
| Chunk 100.000 | 9 | 608 ms | 28 | 60,58 MB |
| Chunk 1.000.000 | 9 | 317 ms | 30 | 60,67 MB |
| Vuelta a origen | 9 | 55 ms | 30 | 60,78 MB |

Nodos activos aproximadamente 312-452, sin crecimiento proporcional a la distancia en esta muestra. Pending/built quedaron a cero tras cada transición. La memoria estática del motor no es RSS ni memoria total de texturas/GPU; no usar la tabla para prometer estabilidad de toda la RAM.

Generar datos de chunk + red nominal, 200 muestras por punto: 0,056-0,057 ms de media tanto en origen como en chunks 1.000, 100.000 y 1.000.000. No incluye construir/recolorear sprites, física o subir texturas. Las posiciones a distancias enormes ya están degradadas por precisión; coste constante no significa geometría correcta allí.

## Historial, mapa y guardado

Datos sintéticos de descubrimiento en una línea, sin gran colección de caballos ni miles de misiones. Tiempo medio de consultar `_cells`, hash de firma, búsqueda negativa `Array.has` y una escritura completa temporal:

| Chunks descubiertos | `_cells` | Hash de firma | Búsqueda negativa | Guardado completo | Archivo |
|---:|---:|---:|---:|---:|---:|
| 100 | 0,054 ms | 0,0014 ms | 0,00043 ms | 0,26 ms | 1,6 KB |
| 1.000 | 0,57 ms | 0,012 ms | 0,0069 ms | 0,72 ms | 9,7 KB |
| 10.000 | 5,13 ms | 0,041 ms | 0,031 ms | 2,54 ms | 99,7 KB |
| 50.000 | 23,96 ms | 0,276 ms | 0,243 ms | 13,13 ms | 540 KB |

Estos archivos pequeños NO representan una campaña completa: añadir misiones, caballos, ancestros y ediciones aumenta el trabajo. `save_progress` serializa todo, aunque solo haya cambiado posición. El auto-guardado nominal se solicita cada cuatro segundos y algunas altas de misión también guardan. En Android el coste puede ser mayor y la latencia de almacenamiento distinta.

Reconstrucción real de comandos del mapa, a través de render de escritorio: 100 chunks ~78 ms, 1.000 ~503 ms. La prueba de 10.000 emitió sus métricas de historial pero no completó el render/reconstrucción antes del timeout global del proceso. No se atribuye todo ese timeout a una única función: es una prueba fallida de carga, no una medida exacta de latencia de 10.000. No se repitió una carga bloqueante mayor por insistencia.

El mapa recorre TODOS los chunks descubiertos, regenera decoración y aplica TODAS las ediciones por cada chunk, incluso fuera del área visible. El caché retiene comandos y evita repetir la reconstrucción cada fotograma cuando la firma no cambia, pero un descubrimiento, zoom o desplazamiento la invalida. Además se vuelve a calcular hash del historial para detectar cambios. A escala pequeña funciona; a gran escala requiere otra arquitectura.

Se detectó un error de render de texto con tamaño cero al dibujar una marca de misión en el mapa extremadamente comprimido de 1.000 chunks. No cambia el guardado, pero es un fallo concreto de nivel de detalle. Los iconos de decoración se amontonan antes de que puedan leerse: no basta con mantener el marcador del jugador grande.

Ediciones: aplicar 10.000 operaciones dispersas a UN chunk costó ~20,45 ms de media (100 repeticiones). Indexarlas espacialmente es prioritario: el coste actual crece con todas las ediciones, no solo las locales.

## Precisión a gran distancia

Medición de Vector2 del build actual, paso esperado al galope 260/60 = 4,333333 unidades:

| Coordenada x | Paso que resulta | Añadir una unidad |
|---:|---:|---:|
| 10.000 | 4,3330 | 1 |
| 100.000 | 4,33594 | 1 |
| 1.000.000 | 4,3125 | 1 |
| 10.000.000 | 4 | 1 |
| 100.000.000 | 8 | 0 |
| 1.000.000.000 | 0 | 0 |

La solución NO es prohibir explorar hasta esas coordenadas. Mantener coordenada global como entero de región/chunk + desplazamiento local pequeño; render/física en origen flotante cerca del jugador. Rebasar juntos actores, colisiones, cámara, lazo, efectos y referencias temporales. Persistir posiciones regionales y convertir a local solo lo visible. También sustituir Vector2i global si se busca rebasar su rango de 32 bits: pares de enteros de 64 bits, o regiones jerárquicas. Un mundo digital tiene límites de representación; se alejan con direccionamiento regional, no con una barrera de juego.

## Cachés y mantenibilidad

- `_chunks`, `_chunk_pending`, `_chunk_built` descargan fuera del radio local; preservar ese modelo y medir su presupuesto en Android.
- `WildHorseArt.frame_cache` retiene SpriteFrames por genotipo sin expulsión. Pasó de 4 a 30 entradas en los saltos y no volvió a cuatro al regresar. No se midió fuga infinita; se observó retención. El número de genotipos es finito pero grande.
- PixelLab borra su caché de texturas al superar 600 entradas, pero frames ya referenciados por la otra caché pueden seguir reteniéndolas. Necesita presupuesto coordinado/LRU con referencias activas, no dos políticas independientes.
- V2 vuelve a construir el pequeño plan local para consultas por chunk y vuelve a solicitar cargas de piezas en dibujo; cachear descriptores puros y atlas compartido con invalidación por versión/semilla.
- Las versiones V1/V2 están preservadas, pero `frontier_world.gd` concentra demasiadas responsabilidades y contiene ramas globales basadas en SaveData. Separar repositorio, generador, streaming, fauna, UI de mapa y reglas de superficie por interfaces de contexto.
- El generador nominal referencia una disposición que vive en Presentation y el builder de edificios también: invertir esa dependencia hacia un descriptor de datos de mundo compartido. No duplicar posiciones/anchuras entre dibujo, superficie, colisiones y mapa.
- Hay un comentario ya existente sobre borrado de oclusores cada frame en `_update_chunks`: revisar su alcance en una corrección propia, no cambiarlo dentro de una medición.
- Los tests de legado ahora fijan explícitamente su versión. Añadir contratos por generador para que tests que crean mundo nuevo no dependan accidentalmente del valor global dejado por otro test.

## Pueblos y variedad de red

Hoy no hay generador de pueblos periódicos ni índice de asentamientos. La red nominal tiene un eje infinito recto y solo ocho variantes de ramales en su núcleo. No confundir extensión sin límite con variedad estructural ni con un mundo poblado a lo largo de kilómetros.

Propuesta escalable: macroregiones deterministas por semilla/coordenadas/versionado, cada una genera un descriptor pequeño de conexiones, terreno, asentamientos y puertos. Resolver fronteras mediante una regla canónica compartida por vecinos, sin recorrer todas las regiones anteriores. Un eje/arbol jerárquico con progreso monotónico y ramales de asentamientos preserva conectividad sin ciclos. Colocar pueblos por estaciones de distancia del eje con jitter determinista y conectarlos a puertos previstos; validación local más contratos de frontera. Al no existir escala km aprobada, no afirmar todavía separación física implementada.

El mapa consulta descriptores/index espacial de pueblos de la zona visible, no instancia sus edificios para conocer su posición. Guardar solo diferencias respecto al contenido generado y estado de descubrimiento. La mejora de variedad estructural y montañas se implementará en una versión posterior para no alterar las partidas V1/V2 existentes.

## Plan por prioridad, sin limitar crecimiento

**P0: mapa e historial.** Índice hash para pertenencia/estado; conjunto compacto por regiones para descubierto; revisión incremental en vez de hashear arrays completos; consulta espacial solo de región visible. LOD de mapa con pirámide de tiles/imagen por región y agrupación de iconos a zoom lejano. Recalcular solo tiles sucios, reutilizar al desplazar. Mini-map sigue al jugador localmente; mapa global conserva vista general agregada sin dibujar cada árbol. Evitar texto de tamaño cero.

**P0: persistencia.** Repositorio por partida/region, diario o transacciones para cambios y checkpoints, escrituras fuera del camino de render con recuperación probada. Posición frecuente separada de colecciones grandes. Índice de ediciones por chunk, manteniendo orden de operaciones locales. No cambiar formato real sin fixtures/migración/backup.

**P1: memoria de arte.** Caché LRU coordinada de frames/texturas, presupuesto por plataforma, conservar referencias de actores activos, precalentamiento con presupuesto de trabajo. Medir GPU/RSS además de MEMORY_STATIC.

**P1: coordenadas regionales/origen flotante.** Hacerlo antes de expandir pruebas a recorridos reales muy largos; contratos para física/lazo/NPC/guardado/multijugador futuro.

**P1: datos de mundo.** Separar descriptores del generador versionado y módulos de edificios/terreno/caminos/mapa. Variación estructural con contratos de conectividad y límites entre chunks, no copiar ocho plantillas.

**P2: pruebas continuas.** Viajes largos con paso real y retorno, pruebas de muchas regiones/semillas, interrupciones de guardado y carga, pruebas de caché con genotipos distintos, presupuestos de fotograma y memoria en Android de gama objetivo. Capturar p50/p95/p99, no solo media. Un presupuesto excedido debe aplazar trabajo no visible, no cerrar el mundo al jugador.

## Caso de Ant y marcador

La captura aportada muestra 31 misiones activas, 36 hechas, cuatro cerdos y una franja descubierta extensa. Una imagen no revela los IDs exactos de chunks ni su cantidad; no se ha leído su guardado. Se probó además una huella sintética alargada de 41 filas de chunks, no una copia de su partida. El marcador fijo sigue visible en mini/mapa grande; se añade encuadre general al abrir el mapa (zoom 1 y pan cero) para no heredar un zoom que oculte parte del área. A zoom manual mayor aún puede quedar fuera de vista, lo que es normal al explorar el mapa. No hay centramiento forzado que impida desplazarse.

La captura sintética confirma que hay demasiados símbolos a escala global: el plan LOD/agrupación es necesario aunque el marcador ya no se encoja. La prueba fue escritorio; no se afirma que su teléfono haya ejecutado estos cambios.
