# Sombreros: color y acabado separados

Preview sin APK. Decisión del usuario: selectores separados.

- Original y los dos tintes anteriores se mantienen, sin cambiar selecciones antiguas.
- Veinte colores procedentes de HorseCollection.COATS / HorseAppearance.COLORS.
- Patrones compartidos: liso, parches, moteado, trasera blanca, patas claras, corazones, estrellas, triángulos, rombos, cebra, jirafa y vaca. Los nombres de los patrones anatómicos se conservan; en el sombrero significan zona izquierda o franja inferior, no anatomía literal.
- Arcoíris reutiliza la misma función y paleta que la crin; Galaxia reutiliza HorseAppearance.galaxy_color. Patrones reutilizan HorseAppearance y HorsePatternMap, sin nuevas texturas raster.
- El patrón queda limitado a la máscara del sombrero y usa un tono claro/oscuro contrastante según el color base. Arcoíris y Galaxia son acabados completos que sustituyen el color sólido.
- Vista previa del sombrero, botón Equipar, sin coste, cambios de genes ni progreso. Original/Azul noche/Arena anteriores desactivan el acabado para conservar exactamente su aspecto; elegir uno de los veinte colores habilita todos los acabados.
- Se guarda como ID validado dentro del campo de sombrero existente. Guardados anteriores siguen cargando. Fallo de guardado conserva selección anterior.
- El mismo tinte sirve para marcha, reposo/beber, sprites clásicos, PixelLab y retrato adulto. El retrato usa la misma textura teñida en vez de una segunda implementación de patrones en shader.

Verificación: 547/547 unitarias, 1.657.727 comprobaciones en la pasada final. Incluye todas las combinaciones de IDs, guardado/carga, compatibilidad anterior y píxeles fuera de la máscara intactos. Capturas reales 896x414 inspeccionadas, Arcoíris y Vaca visibles y controles legibles. Sin Android físico ni APK. Persisten avisos conocidos de recursos al cerrar las escenas de prueba.
