# Rancho Prueba 2.3

Incluye lo de 2.2 y añade selección visual de parentesco en el mapa genealógico.

- Toca un caballo: borde dorado en él y en todos sus antepasados y descendientes conocidos, con todas las líneas de esos recorridos doradas. Los demás quedan atenuados.
- Toca de nuevo el mismo caballo para deseleccionar, o toca otro para cambiar el recorrido.
- No abre una ficha modal: la información queda debajo del mapa. Conserva búsqueda, filtros, zoom y desplazamiento. En modo Solo coincidencias no reaparecen caballos ocultos ni se inventan conexiones para saltarlos.
- Ancestros compartidos se muestran por todas sus ramas sin duplicar identidades. No añade a las parejas de un descendiente ni a hermanos fuera de los recorridos ascendentes/descendentes. Recorridos protegidos contra ciclos.
- Icono de caballo sobre valla junto al caballo activo del menú, en cada fila de selección y en ficha. Flecha de salto si tiene habilidad, aspa si no: no depende solo del color y no ocupa una frase visible. Al tocarlo, muestra la explicación de la capacidad de ese caballo.
- No cambia cría, colección, progreso, saltos ni archivos de guardado.

69 pruebas focales / 75.316 aserciones pasan. Incluyen ramas, ancestros compartidos, ciclos, alternancia de selección, filtros, zoom y posición. Capturas reales de selección y deselección revisadas. Siguen los límites de 2.2: sin certificación de teléfono Android físico, gestos/rendimiento/instalación pendientes de prueba en dispositivo; avisos conocidos de auxiliares GUT del motor de desarrollo, no suite global limpia.

Actualiza sobre la anterior sin desinstalar: paquete com.example.rancho.review, versión2.3/code255, misma firma SHA256 46bdcb2213f8b82696b918f5cfd5764cd5690038ae2938aaec6f11bfffb79bbb. Rama de pruebas, main intacta, sin tiendas.
