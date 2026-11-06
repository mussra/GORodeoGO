# Rancho Prueba 2.5 - mercado y nacimientos por progreso

Mercado local con puntos del juego, sin dinero real ni servicios online. Conserva todos los caballos existentes, selección, genealogía y modos separados. Salto y efectos aprobados no cambian.

## Normal
- Seis ofertas por nivel máximo alcanzado, estables al cerrar/abrir y cada una comprable una sola vez. Al superar ese máximo se generan seis nuevas; no hay cambios por reloj ni recarga de pantalla.
- Rareza máxima de oferta y nuevas recompensas: Común desde el inicio, Poco frecuente nivel4, Raro8, Ultra raro12, Legendario16. Dentro de lo desbloqueado hay menor peso de aceptación por categoría: 1 / 0,45 / 0,2025 / 0,091125 / 0,04100625. Estos pesos no son porcentajes finales de aparición: dependen de rasgos y del filtro de nivel.
- Cada victoria gana un nacimiento, incluidas repeticiones. Sin victorias nuevas no se acumulan copias gratis. Criar consume uno al guardar; conserva ambos padres y selección A/B. Créditos iniciales nuevos: cero, sin borrar las crías antiguas.
- Crías adultas se pueden vender. No se aplica la alternativa descartada de excluirlas de venta. Sigue entrenamiento de ensayo existente para madurar.
- Original y caballo activo no se venden: selecciona otro antes. Potros tampoco. Cada venta conserva el registro e identidad para el árbol, aunque ya no esté en colección. Un premio ya vendido no vuelve a concederse por repetir nivel.

## Precios ajustables
Categorías base 250 / 600 / 1.400 / 3.200 / 7.000 puntos; habilidad salto añade200 aparte. Venta40% del menor entre valor actual y precio pagado. No hay ganancia al comprar/revender inmediatamente. Rareza no aumenta estadísticas.

El nivel se calcula con puntuaciones de pelaje/patrón (0-2), crin arcoíris+2, ojos arcoíris/Galaxy+2, acabado Galaxy+4, agrupadas cada2 puntos con máximo4. Es una regla de diseño ajustable, no una frecuencia observada. La rareza de encontrar y la de reproducir siguen siendo distintas porque la herencia A/B no se ha aleatorizado. El atlas muestra categoría y precio de todos los aspectos; solo las ofertas vigentes se pueden comprar en Normal.

## Debug y seguridad
Debug mantiene catálogo completo y compras/nacimientos libres; Normal no hereda sus puntos, créditos, ofertas ni caballos. Compra y venta piden confirmación. Guardado fallido restaura saldo/colección/créditos/ofertas. Registros antiguos migran con cero créditos y lista de compras vacía, sin eliminar datos. No hay acceso al mercado de otra persona ni cría compartida online todavía.

80 pruebas focales / 79.200 aserciones pasan: oferta estable/desbloqueos/agotamiento, nacimientos/victorias, persistencia, rollback, identidad/linajes, ciclos, separación de modos, precio/reventa en1200 aspectos y regresiones previas. Capturas reales revisadas. Sin prueba de esta versión en Android físico; avisos conocidos de auxiliares GUT, no suite global limpia.

Paquete com.example.rancho.review, versión2.5/code257, misma firma. Actualiza encima sin desinstalar. Rama de pruebas; main intacta; sin tiendas.
