# Rancho Prueba 2.7.89

APK conjunto desde `feat/open-world-test-20261107`, sin cambios en main. Incluye las previews nominal98, marcador99, montañas103, cerdos104, florista105 y mapa106 posteriores al APK2.7.88. Autorización de Ant de 12/11/2026 09:34:48 aplicada a este único APK.

## Incluido

- Marcador del jugador de tamaño fijo en pantalla y mapa encuadrado al abrir.
- Generador V3 SOLO para mundos nuevos: cordilleras por chunks con colisión de jinete/caballo/cerdo/cabra, puertos provisionales160unidades y red conectada sin circuitos. Posiciones de edificios/ramales variables por semilla. Siempre rancho, granjero y floristería accesibles. Granjero/tablón/hogar siguen posiciones nuevas. Arte de montaña geométrico provisional por código.
- Mundos V1/V2 mantienen su generador y progreso. V3 no se añade por encima de un guardado antiguo. No hay selector de varias partidas todavía: no borres tu partida para probar V3.
- Cerdos individuales: inventario real, total en aviso español, historial por ID y captura parcial sin respawn. Los +40puntos por captura que ya existían siguen. Venta opcional al granjero con precio previo propuesto40puntos/cerdo, cantidad y total. Cerrar conserva animales. Operación de guardado con rollback si falla. No hay pagos retroactivos inventados donde el guardado antiguo carece de IDs.
- Sin cupo artificial de almacenamiento de caballos/cerdos/cabras. Cabras individuales registradas; la población actual sigue siendo tres del prototipo, no se han añadido rebaños regionales ilimitados.
- Florista con dos encargos consecutivos: tres flores azules, tres doradas. Muestra de flor en diálogo y Encargos, aura distintiva, icono mini/mapa. Recoger al pasar encima sin lazo. Progreso guardado y sin doble recogida. Arte de flor/aura provisional por código.
- Notas en mapa: pulsación larga0,6s crea/edita, texto hasta240caracteres, marca dorada, borrado y foto local opcional de la vista del mundo al abrir mapa. Reabrir muestra miniatura. Icono lugar/caballo automático. Caballo vinculado por ID sigue reapareciendo en su zona por semilla si no se captura; no conserva pose exacta ni punto de huida. Las fotos no se suben.
- Zoom dorado+/- con slider0,5-32x y valor, arrastre táctil explícito, límites por eje y terreno recortado fuera de los botones. Dibujo retenido durante arrastre y LOD distante; jinete inmóvil/interacción pausada con mapa o nota abiertos. X/volver cierra, toque corto en mapa grande ya no lo cierra accidentalmente.
- Textos españoles existentes revisados y nuevos mensajes traducidos. La opción automática sigue el idioma del sistema; para forzar español usa la opción de idioma del juego.

## Validación

- Unitarias finales535/535, 1.586.460aserciones.
- Regresión pertinente de Frontera11/11: nominalV1/V2, huida, floristería anterior, NPC, caché de mapa, montañas, cerdos, flores y notas.1.257aserciones.
- Entrada real de pantalla con render: mapa de arena y bullet time6/6,27aserciones. Esas pruebas fallaban headless sin render; con render pasan. No se afirma que se ejecutó toda la suite de campaña.
- Nueva prueba de notas: evento ScreenTouch/pulsación larga, guardar/cargar, mismo ID/rasgos del caballo, eliminar. Una prueba de captura real de cerdo demuestra inventario1/+40puntos y reconstrucción sin respawn del ID.
- Montañas: 1.000semillas,381redes del núcleo y54disposiciones de edificios en muestra. Conectividad/puertas/puertos y colisión real del jinete+animales comprobadas.
- Cerdos/cabras: 10.000IDs de cada especie guardados/leídos sin cupo artificial; duplicados y errores de escritura con rollback probados.
- Mapa10.000chunks sintéticos100x100, escritorio llvmpipe: reconstrucción+primer render190,691ms con montañas y caché.120eventos cortos de arrastre0,137msCPU total, sin reconstrucción durante ese tramo. No equivale a FPSAndroid ni elimina coste al terminar arrastre.
- Capturas reales de escritorio1598x720 y896x414 inspeccionadas: núcleo, montañas, precio/venta, aura/encargos, nota/foto y zoom. Se corrigieron problemas encontrados de superposición y recorte.896x414 NO es un teléfono físico.
- ExportAndroid Review completado. APK verifica firmaV2/V3 con mismo certificado que2.7.88; ZIP íntegro y nuevos recursos presentes. Manifest com.example.rancho.review, versionCode348, versionName2.7.89. Androidmínimo24,target36. El parser antiguo aapt avisa android:required, export y apksigner verifican.
- ADBsin dispositivo: no se afirma instalación, rendimiento, teclado ni control táctil en un Android físico. Los fixtures siguen avisando de recursos/objetos retenidos al cerrar; no se presenta el cierre como libre de avisos.

## Decisiones y trabajo pendientes

Precio final por cerdo y si varía entre pueblos; mantener o no captura+venta como dos recompensas; venta de cantidades parciales (ahora todo el inventario mostrado). Ancho final de puertos, arte/biomas y si el lanzamiento de lazo debe chocar con roca (el animal ya no la cruza). Rodeo inteligente de animales, nuevas cabras/pueblos regionales, premios y repetición de encargos de florista. Fotos recortadas/cámara propia e iconos manuales, etiquetas permanentes de notas y pose exacta de caballo. Varias partidas sigue en diseño.

Optimización para crecer sin techo sigue abierta: el mapa aún recorre metadatos de descubierto, verifica hash cada0,3s cuando está quieto y puede reconstruir al finalizar un arrastre; guardado completo e historial/ediciones/coordenadas float aún requieren índices espaciales, tiles/LOD multinivel, almacenamiento regional y origen flotante. No se ha impuesto un tamaño máximo del mundo ni se afirma resuelta toda su escalabilidad.

## Integridad

- SHA256 APK: `4b74c19795688561cbd95a7c2d8375a10abc3ebf382745899ff0dc55b46df260`
- Certificado SHA256: `46bdcb2213f8b82696b918f5cfd5764cd5690038ae2938aaec6f11bfffb79bbb`
