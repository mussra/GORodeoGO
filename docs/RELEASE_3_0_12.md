# Rancho Prueba 3.0.12

- Valla lateral de Ant colocada entera en los dos laterales verticales de cada corral numerado: tres postes y dos tramos.
- Imagen vertical, sin rotación, repintado ni deformación: solo escala uniforme y recorte de márgenes vacíos. No se repite por módulos.
- Transparencia alfa real. Original exacto preservado en art/corral312/source y excluido del APK.
- Puertas, tramos horizontales, colisiones, economía y guardado sin cambios. Laterales exteriores de la arena sin cambios.
- 457/457 pruebas, 55.490 aserciones. Inspección visual de niveles 1, 11, 40 y puerta abierta en escritorio. Sin prueba física Android.
- Paquete com.example.rancho.review, versionCode 472, firma de pruebas habitual. Rama feat/open-world-test-20261107. Main no modificado.

## Evidencia de arte
Original RGBA 724×2172. Recorte (285,0)-(440,2164), con los tres postes y ambos travesaños completos. Se descartan márgenes transparentes y motas aisladas externas, no se pintan píxeles. Anclajes de las bases superior e inferior a y=270 e y=2160; escala uniforme en ambos ejes. Una pieza completa por lateral, sin costuras de repetición.

## Límites conocidos
Las capturas proceden de renderizado de escritorio con perfil preparado, no de una partida humana en móvil. El arnés visual/pruebas puede avisar de objetos retenidos al cerrar; las pruebas pasan. No se certifica rendimiento ni tacto en Android físico.

Una ejecución paralela de pruebas registró un fallo intermitente al escribir el guardado en test_network234. Se conserva el log inicial; al repetir ese bloque sin otra ejecución simultánea pasó 206/206. El otro bloque pasó 251/251. No se han cambiado rutinas de guardado.
