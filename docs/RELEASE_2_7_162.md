# Rancho Prueba 2.7.162

## Correcciones
- El tablón muestra el encargo aceptado al granjero, además de la manada que ya estuviera asignada.
- Se ven los cerdos/cabras, el progreso y la dirección y distancia al animal cargado más cercano. Si no hay uno cargado, no se inventa un destino.
- El encargo repetible de cinco animales también aparece y cuenta en las misiones activas. El progreso sigue ahí al guardar y recargar.
- Los encargos terminados pendientes de agradecer se conservan sin asignar de oficio otra manada. Las flores indican buscar el aura en el mapa.
- El músico usa la misma profundidad por los pies que el jinete, en lugar de una capa fija por encima.

## Conservación
Sin migración de pueblos, sin cambios de distancia ni murallas y sin recolorear manadas o colección. Esas decisiones siguen abiertas. Huerto y maestría no se modifican. Main y distribución en tiendas no se tocan.

## Comprobaciones y límites
102/102 pruebas de integración dirigidas, 1.147 aserciones en 20 scripts. Incluyen aceptación real por diálogo, encargo repetible por su panel, captura/progreso, guardado y recarga, convivencia con misión de manada y profundidad del músico. Capturas del motor inspeccionadas a 960 × 540. APK exportado y firma verificada; no ejecutado en un teléfono Android físico. El cierre de las pruebas deja avisos de 11 CanvasItem, 16 ObjectDB y 2 recursos; no se ocultan como una ejecución sin avisos.

Instalar encima de Rancho Prueba, sin desinstalar. Paquete com.example.rancho.review, código 421, misma firma que 2.7.161.
