# Rancho Prueba 2.7.156

## Primera identidad de pueblos
Los cuatro pueblos actuales reciben una identidad guardada: nombre, color y patrón. Primera tanda: liso, estrellas y jirafa. No se crean nuevos pueblos ni se cambian sus posiciones, semilla, edificios, accesos o colisiones. Los nombres salen de la paleta existente de caballos y del patrón, con sufijos estables si se repiten. Se guardan los colores y el nombre, no solo una fórmula que pueda cambiar en una actualización.

La franja gris de triángulos pasa a ser muro coloreado con borde claro, juntas y remates. Su forma sigue siendo la separación vertical existente, no un recinto cerrado nuevo. La identidad corresponde al pueblo más cercano a su paso. El hueco del portón sigue teniendo 160 unidades y conserva el camino que lo cruza: la carretera continúa hacia los otros pueblos y mantiene sus bifurcaciones. No se añaden barreras nuevas.

Se reutilizan la paleta, la forma de estrella y el mapa de manchas de jirafa de los caballos. El acabado de muro es separado para no aplicar máscaras del cuerpo de un caballo a edificios. Las estrellas se alinean dentro del ancho del muro y tienen contraste alto. La miniatura usa una estrella grande por tramo en lugar de reducir decenas de estrellas a puntos. La jirafa usa el mismo mapa de formas con escala simplificada en la miniatura.

## Indicaciones, icono y pin
Al preguntar a un primo por los otros pueblos, la indicación usa su nombre automático y dirección real. Se guarda un pin, sin revelar terreno. El diálogo muestra la miniatura y el nombre. La florista también usa el nombre del pueblo de su compañera y aceptar su encargo guarda el pin junto al encargo, en una misma escritura.

El minimapa muestra el objetivo; si queda fuera, una flecha indica su dirección. En el mapa ampliado se puede tocar el icono para ver su nombre y centrar el destino. El icono es un esquema de la separación y camino pasante actuales con color y patrón; no es una fotografía ni promete las formas cerradas del mockup. No se dibuja una ruta nueva ni se revela el terreno entre origen y destino.

Pista, visita y siesta están separados: oír la pista no marca el pueblo como visitado. Solo tras visitarlo se habilita la siesta; entonces desaparece el pin activo, pero el pueblo conserva su icono. La siesta sigue avanzando media ruta conocida y conserva el descanso entre usos. El rancho sigue disponible como origen inicial. No se cambia esta mecánica.

## Compatibilidad y alcance
La carga añade las identidades y los marcadores a las partidas V3 sin mover puertas ni borrar primos conocidos o dirección de llegada. Los generadores V1/V2 no reciben pueblos nuevos. Fallar al guardar una pista no deja un pin fantasma ni cambia la posición guardada del jugador. Main intacta, misma rama de pruebas.

Incluye los cambios de 2.7.155: escala coherente de NPC, Lucía mirando al cultivo al regar y huerto separado con su camino. No incluye nuevas formas de muralla, vaca/cebra u otros patrones de pueblos, huertos remotos ni actividades autónomas periódicas de los NPC.

## Verificación
Dos baterías completas: 132/132 pruebas en 23 scripts y 54/54 en 13 scripts. Total 186/186 pruebas y 1.459.323 comprobaciones; la mayoría son un barrido exhaustivo del terreno y sus colisiones, no partidas manuales. Repetidas además las cinco pruebas nuevas de identidad/pin tras el último ajuste visual, añadiendo una comprobación de centrar el destino sin revelar terreno.

Comprueba persistencia de nombres, migración aditiva, pista sin visita, primera siesta bloqueada, fallo de guardado sin cambios, recarga del pin, selección del icono en mapa, desbloqueo al llegar, caminos reales a los cuatro pueblos y la misma geometría de obstáculos. Capturas reales inspeccionadas del portón, NPC, mapa, detalle e iconos a 64 px. Diálogo inspeccionado también en 960x540.

Sin Android físico. Avisos de cierre de la batería base: 8 CanvasItem y 2 recursos vivos; la batería extra también detecta 15 nodos huérfanos en una prueba de diálogo de florista. No se presenta como una prueba sin fugas. Las pruebas y capturas usan partidas de QA separadas.

Mismo paquete com.example.rancho.review y certificado, versionCode415.
