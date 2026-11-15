# Rancho Prueba 2.7.166

## Caminos y pueblos

- Cruces T/X, esquinas y bifurcaciones dibujados como una sola superficie de tierra. Sin remates rectos atravesados ni bordes internos. Cambio visual compartido también en mundos anteriores, sin mover sus rutas.
- Mundos nuevos V5: pueblo inicial conectado al este; desde ese vecino se accede a dos pueblos, uno al norte y otro al sur. El cuidador de caballos y el guarnicionero intercambian las ramas según la semilla.
- Un solo loco, en el pueblo del cuidador. Diario ajustado a ese único personaje.
- Oficios: granjero, Lucía, músico y primera florista en el inicial; segunda florista en el vecino este; cuidador en una rama; guarnicionero en la otra. Se conserva el contenido existente.
- El cuidador abre la caballeriza actual; el guarnicionero abre el equipo actual. Misma colección, puntos, precios y requisitos. No hay economía duplicada.
- Los dos personajes nuevos usan por ahora el dibujo existente del granjero con tintes y rótulos de oficio. Sus casas también reutilizan arte existente.
- Las partidas anteriores conservan su generador, posiciones y personajes. La colección capturada no se recolorea ni se borra.

## Fuera de esta entrega

Las nuevas misiones entre pueblos con direcciones calculadas siguen como propuesta pendiente de revisión. Huerto y reorganización de maestría no cambian. No hay publicación en tiendas ni cambios en main.

## Validación

- 123/123 pruebas de integración, 1373 comprobaciones.
- 53/53 pruebas unitarias, 13473 comprobaciones: uniones de caminos, continuidad entre fragmentos, ambas distribuciones norte/sur, puertas transitables y conservación de V4.
- Apertura y salida real de caballeriza/equipo desde ambos servicios verificadas por pruebas de integración.
- Capturas reales del juego revisadas a 960×540: T/X/esquina/Y, unión en mundo V4, pueblos V5 y panel de servicio.
- Validación de escritorio con controles simulados. No certifica tacto, rendimiento o legibilidad en un Android físico.
- La regresión termina con avisos de cierre: 7 CanvasItem, 10 ObjectDB y 2 recursos retenidos. No son fallos de las 123 pruebas, pero quedan registrados.
