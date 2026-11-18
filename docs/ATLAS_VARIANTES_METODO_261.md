# Recuento reproducible del atlas base

Solicitud de Ant, 18 de noviembre de 2026: conservar esta cifra para marketing.

## Cifra y alcance

El generador enumera **47.250 combinaciones base**. Tras normalizar rasgos que el retrato no usa, quedan **41.706 claves de apariencia** según el render actual. No llamarlas 41.706 caballos únicos ni prometer que se han comparado píxel a píxel.

- 21 pelajes × 18 patrones × 6 crines = 2.268 familias de origen.
- Liso usa un color de manchas; los otros 17 patrones enumeran 22 valores (Original + 21 colores).
- 21 × 6 × (1 + 17 × 22) = 47.250 combinaciones brutas.
- `HorseAtlas.visible_key261` elimina genes sin efecto en el retrato actual: manchas de Liso/Patas claras, alias de color Original y patrones del mismo color que el pelaje cuando no dejan marca visible. Se mantiene la excepción del centro del Leopardo.
- La agrupación no elimina genes, registros propios ni reglas de crianza. Es presentación.

## Qué NO incluye

No es el total de todo el juego: no multiplica colores adicionales de ojos/patas, acabados, unicornios, emblemas y sus posiciones, accesorios, maestros/supremos, etapas o futuras altas. El atlas base no enumera todas esas dimensiones. Los retratos se validaron con capturas representativas, no comparando exhaustivamente todas las imágenes. Cambiar el shader puede cambiar la cifra.

## Ejecutar de nuevo

Desde la raíz del proyecto con Godot 4.7.2:

```
godot --headless --path . tools/count_atlas261.tscn
```

El script llama al generador real `HorseAtlas.filtered_entries` y a `visible_groups261`. Para el commit de 2.7.189, sin caballos propios:

| Filtro | Combinaciones brutas | Claves de apariencia |
|---|---:|---:|
| Ninguno | 47.250 | 41.706 |
| Crin arcoíris | 7.875 | 6.951 |
| Pelaje 6 | 2.250 | 1.986 |
| Ultra raro | 2.574 | 2.403 |

RESULTADOS agrupa primero por familia pelaje/patrón/crin; al abrir muestra los colores de manchas que sí cambian el aspecto. Por eso 117 familias de Ultra raro no sustituyen a las 2.403 claves de apariencia ni a las 2.574 combinaciones.

## Redacción de marketing propuesta, pendiente de revisión

"Más de 41.000 combinaciones de aspecto en el atlas base, antes de contar ojos, patas, acabados y emblemas."

Es una propuesta, no texto publicado. Antes de marketing final, repetir el recuento en la versión que se vaya a distribuir y revisar una muestra visual ampliada.
