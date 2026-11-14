# Rancho Prueba 2.7.147

## Reloj en el círculo del rayo, no bajo el caballo
Corregida la interpretación del indicador: se quita el reloj bajo el jinete y el texto Regate del HUD. Carreras y justa muestran la recarga dentro del icono circular del rayo, con el mismo relleno oscuro por sector del indicador compartido de Frontera.

El dibujo de rayo es el de la referencia de Ant, alimentado por la recarga real del sprint. El icono es un indicador, no añade una pulsación nueva: se conserva levantar y volver a apoyar al correr para preparar el sprint. También se conservan sprint en justa, IA con plan independiente y música sin silbido.

## Músico de ambiente
Arte PNG estático entregado por Ant, con sombrero, Ganjo y espiga de trigo. Aparece junto a la salida de carreras, fuera de la valla, y cerca de casa en Frontera, apartado del acceso. Un único componente en ambos lugares. Sin colisión, misión, recompensa, diálogo, audio extra ni cambios de guardado. No se presenta una animación generada: por ahora es el personaje estático proporcionado.

## Comprobación
66/66 pruebas dirigidas, 485 aserciones. Verificados indicador lleno/medio/vacío, ausencia del texto Regate, controles sin cambio y arte opcional. Capturas reales de carrera, justa y Frontera inspeccionadas; detalle limpio del botón incluido. Falta prueba en Android físico. Persisten avisos conocidos de limpieza del banco de pruebas y los fallos antiguos adicionales documentados en146.

Mismo paquete y firma de pruebas, arm64, versionCode406. Rama de pruebas, sin main, web ni tienda. El segundo parado tras el lazo no se ha añadido.
