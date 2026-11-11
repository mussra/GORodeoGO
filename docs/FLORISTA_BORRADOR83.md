# La florista y los caminos de flores

Diseño y guion para revisar. 11 de noviembre de 2026.
No implementado. Sin APK nueva ni cambios del mapa.

## Lo que ha decidido Ant

- Personaje: florista. Usa la imagen que ha enviado Ant.
- Pide misiones de encontrar flores.
- En el mapa tendrá una floristería.
- Habrá muchas flores alrededor y en la entrada.

La imagen se conserva sin retocar en `design_assets/florista-ant-20261111.png`. Los ojos quedan ocultos por el sombrero, también cuando saluda sujetando el ala. No inventar ojos, cambiar la cara ni añadir gestos que los descubran.

## Papel en la historia

El vaquero sigue siendo quien presenta la aventura. El granjero conserva sus encargos de animales. La florista abre otra forma de explorar: observar el paisaje, encontrar flores y volver a un lugar conocido.

Nombre propio pendiente. En el guion aparece como "Florista". No se le asignan parentescos ni poderes mágicos.

## Su lugar en el mapa

Requisito confirmado: floristería con flores abundantes alrededor y a la entrada.

Propuesta de colocación, todavía no aplicada: cerca del rancho, en un desvío corto que pueda encontrarse en la primera exploración. Mantener libres la puerta, el camino y el espacio para acercarse a hablar. No desplazar la casa, el granero, el estanque ni al granjero.

- Dos grupos de flores enmarcan la entrada; la puerta sigue visible.
- Macetas y grupos de flores recorren los laterales de la tienda.
- Un espacio despejado permite parar el caballo y hablar con ella.
- La florista espera junto a la entrada, no en medio del paso.
- Las flores de la tienda son decoración. Las flores de un encargo se identifican por separado para no recoger sin querer el escaparate.

No se ha elegido una coordenada definitiva ni se han cambiado colisiones.

## Diálogos propuestos

Una frase por tarjeta. Sin avance automático. Todos los objetivos, cantidades y recorridos siguientes son propuestas, no reglas ya aprobadas.

### 10. Presentar a la florista

**Disparador:** primera aproximación a la tienda, sin interrumpir una acción. Aviso opcional del vaquero.

**Vaquero:**

> Mira cuántas flores. Esta es la floristería.
>
> Su dueña busca flores para sus ramos. Podemos preguntarle si necesita ayuda.

**Acción:** mostrar "Hablar con la florista" al estar cerca. No aceptar un encargo automáticamente.

### 11. Primer encuentro

**Disparador:** primera conversación elegida por el jugador.

**Florista:**

> Hola. Bienvenido a mi floristería.
>
> Con estas flores preparo ramos para la gente del lugar.
>
> A veces necesito buscar flores por los caminos. ¿Quieres ayudarme?

**Elegir:** Ver encargo / Otro día.

### 12. Primer encargo: una flor cerca

**Disparador:** elegir "Ver encargo" sin otro encargo suyo activo.

**Florista:**

> Busco una flor amarilla para un ramo.
>
> Hay una junto al camino, cerca de aquí.
>
> Cuando la encuentres, tráemela. Te esperaré en la tienda.

**Elegir:** Aceptar / Ahora no.

**Objetivo propuesto:** encontrar una flor amarilla cercana y regresar a hablar. Para empezar, una sola flor y una pista visual clara. El girasol existente puede servir para esta prueba; color y silueta, no solo el color, distinguen el objetivo.

**Si aún no la tiene:**

> Sigue el camino y fíjate en la flor amarilla.
>
> No hace falta ir muy lejos.

**Al encontrarla, ayuda del vaquero:**

> Esta es la flor que buscábamos. Volvamos a la floristería.

**Al regresar con ella:**

> Es justo la que necesitaba. Gracias por traerla.
>
> Ya puedo terminar el ramo.

Sin premio numérico prometido. Si se decide una recompensa, mostrarla antes de aceptar.

### 13. Un ramo de varios colores

**Disparador propuesto:** primer encargo entregado y nueva conversación.

**Florista:**

> Hoy quiero preparar un ramo de varios colores.
>
> Busquemos una flor amarilla y una morada.
>
> Mira bien su forma. Te enseñaré cuáles necesito.

**Elegir:** Ver las flores / Otro día.

Mostrar dos imágenes de referencia con sus nombres antes de aceptar. Cantidades propuestas: una de cada tipo. No convertirlo en una lista larga para los más pequeños.

### 14. Volver a visitar la tienda

**Disparador:** hablar sin encargo nuevo o después de una entrega.

**Florista:**

> Qué bien verte de nuevo.
>
> Puedes seguir explorando. Cuando tenga otro encargo, te lo contaré.

No prometer rotación diaria, espera real ni misiones infinitas sin decidir esas reglas.

## Qué arte ya tenemos y qué falta

### Disponible

- Imagen de la florista enviada por Ant: sirve para un retrato de diálogo y como figura estática provisional, reducida. No tiene vistas de espalda, marcha ni piezas separadas.
- Seis PNG de flores en `art/world/cartoon/flower_1.png` a `flower_6.png`, ya usados por la decoración. Se pueden reutilizar para llenar el entorno y para una prueba de búsqueda, sin generar flores nuevas.
- Casa y granero existentes. Una casa podría indicar temporalmente la huella de un edificio en una maqueta, pero no es una floristería terminada. No se presenta como tal.

### Pieza principal que falta para el mapa final

**Edificio de floristería:** PNG con transparencia, vista de tres cuartos compatible con las casas del mapa actual, puerta mirando al camino, base completa visible, espacio despejado delante y sin personaje incrustado. Puede incluir escaparate y un cartel con motivo floral; mejor sin letras pequeñas. No incluir un suelo rectangular de fondo.

Enviar a Ant una referencia de las casas existentes junto a la florista para conservar escala visual, perspectiva y estilo. La ilustración de la florista es más detallada que las flores y casas actuales: decidir juntos si se conserva esa mezcla o se prepara una versión simplificada para mapa. No retocar su imagen sin aprobación.

### Opcionales, no bloquean una maqueta

- Dos o tres grupos de flores en maceta o cubo para la entrada, con transparencia y separados del edificio. Las seis flores actuales permiten empezar; no hace falta pedirlas otra vez.
- Flor objetivo especial, solo si se quiere una variedad que no existe. Una imagen por variedad, reconocible al tamaño del mapa, con tallo y silueta distintos.
- Figura de la florista preparada para mapa si la reducción del retrato pierde demasiado detalle. Misma ropa, sombrero, ramo e identidad; ojos siempre tapados. Una pose quieta basta para una primera versión.

No hacen falta interiores, animación de caminar ni labios para esta propuesta.

## Reglas de implementación pendientes

- Reutilizar el sistema común de personajes y encargos; no crear otro flujo de misiones paralelo.
- Añadir una fase de entrega: la búsqueda termina al volver a hablar, no al tocar la flor. Esta fase todavía no existe para la misión de flor actual.
- No cambiar silenciosamente la misión existente "Una flor al este". Hoy se activa al cruzar más de 15 bloques al este y se completa al recoger su flor. La florista puede tener encargos nuevos sin romper esa partida guardada. Vincular aquella misión a ella requiere una decisión y migración aparte.
- No subir el nivel de campaña por entregar flores. Mercado y maestría conservan sus reglas.
- No fijar recompensas, ubicación final o cantidades como aprobadas. Las propuestas se revisan antes de implementarlas.
- No confundir las flores ornamentales de la tienda con objetos recogibles de misión.
