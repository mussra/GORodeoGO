# Rancho Prueba2.7.122

## Adornos de oro y plata para patas y botas

Menú principal → Equipo → Adornos de oro y plata.

| Metal | Puntos | Cerdos capturados | Cabras capturadas | Encargos cobrados |
| --- | ---: | ---: | ---: | ---: |
| Plata |6.000|20|15|4|
| Oro |12.000|40|30|8|

- Hay que cumplir todos los requisitos. Solo se gastan puntos; capturas y encargos son logros acumulados que se conservan.
- Una compra desbloquea ese metal tanto para patas como para botas. Comprar no equipa automáticamente.
- Se puede equipar en ambos, solo patas o solo botas de cada caballo adulto propio. También combinar oro y plata entre las dos zonas o quitar cada una por separado sin coste.
- No se modifica el caballo genético, sus estadísticas, ascendencia, nombre ni maestría. No se heredan automáticamente estos complementos. Los acabados especiales de2.7.121 pueden combinarse con ellos.
- No se cobra dos veces el mismo metal. Un fallo al guardar revierte el cobro o el cambio de equipado. El modo prueba no permite comprar ni cambiar complementos persistentes.

## Cobertura compartida

Máscaras derivadas de los dibujos originales, sin crear ni sustituir arte fuente. Bandas estrechas sobre las patas visibles y detalles de puño/puntera de botas, no sobre pantalón, ojos o cara del caballo. Algunas patas quedan ocultas por la cola en poses de espaldas: no se pintan por encima de ella.

Retrato, cinco direcciones montadas y sin jinete en la vista de caballo, saltos, golpe y reposo/beber. Un mismo material de metal sirve para ambos y convive con el acabado de oro/cristal/hielo. Compartido por niveles, Frontera y país.

## Verificación

- 648/648pruebas unitarias,2.558.296comprobaciones.
- 120/120pruebas de integración,6.504comprobaciones.
- 133poses fuente con máscara del tamaño correcto, regiones sin solapamiento y sin píxeles fuera de la silueta.
- Seis láminas de todas las poses en oro/plata/mezcla con hielo revisadas visualmente.
- Compra real de ambos metales, equipado mixto, retirada, recarga, requisitos insuficientes, compra repetida, cría/no propietario, modo prueba y guardado fallido.
- Tienda a1280×720y960×540 y actor real con ambos metales y acabado de hielo.

Capturas de simulación con saldo/logros preparados únicamente para comprobar la tienda. No son progreso del usuario. Pruebas de escritorio, no certifican rendimiento, tacto o legibilidad en un Android físico.

Se mantienen siesta2.7.119, encargos2.7.120 y acabados2.7.121. Pendiente: niveles21-40, llaves, ajustes de la cadena Galaxy, crecimiento normal y ritual. Este bloque no da por finalizado todo el diseño aceptado.

Paquete com.example.rancho.review,arm64,versionCode381. Misma firma de Rancho Prueba para actualizar sin desinstalar. Rama feat/open-world-test-20261107; main intacta. Sin publicación en tienda.
