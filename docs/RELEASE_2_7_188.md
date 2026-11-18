# Rancho Prueba 2.7.188

Ajustes → Control de movimiento permite elegir entre:
- Actual: el mando sigue al dedo. Sigue siendo el predeterminado, sin quitarlo.
- Anclado: centro fijo en el punto inicial hasta soltar, recorrido corto de 60 px hasta saturar. Volver hacia el origen cambia la dirección sin mover el centro.

La preferencia se guarda en el dispositivo y se aplica al entrar en juego, en todos los modos que usan el control compartido. Solo cambia el movimiento: el lazo conserva su mando con el otro dedo. Se mantienen los arreglos de borde, scroll y lazo de 187.

329/329 pruebas, 53.787 aserciones en 52 scripts. Incluye saturación/retorno al origen, dos dedos simultáneos, persistencia y vuelta al modo anterior. Bordes, soltar, cancelar, foco y pausa se prueban también en modo anclado. Capturas reales inspeccionadas de ajustes, dos opciones, centro fijo y dos dedos.

Sin prueba en Android físico. 7 avisos de obsolescencia y 2 objetos residuales del ejecutor al cerrar, ninguna prueba falla. Rama de pruebas únicamente, sin main, tiendas ni gasto. El precio y reglas de equipo no cambian.
