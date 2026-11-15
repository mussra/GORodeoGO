# Rancho Prueba 2.7.158

APK de prueba, misma aplicación y firma. Rama `feat/open-world-test-20261107`; sin cambios en main ni tienda.

## Carreras

- El caballo alcanzado por el lazo se para realmente durante 1 segundo. Se aplica al jugador y a los rivales. No hay toros en este modo.
- Sustituye el freno anterior al 75% durante 1,2 segundos. Cancela el sprint en curso y no permite usar otro para saltarse la parada.
- Al terminar puede volver a moverse, sin salto de posición ni impulso guardado. La protección posterior de 3,2 segundos desde el impacto se mantiene para impedir paradas encadenadas.
- La pausa no consume el segundo. El aviso dice "ENLAZADO · PARADO" y muestra el tiempo restante.
- No cambia Justa, Duelo ni el aturdimiento de los otros modos.

## Pueblos

- Segundo pueblo visitado: el loco explica que cerca hay caballos salvajes parecidos al pueblo y nombra su patrón y colores. No habla de caballos ni zonas ya explorados.
- Tercer pueblo visitado: "Si quieres caballos diferentes, aléjate de los pueblos."
- Los mensajes siguen el orden real de visita y se guardan. Si una partida ya guardaba tres visitas, se recupera su tercer pueblo del historial. Las partidas antiguas sin orden conservan el criterio de siguientes visitas nuevas, sin inventar el pasado.
- Comprobado con terreno lejano generado: fuera de la influencia de todos los pueblos, la población coincide exactamente con el generador aleatorio original y conserva variedad de capas y patrones.
- No cambia el equilibrio regional 70/60 ni la dificultad de los niveles 15-19. Se preparan alternativas por separado para decidirlas.

## Verificación

105 casos dirigidos de regresión, 103 aprobados y 2 fallos heredados de carreras que también se reproducen en 2.7.156 bajo las mismas condiciones. No se relajan expectativas para declararlos aprobados. Pruebas de parada (jugador y rival), impacto de vuelo real, bloqueo del sprint, protección, pausa, reanudación, diálogos segundo/tercero, persistencia, fauna lejana, copa, controles, pueblos y doma.

Inspeccionadas capturas del segundo y tercer pueblo a 960×540 y del estado parado en carreras. Los textos están completos y el minimapa sigue visible. La captura de carrera es una escena QA preparada para mostrar el estado, no una prueba de tacto en teléfono.

No se ha repetido toda la batería de 285 scripts de 2.7.157. Aquella batería no estaba completamente verde; esta entrega no pretende corregir toda esa deuda. Siguen avisos menores de recursos al cerrar pruebas. Sin Android físico: pendientes sensaciones, tacto y rendimiento real en dispositivo.

## Archivo

- Paquete `com.example.rancho.review`, versión Android 417.
- 82194377 bytes.
- SHA-256: `71ec2af5b012c24358d75b7168605b6e37e061c939e14c3b1419133dd936b26f`.
- Certificado SHA-256: `46bdcb2213f8b82696b918f5cfd5764cd5690038ae2938aaec6f11bfffb79bbb` (el mismo que 2.7.157).
