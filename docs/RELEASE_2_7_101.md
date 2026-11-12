# Rancho Prueba 2.7.101

## Hecho: nacimiento Galaxy puro

La cría de dos adultos Galaxy distintos conserva su acabado Galaxy y ahora guarda una prueba versionada del nacimiento. Se muestra el sello `◆ GALAXY PURO` en la previsión de cría, ficha, colección y Mi rancho, incluida la vista familiar. Los grupos de apariencia indican cuántos registros puros contienen, sin llamar puros a todos los de ese color.

La regla implementada es concreta: dos padres con acabado Galaxy en el momento de criar. El registro conserva sus IDs, acabado y enlaces de ascendencia de ese momento. No afirma que todas las generaciones anteriores fueran Galaxy ni introduce alelos recesivos.

- Un único padre Galaxy puede transmitir el acabado conforme a la regla anterior, pero no concede el sello.
- Editar o vender posteriormente a un progenitor no reescribe la prueba del nacimiento.
- El guardado valida la forma del registro; no sustituye padres por otros registros ni permite dos copias del mismo padre.
- Los caballos antiguos sin prueba de nacimiento no se etiquetan retroactivamente por su apariencia o por los valores actuales de sus padres.
- El sello permanece tras el crecimiento de prueba y la recarga.

## Límites

La cría sigue siendo potrillo, no se puede montar y no se transforma automáticamente en unicornio. No se han implementado crecimiento normal, llaves20/40, fuente, ritual, país nuevo ni cambios en la maestría. Tampoco se cambian rareza, estadísticas, precios, nacimientos disponibles, adquisición Galaxy con un solo padre ni caballos ya conseguidos.

La ficha aclara: "Dos padres Galaxy al nacer · todavía no es un unicornio". No se ha generado arte nuevo.

## Validación

- 600/600 pruebas unitarias: 2.556.383 aserciones.
- 14/14 pruebas de integración: nueva interfaz de pureza, Mi rancho, Serenidad y entrenamiento. 82 aserciones.
- Nueve pruebas nuevas entre unidad e integración: dos padres/single Galaxy, snapshot independiente, venta, compatibilidad antigua, registros inválidos, guardado/recarga/crecimiento de prueba, fallo atómico y sellos de interfaz.
- Inspección de capturas a1280x720: ficha, previsión de cría, colección desplazada hasta la cría, Mi rancho y familia.
- La suite unitaria conserva sus avisos de recursos anteriores; el nuevo script de integración termina sin huérfanos.
- No probado en Android físico. Las capturas y pruebas son de escritorio.

## APK

Paquete `com.example.rancho.review`, versionCode360, arm64, Android7.0o posterior. FirmaV2/V3verificada con el certificado anterior. 69.664.070bytes.

SHA-256: `1c5181d53678e1ecead92c1c5437c1cf459f2008ff212639250310a7675797fc`.

Solo rama de pruebas, sin tocar main ni publicar en tienda. Instalar encima sin desinstalar.
