# Preview vallas/HUD, 11 noviembre2026

Petición12:54:Encargos desplegable,ocultar habilidades ausentes,vallas sólidas con profundidad correcta,salto solo caballo capaz y cabras. SinAPKantes de revisar.

Encargos:botón plegado por defecto,despliega texto con fondo. No elimina objetivos, no cambia misiones/recompensas. Indicador RadialGauge compartido oculta cuando no capaz;energía sigue. Frontera actualiza capacidad desde caballo seleccionado.

WorldFence compartido para rancho y zona de prueba:colisión rectangular orientada continua entre postes,capa32saltable,puertas existentes omitidas. Visuales con fragmentos8pxdel MISMOarte,ordenYlocal. Antes cada tramo se ordenaba por poste inicial y la colisión cubría solo postes. No nuevos sprites. Arte de cercados incrustado en ilustración del granero no se segmenta automáticamente;las paredes del granero siguen sólidas, no saltables.

Pivote jinete:Frontera conservaba cascos44pxpor debajo del origen de física/y-sort. Corregido offset visual de sprite para alinear cascos al suelo físico, no escala de cuerpo ni estadísticas. Marcador de ocultación sube44pxen consecuencia. Afecta colocación visual respecto a posiciones guardadas, no cambia coordenadas guardadas por sí solo. Si un guardado queda dentro de un raíl nuevo,clear_spawn busca desplazamiento libre más cercano12..48pxantes de revelar;solo si hay solape con valla,no teletransporta rutas ni atraviesa paredes. Si no encuentra hueco,retornafalse,documentar para casos de edición extrema.

HorseJumpMotion extrae regla del corral para ambos actores. Ray62pxdetecta valla,caballo capaz a>60px/sinicia salto automático;se mantiene duración0,68s/distancia180pxdel corral. Prueba cuerpo en aterrizaje y corredor de obstáculos no saltables,máscara de valla ignorada solo en vuelo;escala,pivote,z-indexycolisión restaurados al aterrizar/interrumpirse. Z30durante vuelo para no quedar detrás de rail. No salta árboles/paredes. Frontera usa framesjumpclásicos existentes,no arte nuevo.

Cabras siguenNode2Dno bloqueantes para jugador,pero cruce de valla dispara arco visual0,48s/28pxusando arte existente y profundidad sobre raíl. No es animación raster nueva. Cerdos frenan paso que intersecta raíl;caballos salvajes usan colisión física32. No se les concede salto.

QA final:475/475unitarias,57210aserciones;7/7integraciones dirigidas57aserciones(casa,lazo,vallas,capacidad,UI,pivote,recuperación local guardado);salto corral8/8,55aserciones. Avisos de fixtures/orphanspersisten,no se afirma sinwarnings. Vídeo controlado de componentes reales9s,imágenes deHUDabierto/cerrado revisadas. No Androidreal,sinAPK,nueva release solo de material de preview. Queda revisión de Ant.
