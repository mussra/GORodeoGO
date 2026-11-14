# Carrera con lazo: primer prototipo

Entrada: menú principal, "Carreras · prueba". Tres circuitos seleccionables: Óvalo, Curvas del valle y Circuito serpiente, con una vuelta en cada intento, tú y tres rivales de IA. Dieciséis puertas ordenadas, flecha hacia la siguiente y minimapa siempre visible. Cuenta atrás, posición, tiempo, pausa, resultado y reintento. La carrera termina para todos cuando llega el jugador; los rivales que no han terminado aparecen como "en pista". No es multijugador.

## Reglas provisionales, aisladas de los demás modos

Velocidad base 260 y aceleración 900 igualadas, regate disponible para todos. El salto NO se regala: se conserva HorseJump.capable de tu caballo. Por ahora los rivales usan la misma habilidad que el caballo montado, para probar los dos casos de forma comparable. El jugador conserva el aspecto de su caballo montado. Por ahora los rivales comparten ese arte y se distinguen por nombre y color del aro, no son nuevos caballos guardados. EQUALIZED en race190.gd concentra la opción provisional; no modifica atributos de colección.

El lazo usa los controles existentes: apunta y suelta. Solo son candidatos los rivales de delante, dentro del alcance 220. Se resuelve en la posición real del rival cuando cae, no en la posición de cuando se lanzó. Vuelo compartido 0,35 s. Un acierto reduce 25%la velocidad durante 1,2 s, sin pararlo, arrastrarlo, dañarlo, golpearlo ni aturdirlo. La cuerda es visual, no una unión física. Durante 3,2 sdesde el acierto no acepta otro lazo:1,2 sfrenado más 2 sde protección posterior. No apila ni reinicia el efecto. Enfriamiento de lanzamiento 3 s. Es balance inicial, no definitivo.

El regate es el gesto existente del joystick de movimiento, incluida su cámara lenta y trazado. Esquivar significa salir del área de caída a tiempo; no da inmunidad por pulsar. La IA reacciona a cuerdas que ya están volando y puede usar el regate compartido; no lee entradas futuras. El tiempo, IA y vuelo avanzan en el mismo reloj de simulación. No se cronometra con tiempo real mientras se dibuja el regate.

Los bordes reconducen suavemente al circuito. No hay choques ni empujones entre corredores. Las puertas requieren cruce hacia delante y dentro de su ancho; no se puede ganar cruzando el centro o saltándose puertas. Los tiempos de 45-48 sobservados con conducción sintética solo prueban que se puede completar la vuelta, no miden dificultad para una persona.

## Reutilización

- RaceRider 190 deriva del jugador del mundo: movimiento manual, arte, mano del jinete y animaciones siguen compartidos.
- LassoController y LassoRope hacen carga, lanzamiento, herencia de velocidad, vuelo y resolución. Los corredores solo implementan su respuesta temporal al acierto. No hay otro motor de lanzamiento.
- DodgeController y DodgeVisuals hacen el regate de jugador e IA. No hay otro regate ni cambios en niveles/Frontera.
- Misma escena touch_controls.tscn y JoystickAppearance; sonido RanchAudio y estilo de cuerda compartidos.
- Nuevo y específico de carreras: geometría/cálculo de puertas, progreso, IA de recorrido, efecto temporal de freno y HUD/resultados.

## Guardados y siguientes fases

Este prototipo no guarda récords ni entrega logros, dinero o caballos. No cambia colección, entrenamiento, mejoras ni progreso de otros modos. Ant quiere logros y caballos exclusivos de carreras: están pendientes de diseñar e integrar después, no descartados.

Pendiente de sensación real en Android: tamaño del circuito/cámara, ritmo de adelantamientos, lectura de amenaza de lazo, dificultad de IA y equilibrio de la ralentización. Pista y presentación deliberadamente sencillas; sin arte nuevo generado ni cambios a los iconos de Ant.

## Verificación

711/711 unitarias completas (387+324).93/93 dirigidas GL,1843 aserciones, incluidas 19 pruebas nuevas de circuito/carrera. Cierre/proyección de pista, bordes, puertas en orden, cruce al revés, atajos, componentes compartidos, igualdad, movimiento/IA, lazo real con vuelo diferido, protección, fallo, evasión espacial, controles táctiles nativos, pausa, meta y salida de cámara lenta; ausencia de escritura de guardado o cambio de caballos. También regresión de mapas/niveles, lazo, menús e iconos.

Capturas reales inspeccionadas a 960×540 y formato ancho 1600×720: entrada en menú, salida, vuelo, frenado, regate, pausa y meta. Vuelta completa con movimiento sintético y 16 puertas en 45-48 s de simulación. Solo simulación de escritorio, no Android físico. Avisos conocidos de recursos al cerrar pruebas y API obsoleta del banco de pruebas.

## Vallas y niveles de carrera añadidos tras el audio de Ant

Cuatro vallas parciales por circuito, en las puertas 3,7,11,15. Son WorldFence reales con su arte/colisión; queda un hueco lateral de unos 130 px para rodearlas. HorseJumpMotion y HorseJump.capable son los de niveles/Frontera, no otro salto. Al acercarse con velocidad suficiente, el caballo que sabe salta automáticamente. Un no saltador debe dirigirse al hueco. La IA no saltadora planifica ese desvío; la saltadora puede pasar por encima. No hay castigo por golpear ni daño. El regate respeta la colisión de vallas, no permite atravesarlas.

Comprobadas vueltas completas de los tres circuitos tanto con no saltador como con saltador, movimiento sintético,16 puertas en todos los casos. No saltadores sin activar salto. Los saltadores activan la animación y trayectoria compartidas. Última prueba: Circuito serpiente con saltador 48,42 s de simulación. Estos tiempos no son balance final. Los tres trazados son variantes cerradas, sin nuevos tipos de terreno/arte; se podrán ampliar más adelante.

## Diseño futuro acordado, NO implementado

Inscripción con dinero del juego, niveles de coste y premios crecientes. La carrera de precio máximo entregará un caballo especial exclusivo; sus crías heredarán esa característica especial. Pendiente definir coste, premio, característica, condiciones de victoria/entrega y herencia. No se añade ninguna transacción ni genética nueva ahora. También queda para después ajustar velocidades/habilidad: Ant plantea compensar no saltadores rápidos frente a saltadores menos rápidos. Esta versión todavía iguala velocidad/manejo.
