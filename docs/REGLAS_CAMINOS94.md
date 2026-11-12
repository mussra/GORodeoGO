# Reglas de caminos: menor cansancio y salvajes fuera

Cambios sobre la rama de prueba, posteriores al mapa modular 93. Sin APK, sin merge a main y sin migraciones de guardado.

## Resultado de comprobar el código anterior

La resistencia del mundo no consultaba si el jinete estaba sobre camino. En la prueba modular no había ciclo de resistencia. Tampoco había exclusión de caminos para aparición o movimiento de salvajes. Estas dos reglas faltaban, no eran reglas ya funcionando.

## Menor cansancio sobre camino

Se añade un único ajuste compartido `WorldStamina.ROAD_DRAIN_MULT = 0.65`: al trotar o galopar, sobre tierra de camino se consume un 35% menos de energía que sobre hierba. Es un valor inicial reversible de equilibrio, no un porcentaje elegido por Ant. Mantiene un coste, no da energía infinita. Caminar y estar parado conservan exactamente su recuperación anterior. No se activó resistencia en los niveles de corral.

La Frontera habitual consulta la superficie al actualizar resistencia. El mapa modular utiliza el mismo cálculo y límite de marcha, y muestra un porcentaje de energía junto al botón de vuelta. No se guarda ese estado de la prueba.

### Detección

- Frontera: usa los tramos de 24 unidades con los que se dibujan las dos vías principales, 45 unidades de anchura; los accesos usan el mismo recorrido suavizado y 32 unidades. No da el beneficio a toda la vieja banda lógica de 46 unidades a cada lado.
- Modular: consulta el píxel de tierra del sprite real, transformado por la orientación de cada pieza y por el acabado claro/oscuro seleccionado. Una esquina verde de una baldosa curva no cuenta como camino. Se prueban salidas de todas las piezas y curvas interiores/exteriores en ambos acabados.

## Salvajes fuera de caminos

Caballos salvajes, cerdos y cabras comparten una restricción de superficie proporcionada por su mundo. Cubre las manadas generadas, los animales de la zona de prueba, las cabras de muestra y los caballos de la nueva escena modular.

- Al aparecer, si su posición cae sobre camino o demasiado cerca de la orilla, se busca una posición cercana de hierba de forma determinista. Solo se ajusta el nodo activo y su centro de paseo, sin escribir guardados ni modificar el generador/RNG de contenido o los ID de misiones.
- El movimiento de paseo, huida, seguimiento/acercamiento y carga se limita al lado de hierba. Si la trayectoria invade camino, intenta deslizarse por la orilla; si no hay paso, se detiene. Se comprueban puntos intermedios para que un paso largo no salte de una orilla a otra.
- El margen de huellas es de 18 unidades. La regla limita la posición/huellas del animal, no promete que una cola o el dibujo completo de un sprite nunca sobresalga visualmente sobre un borde.
- Cambiar el acabado modular vuelve a comprobar a sus animales por pequeñas diferencias en la anchura pintada.
- No afecta al caballo montado por el jugador ni a los animales de niveles que no tienen proveedor de caminos. El jinete puede entrar y salir de caminos libremente.

Consecuencia: los caminos separan zonas para los salvajes; no cruzan por ellos para alcanzar al jinete. No se ha añadido búsqueda de rutas largas alrededor de la red, así que pueden quedarse al borde. Tampoco se ha creado invulnerabilidad del jugador sobre caminos: un radio de contacto desde una orilla sigue siendo el mismo. No presentar esta regla como inmunidad frente a animales.

No se modificaron los cuerpos/colisiones de los edificios, el comportamiento de soltar el lazo por aturdimiento ni el sistema de guardado.

## Pruebas y revisión

- Suite completa de unidades: 515/515, 59.853 aserciones, 5 avisos. Cuatro pruebas nuevas de superficie, resistencia y pasos sin atravesar caminos.
- Integraciones focales: 12/12, 1.239 aserciones. Incluyen 2 nuevas con 993 aserciones y las 10 anteriores de mapa modular, floristería, descubrimiento, vallas y velocidad/lazo.
- Prueba sobre Frontera real cargada: aparición de los animales cargados fuera de vía; caballo, cerdo y cabra adicionales colocados inicialmente sobre camino se recolocan; huida/carga no entran ni atraviesan camino. El ciclo real de resistencia da el ahorro esperado.
- Prueba modular en ambos acabados: aparición sobre cada una de las 40 celdas se corrige a hierba, se prueba movimiento de las tres clases y paseo de caballo, así como consumo real sobre camino y hierba. Posición/ediciones guardadas intactas.
- Volver de la prueba modular al mundo real sigue pasando la comprobación de restauración sin cambio de posición/ediciones guardadas.
- Dos PNG finales inspeccionados: porcentaje de energía legible, botones sin solapamiento y caballos en hierba en ambas variantes.
- Los tests de escena conservan avisos de recursos/objetos al cerrar. No hay fallos de aserciones. No hay prueba Android ni tacto físico, no se certifica FPS móvil.

Microprueba de coste CPU, no FPS: 1.000 decisiones de movimiento bloqueado junto a camino, media de 0,121 ms por decisión en Frontera, 0,154 ms claro modular y 0,158 ms oscuro modular, en esta máquina de pruebas. El caché de puntos de vías tiene un límite para no crecer sin fin al explorar. No sustituye un perfil con muchas manadas activas en Android. Los perfiles de dibujo publicados con el mapa 93 eran anteriores a estas dos reglas.

## Frase pendiente de elección, NO implementada

Frase de Ant: "En camino te cansas menos". Tres ubicaciones posibles:

1. Consejo de carga al entrar en Frontera: discreto, sin ocupar el mapa, pero se puede pasar por alto.
2. Cartel en el primer cruce junto al rancho, con texto al acercarse o interactuar: enseña la regla donde se puede probar, sin texto flotante permanente. Recomendación.
3. Consejo del maestro al presentar la exploración: más personal, depende de ver ese diálogo.

Ant elige ubicación antes de colocar la frase. No se ha cambiado ningún texto de consejos ni puesto un cartel nuevo.

## Lo que sigue pendiente

Elegir dónde mostrar la frase y revisar si el ahorro inicial de 35% le gusta. Siguen pendientes la elección de acabado, la decisión sobre llevar la disposición modular al mundo habitual y el OK explícito para generar otro APK. El APK 2.7.87 no contiene estos cambios.
