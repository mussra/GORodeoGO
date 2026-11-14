# Rancho Prueba 2.7.138

Avance de pruebas Android, no versión de tienda. Rama `feat/open-world-test-20261107`; `main` sin cambios.

## Carreras más claras
- Mapa del circuito real, siempre visible: recorrido, dirección, meta, próxima puerta, vallas y cuatro participantes. Tocar amplía el mapa y pausa; volver lo cierra sin disparar el lazo.
- Pista con bordes alternos, tierra, rodadas, vegetación, salida a cuadros y señales del paso lateral. Vallas con doble travesaño y postes, usando el componente y las texturas existentes; la colisión no cambia.
- Clasificación, porcentaje de vuelta, velocidad de juego y estado del lazo/regate. Cámara que se abre gradualmente al galopar y aviso de un lazo entrante.
- Al ganar aparece el diálogo compartido del granjero, con una pista distinta por circuito. Texto completo desplazable cuando hace falta.

## Fallos corregidos
- Los jinetes de carreras usan movimiento cenital: una valla diagonal ya no se interpreta como pendiente y no bloquea a los rivales sin salto. Reproducción y prueba automática en Curvas del valle.
- El mapa ignora el ratón emulado por un toque, evitando dobles aperturas/cierres.
- La IA puede reaccionar a un lazo en vuelo sin esperar al siguiente turno de ataque. Calcula una anticipación sencilla del objetivo y conserva el mismo vuelo compartido de 0,35 s.
- Otra carrera repite el circuito elegido sin volver innecesariamente al selector.
- Consulta de distancias más ligera, sin alterar puertas, ancho, trazado ni velocidad igualada.

## Validación
- 711 pruebas unitarias aprobadas.
- 100 pruebas dirigidas de integración aprobadas, incluidas entrada táctil simulada, mapa/pausa, diálogo sin cambios de progreso, vallas/salto, lazo y recuperación del atasco diagonal.
- Seis simulaciones completas a paso de física normal: tres pistas con y sin salto; cuatro participantes cruzan las 16 puertas en cada una. Sin teletransporte de recuperación ni escrituras de partida.
- Revisión visual de la carrera, controles, vuelo, mapa ampliado, resultado y diálogo a 960x540, más vista ancha.
- APK arm64: paquete `com.example.rancho.review`, versionCode 397 y misma firma que las pruebas anteriores.

Las pruebas se hicieron en escritorio. Falta probar instalación, legibilidad, tacto y rendimiento en un Android real. Siguen algunos avisos de limpieza al cerrar los bancos de pruebas; no se presentan como certificación de producción.

No se han añadido cobros, premios, caballos desbloqueados, cambios genéticos ni progreso persistente. La web no se publica.
