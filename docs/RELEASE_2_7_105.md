# Rancho Prueba 2.7.105

## Mapa y siesta dentro de la maqueta del país

Frontera → Menú → País nuevo → Mapa local.

- El mapa local muestra solo la zona explorada. No enseña la fuente, el río entero ni los caminos sin recorrerlos.
- Entrada, raíces y nacimiento se añaden al selector únicamente tras visitarlos. Tocar un sitio conocido abre la confirmación compartida de siesta.
- Volver a casa lleva a la entrada de este país, no al rancho. Salir a Frontera devuelve al mundo original.
- Misma cortina, confirmación y transacción que Frontera. La llegada comprueba terreno de este país y la forma física real del jinete; un destino bloqueado conserva origen, registro y exploración.
- No explora el camino intermedio, no completa encargos, no gasta puntos/energía ni cambia caballos. Rechaza lazo en vuelo/carga, golpe y viaje simultáneo. Cancelar o Atrás no inicia el viaje.

## Límites

Sigue siendo una maqueta SIN GUARDADO y SIN RITUAL. Al salir se pierde su exploración local. No es el país final: faltan reentrada persistente, rastro/puerta normal, pistas y arte final. Árbol ampliado, río, fuente y arcoíris son provisionales. La apariencia oro/cristal/hielo no cambia; no se decide su obtención ni precio.

## Verificación

614 pruebas unitarias, 2.556.620 aserciones.39 integraciones enfocadas,3.122 aserciones: país, siesta, mapa modular, manadas móviles, notas, primos y regreso a casa. Se actualizan dos pruebas antiguas que esperaban un regreso inmediato sin confirmación; desde2.7.102 el regreso es una siesta confirmada. Regresión de confirmación Frontera y mapa local revisada en1280×720y960×540, con capturas. Tap nativo, arrastre y dos dedos simulados; no equivalen a prueba física Android. Persisten avisos de recursos al salir de la batería unitaria.

APK arm64, paquete com.example.rancho.review, versionCode364. Firma V2/V3, certificado SHA25646bdcb2213f8b82696b918f5cfd5764cd5690038ae2938aaec6f11bfffb79bbb.
SHA256 APK:38a39d13421f83adf7b097a483f8312558a11012f5876a3f7cd3c87952f391fd.
