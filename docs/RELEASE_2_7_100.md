# Rancho Prueba 2.7.100

## Hecho: Serenidad conectada a las capturas

La Serenidad ya existía en las estadísticas, pero no llegaba al controlador de toros. También había quedado fuera del llenado de confianza con lazo al retirar la confianza pasiva del mundo.

- Toros: la Serenidad del caballo equipado multiplica la velocidad de reducción de nervios mientras está enlazado.
- Caballos salvajes: la misma Serenidad multiplica el llenado de confianza con lazo, conservando temperamento y afinidad genética.
- Se usan los límites existentes del atributo, ×0,5 a ×2, con ×1 como valor base. Caballos antiguos sin este atributo mantienen el ritmo base anterior. Valores inválidos usan la base.
- El valor procede de la colección equipada en ambos modos, no del color ni de la rareza.
- No se modifica el recurso compartido de ajuste de toros al aplicar el atributo.

## Reglas conservadas

No hay confianza pasiva. Sin lazo no se captura ningún caballo. Serenidad no salta la familiaridad exigida por un semental desconfiado. No reduce las molestias causadas por otros toros, no evita escapes, no cambia el tranquilizante y no evita el aturdimiento ni la pérdida de capturas al chocar con un toro salvaje. No cambia precios, premios, compras ni las reglas de captura de cerdos/cabras.

Con el ajuste base del toro, tras tres segundos de lazo sin molestias quedan 82, 64 o 28 puntos de nervios usando Serenidad ×0,5, ×1 o ×2, respectivamente. Son capturas de una simulación controlada, no una medida tomada en Android físico.

## Pruebas

- 594/594 pruebas unitarias, 2.556.347 aserciones.
- 28/28 pruebas de integración en siete scripts relacionados, 152 aserciones: Serenidad real en nivel/mundo, lazo del mundo, aturdimiento, cuerdas, animación del toro, Mi rancho y persistencia de manadas.
- El script antiguo de capacidad/seguimiento pasa 8/9 pruebas. La restante consulta un campo del HUD retirado. Al restaurar todo el código modificado a 2.7.99 vuelve a fallar igual; es deuda de la prueba, no una regresión nueva.
- Nueve pruebas nuevas entre unidad e integración comprueban límites, tiempos, molestias, escapes, la fuente del caballo equipado y el contacto real con toro salvaje.
- Capturas de las tres Serenidades renderizadas e inspeccionadas en escritorio.
- Persisten los avisos de recursos de las suites anteriores; no se presentan como solucionados.

## APK

- Paquete `com.example.rancho.review`, versionCode 359, arm64, Android 7.0 o posterior.
- 69.663.891 bytes. SHA-256: `fb94ab1cc10b5f5efc9d976c8ae810c69f6528beafa44944d0b60f6af2588276`.
- Firma V2/V3 verificada con el certificado de las versiones anteriores.
- Solo rama de pruebas, sin cambiar main ni publicar en tienda. Instalar encima sin desinstalar.
- No probado en teléfono Android físico.
