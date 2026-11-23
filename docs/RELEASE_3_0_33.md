# Rancho Prueba 3.0.33

La recuperación de errores cosméticos detectados al cargar ya permite continuar con la partida corregida como partida activa, sin menú de ranuras.

1. Antes de escribir una corrección, se reserva una carpeta única y se copia el archivo original byte a byte. Se verifican los bytes y su SHA256. Nunca se reutiliza ni se borra una copia existente.
2. Solo se corrigen los campos de apariencia conocidos por el recuperador. Los índices desconocidos usan el valor por defecto: sin un color original válido no hay una distancia visual fiable para escoger otro. No se adivinan equivalencias.
3. Se modifica el contenido original, no una reexportación del progreso normalizado. Se conservan las demás secciones, incluidos datos que esta versión no conoce. El candidato se escribe en la carpeta de copia, se vuelve a leer y se comprueba que es idéntico al candidato esperado.
4. Una lectura independiente ejecuta las validaciones completas. Si falla la copia, la escritura o la validación, no se reemplaza el archivo activo. Solo tras superar las comprobaciones y verificar de nuevo el hash del original y de la copia se activa el candidato mediante reemplazo atómico.
5. Un aviso visible indica los campos cambiados, sus valores nuevos y la ruta de la copia original. La partida corregida puede seguir guardando y registrando capturas con normalidad.

IDs, parentescos, recibos, progreso, puntos, premios, acabados genéticos desconocidos y emblemas inválidos siguen protegidos. Esta recuperación no intenta arreglar corrupción arbitraria ni datos críticos. Los candidatos nuevos inválidos generados durante una sesión siguen rechazándose antes de escribir.

## Pruebas

125 pruebas y 60.286 aserciones, todas pasan. Los casos de copia y recuperación cubren original exacto, diferencia cosmética mínima, progreso y secciones desconocidas intactos, captura posterior, error crítico, fallo al crear la copia, fallo de validación del candidato y segunda reparación sin sobrescribir la primera copia y cambio del archivo original durante el proceso. También pasa el barrido independiente de 58.031 comprobaciones de generación y validación de 3.0.32.

Aviso y diagnóstico inspeccionados visualmente a 1280 × 720 con un color inválido simulado. Las pruebas usan únicamente archivos sintéticos aislados. No se ha abierto, cambiado ni borrado la partida de Ant. No se ha probado en Android físico ni simulado un corte eléctrico o disco lleno.

Mismo paquete de prueba `com.example.rancho.review`, nombre Rancho, versionCode 493 y misma firma. Instalar encima sin desinstalar ni borrar datos. Solo rama de prueba, sin cambios en main ni tienda.
