# Rancho Prueba 2.7.153

## Piloto: Huerto de Lucía
Una parcela y una variedad de zanahoria. En Frontera, habla con la florista y pulsa "Huerto de Lucía · zanahorias". Ella presenta al hortelano que cuida la parcela cercana. La flecha indica cómo llegar al huerto y a la muestra silvestre.

1. Acércate a la parcela y acepta el huerto.
2. Recoge la zanahoria silvestre marcada para obtener una semilla.
3. Vuelve, siembra y riega. Explora a caballo para que crezca, sin esperas de reloj ni plantas que se marchiten.
4. Cosecha tres zanahorias y una semilla para volver a sembrar.
5. Da una zanahoria al caballo seleccionado. Su propiedad se revela tras la primera cosecha.

La zanahoria nutritiva reduce un 15% el gasto de resistencia al trotar o galopar durante 120 segundos activos en Frontera. No cambia genes, velocidad, recuperación de resistencia ni maestría. Un único alimento activo, ligado al caballo alimentado, sin acumulación ni sustitución hasta que termine. Fuera de Frontera o con la ventana del huerto abierta no corre el tiempo del alimento. Crecimiento por 900 unidades recorridas, no por tiempo fuera del juego. Sin compras ni créditos.

Guardado aditivo y versionado: conserva la parcela, las semillas, la cosecha y el alimento restante. Una acción que no puede guardarse no consume ni concede nada. Partidas anteriores sin huerto empiezan con el sistema bloqueado, sin reescribir el generador ni el progreso previo. Las herramientas de prueba no gastan ni conceden cosecha.

## Arte de Ant
Integradas las cinco fases de zanahoria de la primera hoja y las poses del hortelano: reposo, plantar, regar y cosecha en sus acciones. La pose de caminar queda preparada, pero el NPC no tiene recorrido animado en este piloto. Ojos ocultos por el sombrero. Fondo verde eliminado, incluidas las islas interiores entre el brazo y la zanahoria y bajo la regadera. Hojas, ropa y gotas conservadas. Las otras especies de la hoja no se añaden en esta entrega.

## Verificación y límites
117/117 pruebas dirigidas, 984 comprobaciones, 20 scripts. Incluye ciclo completo, rechazo de acciones duplicadas o fuera de orden, toque nativo sintetizado en el botón de aceptar, cierre Atrás compartido, reanudación de controles, guardado fallido sin consumir cosecha, guardado/carga de alimento y posiciones, partida antigua sin la clave y rechazo de una versión futura para evitar sobrescribirla. Regresión de joysticks, mapas, notas, salto, carreras, justa y duelo.

Capturas reales de la escena inspeccionadas en 1280x720. La captura de cosecha usa una partida aislada con avance de crecimiento preparado para QA; no documenta una partida manual completa. No probado en Android físico. Siguen los avisos conocidos del ejecutor sobre decoración huérfana y recursos vivos al cerrar pruebas de mundo (10 nodos huérfanos; 2 recursos vivos al salir). No se presenta como prueba sin fugas.

Mismo paquete com.example.rancho.review y firma, versionCode412. Solo rama de pruebas; main intacta. No se cambia estructura, progresión, regla de maestría ni se implementa todavía diversidad genética vegetal.
