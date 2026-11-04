# Mapas grandes: candidato de pruebas

Rama `improve/scrolling-arenas`, separada de la release 0.21.15 y del hotfix de seguimiento. No publicada en APK.

## Propuesta reversible

- Niveles 1-10 conservan su arena y cámara.
- Del 11 al 20 la arena pasa de 1,6 a 2,32 veces la dimensión anterior, progresivamente. Son valores de prototipo, no medidas elegidas por Antonio.
- La cámara sigue al vaquero y se limita por el perímetro. HUD y mandos permanecen en pantalla.
- Corrales y meta cambian de posición, sin inflar cuerpos, anchura de puertas ni personajes. Las vallas y los límites físicos crecen con el mapa.
- Flechas TORO y META indican objetivos fuera de vista. Toros cercanos en una misma dirección se agrupan con contador. Se ocultan en pausa/fin.
- Las conexiones de puertas solo se dibujan cerca del vaquero para no cubrir toda la arena con líneas. Las reglas de apertura no cambian.

## Comprobaciones

- Suite completa tras corregir acceso a puertas liberadas: 271 tests y 4300 aserciones pasan.
- Pruebas de geometría en todos los niveles ampliados: corrales dentro de límites, sin solapes y rutas estáticas con margen hacia cierres y meta.
- Entrega física a la meta reposicionada; agrupación, visibilidad y pausa de indicadores; movimiento de cámara.
- Dos pruebas adicionales cronometradas recorren desde el centro hasta un cierre real, esperan quietud para abrir, capturan en el corral y remolcan hasta la meta, sin teletransportar personajes. Con otros toros detenidos para aislar el trayecto: nivel 11 consume unos 14 s de 90; un corral lejano de nivel 20, unos 20 s de 450. Incluyen espera de calma de 8,5 s.

Estos viajes prueban la ruta, no el equilibrio con toda la manada ni el tiempo de una campaña humana completa. Se conservan los tiempos anteriores; ajustarlos requiere más evidencia. El video usa controles simulados en Godot, no prueba con dedo en Android. El aviso residual de dos recursos de audio al cerrar sigue pendiente.
