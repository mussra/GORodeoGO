# Revisión nocturna de Rancho, 15-16 noviembre 2026

## Acceso y progresión observados
- Rodeo de toros: nivel 1 inicial; cada victoria habilita el siguiente, hasta 40. DEBUG usa progreso separado.
- Carreras: accesible desde Juegos sin nivel previo; cuatro circuitos libres sin premio. El salto depende del caballo; las vallas tienen paso lateral.
- Copa: se entra desde Carreras. 32 objetivos en orden; registro separado y premio final transaccional ya existente. Una sesión temporal no puede usar progreso guardado de Copa.
- Duelo: acceso libre, mejor de tres, lazo válido y sin daño.
- Justa: acceso libre, pasadas automáticas; sin captura no hay punto y se repite pasada.
- Hípica de memoria: acceso libre, seis rondas de secuencias, salto del modo independiente de los genes del caballo.

No se cambian estos requisitos: se explican en Juegos.

## Decisiones aplicadas
Se conservaron los identificadores de ojos, colores, sombreros y estilos anteriores. El rosa nuevo es opción manual/de cría; se congeló la paleta histórica usada por los sorteos del mundo para evitar cambios colaterales. Se corrigió construcción y distribución del menú alternativo, sin reemplazar el menú principal ni cambiar su ruta. Se actualizaron pruebas antiguas que suponían 20 colores/20 niveles, reacción del bot al lazo (ahora planificada) o ampliación de mapa al pulsar (ahora al soltar), preservando las conductas actuales. Fixtures aislados del estado de otros tests.

## Rendimiento medido
Ver `night169-performance.json`: muestra corta, ventana Linux con llvmpipe, no móvil. Construcción de escenas: Carreras 297 ms; Duelo 65 ms; Justa 68 ms; Hípica 64 ms. P95 por fotograma aproximado: 35/22/22/24 ms respectivamente, incluyendo el coste del entorno. Memoria estática informada por el motor: alrededor de 69-70 MB, no memoria total del proceso. Carga de mundo en benchmark existente: listo inicial 1,23 s y nueve chunks 9,17 s; sirve para priorizar perfilado, no para prometer un tiempo Android.

## Pendientes por impacto
1. Alta: actualización e instalación en Android real sin desinstalar; comprobar colección/guardados, dos dedos, pausa y vuelta a Juegos en cinco modos.
2. Media: completar integración larga por scripts aislados; no declarar aprobados los grupos que agotaron tiempo.
3. Media: perfilar carga del mundo en dispositivo y tras varios viajes, no solo una apertura; medir memoria del proceso y recursos retenidos.
4. Baja: comprobar idiomas y texto en pantallas pequeñas. La nota nueva de acceso está en español, como los nombres actuales de Juegos.
5. Requiere decisión: Instinto, nuevas mecánicas o requisitos de acceso, cambios de economía y rediseños grandes. No ejecutados.
