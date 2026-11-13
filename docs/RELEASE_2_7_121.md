# Rancho Prueba 2.7.121

## Oro brillante, cristal e hielo ya se pueden conseguir

Menú principal → Equipo → Acabados especiales.

| Acabado | Puntos | Cerdos capturados | Cabras capturadas | Encargos del rancho cobrados |
| --- | ---: | ---: | ---: | ---: |
| Oro brillante |24.000|80|60|16|
| Cristal |42.000|160|120|32|
| Hielo |66.000|280|220|56|

- Hay que cumplir todos los requisitos. Un saldo antiguo grande no evita capturar animales y hacer encargos. Las capturas antiguas válidas cuentan; no hay que repetirlas.
- Solo se gastan los puntos de la compra. Capturas y encargos son logros acumulados, no se consumen.
- Se compra una vez el acabado. Después se puede equipar en caballos adultos propios, uno por caballo, o quitarlo sin coste. La ficha guarda qué acabado lleva cada caballo.
- Son complementos visuales. No cambian genes, ascendencia, maestría, salto o estadísticas; no se heredan automáticamente y no sustituyen al Galaxy genético.
- Comprar y equipar son acciones separadas. Un fallo de guardado revierte el cobro o el cambio. No se puede comprar dos veces el mismo acabado.
- El botón de comprar no se habilita hasta cumplir los requisitos; la pantalla muestra tanto el progreso actual como los requisitos.

## Cobertura visual

Se reutilizan los materiales y máscaras existentes. Oro con brillo móvil, cristal translúcido con facetas e hielo con escarcha. El jinete, su ropa y sus ojos ocultos se conservan.

Aplicado al retrato, cinco direcciones de marcha montada, cinco direcciones sin jinete en la vista del caballo, cinco saltos, golpe y reposo/beber. Comprobadas133poses fuente con dimensiones de máscara/UV y láminas visuales de todos sus fotogramas. El mismo renderizado de montura se usa en niveles, Frontera y país.

## Comprobado

- 644/644 pruebas unitarias, 2.557.815 comprobaciones.
- 117/117 pruebas de integración, 5.774 comprobaciones.
- Compra de los tres acabados, equipamiento, recarga, requisitos insuficientes, modo prueba, cría no adulta, guardado fallido y recuperación del aspecto original.
- Material aplicado a todos los fotogramas de las animaciones de un jugador real; capturas en Frontera de las tres variantes. Tienda revisada a1280×720 y960×540.
- APK arm64, mismo paquete y firma, versionCode380.

## Límites y trabajo pendiente

No incluye todavía adornos oro/plata en patas y botas, niveles21-40, llaves Galaxy, crecimiento normal ni ritual. No se da por terminada toda la aceptación de diseños.

El ritmo económico se calcula con hipótesis de capturas por hora, no con horas medidas en una partida completa. Estos precios y requisitos evitan comprar todos los extras solo repitiendo unas pocas veces el nivel20, pero se seguirá probando la experiencia.

Comprobado en escritorio. Rendimiento, tacto y legibilidad en un Android físico siguen pendientes.
