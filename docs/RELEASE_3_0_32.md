# Rancho Prueba 3.0.32

Auditoría de generación, lectura y guardado, en la rama de prueba. No se ha cambiado main ni publicado en tienda.

## Cambios

- La identidad de los pueblos ya no recorta el índice válido 20 de la paleta a 19. Se conserva la generación histórica del mundo, sin cambiar sus semillas.
- Si hay índices de apariencia desconocidos en caballos o manadas, se sustituyen por un valor por defecto solo en memoria. Un aviso visible explica lo ocurrido una vez por archivo y ejecución. El original queda intacto y todo guardado permanece protegido. No se crea ningún archivo de recuperación.
- Se cubren pelaje, dibujo, crin, ojos, manchas, patas y estilos de color. También colores de pueblos y color de sombrero. No se reparan IDs, parentescos, progreso ni premios; un acabado genético desconocido o emblema inválido sigue bloqueado.
- Las cabras, igual que los cerdos, se sueltan si falla el guardado de su captura. No dan puntos, no suena victoria y no vuelven a intentarlo cada frame. Se puede volver a enlazarlas para reintentar. Los duplicados ya registrados no dan otra recompensa.
- Flores y objetivos de pueblo conservan su estado al fallar el guardado. Avisan y no reintentan hasta que el jugador se aleje y vuelva.
- Se comprueban los datos nuevos antes de reemplazar el archivo: caballos, manadas, victorias, países, versiones, inventarios y posición. Un índice inválido ya no llega al generador de diseños de sombrero antes de detectarse.
- Se protegen las lecturas con puntos negativos o mal tipados, capturas vacías o duplicadas, posición no finita e inventarios imposibles. No se sustituyen silenciosamente por cero.
- El escritor de posiciones de caballos rechaza los mismos IDs, índices y límites que su lector. Las ediciones del mundo rechazan posiciones infinitas/NaN y recuentos mal tipados.
- El huerto no genera una cosecha que su propio lector truncaría al llegar al límite. Si no cabe la cosecha completa, conserva la planta y el inventario sin cambios.
- El diagnóstico añade G04 (recuperación visual en memoria), G05 (candidato inválido), G28–G32 (datos críticos, capturas, posición e inventarios).

## Verificación

118 pruebas automatizadas, 60.232 aserciones, todas pasan. Batería adicional independiente con:

- 288 parejas de semilla/versión, entre las seis versiones de generación; 1.440 chunks y 1.252 apariencias de caballos salvajes.
- Las 49.896 combinaciones básicas de pelaje, dibujo, crin y ojos; 264 combinaciones de campos opcionales, estilos y acabados; límites inválidos explícitos.
- 2.000 cruces con validación de colección, 60 niveles de ofertas del mercado y 24 ciclos completos de escritura, lectura y captura de cerdo y cabra.
- 288 entradas, movimientos y salidas de países; 300 victorias, encargos y jardín.
- Fallos de lectura, colores desconocidos, parentescos rotos, versiones desconocidas, índices fuera de rango y errores de escritura. Comparación byte a byte del archivo sintético protegido.

Se inspeccionaron las capturas reales del aviso y diagnóstico a 1280 × 720. APK firmado y verificado con el mismo paquete y certificado, versionCode 492. No se ha probado esta versión en un teléfono físico. No es una demostración exhaustiva de todas las partidas ni de todos los fallos posibles del sistema de archivos. Algunas pruebas antiguas que borran archivos se excluyeron para respetar la instrucción de no borrar.

Los archivos usados son pruebas sintéticas aisladas. No se ha borrado ni modificado la partida de Ant. Para guardar una recuperación cosmética en una copia separada hará falta su aprobación; de momento solo se lee en memoria.

## Instalación

Instalar encima de la versión de prueba habitual. No desinstalar ni borrar datos. Nombre visible: Rancho. Paquete: `com.example.rancho.review`.
