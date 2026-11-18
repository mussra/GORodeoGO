# Inventario de dibujo por código y plan de sustitución

Revisión de la rama de prueba tras 2.7.188. No se ha cambiado la jugabilidad ni activado ninguna sustitución visual.

## Qué cuenta y qué no

- Confirmado: dibujo hecho con líneas, polígonos, formas, estilos, SVG o texturas calculadas. El escaneo encontró 82 archivos de presentación con llamadas de dibujo; no son 82 sprites: varios solo muestran imágenes ya existentes.
- No se atribuye origen ChatGPT a una imagen por su nombre. Alma, libro y guarnicionería son archivos recibidos del usuario. Los grupos AntIcons187/188 y MenuEntryArt189 muestran hojas recibidas; no deben confundirse con los iconos de equipo aún dibujados por código.
- Caballo de la categoría Caballeriza y la moneda de Adornos ya usan imágenes. En cambio la estrella de Acabados, flecha Volver, sombreros, fustas, montura, riendas/lazo, estribos, herraduras, espuelas, mantas, moneda con + y check de Equipar siguen siendo formas.
- Cerdos, cabras, toros, caballos, jinetes, NPC, flores principales, casas, árboles, libro y taller cargan imágenes. Sus indicadores, sombras, cuerda, barras y algunos acabados se calculan aparte. No hace falta pedir otra vez todas las animaciones para resolver estos iconos.

## Una hoja, cien módulos

Se agrupan variantes de color, mejoras que comparten dibujo, tamaños, estados de brillo y todas las repeticiones. No se agrupan fusta básica/larga ni sombrero normal/gala porque tienen dibujo distinto. Hay 100 celdas, no 100 sistemas ni una lista de 100 fallos. Algunas celdas son piezas de textura de dibujos grandes o componentes del sistema visual, no iconos de botones.

Cada celda aporta una imagen base. Porcentajes, trazos del lazo, límites reales de captura, rutas, geometría de mapas, números, letras y selección siguen calculándose para representar correctamente la partida. Cambiar las imágenes no debe convertirlos en decorado estático. Las variaciones de genética requieren máscaras/UV y conservar las capas: una hoja pequeña no reemplaza por sí sola las animaciones ni los fondos grandes a resolución final.

Los nombres de destino son art/replacement259/<archivo>.png. manifest.json conserva orden, fila, columna, tamaño de uso y fuente. El recortador incluido valida la cuadrícula y elimina el color magenta de fondo, incluidos los huecos interiores de aros y marcos. Ningún archivo nuevo se activa automáticamente.

## Detalle por celda

