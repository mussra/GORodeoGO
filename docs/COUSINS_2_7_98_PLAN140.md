# Primos del pueblo: integración de prueba 2.7.98

En curso. No incluido en 2.7.97. Originales de Ant conservados sin cambios en art/npc/source/primos140/. Dos derivados transparentes de192x192, dibujo144px, escala0,625:90px visibles. Recorte y reducción nearest-neighbor, sin generar poses ni cambiar el dibujo.

## Alcance

Cuatro primos estáticos e interactuables, una pista distinta por primo, diario persistente de primos/pistas. Repetir la pista no desbloquea artificialmente otro NPC. Preguntar por los primos recomienda uno desconocido a partir del diario, con dirección cardinal calculada desde sus ubicaciones reales. Si ya se conocen todos, lo dice y no inventa un destino.

El mundo publicado tiene dos núcleos reales: rancho y floristería del Camino del Este. Para las cuatro pistas se añadirán dos caseríos con el arte existente, fuera del área anteriormente explorada, sin recolocar esos dos núcleos ni migrar el generador. Posiciones estables en un estado versionado aparte. Los cuatro se conectan al camino principal existente, con acercamiento reservado y verificado. No usar coordenadas en diálogos ni prometer un paso que no se haya validado.

## Pistas

1. Caballos legendarios aún por descubrir en el Atlas; la genética indica que deben existir. Ultra raro frente a Legendario sigue pendiente de decisión; no cambiar categorías del Atlas.
2. Cuidado con los cuernos, ambiguo, sin revelar directamente al unicornio.
3. Cuerno recto y simétrico, único, distinto del de un toro.
4. Rumor de fuente mágica. No dar una dirección falsa hacia una fuente que todavía no existe. Una dirección posterior hacia país/rastro/árbol/río depende de implementarlos y fijar su ubicación. Ningún primo cuenta por sí solo la receta completa.

La llegada norte/sur/este/oeste se infiere al cruzar el entorno del pueblo desde una posición real previa, no de la cámara. Al cargar directamente dentro del pueblo, no inventar una llegada.

Normal: sombrero tapa ojos. Sorpresa: usar la otra ilustración cuando vea una montura identificada de verdad como unicornio, no por acabado galaxy ni por una silueta del Atlas. Permitir prueba aislada con tal montura sin concederla al jugador ni activar la futura transformación.

## Guardado y pruebas pendientes

Estado aditivo, versión1, ligado a la semilla: registro de pueblos, conocidos, pistas y llegada. Atomicidad y vuelta atrás si falla guardar una conversación. V1/V2 conservan mundo sin ampliación si los emplazamientos requieren V3. V3 se amplía sin borrar exploración.

Probar cuatro pistas en distinto orden, repetición, sugerencias solo desconocidas, todas las direcciones según posición, carga sin inventar llegada, fallo de guardado, diario tras recarga, render90px y cambio normal/sorpresa, caminos/collisiones desde origen a cada caserío, NPC fuera de rango, no duplicar al descargar/cargar. Suite unitaria/regresiones; APK misma firma, code357, descarga anónima/SHA. Todo con simulación de escritorio, no Android físico.
