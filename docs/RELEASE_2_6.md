# Rancho Prueba 2.6 - aprendizaje, afinidad y Atrás seguro

## Mentor y aprendiz
En Caballeriza > Entrenamiento se eligen técnica (salto/regate), mentor adulto que la conozca y otro adulto. Guarda la pareja y monta uno de ellos antes de entrar a una misión. El compañero aparece como tarjeta de apoyo, no como segundo caballo físico ni jugador online. La pareja se fija al comenzar la misión y gana avance solo con victoria; perder, salir o dejar pasar tiempo no suma. Cambiar pareja no borra lo aprendido.

- Aprendizaje: 34 puntos base por victoria hasta100. Afinidad compartida+10 por victoria, tope100, mejora aprovechamiento hasta20%. Base nueva aprende en3 victorias.
- Mentor y aprendiz que ya conocen la técnica ganan dominio individual: cada victoria suma12% de lo que falta hasta100, con el mismo bono de afinidad. Rendimientos decrecientes y límite100. El dominio reduce recuperación de la técnica hasta20%; no cambia arte, arco, duración de animación, velocidad, potencia ni alcance base de la fusta.
- Afinidad pertenece a la pareja, dominio/aprendizaje al individuo. Sin pérdidas por ausencia ni por cambiar compañero. Se guardan por separado en Normal y Debug.
- Nuevos nacimientos empiezan sin salto ni regate aprendido: no se heredan automáticamente. Las habilidades de caballos ya existentes se conservan; en registros anteriores el regate queda como antes, disponible con fusta. No se añade entrenamiento obligatorio para criar. El regate aprendido sigue necesitando fusta equipada.
- Iconos de salto y regate en selección, ficha y menú, con explicación al tocar.

## Atrás
Atrás Android/Escape cierra primero diálogos y capas: entrenamiento/árbol, ficha hacia colección, caballeriza, equipo/ajustes/niveles, y principal. Principal pide confirmación antes de salir. El botón Salir también confirma. En partida Atrás pausa/reanuda; desde pantalla de fin vuelve al menú. No elimina ni reinicia el guardado.

Se detectó la causa anterior: el menú principal recibía Atrás y salía aunque un menú superpuesto estuviera abierto. Ruta única central evita salidas y acciones duplicadas; SceneTree configurado para no salir automáticamente.

84 pruebas focales / 79.285 aserciones pasan. Aprendizaje, herencia futura, conservación existente, límites/rendimientos, afinidad, persistencia y rollback. Recorrido real de menús y confirmación inspeccionados con capturas, más entrenamiento antes/después y tarjeta en misión. No prueba en Android físico de esta versión; avisos auxiliares GUT conocidos, no suite global limpia.

Paquete com.example.rancho.review, versión2.6/code258, misma firma. Actualización sin desinstalar. Guarda todos los datos previos, campos nuevos vacíos/0 por defecto. Rama de pruebas, main intacta, sin tiendas.
