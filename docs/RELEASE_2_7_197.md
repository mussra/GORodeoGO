# Rancho Prueba 2.7.197

## Los toros recuperados vuelven al granjero
Cada toro asegurado en el corral del Rodeo queda registrado en el guardado de Frontera al devolverlo, sin esperar a ganar todo el nivel. Al volver al pueblo aparece en el corral del granjero junto al granero. Los lazos sueltos o toros todavía en camino no cuentan.

Se guarda una identidad por nivel y toro: repetir el mismo nivel no duplica sus animales. Se muestran hasta seis toros en dos filas, con recuento total siempre visible. Los demás permanecen contabilizados, sin generar cientos de cuerpos, colisiones ni animales capturables. Se reutilizan vallas y dibujo de WorldFence y el arte existente de los toros. En mundos antiguos se usa el cercado existente del rancho; en los nominales, un cercado junto al granero, fuera de la calle. No se alteran cerdos, cabras, premios o misiones.

No se inventa histórico: guardados anteriores no registraban cada toro devuelto. Se empiezan a incorporar desde esta versión; se pueden recuperar repitiendo niveles sin duplicaciones. Si falla el guardado, queda un registro pendiente y un aviso; el siguiente guardado correcto (incluido el de victoria) lo incorpora una sola vez. Ensayos aislados y DEBUG no suman toros.

Incluye Rodeo automático y diálogo del granjero de 196. Cadena posterior intacta: Rodeo 1 y dos pueblos para carreras, victorias posteriores sin cambios.

## Verificación
402/402 pruebas seleccionadas en dos bloques, 54.551 aserciones, 64 scripts. Incluye el evento real del nivel al devolver un toro, guardado/carga, duplicados, límite visual, ensayos/DEBUG, datos inválidos y recuperación tras fallo de escritura. Un aviso GUT y 21 deprecados entre ambos bloques; dos objetos al cierre. Se corrige además la liberación de constructores de chunks fuera del árbol al salir del mundo, reproducida al cerrar con un diálogo pendiente. Dos capturas inspeccionadas, seis visibles de nueve registrados y recuento igual tras recargar.

No Android físico ni toda la suite histórica. Mismo paquete/firma, versionCode456. Rama de pruebas; main/tienda sin cambios. Sin retirar sistemas ni gastos.
