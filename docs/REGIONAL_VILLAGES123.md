# Pueblos y encargos por región

## Propuesta

Cada pueblo tiene identidad estable, granjero, florista, perfil de bioma y estado independiente. Los IDs no dependen del nombre visible ni de cuándo se carga un chunk. Un pueblo terminado nunca vuelve a ofrecer sus encargos; otro pueblo puede tener otros. Un mensaje fijo deja claro el cierre: "Aquí hemos terminado. Gracias por tu ayuda. Ya no tengo más encargos para ti en este pueblo."

Ejemplos, no parámetros definitivos:

- Pradera: granjero pide tres cerdos, florista tres flores azules. Campos con una especie azul, no flores de todos los tipos dispersas.
- Montaña: granjero pide tres cabras, florista pide una especie regional. Diez tipos florales disponibles en campos separados. Tener diez especies no implica automáticamente diez encargos.

Perfil y catálogo separan tipo de animal, lista de especies florales, objetivos, cantidades, requisitos y textos. Reutilizan aceptar/contar/completar y eventos únicos del flujo actual, no otro sistema de captura. Las flores usan arte existente, sin nuevos sprites. Los campos tienen distribución estable por semilla/pueblo/versión y se dibujan sin actualización por frame.

## Implementado en esta preview

- En V3 actual, diálogo final constante para el granjero y florista cuando todos SUS encargos existentes están terminados. Desaparece aceptar nuevo encargo; la venta de cerdos sigue aparte. No se borran estados, capturas, flores ni recompensas.
- V1/V2 conservan su flujo de diálogo previo. No cambia el generador.
- Contrato RegionalVillages123 de perfiles, NPC, definiciones y serialización separada/versionada por ID de pueblo. Pruebas comprueban independencia y persistencia del estado terminado tras serializar/deserializar.
- Renderer de campos regionales con paleta de uno o diez tipos. Preview aislada de perfiles, campos, encargo y cierre real de diálogo compartido.

## Lo que NO está activado aún

El V3 actual contiene un núcleo de rancho, dos casas y florista, pero no un generador de pueblos repetidos. Esta preview NO añade pueblos ni campos a partidas existentes, NO mueve objetivos de encargos activos, NO añade estados a SaveData y NO migra misiones existentes. El contrato de guardado está listo y probado de forma aislada, no conectado al archivo de partida. La etiqueta "Guardado: pueblo" de la imagen indica la clave propuesta, no un guardado nuevo real del jugador.

Los dos encargos actuales del granjero (cerdos, luego cabras) y dos de la florista (azules, luego doradas) se mantienen íntegros. Transformar el primer granjero en solo cerdos en una partida existente sin perder su misión de cabras necesita una decisión de migración. Recomiendo marcar el núcleo como pueblo heredado y conservar su cadena; nuevos pueblos siguen nuevos perfiles.

Para activar pueblos: registro estable de asentamientos con colocación y acceso validados en carretera V3; campos fuera de puertas y rocas/montañas; objetivos por pueblo/bioma; guardar por pueblo en una sección nueva; eventos restringidos a ese pueblo para que una misma captura no complete todas las misiones del mapa; streaming/culling; minimapa; pruebas de save/load y de completar cadenas entre pueblos. Nueva distribución debe tener versión propia y aplicarse a mapa nuevo o regiones aún no exploradas, no recolocar silenciosamente progreso.

Pendiente elegir: nombres, distancia/frecuencia de pueblos, qué perfil asignar por región, cantidad y variedad de encargos por NPC, recompensas, si capturas previas cuentan (recomiendo no), reposición de flores, y si los campos decorativos siempre son recogibles o solo los objetivos activos.

No se han modificado Galaxy, receta de unicornios, fuente ni catálogo de niveles. No APK por esta propuesta aislada sin pueblos activados; el cierre V3 queda listo para el siguiente avance jugable comprobado.
