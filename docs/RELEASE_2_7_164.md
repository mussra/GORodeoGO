# Rancho Prueba 2.7.164

## Pueblos amurallados, solo mundos nuevos
- Nuevo generador V4: los cuatro pueblos, incluido el inicial, tienen recinto cerrado, una puerta transitable con hojas de madera abiertas y cartel con su nombre propio.
- Formas sorteadas por semilla: rectángulo, rombo, estrella, círculo, cuadrado o pentágono. La forma no vuelve a sortearse al cargar. Cada recinto se adapta a su contenido, manteniendo margen respecto a casas, personajes y parcelas.
- Cada pueblo conserva sus propios edificios y personajes dentro. No se han clonado todos los servicios y misiones en todos los pueblos.
- La disposición nueva separa los emplazamientos principales aproximadamente 10.240 unidades (1.280 m según la escala de distancia del juego). El camino exterior une las puertas; los accesos de la florista rodean la muralla en vez de atravesarla.
- Dibujo, física y mapa usan el mismo contorno y la misma abertura. Las poblaciones salvajes y la decoración natural no aparecen dentro del recinto ni sobre las murallas. Los cultivos y muestras silvestres externos siguen fuera cuando no pertenecen al pueblo.

## Partidas
No hay migración, copia ni borrado automático. Las partidas V1/V2/V3 siguen usando su generador anterior. Para ver los pueblos nuevos hay que iniciar un mundo nuevo; la aplicación no borra el actual por su cuenta. La colección y el progreso no se reinician al instalar el APK.

## Pruebas y límites
107/107 pruebas de integración, 1.203 aserciones. Incluyen al jinete real cruzando la puerta, chocando con la pared visible, casas/personajes/parcela dentro y guardado/recarga con V4 y V3. Otras 32/32 pruebas de política, identidad y geometría, 12.609 aserciones; 80 recintos cubren las seis formas, puertas en vértices, caminos transitables, círculos redondos y contornos compartidos con el mapa.

Inspeccionadas las capturas del mundo completo de los cuatro pueblos, una entrada a escala de juego y el mapa ampliado. Las vistas generales usan una cámara de QA más alejada y cargan el recinto completo para comprobar su cierre. La cámara normal del juego no se cambia. APK exportado y firma verificada; no ejecutado en un teléfono Android físico. La regresión deja avisos al cerrar: 6 CanvasItem, 9 ObjectDB y 2 recursos.

## Todavía pendiente
Esta versión NO cambia la pantalla Equipo, las proporciones de la animación de carga ni el resto de textos de la aplicación. Huerto y maestría mantienen su comportamiento. Main y tiendas de aplicaciones sin tocar.

Código 423, com.example.rancho.review, misma firma de prueba.
