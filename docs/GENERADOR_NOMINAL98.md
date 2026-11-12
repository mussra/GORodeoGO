# Generador nominal para mundos nuevos

Preview de código, sin APK ni main. El APK 2.7.88 publicado antes no incluye estos cambios.

## Aplicado

Un mundo que todavía no tiene semilla recibe ahora `generator_version=2` al crearse, junto a su propia semilla, y guarda esa versión. V2 utiliza las normas de la red modular dentro de Frontera real, con streaming, descubrimiento/minimapa, encargos, personajes, capturas y guardado existentes. No se redirige a la escena de prueba sin progreso.

- Eje oeste-este que continúa entre chunks sin cortar la vía ni formar circuitos.
- Ramales curvos por semilla, puertas finales y edificios fuera de la vía de paso. Los cuerpos y sprites de los edificios se comparten con la vista de diseño, sin duplicar una segunda implementación de esas casas.
- Casas, rancho y floristería en el núcleo inicial modular; granjero y punto de tablón adaptados a esa distribución. El regreso a casa utiliza el hogar de V2.
- Césped claro por defecto y piezas completas. La alternativa oscura se conserva en la vista de diseño; no hay noche automática.
- Detección de tierra según piezas/rotación y 35% menos consumo de energía en caminos. Spawn y paseo de salvajes los evitan; huida puede cruzarlos.
- Los obstáculos generados ceden a los caminos y zonas de edificios. Las ediciones manuales del jugador no se borran silenciosamente.
- Mini/mapa dibuja la misma red de V2 y filtra decoración no construida. La vía continúa hacia regiones con manadas, cerdos y misiones de Frontera. No se crean pueblos nuevos ni una escala km aún no decidida.

La red V2 extiende horizontalmente el eje del diseño aprobado; los ramales/edificios nuevos son los del núcleo inicial. No genera pueblos repetidos a kilómetros ni biomas nuevos. Tampoco pretende reproducir todos los adornos/vallas/estanque del rancho antiguo en la distribución nueva.

## Partida anterior intacta

Todo guardado que ya tiene semilla y no trae campo de versión se interpreta como V1. Carga su distribución, edificios, caminos, coordenadas y progreso anteriores. `ensure_world_seed` no regenera una semilla existente ni cambia su versión. Los chunks nuevos que explore esa partida también mantienen V1: no se mezclan dos generadores dentro del mismo mundo.

El campo nuevo es aditivo en el formato actual. Cargar un archivo legado y comprobar su semilla no lo reescribe; hay prueba de bytes idénticos. Guardar normalmente en el futuro puede añadir el campo V1, pero no migra el mapa. Versiones desconocidas no se aceptan para escribir como si fueran válidas.

No se ha accedido al guardado de Android de Ant ni se ha ejecutado una migración. Las pruebas usan archivos y directorios temporales aislados.

No abrir un guardado V2 con una app antigua que ignore el campo: esa app no conoce este generador y no se puede prometer compatibilidad hacia atrás. Se conserva el mundo legado para las partidas antiguas, no se hace que un binario viejo entienda V2.

## Botón de menú

"Mapa modular nuevo" pasa a **"Vista de diseño"**, con "Sandbox, no crea ni sustituye partidas". Sigue abriendo la comparación aislada y vuelve al mismo mundo anterior.

No lo llamé "Partida nueva" ni lo hice reiniciar la partida activa: todavía no existe el sistema de slots y hacerlo así mezclaría o borraría progreso. Cuando se implemente el selector de partidas, la acción Crear partida tendrá semilla propia y utilizará V2 por defecto. La vista de diseño podrá quedar en herramientas o retirarse por decisión de Ant.

Por ahora, una instalación/partida cuyo mundo aún no existe adopta V2 al crearlo. Una partida existente conserva V1. No hay un nuevo botón destructivo para forzar V2 sobre la partida actual.

## Verificación

- Suite completa: 521/521 unitarias, 132.697 aserciones en la última ejecución completa.
- Focal nueva: creación V2, conservación V1, ida/vuelta de versión, misiones/capturas/posición guardadas, archivo legado sin reescritura y versión desconocida rechazada para guardar.
- Continuidad de piezas y superficie en 13 columnas de chunks; árboles regionales sin ciclos y enlaces recíprocos en 32 semillas, con edificios alcanzables. Las normas previas siguen probadas en 256 semillas.
- 15/15 integraciones focales, 376.159 aserciones: nominal V1/V2, cuerpos y destinos, mapa modular, resistencia/superficie, huida, floristería legada, descubrimiento, vallas y velocidad/lazo.
- La escena nominal real V2 carga, muestra su minimapa y permite aceptar el encargo del granjero en la integración. No equivale a una campaña completa de juego extremo a extremo.
- Retorno de la vista de diseño sigue pasando la comprobación de mundo y datos guardados intactos.
- Capturas de Frontera nominal, mapa ampliado y menú revisadas. Se detectó y corrigió en revisión un problema de vida útil de texturas dinámicas: ahora el nodo retiene las texturas de caminos en caché, sin franjas blancas.
- Persisten avisos conocidos de objetos/recursos al cerrar pruebas. Sin fallos de aserciones. Sin instalación/ejecución Android ni medida de FPS móvil.

## Pendiente

Partidas ilimitadas/selector/migración a Partida 1 siguen como plan de diseño, no implementados por este cambio. También pendientes pueblos, escala/tiempos finales, descubrimiento de marcadores, ubicación de frase y futuro ciclo nocturno. Otro APK requiere OK explícito; el OK anterior se agotó con 2.7.88.
