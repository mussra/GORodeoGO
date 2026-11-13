# Preparación del ritual, sin transformación activada

Este bloque es lógica de lectura y pruebas. No hay botón de ritual, mutación de caballo, premio ni cambio de aspecto. No está incluido en la APK2.7.125.

## Requisitos comprobados

El caballo debe estar en la colección, ser la montura seleccionada, adulto, Galaxy puro con prueba guardada al nacer y100%de una campaña completada con él. Debe estar en el país de la fuente, a120píxeles o menos del sitio de la fuente en su orilla transitable, no dentro del agua ni de otro obstáculo. Una identidad que ya sea unicornio no vuelve a completar la receta. La genealogía debe ser válida y completa.

La preparación devuelve motivos de requisitos faltantes. Aunque todos se cumplan, el resultado marca efecto desactivado y representación visual pendiente. No transforma solo datos para aparentar que la cadena está terminada.

## Variante por ascendencia

Ant indicó el11nov que el cálculo depende de toda la ascendencia, no de escoger un color libremente. Se mantiene una propuesta determinista: todos los antepasados únicos de la genealogía, incluidos los vendidos; peso1/2^distancia. Un antepasado repetido cuenta una vez a su distancia más corta. No hay un límite pequeño de generaciones ni recursión que recorte la búsqueda. Ciclos o padres ausentes invalidan el cálculo.

Pelaje, crin y ojos aportan partes iguales de su peso. Cada color se asigna a la paleta más cercana de azul, rosa, verde, rojo o negro. Crin arcoíris y ojos multicolor se muestrean en doce puntos para no contarlos como un rojo fijo. Gana la mayor puntuación; empates en orden estable azul/rosa/verde/rojo/negro. No hay tirada nueva al recargar ni se usan IDs o nombres como azar.

Los colores de referencia, distancia de color, pesos y120píxeles son calibración de implementación. Este bloque todavía no decide el aspecto final ni convierte caballos. No añade probabilidad de fracasar a la receta Galaxy puro+maestría+fuente.

## Carencia antes de activar

Las previews existentes eran paletas sobre caballo y un cuerno provisional del Atlas. No hay arte final de unicornio montado/animado ni retrato integrado en esta copia. Hace falta un diseño aportado/aprobado o permiso para preparar un estudio que integre el cuerno en las poses existentes. Después: inspección de todas las poses, confirmación explícita en fuente, guardado atómico, conservación de identidad/genes/padres/logros, actualizar todos los renderers y repetir pruebas. No lanzar el efecto mientras el caballo resultante siga viéndose como un caballo sin cuerno.
