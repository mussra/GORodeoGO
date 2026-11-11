# Relojes de habilidad con el arte de Ant

Cambio posterior a la APK 2.7.84, solo en rama de prueba. No genera otra APK.

La hoja enviada por Ant mide 2172x724 y ya tiene canal alfa transparente. No tiene fondo blanco ni negro que haya que eliminar. El original se conserva en `art/ui/skills/source/ant-skill-clocks-20261111.png`.

Recorte reproducible: tres celdas de 724x724, izquierda a derecha energía, regate, salto. Se guardan copias de UI a 256x256 con reducción Lanczos. No hay pintura, generación, cambio de color ni sustitución del alfa. El script de recorte está en `tools/skill_clocks/crop.py`.

Los tres se usan en el componente compartido `RadialGauge`, tanto en Frontera como en los niveles, con las mismas reglas de disponibilidad y tamaño lógico 76x76. Energía sigue siendo energía restante, no una habilidad con cooldown. No hay nuevos relojes de unicornio o Galaxy maestro.

El sector dinámico se dibuja sobre la cara del reloj, a las 12 y en sentido horario, con el ratio y transparencia anteriores. Se limita al interior para no teñir el marco de madera. No se pinta recarga dentro de los PNG. Las habilidades no disponibles se ocultan igual que antes.

Verificación: imagen real de los tres a 76px, con 0/25/50/75/100% y sobre damero para comprobar transparencia. 493 pruebas unitarias, 58.151 aserciones. Pruebas del canal alfa exterior, dimensiones, valores del ratio y ocultación. Sin prueba Android.
