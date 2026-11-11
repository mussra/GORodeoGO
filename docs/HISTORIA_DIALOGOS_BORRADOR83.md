# Un rancho, muchos caminos

Borrador para revisar. 11 de noviembre de 2026.
No implementado en el juego. Sin APK nueva.

## La historia

Llegas a un rancho junto a una tierra llena de caminos.
Tu caballo y tú podéis superar retos en los corrales o salir a explorar.
El rancho es vuestro punto de partida: allí podéis preparar la siguiente salida y conocer a quienes necesitan ayuda.
Entre misiones, encuentros y nuevos caballos, iréis formando vuestra propia cuadra.
En los caminos conoceréis a la florista. Sus encargos os invitan a buscar flores y regresar a su tienda.
No hay un único camino: podéis alternar las dos aventuras.

## Quién lo cuenta

El vaquero del juego es el narrador. Cercano, tranquilo y con ganas de salir de aventura. Habla con frases cortas. Acompaña sin dar una charla ni regañar.

Su identidad visual se conserva: el ala del sombrero tapa siempre sus ojos. Ni un gesto ni un asentimiento los descubre. En la prueba se mueve la ilustración existente entera; no se ha dibujado ninguna cara ni boca nueva.

El granjero existente conserva sus propios encargos. La florista, creada por Ant, pide ayuda para encontrar flores y tiene una floristería rodeada de flores, también en la entrada. Su diseño y sus diálogos se desarrollan en FLORISTA_BORRADOR83.md. Más personajes se podrán proponer después. No se añaden aquí la fuente mágica, el loco del pueblo ni una historia de adquisición de unicornios.

## Guion y disparadores propuestos

Una frase por tarjeta siempre que sea posible. "Siguiente" y "Ahora no" disponibles. Sin avance automático. Las etiquetas de abajo no se leen en voz alta.

### 01. Bienvenida

**Cuándo:** primera entrada al menú, después de la presentación de marca.

**Vaquero:**

> Bienvenido al rancho. Tu caballo y tú tenéis mucho por descubrir.
>
> Tenemos dos caminos: superar misiones y explorar la Frontera.
>
> Puedes cambiar de uno a otro cuando quieras.

**Elegir:** Ver los dos modos / Ahora no.

### 02. Dos caminos, una aventura

**Cuándo:** al elegir "Ver los dos modos", o desde la futura ayuda.

**Vaquero:**

> En las misiones hay retos por niveles. Cada uno tiene un objetivo.
>
> En Frontera eliges adónde ir. Puedes explorar y encontrar encargos.
>
> Los dos modos comparten tus caballos y tus puntos.
>
> Puedes llevar el mismo caballo de un modo al otro.

**Elegir:** Ir a las misiones / Explorar Frontera / Decidir luego.

Los botones deben usar los mismos nombres que el menú real. Si el acceso de niveles tiene otro nombre, ajustar ambos antes de implementar el tutorial.

### 03. El primer reto

**Cuándo:** primera entrada a un nivel, tras la carga y antes de habilitar el movimiento.

**Vaquero:**

> Mira el objetivo de esta misión. Te dice qué tienes que hacer.
>
> Ve paso a paso. No hace falta hacerlo perfecto a la primera.

**Seguir:** Vamos.

No repetir en cada nivel. Mantener visible el objetivo.

### 04. Lo que consigues viaja contigo

**Cuándo:** primera victoria de campaña, después del resultado.

**Vaquero:**

> Un reto superado. Tus puntos sirven también fuera de las misiones.
>
> En la caballeriza puedes ver tus caballos y visitar el mercado.
>
> Después puedes volver a los corrales o salir a explorar.

**Seguir:** Continuar.

### 05. La primera salida a Frontera

**Cuándo:** primera llegada al rancho en Frontera, con la carga terminada y el jugador parado.

**Vaquero:**

> Esta es la Frontera. Aquí eliges tu camino.
>
> El tablón del rancho tiene encargos. También puedes descubrirlos al explorar.
>
> El granjero necesita ayuda. Puedes acercarte a hablar con él.
>
> Toca Encargos para recordar lo que tienes pendiente.

**Elegir:** Ver el rancho / Salir a explorar.

Estos botones cierran la explicación. No aceptan trabajos automáticamente ni mueven al jugador.

