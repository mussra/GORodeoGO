# Decisiones del ciclo 198

Peticiones actuales de Ant: quitar regate solo a justa; apuntar antes de correr y cuenta 3-2-1; dos canciones del mismo instrumento; corregir solo notas que chocan en carreras, antes del futuro silbido.

- Justa: regate deshabilitado simétricamente, incluida IA. No afecta carreras o duelo libre. Se reutiliza el movimiento y lazo, sin duplicarlos.
- Apuntar antes de salir en justa/carreras. Hay dos condiciones distintas: preparar y lanzar. Lanzar requiere salida; soltar pronto cancela, no dispara más tarde. Cuenta central no intercepta los dedos.
- Cuenta atrás de tres segundos de simulación, visible 3-2-1 y confirmación YA. No añade esperas entre objetivos ni bloqueos de calendario.
- Dos arreglos propios con el mismo Ganjo, 16 compases: carreras 156 BPM; justa/duelo 132 BPM. Una sola voz con fade y respeto a pausa/silencio. No cambia la música de menú ni niveles anteriores.
- Ant indicó notas que sonaban desafinadas en carreras. Revisión de secuencia: ocho Sol# fuera de Sol mayor. Se corrigen exactamente esos eventos (seis a Sol y dos a La). Tema de justa/duelo sin un solo byte cambiado. No se regraba, rearmoniza ni cambia el tempo.
- El instrumento es una grabación real con variaciones de afinación y armónicos. No se afirma que cambiar notas escritas sea una certificación auditiva. Escucha final del archivo corregido pendiente.
- Silbido: siguiente experimento separado y sin gasto; no incorporado en 2.7.143.

Fuentes verificadas: https://github.com/sfzinstruments/ganjo ; commit ccff5cd5cd3b513873a48994c07724d9d3c39e1c ; licencia CC0 https://raw.githubusercontent.com/sfzinstruments/ganjo/ccff5cd5cd3b513873a48994c07724d9d3c39e1c/LICENSE.md . La licencia coincide con la guardada anteriormente. Lista de muestras/URLs/hashes y métricas en audio/music/metrics198.json, secuencia reproducible en tools/audio/compose_race_duel198.py. Ningún archivo de fuentes se usa como prueba de aprobación del usuario.
