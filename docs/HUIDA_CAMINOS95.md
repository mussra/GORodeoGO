# Decisiones y ajuste de caminos, 12 noviembre

## Decisiones de Ant

- Conservar los dos acabados. Claro por defecto; oscuro disponible para una decisión futura sobre noche u otra zona. No se ha creado un ciclo nocturno ni una zona nueva.
- Aprobado el ahorro de resistencia del 35% sobre caminos. Se conserva.
- Los salvajes evitan los caminos, pero pueden atravesarlos cuando huyen.

## Implementación

Los puntos de aparición siguen en hierba, como el paseo, acercamiento al jinete y carga de cabras. La huida puede entrar y atravesar los caminos en Frontera y en ambas variantes del mapa modular. Las manadas de caballos pueden cruzar durante la huida de grupo, incluso sin pánico; eso no convierte el acercamiento tranquilo por afinidad en una huida.

Si termina una huida sobre la vía, el movimiento ordinario vuelve hacia la orilla más cercana, sin teletransporte. Cerdos y cabras salen andando a hierba cuando deja de ejecutarse su huida. Se conserva el comportamiento del lazo, los contactos/aturdimiento y los límites de distancia del hogar. No se han tocado guardados ni colisiones del mundo.

El acabado claro ya era el predeterminado y sigue siéndolo. La alternativa oscura continúa disponible mediante el botón de la escena de prueba. No se ha activado automáticamente según la hora.

## Pruebas

- 515/515 unitarias en la ejecución completa de esta revisión (el número de aserciones varía según el caché de pruebas de arte; ejecución previa a publicar: 59.621).
- Integraciones de reglas anteriores adaptadas: 2/2, 993 aserciones. Aparición y movimiento ordinario se mantienen fuera de caminos; resistencia sin cambios.
- Nueva integración: Frontera real, modular claro y modular oscuro; huida de caballo, cerdo y cabra entra en vía y llega a la otra orilla; acercamiento/carga no cruza; huida de manada sin pánico cruza; vuelta a hierba tras terminar la huida. 1/1 prueba, 489 aserciones.
- Avisos conocidos de recursos/objetos al salir de las escenas de prueba, sin fallos de aserciones en las pruebas aprobadas.
- No hay APK nuevo, prueba física Android, cambio a main ni migración del mapa modular.

Sigue pendiente elegir la ubicación de "En camino te cansas menos" y decidir la migración del mapa modular. No se ha colocado la frase.