| Celda (fila,columna) | Archivo | Qué reemplaza / dónde | Tamaño de uso |
|---|---|---|---|
| 1 (1,1) | back.png | flecha de volver hacia la izquierda / Equipo | 32-100 px |
| 2 (1,2) | buy.png | moneda dorada con pequeño signo más / Equipo | 32-100 px |
| 3 (1,3) | equip.png | marca de equipado verde / Equipo | 32-100 px |
| 4 (1,4) | hat_category.png | sombrero marrón de la categoría Sombreros / Equipo | 32-100 px |
| 5 (1,5) | finish_category.png | grupo de tres estrellas de acabados / Equipo | 32-100 px |
| 6 (1,6) | whip_basic.png | fusta básica de cuero / Equipo | 32-100 px |
| 7 (1,7) | whip_long.png | fusta mejorada de cuero con extremo largo / Equipo | 32-100 px |
| 8 (1,8) | saddle.png | montura de viaje de cuero / Equipo | 32-100 px |
| 9 (1,9) | reins.png | par de riendas de precisión / Equipo | 32-100 px |
| 10 (1,10) | stirrups.png | par de estribos metálicos con correas / Equipo | 32-100 px |
| 11 (2,1) | horseshoe.png | herradura de hierro / Equipo | 32-100 px |
| 12 (2,2) | spurs.png | par de espuelas con estrella metálica / Equipo | 32-100 px |
| 13 (2,3) | blanket.png | manta roja de montura con ribete dorado / Equipo | 32-100 px |
| 14 (2,4) | hat_gala.png | sombrero oscuro de gala con cinta dorada / Equipo | 32-100 px |
| 15 (2,5) | lasso_item.png | lazo largo enrollado, cuerda y lazada claramente reconocibles / Equipo | 32-100 px |
| 16 (2,6) | victory_spark.png | estrella luminosa de mejora de cuatro puntas / Equipo | 32-100 px |
| 17 (2,7) | button_normal.png | botón redondeado azul petróleo sin texto / Marcos y controles | base 128-400 px; paneles escalables |
| 18 (2,8) | button_pressed.png | mismo botón pulsado de color miel sin texto / Marcos y controles | base 128-400 px; paneles escalables |
| 19 (2,9) | button_disabled.png | mismo botón desactivado oscuro sin texto / Marcos y controles | base 128-400 px; paneles escalables |
| 20 (2,10) | panel.png | marco de panel azul petróleo, centro despejado / Marcos y controles | base 128-400 px; paneles escalables |
| 21 (3,1) | dialog.png | marco de diálogo redondeado, centro despejado / Marcos y controles | base 128-400 px; paneles escalables |
| 22 (3,2) | bar_track.png | canal vacío de barra horizontal / Marcos y controles | base 128-400 px; paneles escalables |
| 23 (3,3) | bar_fill.png | relleno horizontal turquesa de barra / Marcos y controles | base 128-400 px; paneles escalables |
| 24 (3,4) | joystick_knob.png | botón circular semitransparente dorado para el dedo / Marcos y controles | base 128-400 px; paneles escalables |
| 25 (3,5) | scroll_track.png | canal vertical fino de desplazamiento / Marcos y controles | base 128-400 px; paneles escalables |
| 26 (3,6) | scroll_thumb.png | agarre vertical dorado de desplazamiento / Marcos y controles | base 128-400 px; paneles escalables |
| 27 (3,7) | tab.png | pestaña redondeada sin texto / Marcos y controles | base 128-400 px; paneles escalables |
| 28 (3,8) | checkbox.png | casilla vacía cuadrada de cuero / Marcos y controles | base 128-400 px; paneles escalables |
| 29 (3,9) | radio.png | selector circular vacío / Marcos y controles | base 128-400 px; paneles escalables |
| 30 (3,10) | slider.png | pequeño tirador redondo para deslizador / Marcos y controles | base 128-400 px; paneles escalables |
| 31 (4,1) | close_cross.png | cruz de cerrar sencilla / Marcos y controles | base 128-400 px; paneles escalables |
| 32 (4,2) | tooltip.png | placa de aviso pequeña sin texto / Marcos y controles | base 128-400 px; paneles escalables |
| 33 (4,3) | capture_ring.png | anillo vacío dorado de captura / Captura y efectos | 16-160 px; cuerda repetible |
| 34 (4,4) | capture_dot.png | punto de impacto luminoso pequeño / Captura y efectos | 16-160 px; cuerda repetible |
| 35 (4,5) | rope_segment.png | tramo de cuerda trenzada recta horizontal, repetible / Captura y efectos | 16-160 px; cuerda repetible |
| 36 (4,6) | rope_loop.png | lazada de cuerda vista desde arriba, vacía por dentro / Captura y efectos | 16-160 px; cuerda repetible |
| 37 (4,7) | player_ring.png | óvalo turquesa vacío de selección bajo el jinete / Captura y efectos | 16-160 px; cuerda repetible |
| 38 (4,8) | player_arrow.png | punta triangular turquesa de dirección / Captura y efectos | 16-160 px; cuerda repetible |
| 39 (4,9) | edge_arrow.png | flecha dorada de dirección fuera de pantalla / Captura y efectos | 16-160 px; cuerda repetible |
| 40 (4,10) | edge_badge.png | medallón oscuro vacío para indicador lateral / Captura y efectos | 16-160 px; cuerda repetible |
| 41 (5,1) | fatigue_frame.png | marco fino vacío de fatiga / Captura y efectos | 16-160 px; cuerda repetible |
| 42 (5,2) | held_check.png | pequeña marca de animal controlado / Captura y efectos | 16-160 px; cuerda repetible |
| 43 (5,3) | stun_dust.png | nube pequeña de polvo de golpe / Captura y efectos | 16-160 px; cuerda repetible |
| 44 (5,4) | dash_dust.png | nube alargada de polvo de carrera / Captura y efectos | 16-160 px; cuerda repetible |
| 45 (5,5) | dash_streak.png | destello alargado turquesa de regate / Captura y efectos | 16-160 px; cuerda repetible |
| 46 (5,6) | cooldown_arc.png | aro vacío de recarga, sin porcentaje / Captura y efectos | 16-160 px; cuerda repetible |
| 47 (5,7) | memory_halo.png | halo circular de pista de memoria / Captura y efectos | 16-160 px; cuerda repetible |
| 48 (5,8) | number_plaque.png | placa de madera pequeña vacía para número / Captura y efectos | 16-160 px; cuerda repetible |
| 49 (5,9) | book_mean.png | dos grupos de barras que dan una barra intermedia, concepto de media sin números / Libro y heráldica | 32-128 px; ilustraciones libro 460x126 |
| 50 (5,10) | book_caps.png | barra llena con tope final visible / Libro y heráldica | 32-128 px; ilustraciones libro 460x126 |
| 51 (6,1) | book_breeds.png | tres siluetas de caballo con aspectos distintos / Libro y heráldica | 32-128 px; ilustraciones libro 460x126 |
| 52 (6,2) | shield_classic.png | escudo heráldico clásico vacío / Libro y heráldica | 32-128 px; ilustraciones libro 460x126 |
| 53 (6,3) | shield_round.png | escudo heráldico redondo vacío / Libro y heráldica | 32-128 px; ilustraciones libro 460x126 |
| 54 (6,4) | shield_flat.png | escudo heráldico de base plana vacío / Libro y heráldica | 32-128 px; ilustraciones libro 460x126 |
| 55 (6,5) | symbol_sun.png | símbolo heráldico de sol / Libro y heráldica | 32-128 px; ilustraciones libro 460x126 |
| 56 (6,6) | symbol_mountain.png | símbolo heráldico de montañas / Libro y heráldica | 32-128 px; ilustraciones libro 460x126 |
| 57 (6,7) | symbol_diamond.png | símbolo heráldico de rombo / Libro y heráldica | 32-128 px; ilustraciones libro 460x126 |
| 58 (6,8) | symbol_cross.png | símbolo heráldico de cruz / Libro y heráldica | 32-128 px; ilustraciones libro 460x126 |
| 59 (6,9) | symbol_wave.png | símbolo heráldico de ola / Libro y heráldica | 32-128 px; ilustraciones libro 460x126 |
| 60 (6,10) | book_paper.png | textura de pergamino crema sin letras / Libro y heráldica | 32-128 px; ilustraciones libro 460x126 |
| 61 (7,1) | genealogy_connector.png | pequeño tramo de rama de árbol genealógico / Libro y heráldica | 32-128 px; ilustraciones libro 460x126 |
| 62 (7,2) | affinity_question.png | signo de interrogación de afinidad / Libro y heráldica | 32-128 px; ilustraciones libro 460x126 |
| 63 (7,3) | alert_mark.png | signo de exclamación de alerta / Libro y heráldica | 32-128 px; ilustraciones libro 460x126 |
| 64 (7,4) | lineage_badge.png | escudo con silueta de caballo, insignia de linaje / Libro y heráldica | 32-128 px; ilustraciones libro 460x126 |
| 65 (7,5) | fence_rail.png | travesaño horizontal de valla de madera / Mundo y mapas | objetos 32-128 px; piezas 128-400 px |
| 66 (7,6) | fence_post.png | poste de valla de madera / Mundo y mapas | objetos 32-128 px; piezas 128-400 px |
| 67 (7,7) | gate_leaf.png | hoja de portón de madera sin cerrar la carretera / Mundo y mapas | objetos 32-128 px; piezas 128-400 px |
| 68 (7,8) | wood_sign.png | cartel de madera vacío sobre poste / Mundo y mapas | objetos 32-128 px; piezas 128-400 px |
| 69 (7,9) | town_map_icon.png | miniatura de pueblo con dos casitas y carretera que continúa entre dos postes / Mundo y mapas | objetos 32-128 px; piezas 128-400 px |
| 70 (7,10) | road_surface.png | textura de tierra clara de camino, vista superior, repetible / Mundo y mapas | objetos 32-128 px; piezas 128-400 px |
| 71 (8,1) | race_track.png | textura de pista de arena, vista superior, repetible / Mundo y mapas | objetos 32-128 px; piezas 128-400 px |
| 72 (8,2) | arena_floor.png | suelo azul verdoso discreto de recinto, repetible / Mundo y mapas | objetos 32-128 px; piezas 128-400 px |
| 73 (8,3) | hay.png | bala redonda de heno de estación de distracción / Mundo y mapas | objetos 32-128 px; piezas 128-400 px |
| 74 (8,4) | water_trough.png | abrevadero lleno de agua, vista tres cuartos superior / Mundo y mapas | objetos 32-128 px; piezas 128-400 px |
| 75 (8,5) | cactus.png | cactus verde con dos brazos / Mundo y mapas | objetos 32-128 px; piezas 128-400 px |
| 76 (8,6) | garden_plot.png | parcela pequeña de huerto con cuatro surcos vacíos / Mundo y mapas | objetos 32-128 px; piezas 128-400 px |
| 77 (8,7) | wall_stone.png | textura de muro de piedra crema repetible / Mundo y mapas | objetos 32-128 px; piezas 128-400 px |
| 78 (8,8) | wall_trim.png | remate horizontal de muro de piedra / Mundo y mapas | objetos 32-128 px; piezas 128-400 px |
| 79 (8,9) | gate_pillar.png | pilar de entrada de piedra / Mundo y mapas | objetos 32-128 px; piezas 128-400 px |
| 80 (8,10) | map_frame.png | marco de minimapa cuadrado con interior vacío / Mundo y mapas | objetos 32-128 px; piezas 128-400 px |
| 81 (9,1) | menu_background.png | motivo de fondo azul petróleo con horizonte de rancho muy sutil / Fondos y módulos | piezas 128-400 px; fondos finales requieren ampliación |
| 82 (9,2) | cartoon_background.png | paisaje simplificado de cielo, colinas y arena / Fondos y módulos | piezas 128-400 px; fondos finales requieren ampliación |
| 83 (9,3) | sea_surface.png | textura de mar azul turquesa repetible / Fondos y módulos | piezas 128-400 px; fondos finales requieren ampliación |
| 84 (9,4) | river_surface.png | textura de río azul claro repetible / Fondos y módulos | piezas 128-400 px; fondos finales requieren ampliación |
| 85 (9,5) | shore_foam.png | tramo horizontal de espuma de orilla, repetible / Fondos y módulos | piezas 128-400 px; fondos finales requieren ampliación |
| 86 (9,6) | bridge_board.png | tablón de puente de madera repetible / Fondos y módulos | piezas 128-400 px; fondos finales requieren ampliación |
| 87 (9,7) | goal_pen.png | base decorativa de destino de captura vacía / Fondos y módulos | piezas 128-400 px; fondos finales requieren ampliación |
| 88 (9,8) | obstacle_block.png | obstáculo cuadrado de madera reforzada / Fondos y módulos | piezas 128-400 px; fondos finales requieren ampliación |
| 89 (9,9) | goal_lantern.png | pequeño poste con luz de destino / Fondos y módulos | piezas 128-400 px; fondos finales requieren ampliación |
| 90 (9,10) | memory_fence.png | valla de salto de hípica vista de frente / Fondos y módulos | piezas 128-400 px; fondos finales requieren ampliación |
| 91 (10,1) | pattern_star.png | estrella de cinco puntas para máscara de pelaje y muro / Fondos y módulos | piezas 128-400 px; fondos finales requieren ampliación |
| 92 (10,2) | pattern_spot.png | mancha orgánica para máscara de pelaje y muro / Fondos y módulos | piezas 128-400 px; fondos finales requieren ampliación |
| 93 (10,3) | pattern_stripe.png | rayas curvas para máscara de pelaje y muro / Fondos y módulos | piezas 128-400 px; fondos finales requieren ampliación |
| 94 (10,4) | pattern_roan.png | moteado suave para máscara de pelaje / Fondos y módulos | piezas 128-400 px; fondos finales requieren ampliación |
| 95 (10,5) | galaxy_cloud.png | pequeña nebulosa violeta azulada sin estrellas sueltas / Fondos y módulos | piezas 128-400 px; fondos finales requieren ampliación |
| 96 (10,6) | glow_aura.png | halo suave luminoso turquesa sin objeto central / Fondos y módulos | piezas 128-400 px; fondos finales requieren ampliación |
| 97 (10,7) | map_node.png | nodo circular vacío de mapa de pueblos / Fondos y módulos | piezas 128-400 px; fondos finales requieren ampliación |
| 98 (10,8) | map_route_arrow.png | punta de flecha pequeña para ruta de mapa / Fondos y módulos | piezas 128-400 px; fondos finales requieren ampliación |
| 99 (10,9) | minimap_dot.png | punto circular claro para entidades de minimapa / Fondos y módulos | piezas 128-400 px; fondos finales requieren ampliación |
| 100 (10,10) | ground_shadow.png | sombra oval suave negra semitransparente / Fondos y módulos | piezas 128-400 px; fondos finales requieren ampliación |

