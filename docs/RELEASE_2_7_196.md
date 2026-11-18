# Rancho Prueba 2.7.196

## Rodeo automático tras los primeros tres cerdos
El Rodeo se habilita directamente cuando el primer encargo de tres cerdos está completado. También funciona en partidas ya completadas, sin volver a capturar ni vender animales y sin aceptar otra misión. Se conserva compatibilidad con las partidas que ya tenían Rodeo aceptado.

Al terminar el encargo, el granjero explica: "Eh, se te da bien el lazo. ¿Puedes ayudarme con unos toros? Por favor, ve al menú principal y, en Juegos > Rodeo de toros, podrás recuperar mis toros escapados". El diálogo es informativo, con Entendido. Si estás usando un mapa, diálogo, viaje, lazo o menú, espera a que termines para no interrumpirlo. También aparece en partidas previas que aún no habían aceptado Rodeo. No vuelve a aparecer cada frame; al cerrarlo se recuerda con el indicador compatible que ya existía.

La causa anterior era una aceptación escondida dentro de Menú de Frontera y un mensaje de Juegos genérico que seguía diciendo que faltaban cerdos. Esa aceptación deja de ser un requisito. Los siguientes pasos permanecen: superar Rodeo 1 y visitar dos pueblos para carreras, después las victorias de carreras/duelos/justas de siempre. No se regalan victorias ni se saltan esos pasos.

391/391 pruebas seleccionadas en dos bloques (206 + 185), 54.501 aserciones, 63 scripts. Incluye partida previa, tercer cerdo, aviso, guardado fallido y cadena posterior sin aceptación. Un aviso GUT y 21 deprecados entre ambos bloques. Se cambia una igualdad exacta de joystick a tolerancia 0,00001 tras reproducir un residuo de -0,000000445; no cambia el control de juego. Diálogo renderizado e inspeccionado. Sin Android físico ni toda la suite histórica.

Mismo paquete/firma, versionCode455, rama de pruebas, main/tienda sin cambios. Sin quitar sistemas ni gastos. Los toros visibles en Frontera se trabajan en la siguiente iteración.
