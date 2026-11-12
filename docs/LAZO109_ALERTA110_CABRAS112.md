# Lazo compartido, alerta/sigilo y cabras V3

Preview sin APK ni cambios de main. Incluye Encargos junto a Menú.

## Vuelo del lazo
Antes: Frontera/modular 0,35 s, niveles 0,80 s (0,60 tras progreso 6). Ahora todos usan `LassoController.FLIGHT_SECONDS = 0.35`. Retirados overrides y multiplicación por mejora. El antiguo multiplicador queda en 1,0 por compatibilidad, sin efecto jugable. No hay fase de retorno animada: desaparece al aterrizar o pasa a sujeción.

Medición estable de release a landing, jinete quieto y distancia 180: Frontera 0,3448-0,3456 s; nivel sin mejora 0,3452-0,3521 s; con progreso 6, 0,3451-0,3452 s. Paso discreto del motor. Se descarta la primera muestra tras cargar. El adelanto heredado de la velocidad del jinete sigue usando el mismo tiempo compartido.

## Parámetros de percepción ajustables
`WorldAwareness110`: velocidad sigilosa <=130 unidades/s; aviso a 190 si vas lento y 320 si vas rápido. Primero se para y mira con ?. Huye tras 0,85 s si estás a menos de 85, o tras 0,45 s si vas rápido. A menos de 40, pausa de 0,20 s. No existe probabilidad de fallo impuesta al lazo.

Árboles y obstáculos de ocultación reducen los radios al 30%. Índice espacial de rectángulos actualmente cargados, comprobación local como máximo cada 0,20 s por animal. Se corrigió el borrado prematuro de los rectángulos: ahora duran hasta descargar su chunk. No hay escaneo del mundo completo.

Al lanzar hacia un objetivo, sus compañeros y animales cercanos a 500 unidades, o del mismo grupo, entran en pánico 6 s. El objetivo apuntado se excluye de ese susto específico durante el vuelo, no de la detección normal. Al capturarlo se avisa otra vez. Se conserva la excepción previa de Líder de manada. Los compañeros pueden rebasar la correa doméstica para salir de pantalla, mantienen ID y bloqueo de montañas. Al huir pueden cruzar caminos, como estaba aprobado.

Balance: 100 lanzamientos por escenario, error de puntería ±20 y velocidades/direcciones controladas. Sigilo 100/100 e intercepción con predicción perfecta 100/100. Sin anticipación, los lanzamientos rápidos dieron 21/100 en la pasada final V3 con terreno fijo y 100 direcciones del jinete. El resultado depende de obstáculos y terreno. No son tasas de jugadores ni una promesa de dificultad. La simulación imprime las cifras exactas y conserva la prueba de que la intercepción rápida sigue siendo posible.

## Cabras
V3 añade grupos de 2-4 con probabilidad 38% por chunk, RNG separado y candidatos fuera de caminos y roca. No hay cupo total: se cargan/descargan con los chunks, incluso en regiones lejanas. V1/V2 mantienen sus prototipos y generador. IDs estables `goat:v3:semilla:cx,cy:individuo`, persistencia individual sin reaparecer tras captura y carga. No se modifica el formato de guardado.

Comparten percepción/ocultación y pánico con caballos. Mantienen la captura existente por lazo/agotamiento, carga al jinete y requisitos de encargos. Hay carrera de cinco vistas, pero no pose propia de reposo o pastar para cabras; cuando están quietas se detiene el fotograma. No se ha inventado arte raster.

## HUD y arte
Encargos queda a la izquierda de Menú con el mismo dorado. El panel se abre bajo ellos y oculta el minimapa mientras está abierto. El hueco anterior queda libre.

`tools/validate_horse_art111.py`: comprueba 45 PNG por conjunto, dimensiones, alpha/silueta, fuga de máscaras al fondo y crea comparativas antiguo/nuevo/máscara/diferencia. Autocomprobación con arte original: 45 encontrados, ningún tamaño incorrecto. No puede certificar anatomía, alineación semántica cuerpo/crin ni UV; exige revisión visual de todas las vistas y recoloreados. No genera arte. Adultos del menú y jinete son conjuntos separados.

## Pruebas y límites
545/545 unitarias en datos de prueba limpios. Integraciones pertinentes ejecutadas por separado para evitar contaminación entre fixtures de guardado: percepción, vuelo/intercepción, manadas/cohesión, cabras/reload, montañas, caminos/huida, notas, flores y cerdos. También 5/5 de herramientas de ensayo, actualizadas para activar explícitamente el modo debug que exige la aplicación.

Capturas 896x414 inspeccionadas: alerta, captura, huida, salida de pantalla, cabras generadas y Encargos. GIF comparativo de estados, no vídeo continuo. Sin Android físico y sin APK. Persisten avisos conocidos de recursos al cerrar QA. El arte de reposo sin jinete sigue pendiente de una imagen de Ant.
