# Preview tras feedback Android2.7.82

11 noviembre2026. Rama feat/open-world-test-20261107. No APK ni release nueva, versión permanece2.7.82. Requiere feedback de preview antes de compilar.

## Lazo
La velocidad inicial suma vectorialmente la del caballo al soltarse: destino=origen+dirección*alcance+velocidad_caballo*tiempo_vuelo. Misma lógica en corral y Frontera, no copias. Velocidad en unidades del reloj del juego: tiempo bala afecta física/tween/temporizador juntos, sin dividir dos veces por escala temporal. Cambiar velocidad después de lanzar no teledirige el lazo. Proyección del objetivo de carga actualizada al mismo cálculo. No garantiza que el caballo nunca alcance el lazo si después acelera o lo lanza hacia atrás; sí evita adelantar el lanzamiento frontal manteniendo su velocidad inicial.

## Cerdo y cabra
AnimalFatigue compartido solo drena si está enlazado. Huir libre no drena; recupera incluso mientras huye. Ruptura por distancia/contacto comienza recuperación en ese mismo tick, preservando la fatiga restante. Los animales lejanos también recuperan aunque no se dibuje su movimiento. No cambia encargo requerido, recompensas, captura de agotados con lazo ni regla de soltar al recibir golpe.

## Carga: candidato experimental, no arreglo móvil certificado
Presupuesto cubierto12→8ms(tras comparar variante2ms); calentamiento repartido por frame; texturas del mismo jinete seleccionado precalentadas antes de crear mundo; mundo aún incompleto no se dibuja debajo de la cortina opaca. Recolor/upload por textura y creación de escena siguen siendo indivisibles. No traslado inseguro de nodos/cachés a otro hilo.

Comparativa real mismo escritorio con Vulkan por software, perfiles limpios, no grabación aFPSfijos:
2.7.82:8,64shasta listo; p5052,9ms,p9564,5ms,máximo186,2ms,2frames>100ms.
Candidato antes del último anclaje de pies:12,95s;p5038,2ms,p9557,5ms,máximo181,3ms,2frames>100ms. Hay menos trabajo habitual por frame y más espera total, sin eliminar las pausas máximas. No extrapolar Android ni prometer60FPS.

Archivo móvil recibido y confirmado2.7.82:214frames en14,115s,media15,16FPSdel grabador,mediana entrePTS65,99ms. Hueco codificado1,347sdesde1,144hasta2,491s. Prueba pausa de la grabación durante carga, no permite separar juego/grabador ni medirFPSreales del teléfono.

Cada carga escribe user://loading-last-profile.json y log con p50/p95/máximo/fase y conteos>50/100ms. No acceso público al archivo. Botón de copiar diagnóstico propuesto a main, aún no añadido.

Cruces ralentizados:1560pxen7,8s=200px/sen vez de312. Anclaje inferior compensado por frame con alfa>0,15, solo en pantalla de carga. Ciclo de animales9FPSen vez de4,68; jinete sigue al paso. Posición flotante basada en delta ya existía y se conserva.

## Puntos sobre sombrero
45frames inspeccionados. Limpieza reproducible tools/clean_rider_top_fringe.py, lista exacta en RIDER_FRINGE_AUDIT83.json. Cambiados5PNG,499pixels en zona superior: alfa1–8/255y punto aislado opaco side8(59,10). No arte nuevo ni cambios de máscaras, diseño o identidad. Lámina de45cabezas y vídeo renderizado inspeccionados. Test verifica la condición de limpieza, no equivale a afirmar que toda ilustración nunca puede mostrar otro artefacto en todas las GPU.

## Volver a casa
Antes tween de posición durante0,6spara cualquier distancia, causando viaje visible por todo mapa. Candidato: cubrir con la misma pantalla, preparar animación, soltar captura/cancelar acciones, posición directa HOME_POSbajo cortina, cargar9chunksdestino y revelar0,5s. Sin recorrer/descubrir intermedios. Guarda destino al terminar, no durante trayecto. Previene doble activación pendiente.

Prueba real desde(14000,160)hasta(0,160),9chunkslistos,velocidad0. Vídeo recortado muestra retorno, no la carga inicial. No Android real.

## QA
Unitarias completas con test de proyección:474/474,57207aserciones. Test de vuelo real nuevo normal/tiempo bala para ambos modos y test de vuelta:2/2,35aserciones. Frontera/lazo9/9,31aserciones. Fixture actualizado: el antiguo test exigía agotamiento huyendo libre y no abría el encargo obligatorio. No se quitó ningún gate de producción. Test de lazo nuevo fuerza velocidad constante para comprobar herencia; preview controlada usa componentes reales con movimiento guionizado, no es una partida libre.

Batería final repetida:474/474unitarias y2/2integraciones dirigidas(35aserciones). Confirmado por Ant a las12:14: volver a casa suelta el animal donde estaba, sin captura/transporte gratis. Pendiente: feedback de previews, diagnóstico móvil y posterior autorización para APK. No toda integración ni certificación móvil.

## Seguimiento12:20: fuentes concretas de pausas
Sondas temporales(no retenidas en producción): _build_hud82,3ms, de los cuales70,4ms eran JoystickAppearance generando dos texturas220pxque el VirtualJoystick nativo no consume. Se omite generación si ningún joystick tiene propiedades de textura, manteniendo compatibilidad con consumidores antiguos y mismos colores de tema. Otra sonda midió145,8msen change_scene_to_file(carga de recurso síncrona). Ahora ResourceLoader carga el PackedScene en segundo plano mientras se precalienta; nodos, escenas y cachés de juego siguen en hilo principal. Se espera estado LOADED antes de obtenerlo; si falla conserva ruta original para no atrapar cortina.

Con ambos cambios, nuevas mediciones reales de escritorio/software, perfiles de usuario distintos:
-2ms:13,59s,p5040,3ms,p9560,0ms,máximo92,9ms,0>100ms. Dos repeticiones tuvieron13,06/13,44sy máximos115,7/125,6msen fase prepare,1>100ms. No desaparece toda pausa ni es un dato Android.
-8ms:12,09s,p5043,1ms,p9562,4ms,máximo90,8ms,0>100ms.
-12ms:11,12s,p5043,5ms,p9565,8ms,máximo101,1ms,1>100ms.
Se conserva8mscomo candidato equilibrado, no certificación de mejora móvil. Los números anteriores de2mscon escena síncrona siguen arriba como comparación y no representan el código final. El mayor pico de escena se redujo, pero prepare/warm_selected todavía pueden producir>100msy la entrada sigue más larga que2.7.82.

QA final del candidato con carga de recurso en segundo plano y presupuesto8ms:475/475unitarias,57210aserciones; integración casa/velocidad2/2,35aserciones; frontera/lazo9/9,31aserciones. Suite unitaria sigue emitiendo avisos de orphans/leaks y error de guardado en fixture de entrenamiento; pasar aserciones no equivale a ausencia de esos avisos. Captura final de entrada real inspeccionada: actor visible y cortina retirada,9chunksactivos. Sin nuevo APK.
