# Interiores: siguiente etapa después de 2.7.189

## Estado real

Juanito ya tiene taller ilustrado y puerta funcional. La floristería es el segundo interior en desarrollo: existe la base compartida, el personaje original de Ant, tres interacciones de inspección/pregunta, conversación modal y salida. Sigue siendo una maqueta independiente (`tools/qa_building262.tscn`), sin conexión a la puerta del mundo ni incluida en una APK nueva. No se ha cambiado ningún vecino exterior todavía.

No hay fondo interior de floristería entre los assets actuales. La maqueta lo indica expresamente. No se dibujó un interior nuevo por código. No se simulan cobros, compras ni regalos completados.

## Orden corto

1. **Floristería:** fondo de Ant; mover a la florista al interior, conservando sus encargos, presentación de otros pueblos y regreso a la misma puerta. Objetos iniciales: flores de muestra, lazos y catálogo. Examinar no da propiedad. La muestra se queda en su sitio.
2. **Casa del granjero / establo:** granjero dentro; conservar venta y entrega de animales. Objetos: libro de ganado, saco de alimento y herramientas. Compra explícita de alimento y regalos ofrecidos después de ayudar, con efecto y guardado antes de confirmar.
3. **Casa del Loco:** personaje y conversaciones dentro. Objetos: diario/mapa familiar y recuerdo de viaje. El diario se consulta; un recuerdo solo se entrega cuando el personaje lo ofrece.
4. **Talleres y edificios de otros pueblos:** reutilizar el contrato de interiores por oficio, pero mantener identidades, tareas y estado propios de cada pueblo. Después, inventariar edificios decorativos antes de prometer que todos tienen tienda/personaje.

## Contrato compartido

- Puerta cercana y botón Entrar. El vecino no se duplica fuera/dentro.
- Congelar movimiento y lazo del jugador; volver al punto exterior seguro que corresponde a esa puerta.
- Cerrar diálogo antes que habitación con Atrás; no dejar pulsaciones pasar al mundo.
- Interacciones separadas: **Examinar**, **Preguntar/Pedir permiso**, **Recibir regalo**, **Comprar por X puntos**.
- Nunca recoger objetos de un mostrador al pasar o tocarlos. No hay botín de pertenencias privadas.
- Una compra muestra precio y efecto; un regalo tiene un ofrecimiento del dueño. Comprobar capacidad/saldo y guardar de forma atómica; si falla el guardado, no descontar ni entregar y comunicarlo.
- Los regalos únicos necesitan identificador de edificio/objeto en el guardado; no una variable de la escena. Aún no hay regalos/compras nuevos en esta maqueta.

## Arte

Se reutilizan `art/npc/florist.png`, `art/npc/farmer.png`, los personajes existentes del Loco y `art/breeding256/juanito.png`. No hacen falta retratos nuevos para empezar. Los prompts separados de esta carpeta generan una imagen cada uno y no llevan personajes ni texto, para conservar interacción y legibilidad. La floristería es el único fondo necesario ahora; los demás son la cola de trabajo.

## Próximo paso comprobable

Con el fondo de floristería: revisar perspectiva y espacio útil, integrar imagen, conectar la puerta y el diálogo existente sin recursión entre servicio/interior, retirar la florista exterior y probar encargos antiguos/nuevos, salida, carga de partida y controles. Después entregar APK de prueba. Hasta entonces, 2.7.189 sigue siendo la APK vigente.
