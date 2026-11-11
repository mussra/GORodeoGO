# Preview de carga revisada, 11 noviembre 2026

Escena aislada: `tools/qa_loading_parade.tscn`. No cambia el menú, cargador real, APK, colección, semilla del mundo o guardado.

Deriva del jinete: x(t)=920-620*exp(-t/8.4). Empieza en x300, cruza el centro x640 a6,68s y se aproxima a x920. Siempre crece y frena; no resetea su posición al volver el bucle de cruces. Conserva margen derecho aun en esperas largas.

Listo simulado a18s. A partir de ese instante corre a230px/s y comienza el fundido inmediatamente, duración0,5s. Al terminar el fundido está en x962,3 aproximadamente, dentro de la pantalla de1280px. No espera su salida. En integración futura, el disparador será la disponibilidad real del mundo y no este temporizador de demostración.

Cruces: cerdo, cabra, granjero y caballo, orden e intervalos elegidos por RNG propio. Se reposicionan fuera de pantalla. Pelajes/patrones/crines son cosméticos con el arte compartido, sin escribir genes ni colección. `PARADE_SEED=411` reproduce el vídeo de muestra. Equipo del jinete no varía, pues está integrado en el arte disponible. Granjero estático con leve balanceo, sin ciclo propio de piernas.

El fondo de cierre es captura real regenerada de la rama, no mundo vivo en esta escena. Archivo JPEG incluido para que el prototipo sea reproducible. El vídeo de19,5s ilustra la desaceleración y fundido, no mide la carga ni certifica Android.

Revisión visual: imagen a12s, fotograma de fundido a18,2s, mundo a18,7s y vídeo muestreado. Render completo586frames, sin errores de script/recursos en el registro de esta escena. No APK ni release.