## Fuentes que gobiernan cada grupo

- Equipo: equipment_icon229.gd, EquipmentPanel, SpurButton243. Hay iconos compartidos por básico/mejorado. El nuevo lazo usa provisionalmente el dibujo de riendas.
- Marcos, botones, barras: RanchTheme, QuestButtonStyle, DetailCard179, MapAppearance, MenuBackdrop, controles nativos. Cinco estados de botón pueden derivarse de las tres bases y efectos de foco/hover.
- Cuerda y captura: LassoRopeStyle, LassoRope, LassoController, HeldVisuals. Mismo dibujo compartido en nivel y Frontera.
- Efectos: DodgeVisuals, DodgeEdgeCue, HorseVictory251, AnimalFatigueBar, PlayerMarker223, EdgeIndicators, círculos de JumpMemory207. Los números de memoria son texto, no se rasterizan dentro del icono.
- Libro: BookGlyph256 todavía dibuja media, tope y siluetas. Portada, libro abierto, Alma y pestañas sí vienen de los archivos recibidos.
- Heráldica: HorseEmblem genera escudos, divisiones y cinco símbolos con SVG/máscaras; iniciales son texto. GenealogyPanel dibuja conectores. Las tres divisiones usan las mismas bases y máscaras.
- Mundo: JumpFence, PuzzleCorral, CorralFrontRail, PenDoor, PenLinkOverlay, TownLayer227, TownWallArt242, TownPaint215, WorldMountains103; las formas de pueblos no deben sustituirse por una foto fija.
- Decorado por código: cactus de WorldDecor, parcela de GardenWorld212, suelo/obstáculos/destino de ArenaArt, paisaje de CartoonBackdrop y MenuBackdrop, pistas y separación de Justa/Hípica, agua/orillas/puentes de CountryPreview146. Agua y heno de estaciones son SVG, no imágenes pintadas.
- Mapas: ArenaMinimap, RaceMap191, MemoryMap207, WorldDiscoveryMap159, CountryMap148, TownMap234, MapPlayerMarker99 y TownIcon215. Marcos y marcadores pueden usar arte; rutas, terreno explorado, puntos y formas siguen basados en datos.
- Apariencias: HorseAppearance, HorseGalaxyLook, TownPaint215 y shaders de acabados/siesta calculan máscaras, tintes y brillo. Son tratamiento sobre sprites, no personajes nuevos.

## Fuera de esta hoja

Texto, números, controles del sistema sin dibujo propio, transparencias, posiciones, oclusión, recorte, luces y composición. Los fondos grandes se representan aquí como módulos guía: la hoja sirve para aprobar estilo y recortar símbolos, no certifica suficiente detalle para un fondo de pantalla entero. Los sprites de actores ya cargados no se atribuyen al usuario ni a ChatGPT sin revisar su procedencia original; simplemente no son los placeholders dibujados por código que se detectan aquí.
