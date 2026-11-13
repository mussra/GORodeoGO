# Rancho Prueba 2.7.133

## Corrección visual al abrir la ayuda
El caballo no se borraba ni se descargaba: el área invisible que permite tocarlo heredaba un fondo opaco al quedar deshabilitada por el diálogo. Ese rectángulo tapaba el sprite. Ahora conserva la transparencia también en estado bloqueado. La ayuda sigue bloqueando los toques al fondo; al cerrarla se recuperan. También se evita un fondo opaco en el botón plano del Promedio.

## Verificación
Reproducción antes/después con renderizado GL y capturas a960×540: antes, ayuda abierta con rectángulos opacos; después, caballo visible antes, durante y después. El sprite mantiene frames y animación.23/23 pruebas dirigidas pasan (10 rancho y13 higiene de menús),953 aserciones. Otras36 integraciones de la pasada anterior también pasaron; el único fallo fue el selector de la nueva prueba, corregido y repetido. No probado en Android físico. Sin cambios de datos, guardados, progreso, estadísticas ni arte. Web no publicada; main intacta.

## APK
Versión2.7.133, código392, arm64, com.example.rancho.review, misma firma de prueba. Instalar encima sin desinstalar.
Tamaño: 71415236 bytes. SHA256: d4f3daa72ee3312967d49c03992ee3a52b6f90f62cf7c4ea744ee77a21ee36c0.
