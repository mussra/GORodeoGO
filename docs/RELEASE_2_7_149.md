# Rancho Prueba 2.7.149

## Las vallas de Ant en Salto de memoria
Hoja recortada y alineada en ocho sprites: cuatro colores y sus vistas horizontal/vertical. Se conserva el canal transparente real del PNG; no se elimina pintura blanca, flores ni brillos.

La pista combina roja y amarilla horizontales con azul y verde de perfil. Las primeras se saltan de arriba abajo, las otras de izquierda a derecha. Colisión, comprobación de cruce y minimapa usan el mismo eje, no solo el dibujo. Los números están junto a cada valla sin tapar el arte. Los colores y la posición no cambian durante la secuencia, para que recordar el orden siga siendo justo.

Se sustituyen las vallas genéricas solo en este minijuego. Se añaden arbustos ya existentes en las esquinas, fuera de las aproximaciones de salto. Sin arte generado nuevo, cambios de reglas, maestría, recompensas ni guardado.

79/79 pruebas dirigidas, 590 aserciones: cuatro obstáculos desde ambos sentidos mediante salto automático real, transparencia de ocho recortes, coherencia del eje visual/físico y regresión de los modos anteriores. Capturas reales inspeccionadas tras corregir una carga temporal de decoración que mostraba cuadrados blancos. No Android físico ni certificación de balance humano.

Mismo paquete y firma de pruebas, arm64, versionCode408. Solo rama de pruebas. La reorganización del mundo y la identidad procedural de pueblos siguen en propuesta, sin implementación ni borrado de niveles.
