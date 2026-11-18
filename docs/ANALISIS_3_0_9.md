# Auditoría de tamaño y optimización 3.0.9

## Resultado confirmado

| APK | Bytes | MB decimales | MiB |
|---|---:|---:|---:|
| 3.0.8 | 92.162.194 | 92,16 | 87,89 |
| 3.0.9 | 77.848.540 | 77,85 | 74,24 |
| Ahorro | 14.313.654 | 14,31 | 13,65 |

Reducción del **15,53%**. Solo exclusión de archivos de trabajo del paquete. Ningún original se ha borrado ni modificado. No se ha reducido resolución, cambiado formato de texturas ni recomprimido audio de ejecución.

## Desglose del contenido comprimido del APK

| Tipo | 3.0.8 bytes | 3.0.9 bytes |
|---|---:|---:|
| Texturas y sprites | 54,549,558 | 40,260,962 |
| Motor y bibliotecas nativas | 25,920,129 | 25,920,129 |
| Audio | 4,181,947 | 4,181,947 |
| Código | 3,255,739 | 3,255,739 |
| Otros recursos, datos y firma | 2,933,103 | 2,916,452 |

El desglose suma tamaños comprimidos de entradas ZIP. El tamaño total también incluye cabeceras, directorios y bloques de firma. No es el tamaño instalado ni la RAM. `before-files.csv` y `after-files.csv` enumeran **cada archivo empaquetado**, su ruta original cuando se puede resolver, tipo, bytes comprimidos y bytes sin comprimir.

## No usados en ejecución, excluidos solo del APK

La revisión no se basa en nombres: se buscaron referencias en scripts, escenas, recursos, shaders y configuración. También se revisaron las rutas construidas dinámicamente, la carga por número de fotograma y el lector de carpetas de animación. Estas hojas de trabajo no son las imágenes derivadas que el juego carga. Sus 27 originales siguen en el repositorio con hash conservado, listado en `preserved-originals.json`.

| Archivo conservado en proyecto | Bytes que ocupaba en APK |
|---|---:|
| `art/ui/ant_icons187/source.png` | 1,335,766 |
| `art/ui/skills/source/ant-skill-clocks-20261111.png` | 1,278,878 |
| `art/world/modular87/source/ant-road-grass-sheet-20261111.png` | 1,115,924 |
| `art/experimental/drink_preview83/source_ant.png` | 1,094,012 |
| `art/npc/source/primos140/loco-sorpresa-original.png` | 1,079,744 |
| `art/npc/source/primos140/loco-normal-original.png` | 973,062 |
| `art/ui/ant_icons188/source.png` | 935,164 |
| `art/world/goats/source/running-four-views.jpg` | 913,414 |
| `brand/zumbel_source.png` | 853,084 |
| `art/world/pigs/source/running-front-back.jpg` | 825,860 |
| `art/world/modular86/source/ant-road-sheet-20261111.png` | 819,774 |
| `art/ui/menu_entries189/source.png` | 768,066 |
| `art/world/alternative92/source.jpg` | 671,894 |
| `art/npc/source/farmer-ant-20261111.jpg` | 648,262 |
| `art/world/pigs/source/running-sheet.jpg` | 349,106 |
| `art/world/derived88/straight-source.png` | 92,414 |
| `art/experimental/pixellab/pig/original_sheet.png` | 84,860 |
| `art/experimental/pixellab/pig/original_down_sheet.png` | 65,194 |
| `art/experimental/pixellab/goat/original_side_sheet.png` | 64,930 |
| `art/experimental/pixellab/goat/original_down_sheet.png` | 62,928 |
| `art/experimental/pixellab/pig/original_up_sheet.png` | 56,904 |
| `art/experimental/pixellab/goat/original_up_sheet.png` | 51,234 |
| `art/experimental/pixellab/bull/original_diag_down_sheet.png` | 36,714 |
| `art/experimental/pixellab/bull/original_side_sheet.png` | 34,232 |
| `art/experimental/pixellab/bull/original_diag_up_sheet.png` | 28,092 |
| `art/experimental/pixellab/bull/original_down_sheet.png` | 25,854 |
| `art/experimental/pixellab/bull/original_up_sheet.png` | 23,230 |

Se eliminaron del paquete 54 entradas: la textura importada y el remapeo de cada uno de esos 27 originales. El ahorro restante corresponde a índices y metadatos que disminuyen. No se borraron archivos del proyecto.

## Candidatos no aplicados y riesgos