### 06. Una manada en el camino

**Cuándo:** primera misión de manada descubierta. Esperar a que termine cualquier persecución o acción para mostrar la ayuda.

**Vaquero:**

> Has encontrado una manada. Explorar también trae nuevas misiones.
>
> Si logras domar un caballo, se unirá a tu cuadra.

**Seguir:** Entendido.

No prometer que basta con ver la manada ni que se obtienen todos sus caballos.

### 07. Comprar y vender

**Cuándo:** primera visita al Mercado desde la caballeriza.

**Vaquero:**

> Aquí puedes comprar caballos con puntos del juego.
>
> También puedes vender algunos caballos de tu cuadra desde su ficha.
>
> Las ofertas dependen del nivel más alto que hayas superado en las misiones.
>
> Para encontrar nuevas ofertas, sigue avanzando en esos niveles.

**Seguir:** Ver caballos.

**Ayuda opcional: "Sobre vender"**

> Tu primer caballo se queda contigo. No se puede vender.
>
> Tampoco puedes vender la montura que llevas puesta ni un potro.
>
> Antes de vender, verás cuántos puntos recibirás y podrás cancelar.

### 08. Has avanzado, mira el mercado

**Cuándo:** una victoria aumenta por primera vez el nivel máximo superado. Nunca por repetir un nivel ni por completar un encargo de Frontera.

**Vaquero:**

> Ahora has superado el nivel {nivel}. El mercado tiene nuevas ofertas.
>
> Las compras que ya hiciste siguen siendo tuyas.

**Elegir:** Ver mercado / Seguir jugando.

Combinar con el diálogo 04 si coinciden, para no encadenar ventanas.

### 09. ¿Qué nivel cuenta?

**Cuándo:** ayuda opcional del Mercado. No es una ventana obligatoria.

**Vaquero:**

> Cuenta tu nivel más alto superado en las misiones.
>
> La maestría pertenece a cada caballo. Es otra cosa.
>
> Explorar no sube ese nivel, pero puedes encontrar caballos y encargos.

**Seguir:** Entendido.

## Mercados de varios niveles: intención y estado actual

La petición de mercados de distintos niveles se conserva como dirección de diseño. La versión actual tiene un único Mercado con seis ofertas que dependen del nivel máximo superado. No tiene varios destinos de mercado visitables.

Si se crean esos destinos, sustituir la explicación del diálogo 07 por:

> Hay mercados de distintos niveles.
>
> El nivel más alto que hayas superado marca a cuáles puedes ir.
>
> Para visitar mercados de nivel más alto, supera nuevas misiones.

No se han inventado pueblos, umbrales, entradas de pago o puertas bloqueadas. Esa versión solo debe mostrarse cuando los destinos existan.

## La prueba de vídeo

Animática corta con la ilustración ya existente del vaquero montado, balanceo y voz narradora provisional. Cuatro bocadillos: bienvenida, modos, progreso compartido y mercado. No hay sincronía de labios ni gestos de manos nuevos.

El sombrero y la cara se transforman juntos: los ojos nunca quedan al descubierto. El arte fuente no se ha editado.

Para una actuación más expresiva, el siguiente paso sería que Ant crease una lámina del mismo vaquero con cuerpo separado, cabeza con sombrero solidarios y dos o tres gestos de brazos. Los ojos seguirían ocultos en todos ellos. Es una opción, no un trabajo ya encargado ni necesario para probar el guion.

## Criterios para una implementación posterior

- Texto grande, frases breves y tiempo libre para leer.
- Voz de apoyo para quien todavía lee despacio. Texto y voz dicen lo mismo.
- Saltar y volver a consultar desde Ayuda.
- Guardar cada introducción vista por partida. No gastarla desde el modo ensayo.
- No interrumpir una captura, un lazo, un salto o una persecución.
- Leer o cerrar un diálogo no acepta encargos, compra caballos ni cambia recompensas.
- Mostrar al narrador no añade un personaje físico nuevo al mapa.

## Reglas verificadas para este borrador

Compraventa y ofertas por nivel en `horse_market.gd`; puntos, colección y progreso en `save_data.gd`; tablón y descubrimientos en `world_missions.gd`; granjero y encargos en `npc_quests.gd`; etiquetas en `main_menu.gd` e `i18n/ui.csv`.
