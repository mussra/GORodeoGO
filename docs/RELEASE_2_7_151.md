# Rancho Prueba 2.7.151

## Las cuatro vallas en horizontal
Salto de memoria usa ahora las cuatro variantes de la fila superior de la hoja de Ant, todas horizontales: roja, azul, amarilla y verde. Las variantes de perfil quedan disponibles en el proyecto pero no se usan en este modo.

Colisión, cruce de salto, aproximación automática y minimapa comparten el eje horizontal de las cuatro. Por tanto, las cuatro se cruzan saltando de arriba abajo o de abajo arriba. Los números quedan por encima del arte, sin taparlo. Transparencia, secuencias, reglas y seis rondas se conservan.

Incluye la corrección compartida de gestos táctiles de 2.7.150: pasar o soltar encima de mapas/botones no deja atrapado el lazo, y arrastrar desde UI no cuenta como tocarla.

105/105 pruebas dirigidas, 828 aserciones. La prueba de arte comprueba expresamente que las cuatro usan la textura horizontal y el mismo eje; se vuelven a probar las cuatro desde ambos sentidos. Capturas limpias reales inspeccionadas. Sin prueba en Android físico. Siguen los avisos conocidos de objetos/recursos vivos al cerrar algunas pruebas de mundo.

Mismo paquete y firma de pruebas, versionCode410. Solo rama de pruebas. Sin cambios de estructura, progresión ni maestría.
