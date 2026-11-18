# Rancho Prueba 3.0.1

VersionCode 461. Misma aplicación y firma de prueba: se instala encima de 3.0.0.

## Cambios
- Botón del látigo al borde derecho, con margen de 16 px y respeto del área segura. Se recoloca al cambiar la proporción de pantalla.
- En los niveles, la cámara reserva espacio lateral para no tapar el corral en formato de tableta. Solo cambia el encuadre, no el tamaño físico del corral ni sus reglas.
- Un dedo puede mantener el movimiento mientras el otro activa el chasquido. Un pequeño deslizamiento dentro del botón ya no se convierte en un gesto de lazo. Soltar fuera o cancelar ese dedo no activa el botón ni corta el movimiento del otro.
- Equipo y confirmación de compra aclaran que el látigo no toca ni daña a ningún animal. El primer chasquido muestra durante ocho segundos un aviso no modal de que solo hace ruido. Incluye ondas de sonido separadas del emblema de caballo existente, sin dibujo de golpe.

## Se conserva
Alcance, enfriamiento, efectos, precios y reglas. El sonido existente no cambia. No se añade animación de contacto ni golpe. No hay cambios en main ni publicación en tienda.

## Verificación
425/425 pruebas dirigidas, 54830 aserciones en 66 scripts. No es toda la suite histórica. Pruebas de dos dedos con deriva de 18 px, cancelación, soltar fuera y liberación del movimiento. Capturas reales del motor de escritorio en partida aislada a 1600x720, 1280x720 y 1280x960. La captura del primer uso se toma tras activar el botón con el segundo dedo mientras el primero mantiene el movimiento.

APK exportado y firma comprobada. Sin prueba en Android físico: los eventos táctiles son inyectados en el motor de escritorio. La instalación, sensación táctil y rendimiento del dispositivo siguen pendientes de validación allí.

Avisos conocidos: 1 aviso de recurso de GUT, 21 llamadas obsoletas y 2 instancias ObjectDB al salir. Los mensajes de error 7 de SaveData corresponden a pruebas deliberadas de fallo y reversión de guardado. Exportación con herramientas 35 para target 36.

El chasquido de audio existente puede seguir evocando un impacto; no se sustituye sin elegir antes otro sonido.

SHA256 del APK: `7cf29914c6666c55e9ad7901aabd607bb11af61db6ee8434c29a05443700175c`
