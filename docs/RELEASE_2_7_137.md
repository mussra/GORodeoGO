# Rancho Prueba 2.7.137

Primer prototipo del modo B que eligió Ant: carreras de caballos con lazo y regate, sin violencia.

- Entrada "Carreras · prueba" en menú principal.
- Tres circuitos seleccionables: Óvalo, Curvas del valle y Circuito serpiente. Una vuelta por intento, tú+3 IA,16 puertas ordenadas, flecha, minimapa, posición y cronómetro.
- Lazo para frenar brevemente al de delante. También pueden enlazarte. Reduce 25%la velocidad durante 1,2 s; no detiene ni arrastra, no hay daño, golpes, caídas ni aturdimiento. Protección contra encadenar lazos y recarga de 3 s.
- Regate existente para salir del área donde cae el lazo. Mismos componentes reales de lanzamiento/vuelo/cuerda y regate que niveles/Frontera, no recreados.
- Velocidad/manejo igualados provisionalmente, sin cambiar atributos guardados. Salto real según la habilidad de tu caballo, reutilizando el salto existente. Cuatro vallas parciales por circuito: saltar si sabe, rodear por el hueco si no. Rivales con arte existente, diferenciados por nombres y colores.
- Cuenta atrás, pausa, resultado y reintento. Al llegar tú termina el intento; los rivales que faltan figuran "en pista".
- Sin premios, economía ni cambios de colección. Logros y caballos exclusivos previstos para una fase posterior. Sin multijugador.

711/711 unitarias y 93/93 dirigidas GL,1843 aserciones. Controles táctiles sintetizados, vueltas completas de los tres circuitos con saltador y no saltador,16 puertas y capturas reales inspeccionadas. Solo escritorio, no Android físico. Balance inicial y pista simple para probar jugabilidad; detalles y límites en RACE_PROTOTYPE_2_7_137.md. Avisos conocidos de cierre de recursos/API obsoleta en pruebas.

APK 2.7.137/código 396, arm 64, com.example.rancho.review, misma firma. Instalar encima sin desinstalar. Rama feat/open-world-test-20261107, main intacta. Iconos y 3 relojes HUD de Ant sin cambios. Web no publicada, sin tienda ni gastos.
