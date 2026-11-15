# Rancho Prueba 2.7.167

## V6: pueblos por semilla, no un reparto fijo

Para probar la generación V6, empieza una partida nueva. La APK no borra ni migra las partidas anteriores; sus generadores V1-V5 y la colección capturada se conservan.

- El primer pueblo reúne al loco, granjero, florista y Juanito, el guarnicionero. Cada uno recomienda una dirección cardinal distinta, sorteada por semilla.
- Los siguientes pueblos mezclan dos oficios. Siempre encontrarás al primo del oficio que te recomendó ir, además de otro oficio sorteado.
- Las recomendaciones forman un árbol de hasta tres generaciones: ninguna apunta al padre o a un antepasado. Algunas saltan un pueblo real y explorable, y avisan de que el intermedio no es el destino.
- Terminar las recomendaciones NO termina el mundo: la generación territorial continúa por coordenadas y semilla. Hay pueblos con identidad y dos oficios más allá del árbol. Se mantiene una ventana local de 25 celdas más la pequeña red inicial; se guardan descubrimientos y cambios, no un mapa infinito entero.
- Los pueblos no son equidistantes. Su posición lleva una variación por semilla, independiente en cada eje, manteniendo las direcciones cardinales entre vecinos.
- Cada pueblo tiene forma, colores y dibujo de muralla deterministas. Las pistas nombran el dibujo, los dos colores y el sector, para reconocer el destino. Se añade cebra a las murallas V6.
- Las recomendaciones son visitas a personajes. No se han inventado recompensas ni nuevas cadenas económicas. Los oficios abren los sistemas existentes cuando corresponde; las misiones adicionales siguen pendientes de diseño.
- El esquema completo de pueblos está dentro del juego SOLO en modo debug. En normal no aparece ese botón ni se puede abrir esa vista; los destinos aceptados se señalan en el minimapa normal.

## Tiempo estimado con el caballo actual

- Se suman los segmentos del camino real, accesos y entrada/salida del pueblo, no solo la distancia en línea recta.
- El tiempo se simula en pasos de 0,25 segundos con HorseStats, WorldGait y WorldStamina: velocidad real, energía actual, capacidad según potencia, menor consumo en caminos, nutrición y respiros forzados.
- Se propone viajar al máximo ritmo sostenible permitido por esas reglas. Cambiar de caballo recalcula la pista, actualiza velocidad/arte y conserva la energía de cada montura al volver a ella.
- Se muestra una horquilla orientativa de ±20%, redondeada a diez segundos. Es una tolerancia de planificación, NO un error medido o garantizado en Android. Desvíos, controles, paradas y encuentros pueden superarla.
- Ejemplo verificado: misma pista de dos pueblos al oeste, unos 28.544 u de camino: Lento (240 u/s), 2:00-3:10; Rápido (300 u/s), 1:30-2:30.
- Las distancias están en unidades del juego, no metros reales.

## Sombreros por diseños que has tenido

- Ya no se ofrece equipar toda la paleta gratis. Consigues un diseño al haber tenido un caballo con ese color, patrón y color del patrón.
- El diseño queda guardado aunque vendas el último caballo que lo tenía. Las compras, capturas y crías que se guardan alimentan ese historial.
- Se puede previsualizar una combinación bloqueada, pero el botón Equipar queda desactivado. Original siempre está disponible.
- Se ha añadido el selector del color del patrón. El ejemplo rojo con estrellas azules se conserva después de vender y recargar.
- En archivos antiguos se reconocen los caballos actuales y el sombrero ya equipado; no se puede reconstruir un caballo vendido antes de existir este historial. No se concede todo el catálogo por migración.

## Validación y límites

- 127/127 pruebas de integración, 1419 comprobaciones.
- 67/67 pruebas unitarias, 103.141 comprobaciones. Incluyen 50 semillas, rutas, límites de paredes, saltos de dos pueblos, generación lejana reproducible, distintos caballos y venta/recarga de sombreros.
- Capturas revisadas a 960×540 de tres semillas, dos caballos, pueblo lejano, esquema debug y sombreros bloqueados/desbloqueados.
- Corregida la triangulación de caminos en coordenadas lejanas calculando sus uniones en coordenadas locales del fragmento.
- Validación de escritorio. No hay prueba en Android físico ni medición de batería, tiempos reales o rendimiento en teléfono.
- La regresión termina con avisos de cierre: 7 CanvasItem, 12 ObjectDB y 2 recursos retenidos.
- El arte del guarnicionero reutiliza provisionalmente el granjero con un tinte. Las casas y primos reutilizan dibujos existentes.
- Sin cambios en main, tiendas, gastos, huerto o reorganización de maestría.
