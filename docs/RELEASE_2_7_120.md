# Rancho Prueba 2.7.120

## Primer bloque de progresión exigente

### Encargos que se pueden repetir

- El granjero ofrece **Encargos del rancho**, separados de los encargos anteriores. No se borran los antiguos ni se reinician sus logros.
- Acepta el encargo, captura cinco cerdos nuevos y vuelve al granjero a cobrar400puntos. El siguiente pide cinco cabras nuevas. Después se alternan sin límite.
- Solo cuentan capturas posteriores a aceptar, una vez por ID. No se consume el inventario por cobrar. Los cerdos siguen pudiendo venderse aparte.
- Aceptación, capturas, recompensa y número de encargos cobrados se guardan juntos. Si falla el guardado se revierte la operación. Recargar no permite cobrar dos veces.
- El encargo permite capturar su animal con el mismo lazo del juego aunque todavía no se haya aceptado la misión histórica de esa especie. No se añade un sistema de captura paralelo.
- La pantalla muestra puntos, capturas y encargos cobrados; el panel de encargos del mundo muestra el objetivo activo. La nueva pantalla se ajusta a1280×720 y960×540.

### Premios futuros sin borrar lo ganado

- Las primeras victorias conservan sus premios. Las victorias posteriores del mismo nivel dan5% del premio, con mínimo10 y máximo400puntos. Repetir el nivel20 deja de producir8.500puntos cada vez: ahora da400.
- Futuras capturas de cabra:40puntos. Cerdos conservan40 al capturarlos y40 al venderlos. No se abonan nuevas recompensas retroactivas ni se resta saldo existente.
- No cambia los caballos, equipo ni objetos ya conseguidos. Se conserva la migración anterior de primeras victorias.

## Comprobado

- 638 pruebas unitarias, todas aprobadas.
- 114 pruebas de integración, 5.577 comprobaciones, todas aprobadas.
- Prueba real de interfaz: granjero, aceptación, cinco capturas, cobro, cambio a cabras, segundo cobro, vuelta al juego y pantalla pequeña. Capturas revisadas.
- Prueba real del lazo y captura de una cabra para el encargo nuevo sin aceptar la misión histórica. Se conserva también la secuencia histórica y el aislamiento del modo prueba.
- APK arm64 con paquete y firma conservados; versionCode379.

## Sigue pendiente

No activa todavía la compra o equipamiento de oro, cristal, hielo ni adornos oro/plata. Faltan sus otras poses y la tienda con requisitos. Tampoco añade niveles21-40, llaves, crecimiento normal ni ritual. La base de requisitos está documentada, pero no se presenta como contenido terminado.

La tabla de sensibilidad económica es una estimación con ritmos hipotéticos de capturas, no horas medidas jugando. Se probará el ritmo completo cuando los extras sean adquiribles.

Pruebas y capturas de escritorio, no certificación de rendimiento o tacto en un Android físico. Mantiene la siesta de2.7.119.
