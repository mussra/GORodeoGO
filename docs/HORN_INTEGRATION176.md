# Integración del cuerno sobre los caballos actuales

Ant13nov14:11:28: usar los sprites actuales y aportar solo el cuerno con perspectivas. No se genera arte nuevo. Esta preparación no cambia la APK2.7.125, no activa la transformación y no dibuja un cuerno provisional.

## Imágenes solicitadas

CincoPNG transparentes del MISMO cuerno: frontal, lateral mirando derecha, tres cuartos frontal mirando derecha, tres cuartos trasero mirando derecha y trasero. Izquierdas por espejo. RetratoHD: reutilizar tres cuartos frontal si encaja; si su perspectiva no encaja visualmente, pedir ajuste solo para ese retrato, no deformar a ciegas.

Fuente recomendada512×512por vista, alta resolución para reducir limpiamente. Cuerno entero, eje central, base y punta sin recorte, con margen. Frontal/lateral: altura aproximada350-420px; otras vistas acortadas por perspectiva sin forzar la misma altura aparente. Dimensiones de archivo uniformes no significan longitud aparente uniforme. Sin texto ni cuadrícula. Transparencia real, no tablero dibujado. Base sin peana. Marfil/perla neutral, luz arriba-izquierda; sin aura ni brillo externo horneado. Conservar el diseño/relieve entre vistas. Una plancha se puede separar, pero archivos sueltos evitan mezcla de celdas.

Estas son medidas de entrega, no medidas finales en el juego. La escala final se compara con la frente/cabeza, no con el lienzo del cuerno.

## Inventario y anclaje

El catálogo compartido existente cubre133poses de adulto:45montadas,45sin jinete,40de salto,1golpe y2de beber/reposo. Se añade retratoHD936×983. Movimiento/salto:96×96; beber:112×96. El potro no tiene cuerno porque la transformación exige adulto.

Para cada imagen fuente del cuerno: base, punta, tamaño, vista y revisión aprobada. Para cada pose/frame del caballo: punto de implantación en la frente, dirección/longitud proyectada hasta la punta, vista y máscara de oclusión cuando haga falta. No usar una coordenada fija para todas las fases; la cabeza sube, baja y gira. En beber cambia también su inclinación. En salto sigue la cabeza, no la altura de las patas.

El anclaje de base/punta calcula escala y rotación. La perspectiva viene del arte seleccionado, no de estirar un lateral como falso frontal. Revisar aparte los casos traseros: el cuerno puede quedar parcial o completamente oculto por cabeza/crin/sombrero. No dibujarlo encima del jinete para hacerlo visible a la fuerza.

Los frames se componen antes del espejo y transformaciones del sprite. Cuerno, caballo y vaquero heredan una sola vez el mismo flip, giro, desplazamiento y escala; no aplicar un segundo espejo independiente. Retrato usa su propio anclaje y la misma lógica geométrica.

## Color, capas y conservación

Solo una identidad unicornio explícita puede mostrar cuerno. Un Galaxy maestro o Galaxy puro todavía no es unicornio. Paleta final por ascendencia completa según preparación175, no selector libre ni color del objetoPNG. Mantener sombreado del cuerno recibido; no sustituir su volumen por una mancha plana. Decidir por inspección si el marfil queda neutral o lleva tinte suave de la paleta antes de darlo por final.

Componer como capa independiente, con alfa y oclusión propios. No rehornear ni editar máscaras de Ant, genes, manchas, ojos, crin, equipo, adornos, sombreado o sol/luna. El cuerno no puede teñirse accidentalmente con una máscara de patas/botas. Incluir especie/variante/revisión de cuerno/anclaje en la clave de caché para no compartir una textura de unicornio con un caballo normal.

## Preparación y cierre pendiente

HornRig176 es un contrato sin conexión al renderer: valida aprobación/datos, elige las cinco vistas y calcula la transformación por base/punta. Rechaza configuraciones incompletas. No hay imágenes ni coordenadas de cabeza inventadas dentro del contrato.

Al recibir imágenes: verificar transparencia/perspectivas, marcar base/punta, crear anclajes sobre cada pose real, generar hojas de revisión de133poses y retrato, inspeccionar píxeles a1×y ampliado, corregir oclusión/punta/base, probar giros/animación/espejo, tamaño pequeño y límites de recorte. Repetir en caballo normal para confirmar que no aparece cuerno. Solo después habilitar confirmación del ritual, guardado atómico y representación en todos los sitios. No publicar hasta resolver cualquier pose sin revisar.