- **Música:** las cuatro pistas actuales suman 4.157.421 bytes comprimidos en el APK. Una conversión de estudio a Vorbis calidad 6 produce 2.040.958 bytes, unos **2,12 MB adicionales posibles** antes de metadatos. Es compresión con pérdida. Requiere escuchar las cuatro pistas, comprobar volumen, artefactos y bucles; no se incluye en 3.0.9.
- **Duplicados exactos:** 359 grupos de texturas importadas idénticas suman **748.610 bytes redundantes**. Listado completo en `duplicate-candidates.json`. Algunos son fotogramas simétricos o repetidos y otros recursos con rutas distintas. Borrar nombres rompería cargas dinámicas; hay que compartir/remapear recursos y probar animaciones. No se aplica.
- **Texturas activas grandes:** floristería exterior (1,96 MB), interior de guarnicionero (1,77 MB), interior de florista (1,64 MB), guarnicionero exterior (1,45 MB), logo (1,44 MB), árbol (1,40 MB), florista (1,36 MB), césped (1,01 MB) y retrato adulto (0,86 MB) están en uso. Compresión con pérdida, VRAM o reducción de tamaño podrían reducir disco pero causar halos, pérdida de detalle, cambios de color o incompatibilidad. No hay estimación fiable sin comparar cada imagen y probar Android; quedan intactas.
- **Motor nativo:** 25,92 MB comprimidos, de los cuales 25,47 MB corresponden a Godot. Ya solo se empaqueta arm64. Cambiar plantilla o compilar un motor mínimo requiere otro trabajo y puede quitar funciones o alterar compatibilidad. No se hace.
- **Materiales y shaders:** se conservan; la mayor parte del peso está en imágenes, no en el texto del material. No se eliminan acabados, máscaras ni recursos que se construyen en ejecución.
- **Arte de vistas previas y carpetas experimentales:** no se consideran basura. Hay recursos de caballo, jinete, toro, máscaras y beber usados desde estas carpetas; borrar la carpeta completa rompería el juego. `cartoon_hero.png`, céspedes alternativos, fondos y coronas también tienen referencias directas o dinámicas y se conservan.

Los ahorros candidatos son independientes de la reducción ya aplicada y no son una promesa de reducción final. No se marca como no usado un archivo solo porque su nombre no aparece literalmente en un script.


### Lista conservadora de recursos dudosos, no excluidos

Estos recursos necesitan revisión de alcance o tienen referencias dinámicas/configuración, no son archivos probados como sobrantes. Se conservan. El fondo de arranque está configurado en el proyecto y el héroe cartoon tiene una referencia en un menú alternativo.

| Recurso | Bytes en 3.0.8 |
|---|---:|
| `art/bull/bull_Right.png` | 160,260 |
| `art/garden212/gardener-harvest.png` | 169,224 |
| `art/garden212/gardener-idle.png` | 135,154 |
| `art/garden212/gardener-plant.png` | 158,066 |
| `art/garden212/gardener-walk.png` | 135,448 |
| `art/garden212/gardener-water.png` | 151,206 |
| `art/ui/background300/content.png` | 208,020 |
| `art/ui/background300/main.png` | 711,096 |
| `art/ui/crowns241/round/bulls.png` | 192,660 |
| `art/ui/crowns241/round/bulls_pending.png` | 85,526 |
| `art/ui/crowns241/round/cup.png` | 217,408 |
| `art/ui/crowns241/round/cup_pending.png` | 97,178 |
| `art/ui/crowns241/round/duel.png` | 214,298 |
| `art/ui/crowns241/round/duel_pending.png` | 91,916 |
| `art/ui/crowns241/round/joust.png` | 210,446 |
| `art/ui/crowns241/round/joust_pending.png` | 88,474 |
| `art/ui/crowns241/round/memory.png` | 217,392 |
| `art/ui/crowns241/round/memory_pending.png` | 95,724 |
| `art/ui/crowns241/round/race.png` | 199,108 |
| `art/ui/crowns241/round/race_pending.png` | 89,976 |
| `art/ui/cartoon_hero.png` | 922,652 |
| `art/world/cartoon/barn2.png` | 167,916 |
| `art/world/cartoon/house2.png` | 159,258 |
| `brand/zumbel_boot.png` | 197,904 |

## Verificación

- 457/457 pruebas, 55.490 comprobaciones, 76 scripts.
- Los **2.727 recursos de textura/audio restantes son idénticos byte por byte** a los de 3.0.8.
- La diferencia de archivos del paquete coincide exactamente con las 54 entradas previstas, sin archivos añadidos. Las otras diferencias son versión, firma e índices del paquete.
- Los 27 originales conservan sus hashes.
- Prueba de cargas sobre recursos extraídos del APK reducido: iconos, relojes, césped, NPC, retrato, música y menú cargan; las hojas excluidas no existen en el paquete.
- Capturas de pantallas generadas usando los recursos exportados del APK reducido. Inspeccionadas Victoria, tienda y propiedades: retrato, iconos, barras y texto sin cambios visibles.
- Firma, paquete y código 469 verificados. Sin main ni cambios de jugabilidad.

No se ha probado en Android físico. La ejecución con recursos exportados comprueba faltas de recursos, no certifica instalación, tacto, sonido real ni rendimiento Android. Los cambios de exportación se aplican a los dos presets para mantenerlos coherentes.
