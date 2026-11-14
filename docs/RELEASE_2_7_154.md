# Rancho Prueba 2.7.154

## El árbol ya es el menú real
El menú principal ahora ofrece Juegos, Frontera, Equipo y Ajustes, además de Salir. Juegos abre cinco tarjetas: Rodeo de toros, Carreras, Duelo de lazos, Justa con lazos e Hípica de memoria.

- Rodeo de toros sustituye la etiqueta genérica Niveles en el acceso y el selector de la campaña. Conserva los mismos 40 niveles de toros y corrales. "Nivel" sigue nombrando cada reto numerado.
- Hípica de memoria sustituye el nombre anterior en el selector, el título de pantalla y la pausa. Elegido por ser más corto que Equitación de memoria y legible en móvil.
- Volver desde el selector de niveles regresa a Juegos. Volver desde Juegos cierra el selector. Los modos conservan sus salidas al menú principal.
- Las herramientas de caballos/niveles y cambio de modo están en Ajustes → Herramientas DEBUG. Editor, vista de diseño y maquetas de país quedan en Frontera → Menú → Herramientas DEBUG. No aparecen mezcladas con los cinco juegos. Solo se ofrecen en compilaciones con herramientas de prueba habilitadas.
- Árbol horizontal v3 actualizado: azul para rutas del juego normal; gris DEBUG para autoría, herramientas y maquetas. Carreras y huerto siguen siendo pilotos. Los pueblos todavía no abren esos juegos.

## Lucía, la hortelana
Lucía sustituye al hortelano en el huerto piloto: título "Lucía · Hortelana", presentación "Soy Lucía. ¿Cuidamos este huerto?", retrato y poses de sembrar, regar y cosechar con la hoja de Ant. Ojos ocultos por el sombrero y croma exterior/interior retirado. La pose de caminar queda preparada, sin paseo automático. El arte del hortelano anterior se conserva como alternativa.

Solo existe el huerto del Pueblo del rancho. Se añade el identificador estable town_id=home a su estado sin perder el progreso previo. Esta entrega no crea huertos en los otros pueblos ni afirma que ya estén disponibles: Camino del Este, Caserío del Oeste y Caserío del Este Lejano son la siguiente ampliación posible.

No se cambian las mecánicas de los juegos ni los valores del huerto, controles, progreso o maestría. No hay movimiento periódico autónomo de NPC: queda para la siguiente APK. Las notas históricas de otras versiones mantienen los nombres que tenían en su fecha.

## Verificación
130/130 pruebas dirigidas, 2.013 comprobaciones, 23 scripts. Incluye toque nativo sintetizado en Juegos y las cinco tarjetas a 960x540, 1280x720 y 1600x720, rutas a las mismas escenas, volver/cerrar overlays, equipo y ajustes, separación DEBUG, nombres, migración aditiva del town_id y ciclo del huerto. Regresión de seis rondas de memoria, salto y controles compartidos, carreras, justa, duelo, mapas y catálogos de idioma.

Menú, selector, pista y pausa inspeccionados en 960x540 y 1280x720; también Lucía y el submenú DEBUG de Frontera. La cosecha es una fixture de QA con crecimiento adelantado, no una partida manual completa. Sin Android físico. Persisten los avisos conocidos de cierre de pruebas de mundo: 13 nodos huérfanos y 2 recursos vivos; no es una prueba sin fugas.

Mismo paquete com.example.rancho.review y firma, versionCode413. Rama de pruebas, main intacta.
