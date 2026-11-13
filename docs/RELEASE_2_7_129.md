# Rancho Prueba 2.7.129

## Texto dentro de sus espacios
- Componente común para resúmenes en área fija: limita el ancho, ajusta la letra hasta un mínimo y usa puntos suspensivos si sigue sin caber. El texto completo se conserva en la ficha o descripción emergente.
- Para descripciones dentro del desplazamiento, otro modo conserva el texto completo, lo reparte en líneas y deja crecer su altura.
- Aplicado a Atlas, mercado, colección, ficha, menús compartidos, genealogía, Mi rancho, diálogos, doma y tarjetas/tiendas relacionadas. No cambia los textos guardados ni los nombres de los caballos.
- Ajustada la separación del nombre y subtítulo de la ficha para nombres de dos líneas.

## Caballos de Mi rancho
- Los adultos usan los mismos nueve fotogramas laterales montados del juego, con rasgos del caballo, sombrero, acabado y complementos. Se retira la base alternativa de la vista del rancho que daba otra apariencia al Original.
- Colección y ficha conservan el retrato HD compartido, con los mismos rasgos y equipo. Los potrillos siguen quietos.
- Se conserva Mi rancho y Colección sin fusionarlas ni borrar funciones. Se añade el enlace de Colección a Mi rancho, que complementa el enlace existente de vuelta.

## Comprobaciones
- 688/688 pruebas unitarias, en dos grupos de373 y315: 2.559.301 aserciones.
- 41/41 pruebas de integración dirigidas: 3.131 aserciones. Incluyen los nueve fotogramas de cada caballo de prueba, el sombrero y los enlaces de ambas vistas.
- Regresión adicional del componente de texto:3/3 pruebas,15 aserciones; prueba gráfica con límites del Atlas.
- Capturas inspeccionadas con renderizado GL a960×540: Atlas español e inglés, mercado, unicornios, nombres de59caracteres en colección y ficha, menú con textos extremos y Mi rancho con Original, azul y arcoíris. También generada captura del Atlas a1600×720.
- Inglés del Atlas puede usar puntos suspensivos donde el texto traducido no cabe. La localización completa no forma parte de esta corrección.
- No probado en Android físico: falta validar legibilidad, tacto y rendimiento en el teléfono. Persisten avisos de recursos al cerrar las pruebas.

## APK
- Rancho Prueba2.7.129, código388, paquete com.example.rancho.review, arm64.
- Misma firma de prueba que128. Instalar encima; no desinstalar para conservar guardado local.
- Tamaño:71406477bytes.
- SHA-256:6ffa11c5137cd2e27542c012bcf204b919a9441a999318b9e11300e28d76571d.
- Rama feat/open-world-test-20261107, sin fusionar en main. Sin tiendas ni gastos.
- Web no publicada; Windows sigue125. Maestría36-40 sin cambios.
