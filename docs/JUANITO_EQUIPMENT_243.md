# Equipo de Juanito: integración y validación

Base: `7d2255109ff7962c749a9bfbd86defbbbf35886a`.
Rama de trabajo: `feat/guarnicionero-equipo`.

## Incluido

- Catálogo de 16 artículos: fusta básica/mejorada, montura, riendas, estribos, herraduras, espuelas, sombrero y manta. Cada familia tiene dos variantes.
- Herraduras visibles pero **bloqueadas**, sin posibilidad de compra. El mundo aún no tiene penalización de velocidad por terreno difícil. No se ha sustituido por un descuento de resistencia ni se ha inventado una penalización nueva.
- Alforjas no vendibles, con aviso de dependencia del inventario limitado.
- Montura: -5%/-10% de gasto de resistencia al trotar y galopar. No aumenta la velocidad ni cambia la recuperación al caminar/pararse.
- Riendas: -5%/-10% de recarga del regate, tanto en mundo como en Rodeo.
- Estribos: -5%/-10% de duración del aturdimiento, mundo y Rodeo. No se modifican las señales de golpe ni la pérdida de capturas.
- Fusta: 260/420 px, conserva compras anteriores y no retira el regate aprendido en el mundo.
- Espuelas: 900 puntos; +10% durante 1 s, recarga de 8 s, coste del 15% de la resistencia máxima. Mejora: +1800 puntos; 1,3 s y 7 s; mismo impulso/coste. El coste se descuenta al activar sobre el estado de energía del caballo montado, no después ni sobre otro caballo.
- Espuelas solo donde existe resistencia de mundo. No se habilitan en carreras, duelos, justas ni Rodeo. Se requiere movimiento voluntario y galope disponible; bloqueadas sin energía, con agotamiento, pausa/modal, golpe, salto, dibujo de regate, regate o salida de regate. Sin apilar impulsos.
- Botón explícito con coste, reloj y señal breve de impulso. El control de movimiento no cambia.
- Sombrero de gala negro, variante azul/dorada; manta roja, variante azul con detalles dorados. Reutilizan el arte/máscaras existentes. Solo apariencia, sin atributos. Se pueden quitar conservando la propiedad.
- Compra separada de equipar, mejoras requieren básico, no se duplican compras, confirmación con coste ahora, coste total y saldo posterior. No se modifican recompensas, coronas, Instinto, dinero real ni economía de inventario.
- Rollback de puntos/propiedad/equipo si falla el guardado.

## Suposiciones y límites

1. "Correr" incluye trote y galope, no paso ni reposo.
2. La fusta alarga el gesto del caballo entrenado; no sustituye su aprendizaje. Tener un caballo con regate aprendido no lo pierde por no comprar una fusta.
3. Herraduras aplazadas por dependencia inexistente, siguiendo la decisión del coordinador. Alforjas sigue pendiente.
4. Paletas cosméticas propuestas: negro/azul-dorado para sombrero y rojo/azul-dorado para manta. La apariencia no cambia genes ni selección del sombrero anterior; quitar el cosmético restaura la selección previa.
5. Validado en Godot 4.7 de escritorio, renderizador de compatibilidad. No se ha instalado en un Android físico ni exportado APK aquí.
6. La integración final con panorámica y su medición conjunta corresponde al trabajo de cámara. No se afirma rendimiento idéntico ni validación de toda la aplicación.

## Integración

No se han editado `frontier_world.gd` ni `world_camera243.gd`. No quedan enganches manuales pendientes:

- `MountedStatus154` aplica efectos de mundo y añade el botón una vez al HUD.
- `world_player.gd` controla impulso/guardas y refresca cosméticos cuando cambia el equipo.
- `level_0.gd` aplica riendas/estribos; `player.gd` aplica cosméticos del Rodeo.
- El acceso existente a `EquipmentPanel` desde Juanito usa el catálogo ampliado. El título del servicio no consulta la antigua identificación `east140` contra el mapa v6.
- `SaveData` conserva el esquema de puntos/propiedad/equipado y añade solo una operación transaccional para quitar cosméticos.

Importar el bundle en el repositorio del integrador:

```sh
git fetch /RUTA/juanito-equipo243.bundle feat/guarnicionero-equipo
# Revisar el diff y aplicar el commit de FETCH_HEAD sobre la rama de pruebas.
git cherry-pick FETCH_HEAD
```

Registrar las clases nuevas antes de pruebas/exportación:

```sh
godot --headless --import
godot --headless -s addons/gut/gut_cmdln.gd -gconfig=res://tools/gut_juanito243.json
```

`tools/qa_juanito243.tscn` reproduce capturas del panel, confirmación, cosméticos, HUD y servicio con un perfil de prueba local. Es una escena de QA, no una entrada nueva del menú.

## Validación ejecutada

55/55 pruebas, 9786 aserciones, 10 scripts dirigidos. Incluye catálogo, precios, dependencias, bloqueos, compra, confirmación, saldo, duplicados, rollback por fallo de disco, persistencia, fusta anterior, regate, resistencia, habilidades de montura, pérdida de ventajas fuera del mundo y cosméticos sin alterar alfa ni dimensiones.

Dos fixtures anteriores se actualizan: el flujo de equipo abre explícitamente la misión de Rodeo y limpia su victoria pendiente, y el test de iconos cuenta el catálogo ampliado dentro del scroll. No se alteran las reglas de acceso o de coronas para hacer pasar las pruebas.

Inspección de píxeles: panel a 1280x720 y 960x540, partes superior/media/inferior del scroll, confirmación de compra, botón de espuelas en el mundo, servicio Juanito y hojas de 45 fotogramas de movimiento y 40 de salto del cosmético elaborado en cinco vistas. Las capturas intermedias con desbordamiento se corrigieron y volvieron a inspeccionar.

No se ejecutó la suite total como criterio de cierre: el primer intento excedió el límite de ejecución al recorrer pruebas no relacionadas. El archivo de configuración incluido limita de forma explícita las pruebas relevantes, sin depender de `.gutconfig.json`.
