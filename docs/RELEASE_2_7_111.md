# Rancho Prueba 2.7.111

## HECHO: guardado en la playa del país

Antonio comunicó desde Android real el aviso de guardado fallido en la orilla. Reproducido en escritorio: los pies físicos del jinete (18×10) podían llegar legalmente más cerca de la costa que el círculo conservador de radio18 usado para validar el guardado. La posición era legal, pero no se guardaba.

- Los puntos de control guardan el centro legal del jinete sin confundirlo con el margen de seguridad de una siesta.
- Al reabrir se reutiliza la consulta física del componente compartido de llegadas. Una posición legal junto a la orilla se recupera exactamente; no se aparta al jinete por el margen de viaje.
- El mar y los obstáculos siguen bloqueados. No se admite una posición cuyo centro está dentro de terreno sólido o fuera de la isla.
- Un fallo real al escribir sigue conservando el último punto guardado y reintenta. Cuando lo consigue, desaparece el aviso en ese mismo refresco.
- No cambia el formato del guardado, ni se borran visitas, exploración, caballos o progreso del mundo original.

## HECHO: espuma continua

La línea blanca del mar es una sola polilínea cerrada. Los vértices animados se comparten entre tramos; ya no hay saltos entre segmentos con distintos desplazamientos.

## Verificación

622 pruebas unitarias y72 de integración dirigidas pasan:2.556.804 +3.455 comprobaciones. Nueva prueba con contacto físico real en la costa, fallo de escritura simulado, reintento, desaparición del aviso y recarga en frío exactamente en la misma posición. Conserva3sitios, exploración, colección y misiones originales. Capturas inspeccionadas en pantalla ancha.

Validación de escritorio, no móvil físico. APK arm64, mismo paquete y firma,versionCode370. No publica en tienda. La sustitución del mapa del país por los componentes compartidos de Frontera está pendiente del siguiente bloque, no se presenta como terminada aquí.
