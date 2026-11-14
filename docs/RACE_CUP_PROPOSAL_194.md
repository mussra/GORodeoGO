> Nota histórica: este documento refleja el checkpoint local 194. El ciclo 195 lo amplía y activa premios; consultar RELEASE_2_7_140.md y CUP_DECISIONS_195.md para el estado publicado.

# Siguiente ciclo: copa de carreras y vínculo con la historia

Estado: copa optativa implementada LOCALMENTE, sin publicar. Se entra desde el selector de carreras y registra resultados reales en un archivo separado del guardado anterior. Las recompensas siguen siendo propuestas, no están implementadas. No incluida en el APK 2.7.139 publicado.

## Objetivo
Que el jugador vuelva por variedad y mejora durante dos o tres días y termine obteniendo un caballo singular y un objeto elemental que continúen la historia de los unicornios. No se puede afirmar esa duración a partir de pruebas automáticas: requiere sesiones humanas y medir intentos, abandono y tiempo activo.

## Estructura propuesta
Una copa de cuatro capítulos y 16 desafíos, sin esperar obligatoriamente al siguiente día:
1. Aprender: terminar cada uno de los cuatro circuitos.
2. Competir: conseguir podio en cada circuito.
3. Dominar: podio con un lazo acertado, podio usando regate, ganar un duelo y conseguir un podio sin recibir lazos.
4. Final: ganar en los cuatro circuitos.

Cada partida acredita como máximo el objetivo actual, no todos los objetivos futuros a la vez. Los objetivos se muestran antes de jugar. No se pierden pasos por perder una carrera. La cuota de 16 es una hipótesis inicial para probar, no una promesa de tres días ni una razón para introducir repeticiones vacías. Es posible que un jugador hábil lo termine en una sesión. Si ocurre, se necesita más variedad real, no bloquearle con un reloj.

Sin inscripción ni importes nuevos en esta primera copa. La economía y los premios proporcionales pedidos para una fase posterior permanecen separados.

## Recompensas propuestas, NO implementadas
- Caballo singular al terminar la copa, concedido una sola vez. No debe llamarse Galaxy ni contar automáticamente como Galaxy puro: esa ruta ya existe y tiene sus propias llaves y requisitos.
- Su cualidad distintiva y cómo la heredan las crías necesitan definición antes de escribir genética. Un acabado cosmético existente no equivale a un gen heredable; no se simula esa promesa con un simple nombre.
- Objeto elemental único al terminar una etapa narrativa/final. Nombre, aspecto, inventario y uso aún propuestos. Primero tiene que existir un objetivo real de historia al que entregarlo o aplicarlo.
- El ritual actual de unicornio está en preparación: `UnicornRitual175.prepare()` informa `effect_enabled=false` y `visual_ready=false`. Ningún diálogo debe prometer una transformación que no está activa ni saltarse sus requisitos.

La transacción futura debe guardar conjuntamente victoria, derecho al premio y concesión, con identificador único. Reiniciar o pulsar de nuevo nunca debe duplicar un caballo u objeto. Una concesión fallida debe poder reintentarse sin borrar la victoria. No se implementa todavía esa transacción.

## Base técnica preparada y probada
`RaceCup194` valida y acredita resultados terminados, ordena los objetivos y rechaza resultados repetidos o antiguos. Exige 16 puertas y posiciones válidas; el duelo solo cuenta si terminó a dos victorias. No concede recompensas ni toca la colección.

`RaceCupStore194` es un adaptador de guardado separado, llamado solo al entrar expresamente en la copa. Lee sin crear archivos, verifica el temporal antes de renombrar, no reemplaza datos corruptos ni de una versión desconocida y rechaza escrituras antiguas o contradictorias. `RaceCupSession194` conecta resultados de copa, sin cambiar SaveData. Normal y Debug tienen archivos separados; una sesión temporal no puede usar la copa guardada. Cambiar de modo antes del resultado impide escribir en el otro archivo.

Pruebas del núcleo: orden de objetivos, máximo un paso por partida, replay, resultados inválidos, recorrido completo de la tabla con datos de prueba, ida/vuelta del estado, fallos de guardado, versiones futuras, datos corruptos y aislamiento del progreso actual. El lote específico final pasa 19/19 pruebas y 112 aserciones. La regresión conjunta de carreras, duelo, mundo, menú, guardado y regate pasa 144/144, con 3.245 aserciones. Esto prueba lógica, integración y almacenamiento, no una campaña humana completa ni una duración de tres días.

## Conectado y siguiente ciclo
- Conectada telemetría real: impactos del lazo, lazos recibidos y regates iniciados. Un simple apuntado no acredita un acierto. El regate directo también emite ahora el evento compartido de inicio, como el trazado táctil.
- Pantalla de objetivo antes de jugar y vuelta a la copa tras el resultado. Las carreras libres no crean registros de copa. Un duelo solo acredita al terminar el encuentro, no por una sola manga.
- Guardado aislado y comprobaciones de replay, error de disco, corrupción y cambio de modo. No se han probado todavía cierres reales de Android en mitad de una escritura.
- Inspeccionadas imágenes de objetivo inicial, resultado con vuelta a la copa, siguiente objetivo y copa completa. Los estados del final se prepararon como fixtures de revisión visual, no representan una campaña humana completada.

Pendiente: diseñar caballo/objeto, herencia y vínculo narrativo, registrar esas decisiones y después activar concesión idempotente. Jugar sesiones humanas en Android y afinar variedad/dificultad antes de afirmar que está listo para producción.

Se mantienen las restricciones: sin `main`, sin web ni tienda, sin gastos y sin economía concreta nueva. El código nuevo queda en un commit local, sin APK nuevo ni push. La versión descargable continúa siendo 2.7.139, anterior a la copa.
