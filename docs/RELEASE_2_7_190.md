# Rancho Prueba 2.7.190

- Floristería del rancho con el interior ilustrado entregado por Ant, personaje dentro y salida al mismo punto exterior. Se elimina su duplicado exterior del rancho.
- Se conservan los encargos y diálogos actuales. Hablar abre el flujo existente dentro del edificio. Atrás cierra primero la conversación; salir devuelve el control al caballo.
- Flores, lazos y catálogo se examinan o se consultan. No se recogen pertenencias automáticamente. La florista invita: "Si te interesa algo, habla conmigo". No se anuncian regalos ni se inventan compras. El personaje decidirá sus ofertas cuando estén implementadas.
- Corregido el punto de profundidad de la guarnicionería: antes ordenaba al caballo detrás aunque ya estuviera delante de la pared física. Ahora se ordena por la fachada, conservando arte y colisión. Revisado el mismo desfase en casas, granero modular y floristerías, incluidos constructores heredados de pueblos. Capturas de antes/después en los adjuntos.
- Casas/granjero: prompts de una imagen y plan listos; todavía no son nuevos interiores conectados. Algunas casas se abrirán por invitación y otras indicarán que el vecino no está.

## Validación
347/347 pruebas de regresión seleccionada, 54.008 aserciones, 56 scripts. Incluye entrada, encargo existente, vuelta a la habitación y salida sin mover al jugador. Un aviso GUT, 14 deprecados heredados y dos objetos al cerrar siguen presentes. No certifica la suite histórica entera ni Android físico.

APK de prueba, mismo paquete/firma, versionCode449. Sin main, tienda ni gastos. No hay cambios de reglas del atlas respecto a 189.
