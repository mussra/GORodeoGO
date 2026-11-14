# Rancho Prueba 2.7.155

## Personajes proporcionados
Un ajuste compartido mide el área visible del PNG y alinea los pies al suelo: los márgenes transparentes ya no alteran la altura aparente. Granjero, floristas, primos y músico usan altura adulta 92; Lucía usa 76 como niña. Las poses agachadas conservan su proporción con la pose de pie, en vez de estirarse hasta la misma altura.

Lucía riega mirando hacia las plantas y el agua cae sobre el brote. La posición del riego se ajusta a su nueva escala. Sombrero y ojos ocultos se mantienen.

## Cada sitio con su espacio y su camino
El huerto se separa de la floristería, al sur del camino principal. Tiene un acceso propio en L, con el mismo arte de caminos y la misma detección de superficie. La floristería mantiene edificio, posición y acceso anterior. Se reserva el nuevo espacio y el ramal para que la decoración generada no los tape; los objetos colocados por el editor no se borran.

Las partidas que ya tenían parcela migran su posición de forma guardada y aditiva: conservan muestra, semillas, cultivos, agua, distancia de crecimiento, cosechas y alimento activo del caballo. Si falla el guardado de la reubicación se conserva la parcela anterior. El camino se conecta al troncal de su generador, sin cambiar la semilla ni sustituir el mapa anterior.

No se añaden pueblos ni huertos remotos. El diseño de pueblos con patrones, nombres y marcadores es un trabajo posterior. No hay todavía actividades periódicas autónomas de NPC ni nuevas hojas de poses de granjero/florista. Siesta, maestría, progreso y mecánicas de los juegos siguen como estaban.

## Verificación
132/132 pruebas de regresión, 2.041 comprobaciones, 23 scripts. Incluye tamaño visible y apoyo de pies de los cinco tipos de adulto, escala infantil, orientación del riego, separación y acceso transitable, migración sin pérdida y rollback ante fallo de guardado; también los juegos y navegación ya comprobados en 2.7.154.

Capturas reales inspeccionadas del barrio completo y parcela de cerca antes de publicar. La vista de barrio usa zoom de QA para mostrar ambos sitios. La cosecha usa una fixture que adelanta el crecimiento. No probado en Android físico. Avisos conocidos al cerrar los tests de mundo: 8 nodos huérfanos, 11 instancias y 2 recursos vivos. No es una prueba sin fugas.

Mismo paquete com.example.rancho.review, misma firma, versionCode414. Solo rama de pruebas; main intacta.
