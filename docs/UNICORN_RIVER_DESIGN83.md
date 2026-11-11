# Unicornios y río: estado y propuesta

Actualizado el 11 de noviembre de 2026, 13:25. Todo en rama, preview antes de APK.

## Decisiones de Ant

- Un río por mapa limita el avance hasta conseguir un caballo especial.
- Unicornios de cinco variantes: Galaxy azul, rosa, verde, rojo y negro.
- Atlas: solo silueta hasta conseguir el unicornio. Después, aspecto completo.
- Obtención y variante del unicornio dependen de toda la ascendencia de sus progenitores.
- Corrección 13:24-13:25: LOS CABALLOS GALAXY NORMALES DEBEN SEGUIR OBTENIÉNDOSE. Criarlos y su ascendencia Galaxy ayudarán a llegar a un unicornio. No equivalen a unicornio ni se convierten automáticamente.
- Las nuevas paletas de unicornio son exclusivas de esa especie. El Galaxy azul-morado normal existente sigue aparte.
- Rastro arcoíris pendiente de concretar como pista/misión.

## Estado implementado

Categoría Atlas con cinco siluetas de contorno reutilizado, no arte final. Identidad explícita `species=unicorn` + `unicorn_variant`; no se infiere por `finish=galaxy`. La venta conserva descubrimiento a través del registro ancestral. Falta arte completo de unicornio y regla de obtención. No hay spawn, probabilidad ni desbloqueo de unicornios implementado.

Mercado Galaxy, herencia del acabado, selector Debug, compras, premios y adopciones conservan las reglas existentes. Se revirtieron íntegramente los bloqueos provisionales anteriores a la corrección. Carga antigua legible, sin migración y sin normalizar acabados.

Atlas normal: enumera posibilidades normales y añade los caballos propios Galaxy a color, contándolos como propios. Filtros conservan sus variantes exactas. La nueva categoría de unicornios no los toma como conseguidos.

## Ascendencia real

Se guardan dos IDs de padres por cría y registros completos de propios + antepasados vendidos. No hay límite de generaciones almacenadas. Validación contra IDs ausentes y ciclos. Comprados/salvajes son raíces de ascendencia previa desconocida. Los genes pueden editarse en Debug, así que una regla estable debe versionarse y tomar un snapshot al nacer.

## Propuesta, sin implementar

Recorrer TODOS los antepasados únicos de ambos padres, peso `1/2^distancia`. No multiplicar un mismo registro por aparecer en varias ramas. Puntuación por diversidad, rasgos raros, profundidad conocida y afinidad de antepasados Galaxy. Galaxy en padres pesa más que en un antepasado lejano, pero ninguno se descarta. Tener uno no garantiza ni transforma automáticamente en unicornio.

Variante: afinidad azul/rosa/verde/rojo/negro de pelaje, crin y ojos de toda la genealogía ponderada, con aporte adicional Galaxy al potencial de unicornio. Gana la mayor puntuación; empate por hash estable.

Opción A, recomendada: requisitos mínimos de genealogía + probabilidad pequeña creciente (por ejemplo 1%-5%, números por aprobar). Tirada reproducible por hash de genealogía + contador de nacimiento + versión, guardada al confirmar la cría, nunca al abrir la preview. Reabrir/recargar no ofrece reroll. Mostrar requisitos y probabilidad antes de criar.

Opción B: receta genealógica con resultado determinista 100% al cumplirla. Más transparente, pero permite fabricación repetida. Ant debe escoger la regla y sus límites antes de implementarla.

## Río

Todavía NO insertado en arenas/Frontera: un corte arbitrario puede dejar objetivos, corrales y encargos imposibles. Faltan regla de cruce y distribución de objetivos por orilla. Propuesta: capacidad explícita de cruzar ríos/nadar, separada de saltar vallas; minimapa muestra el río en zonas descubiertas. Cabras no saltan el río por heredar su excepción de vallas. Animales tendrían que respetar/rutear la orilla. Semilla fija una trayectoria por partida, NO un río por chunk. Sin puentes/vados inventados ni regalos de habilidad.

## Seguimiento 13:27: oferta normal y ritual propuesto

Verificado ejecutando los catálogos: la fórmula antigua permite Galaxy desde nivel 16, pero las seis ofertas fijas de cada nivel 16-20 no contienen ninguno. El primero aparece en catálogo 23, fuera de los 20 niveles actuales. Es un hueco previo de diseño, no basta restaurar la fórmula para conseguirlo en partida nueva normal. Propuesta pendiente: garantizar una oferta Galaxy en catálogo 16 o 20 sin alterar las otras cinco. No se fija aún.

Idea de Ant, no decisión cerrada: ir montado en Galaxy maestro, con N generaciones Galaxy (2/3/N), seguir pistas del loco del pueblo hasta una fuente mágica. Código actual no contiene fuente mágica ni loco del pueblo, solo Granjero, encargos cerdos/cabras y flor especial al este. Hay pozo decorativo junto a casa, no función mágica. No inventar que ya está implementado.

Maestro: existen maestrías 0-100 de salto/regate que crecen haciendo misiones con el aprendiz montado. Serenidad es estadística de calma y no certifica misiones. Recomendación pendiente: Galaxy adulto + umbral de maestría configurable (ejemplo 80%) conseguido jugando con él; N configurable. Para “N generaciones consecutivas Galaxy”, decidir todas las ramas frente a una línea dominante. Recomiendo todas las ramas conocidas hasta N para que sea difícil y la ficha explique qué antepasado falta. El cálculo de color seguiría usando toda la ascendencia, no solo esas N generaciones.

Flujo propuesto: loco del pueblo ofrece pistas graduales; el rastro arcoíris confirma hitos en el mundo sin revelar toda la ruta de golpe; la fuente revisa montura maestra y genealogía antes de permitir el ritual. No gastar ni criar automáticamente al tocar el agua. Falta decidir si allí nace cría unicornio de dos padres, evoluciona una montura, o se encuentra uno. No implementar hasta aclarar esa diferencia.
