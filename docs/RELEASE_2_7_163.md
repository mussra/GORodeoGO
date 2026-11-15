# Rancho Prueba 2.7.163

## Caballos del pueblo
- Cada caballo salvaje dentro del radio de influencia de un pueblo lleva al menos uno de sus dos rasgos: el pelaje o el dibujo (estrellas, jirafa o liso según el pueblo). Se conserva variedad en el otro rasgo y en el color de las manchas.
- Si se cruzan las influencias de dos pueblos, manda el más cercano a cada individuo. Fuera del radio existente de 3.000 unidades no se modifica la población original.
- También se actualizan las manadas salvajes ya descubiertas al cargarlas, y los caballos desplazados al recuperar su manada de origen. La apariencia se guarda y no vuelve a sortearse al regresar.
- Los individuos capturados se excluyen, no sus hermanos salvajes. No se cambia la colección, los IDs, las estadísticas, las misiones ni las posiciones guardadas.

## Comprobación
104/104 pruebas de integración, 1.166 aserciones en 21 scripts. Otras 18/18 pruebas de afinidad e identidad, 6.616 aserciones: todos los individuos cercanos llevan al menos un rasgo, incluso en el borde del radio; solapamiento, variedad, migración de política anterior, captura parcial, guardado/recarga y fallo de guardado con restauración del estado anterior. Capturas del motor antes/después inspeccionadas. APK exportado y firma verificada. No se ha ejecutado en un teléfono Android físico. El cierre de la regresión deja avisos de 9 CanvasItem, 12 ObjectDB y 2 recursos.

## Pendiente y conservación
Las murallas completas, puerta y formas aleatorias de todos los pueblos todavía NO están en esta versión. Se prepararán en un generador nuevo para mundos nuevos. No se han movido pueblos, casas ni huertos. Huerto y maestría sin cambios. Main y tiendas de aplicaciones sin tocar.

Código 422, paquete com.example.rancho.review, misma firma de prueba. Instalar encima sin desinstalar si se quiere conservar la partida. No es necesario borrar para comprobar esta corrección de caballos.
