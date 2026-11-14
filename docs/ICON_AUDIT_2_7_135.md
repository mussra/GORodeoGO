# Hoja de 12 reemplazos de Ant: auditoría 135

Original 1448×1086 RGBA, conservado.12 recortes sin números y con canal alfa. No se añadió fondo. Ningún icono nuevo inventado. La hoja sustituye piezas de la primera hoja, no añade habilidades ni altera progreso.

|Celda nueva|Antes|Estado|Uso|
|---|---|---|---|
|1|8|Integrada|Moneda completa en Mercado,60×60 control, dibujo ajustado 56×56.|
|2|34|Integrada|Mi posición en mapas compartidos de Frontera/país:24×28 px de pantalla, flecha gira con rumbo, aura dinámica intacta.|
|3|36|Integrada|Candado cerrado en mapa de corrales expandido,16×16. Mini-mapa pequeño conserva punto 5 px por legibilidad.|
|4|37|Integrada|Candado abierto distinto por forma y color, mismo tamaño. No cambia apertura/cierre real.|
|5|40|Integrada|Flor 6 pétalos en glifo compartido de UI/mundo. Color de pétalos conserva variantes de misión; centro crema y alfa intactos. En mapa 8 px conserva forma simple calculada.|
|6|41|Integrada|Rancho en mapa expandido y marcador de sitio visitado ranch:22×20, sin tapar su selección. Mini-mapa conserva símbolo simple.|
|7|47|Integrada|Doble lazo en celebración real de desbloqueo:control 100×70. Mantiene pulso y texto.|
|8|64|Integrada|Aro nativo de joystick en estilos normal/pulsado. Control 220 px, pomo 80 px intactos. No sustituye motor de gestos ni zonas. Alfa 0,65 normal/0,95 pulsado.|
|9|66|Referencia|Placa normal recortada y guardada, no aplicada ni estirada.|
|10|67|Referencia|Placa iluminada recortada, no aplicada.|
|11|68|Referencia|Placa pulsada recortada, no aplicada.|
|12|69|Referencia|Placa deshabilitada recortada, no aplicada.|

## Límite de las placas
Sus recortes miden aproximadamente 334×183, no la proporción de un botón largo de la interfaz. Se guardan como referencia de estilo, según la instrucción recibida. No se estiran, no se fingió una división de nueve parches. El estilo de botones actual sigue escalando correctamente y no cambia su área táctil.

## Verificación
701/701 unitarias completas (377+324).59/59 dirigidas GL,1393 aserciones. Incluyen mapa táctil, pausa, no lanzamiento accidental, notas/fotos, flores/misiones, tamaño del marcador, estilo nativo del aro/pomo, conservación de relojes y placas, tintado de pétalos/centro y alfa.

Capturas inspeccionadas antes/después a 960×540: Mercado, mapa del país y mapa de Frontera con rancho, cuatro rumbos, flores de tres colores, candados cerrado/abierto en mapa expandido, joysticks pulsados/soltados y celebración real de doble lazo. El aro sigue el dedo y desaparece al soltar como antes. Fuente y todos los recortes conservados. Ninguna celda requiere regeneración para estos usos;9-12 quedan como referencia. Solo simulación de escritorio, no Android físico. Persisten avisos conocidos de recursos al cerrar pruebas.
