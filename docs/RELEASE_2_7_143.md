# Rancho Prueba 2.7.143

Justa sin regate, apuntado previo, cuenta atrás visible y dos músicas nuevas con el mismo instrumento. Incluye las correcciones de bloqueo, lazo e IA de 2.7.142. Rama `feat/open-world-test-20261107`; sin cambios en main, web ni tienda.

## Justa
- Regate desactivado para ambos jinetes solo en la justa. Ni doble toque, ni trazado, ni impulso directo, ni esquiva de la IA. No cambia la escala de tiempo.
- Se conserva galope automático, ajuste vertical y lazo. Carreras y duelo libre conservan su regate.

## Preparar el lazo antes de salir
- Justa y carreras muestran 3, 2, 1 grandes y luego ¡YA! antes de correr.
- Puedes apuntar durante la cuenta atrás con los caballos quietos. Mantener hasta salir permite lanzar al soltar después.
- Soltar antes de la salida cancela el gesto: no dispara antes ni encola un lanzamiento automático al llegar a cero.
- El duelo libre conserva sus reglas anteriores de preparación; no se ha ampliado este cambio sin petición.

## Música
Dos arreglos originales nuevos con notas individuales del mismo instrumento Ganjo CC0 que las músicas anteriores:
- Carreras: 156 BPM, 16 compases, bucle de 24,62 s, patrón más rápido.
- Justa y duelos: 132 BPM, 16 compases, bucle de 29,09 s, respuesta más espaciada.

Son temas distintos, no cambios de velocidad de una misma grabación. Se usa una sola voz de música con transición, pausa y silencio existentes. Antes estos modos pedían un contexto no registrado; ahora seleccionan sus pistas expresamente. Los temas de menú y partida anterior no cambian.

Tras la escucha de Ant se corrigieron solo ocho eventos de carreras: seis Sol# de la melodía sobre Mi menor a Sol natural, y dos Sol# de remate sobre Re a La. Se conservan tempo, ritmo, demás notas e instrumento. El tema de justa/duelo es idéntico al primer archivo enviado. Las muestras originales tienen su afinación natural; no se ha hecho una reafinación general ni se promete resolver toda impresión subjetiva. Silbido todavía NO incluido en el juego: se preparará como siguiente prueba separada.

WAV estéreo 48 kHz, pico aproximado -2,5 dBFS, sin muestras saturadas; extremos del bucle iguales. MP3 de escucha publicados aparte. Fuente instrumental y licencia verificadas; sin gasto. La aceptación auditiva final del arreglo corregido y del volumen en el móvil sigue pendiente.

## Validación
- 189/189 pruebas dirigidas en 30 scripts, 3.561 aserciones. Incluyen cuenta 3-2-1/YA, no movimiento ni lanzamiento prematuro, apuntado mantenido, dos dedos simulados, doble toque sin regate, regate conservado en carreras/duelo, música en una sola voz y longitud de bucles.
- 711/711 pruebas unitarias adicionales reejecutadas.
- Justa simulada completa 0-2 en dos pasadas, 9,92 s de juego, sin guardado. No demuestra balance humano.
- Inspección visual de cuenta atrás y apuntado de justa/carrera. Capturas preparadas para QA, no partida humana.

Falta Android físico y escucha del volumen con efectos reales. Persisten avisos de limpieza de algunos bancos de pruebas. No se ha aplicado un segundo parado: sigue pendiente aclarar si se refiere al tirador o al receptor del lazo.

APK arm64, `com.example.rancho.review`, versionCode 402, misma firma de pruebas.
